import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:flutter/material.dart';

import '../../services/set_casos_service.dart';
import '../home_page.dart';

class PageEmergencia extends StatefulWidget {
  const PageEmergencia({super.key});

  @override
  State<PageEmergencia> createState() => _PageEmergenciaState();
}

class _PageEmergenciaState extends State<PageEmergencia> {
  bool ajudaMedicaOrMedicou = false;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pergunta1Controller = TextEditingController();
  final TextEditingController _pergunta2Controller = TextEditingController();
  final TextEditingController _pergunta3Controller = TextEditingController();
  final TextEditingController _pergunta4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergência'),
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
                Text('Aonde foi picado?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                Container(
                  color: Colors.grey[200],
                  height: size.height * 0.32,
                  width: size.width * 0.5,
                  child: Text('aqui vai um boneco'),
                ),
                SizedBox(height: 10),
                //sim ou nao
                Text('Se automedicou ou procurou ajuda médica?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: ajudaMedicaOrMedicou,
                          onChanged: (bool? value) {
                            setState(() {
                              ajudaMedicaOrMedicou = value!;
                            });
                          },
                        ),
                        Text('Sim',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: !ajudaMedicaOrMedicou,
                          onChanged: (bool? value) {
                            setState(() {
                              ajudaMedicaOrMedicou = !value!;
                            });
                          },
                        ),
                        Text('Não',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Mora perto de:'),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma opção';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  items: <String>[
                    'Lote Vago',
                    'Cemitério',
                    'Depósito de Entulho',
                    'Linha de Trem',
                    'Ferro Velho',
                    'Área de Mata',
                    'Rio',
                    'Outro'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _pergunta2Controller.text = value!;
                    });
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: size.width * 0.7,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _adicionarCaso();
                    },
                    child: const Text('Registrar Emergência'),
                  ),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: const Text('Ligar para Emergência'),
                          content: const Text('vou colocar pra abrir o discador do celular'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Ligar'),
                            ),
                          ],
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Ligar para Emergência',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                //mostrar as ubs mais proximas
                SizedBox(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const MapsPlace()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Mostrar UBS mais próximas',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _adicionarCaso() async {
    if (_formKey.currentState!.validate()) {
      await SetCasosService().adicionarCaso('Emergência', 1, _pergunta2Controller.text, null);
      showSnackbarMessage(context, 'Caso criado com sucesso');
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
