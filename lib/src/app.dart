import 'package:escorpionico_proj/src/pages/home_page.dart';
import 'package:escorpionico_proj/src/pages/login_page/login_page.dart';
import 'package:escorpionico_proj/src/pages/maps_page/maps_page.dart';
import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';

import 'package:flutter/material.dart';

import 'pages/login_page/auth_page.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: AppTheme.lightTheme,
      home: const AuthPage(),
      // routes: {
      //   '/auth': (context) => const AuthPage(),
      //   '/login': (context) => const LoginPage(),
      //   '/home': (context) => const HomePage(),
      //   '/maps_place': (context) => const MapsPlace(),
      // },
    );
  }
}
