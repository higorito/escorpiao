import 'package:flutter/material.dart';

import '../home_page.dart';

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

    if(isFormValid ) {
      try {
        await Future.delayed(const Duration(seconds: 2));
        if (email == 'opa@gmail.com' && senha == '123') {
          print('Login efetuado com sucesso');
          isLoading.value = false;
          _onSuccess();
        } else {
          isLoading.value = false;
          _onError();
        }
        
      } catch (e) {
        _onError();
      }
    } else {
      isLoading.value = false;
    }

  }

  void register() {
    print('Register');
  }

  void forgotPassword() {
    print('Forgot password');
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
    notifyListeners();
  }

  void _onError( ) {
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

 void _onSuccess() {
    showDialog(
      context: _formKey.currentContext!,
      barrierDismissible: false, // Evita que o usuário feche o diálogo ao clicar fora
      builder: (context) {
        // Utiliza AlertDialog personalizado para adicionar o ícone animado
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(width: 20),
              Text('Login efetuado com sucesso'),
            ],
          ),
        );
      },
    );

    // Espera 1 segundo antes de fazer o push para outra tela
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(_formKey.currentContext!).pop(); // Fecha o diálogo
      Navigator.push(
        _formKey.currentContext!,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

}