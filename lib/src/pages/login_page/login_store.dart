import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../esqueceu_senha/esqueceu_senha.dart';
import '../register_page/register_switch.dart';

class LoginStore extends ChangeNotifier {
  LoginStore() : super();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  get obscurePasswordNotifier => obscurePassword;

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  get isLoadingNotifier => isLoading;

  ValueNotifier<bool> isFormValidNotifier = ValueNotifier<bool>(false);
  bool get isFormValid => isFormValidNotifier.value;

  Future<void> validateForm() async {
    isLoading.value = true;
    if (_formKey.currentState?.validate() == true) {
      isFormValidNotifier.value = true;
    } else {
      isFormValidNotifier.value = false;
    }
    isLoading.value = false;
    notifyListeners();
  }

  void resetForm() {
    _formKey.currentState?.reset();
    notifyListeners();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String email, String senha) async {
    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbarMessage(_formKey.currentContext!, 'Usuário não encontrado');
      } else if (e.code == 'wrong-password') {
        showSnackbarMessage(_formKey.currentContext!, 'Senha incorreta');
      } else {
        erroLogin('Erro ao realizar login');
      }
    }
    isLoading.value = false;
  }

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 180, right: 20, left: 20),
      ),
    );
  }

  void erroLogin(String msg) {
    showDialog(
      context: _formKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Erro ao realizar login',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                if (msg == 'user-not-found')
                  const Text('Usuário não encontrado'),
                if (msg == 'wrong-password') const Text('Senha incorreta'),
                if (msg == 'email-already-in-use')
                  const Text('Email já cadastrado'),
                if (msg == 'Erro ao realizar login')
                  const Text(
                      'Por favor, tente novamente! \nVerifique se o email e senha estão corretos.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> login(String email, String senha) async {
  //   isLoading.value = true;

  //   if(isFormValid ) {
  //     try {
  //       await Future.delayed(const Duration(seconds: 2));
  //       if (email == 'higor@gmail.com' && senha == '123') {
  //         print('Login efetuado com sucesso');
  //         Navigator.pushReplacementNamed(
  //           _formKey.currentContext!,
  //           '/maps_place',
  //       );
  //         isLoading.value = false;
  //         // _onSuccess();
  //       } else {
  //         isLoading.value = false;
  //         _onError();
  //       }

  //     } catch (e) {
  //       _onError();
  //     }
  //   } else {
  //     isLoading.value = false;
  //   }

  // }

  void register(bool aSaude) {
    Navigator.push(_formKey.currentContext!,
        MaterialPageRoute(builder: (context) {
      return RegisterSwitch( agenteSaude: aSaude);
    }));
  }

  void forgotPassword() {
    Navigator.push(
      _formKey.currentContext!,
      MaterialPageRoute(builder: (context) {
        return const EsqueceuSenhaPage();
      }),
    );
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
    notifyListeners();
  }

  void _onError() {
    showDialog(
      context: _formKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: const Text('Erro ao realizar login'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
