import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: const Text('Nome app', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.orangeAccent,
              child: const Center(
                child: Text('Banner', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              ),
            ),

            const SizedBox(height: 20,),

            
          ],
        ),
      )
    );
  }
}