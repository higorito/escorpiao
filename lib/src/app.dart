import 'package:escorpionico_proj/src/pages/esqueceu_senha/esqueceu_senha.dart';
import 'package:escorpionico_proj/src/pages/home_page.dart';
import 'package:escorpionico_proj/src/pages/login_page/login_page.dart';
import 'package:escorpionico_proj/src/pages/maps_page/maps_page.dart';
import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:escorpionico_proj/src/pages/register_page/prox_register_page.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';

import 'package:flutter/material.dart';

import 'pages/login_page/auth_page.dart';
import 'pages/register_page/register_page.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: AppTheme.lightTheme,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/2-register': (context) => const ProxRegisterpage(),
        // '/esqueceu-senha': (context) => const EsqueceuSenhaPage(),
      },
    );
  }
}
