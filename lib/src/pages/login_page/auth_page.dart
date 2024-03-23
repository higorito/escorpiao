import 'package:escorpionico_proj/src/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';

import '../home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges() ,
     builder: (context, snapshot)
     {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator());
        }
        if(snapshot.hasData) 
        {
          return const HomePage();
        }
        return const LoginPage();
     }
     );
  }
}