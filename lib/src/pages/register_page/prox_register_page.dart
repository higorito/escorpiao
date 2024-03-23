import 'package:flutter/material.dart';

class ProxRegisterpage extends StatelessWidget {
  const ProxRegisterpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text('Próxima página'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: const Text('Ir para a próxima página'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
