import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:validatorless/validatorless.dart';

class EsqueceuSenhaPage extends StatefulWidget {
  const EsqueceuSenhaPage({super.key});

  @override
  State<EsqueceuSenhaPage> createState() => _EsqueceuSenhaPageState();
}

class _EsqueceuSenhaPageState extends State<EsqueceuSenhaPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetSenha() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email enviado!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //printando uma svg
                  SvgPicture.asset(
                    'assets/icons/email.svg',
                    width: 200,
                    height: 200,
                  ),
                  const Text('Verifique sua caixa de entrada'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          color: Color(0xFF01bdd6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Informe o email para recuperar a senha',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blueColor)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.white,
                      filled: true),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validatorless.multiple([
                    Validatorless.required('Campo obrigatório'),
                    Validatorless.email('Email inválido ex: fulano@gmail.com'),
                  ]),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width * 0.8,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: resetSenha,
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
