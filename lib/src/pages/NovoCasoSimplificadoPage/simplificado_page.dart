import 'package:flutter/material.dart';

import 'widgets/documento.dart';

class NovoCasoSimplificadoPage extends StatefulWidget {
  const NovoCasoSimplificadoPage({super.key});

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
        child: Container(
          padding:
              const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'PERGUNTA 1',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'PERGUNTA 2',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'PERGUNTA 3',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'PERGUNTA 4',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Fotos:'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                width: 120,
                child: DocumentBoxWidget(
                  icon: const Icon(Icons.add_a_photo),
                  labels: 'Foto do local',
                  uploaded: false,
                  onTap: () {
                    showDialog(context: context, builder: (context) => const AlertDialog(title: Text('Foto do local, sera implementado em breve')));
                    //TODO: Implementar ação de upload de foto
                    
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text('Verifique as informações antes de continuar:'),
              const SizedBox(height: 10),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 58,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Continuar'))),
            ],
          ),
        ),
      ),
    );
  }
}
