import 'package:escorpionico_proj/src/pages/login_page/login_controller.dart';
import 'package:escorpionico_proj/src/pages/login_page/login_store.dart';
import 'package:escorpionico_proj/src/services/auth_service_google.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:validatorless/validatorless.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = LoginController(LoginStore());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: size.height,
        ),
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: ('assets/images/background_login.png'),
          //   fit: BoxFit.cover,

          // ),
          color: Color(0xFF01bdd6),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  const Text('LOGIN', style: AppTheme.titleStyle),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    controller: controller.emailController,
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo obrigatório'),
                      Validatorless.email('E-mail inválido'),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: controller.obscurePassword,
                    builder:
                        //pra ficar observando a mudança de estado do signal
                        (context, _, __) {
                      return TextFormField(
                        obscureText:
                            controller.obscurePassword.value ? true : false,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.togglePasswordVisibility();
                            },
                            icon: !controller.obscurePassword.value
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                        controller: controller.passwordController,
                        validator: Validatorless.multiple([
                          Validatorless.required('Campo obrigatório'),
                          Validatorless.min(6, 'Senha muito curta'),
                        ]),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.forgotPassword();
                        },
                        child: const Text('Esqueceu a senha?',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 48,
                    child: Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () async {
                          await controller.validateForm();
                          final valido = controller.isFormValid;

                          if (valido) {
                            await controller.login(
                                controller.emailController.text,
                                controller.passwordController.text);
                          }
                        },
                        child: ValueListenableBuilder(
                          valueListenable: controller.isLoading,
                          builder: (context, _, __) {
                            return controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text('ENTRAR');
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'OU REGISTRE-SE COM',
                    style: TextStyle(
                        color: AppTheme.blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.register(false);
                      },
                      child: const Text('USUÁRIO COMUM '),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppTheme.blueColor,
                      ),
                      onPressed: () {
                        controller.register(true);
                      },
                      child: const Text('AGENTE DE SAÚDE'),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
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
                      Text(
                        'Continuar com',
                        style: TextStyle(
                            color: AppTheme.blueColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
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
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.blueColor),
                              ));
                            
                        },
                      );
                      
                      await AuthServiceGoogle().signGoogle();

                      Navigator.of(context).pop();
                      

                      final nav =  Navigator.of(context);

                      nav.pushReplacement(MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }));

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
                            image: AssetImage('assets/icons/google.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
