import 'package:flutter/material.dart';

import '../../services/set_casos_service.dart';

class NovoCasoSimplificadoPage extends StatefulWidget {
  const NovoCasoSimplificadoPage({super.key});

  @override
  State<NovoCasoSimplificadoPage> createState() =>
      _NovoCasoSimplificadoPageState();
}

class _NovoCasoSimplificadoPageState extends State<NovoCasoSimplificadoPage> {
  bool isAvistamento = true;
  bool isAcidente = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pergunta1Controller = TextEditingController();
  final TextEditingController _pergunta2Controller = TextEditingController();
  final TextEditingController _pergunta3Controller = TextEditingController();
  final TextEditingController _pergunta4Controller = TextEditingController();

  bool isLoading = false;

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
          child: Form(
            key: _formKey,
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
                  controller: _pergunta1Controller,
                  decoration: const InputDecoration(
                    labelText: 'PERGUNTA 1',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _pergunta2Controller,
                  decoration: const InputDecoration(
                    labelText: 'PERGUNTA 2',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _pergunta3Controller,
                  decoration: const InputDecoration(
                    labelText: 'PERGUNTA 3',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _pergunta4Controller,
                  decoration: const InputDecoration(
                    labelText: 'PERGUNTA 4',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Sua localização atual será enviada junto com o caso.',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                // Text('Fotos:'),
                // const SizedBox(
                //   height: 10,
                // ),
                // SizedBox(
                //   height: 80,
                //   width: 120,
                //   child: DocumentBoxWidget(
                //     icon: const Icon(Icons.add_a_photo),
                //     labels: 'Foto do local',
                //     uploaded: false,
                //     onTap: () {
                //       showDialog(context: context, builder: (context) => const AlertDialog(title: Text('Foto do local, sera implementado em breve')));
                //       //TODO: Implementar ação de upload de foto

                //     },
                //   ),
                // ),
                const SizedBox(height: 10),
                const Text('Verifique as informações antes de continuar:'),
                const SizedBox(height: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 58,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          _adicionarCaso();
                        },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Adicionar'))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _adicionarCaso() async {
    if (_formKey.currentState!.validate()) {
      await SetCasosService().adicionarCaso();
      showSnackbarMessage(context, 'Caso criado com sucesso');
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: (message == 'Usuário criado com sucesso' ||
                message == 'Caso criado com sucesso')
            ? Colors.green
            : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 180, right: 20, left: 20),
      ),
    );
  }
}
