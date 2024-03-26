import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signUp() async {
    if (_formKey.currentState?.validate() == true) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator.adaptive());
          });

      try {
        if (_passwordController.text == _confirmPasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          showSnackbarMessage(context, 'Usuário criado com sucesso');
          Navigator.of(context).pop();
          await Navigator.push(context,  MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          showSnackbarMessage(context, 'As senhas não coincidem');
        }
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          showSnackbarMessage(context, 'Senha fraca');
        } else if (e.code == 'email-already-in-use') {
          showSnackbarMessage(context, 'E-mail já cadastrado');
        } else {
          showSnackbarMessage(context, 'Erro ao criar usuário');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EscorpMap', style: TextStyle(color: AppTheme.blueColor, fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: 2.2)),
        backgroundColor: Colors.white.withOpacity(0.85),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              
              color: AppTheme.blueColor,
              constraints: BoxConstraints(
                minHeight: size.height ,
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.5,
                              height: size.height * 0.2,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/scorpion.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Crie sua conta',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              controller: _emailController,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.email('E-mail inválido'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
                              ),
                              controller: _passwordController,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.min(6, 'Senha muito curta'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Confirmação de senha',
                                border: OutlineInputBorder(),
                              ),
                              controller: _confirmPasswordController,
                              validator: Validatorless.multiple([
                                Validatorless.required('Campo obrigatório'),
                                Validatorless.min(6, 'Senha muito curta'),
                                if (_passwordController.text !=
                                    _confirmPasswordController.text)
                                  Validatorless.required('As senhas não coincidem'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: signUp,
                                child: const Text('Cadastrar'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Ou registre-se com'),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                print('REGISTRAR COM GOOGLE');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/icons/google.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (message == 'Usuário criado com sucesso')
            ? Colors.green
            : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 180, right: 20, left: 20),
      ),
    );
  }
}
