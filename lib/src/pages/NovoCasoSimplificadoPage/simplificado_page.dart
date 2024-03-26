import 'package:flutter/material.dart';

class NovoCasoSimplificadoPage extends StatefulWidget {
  NovoCasoSimplificadoPage({super.key});

  @override
  State<NovoCasoSimplificadoPage> createState() =>
      _NovoCasoSimplificadoPageState();
}

class _NovoCasoSimplificadoPageState extends State<NovoCasoSimplificadoPage> {
  bool isAvistamento = true;

  bool isAcidente = false;

  void qualCaso(bool value) {
    if (value) {
      isAvistamento = true;
      isAcidente = false;
    } else {
      isAvistamento = false;
      isAcidente = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Caso Simplificado'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Acidente'),
                Checkbox(
                    value: isAvistamento,
                    onChanged: (bool? value) {
                      qualCaso(value!);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Avistamento'),
                Checkbox(
                    value: isAcidente,
                    onChanged: (bool? value) {
                      qualCaso(!value!);
                    }),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Verifique as informações antes de continuar:'),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text('Continuar')),
          ],
        ),
      ),
    );
  }
}
