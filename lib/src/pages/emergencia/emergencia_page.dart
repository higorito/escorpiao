import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final TextEditingController _parteCorpo = TextEditingController();
  final TextEditingController _moraPerto = TextEditingController();

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
                const Text('Em qual local você foi picado?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                //onde foi picado
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
                  value: 'Selecione uma opção',
                  items: <String>[
                    'Selecione uma opção',
                    'Mão',
                    'Braço',
                    'Perna',
                    'Pé',
                    'Cabeça',
                    'Costas',
                    'Barriga',
                    'Pescoço',
                    'Rosto',
                    'Axila',
                    'Virilha',
                    'Joelho',
                    'Tornozelo',
                    'Outro'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _parteCorpo.text = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                //sim ou nao
                const Text('Você procurou assistência médica?',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
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
                        const Text('Sim',
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
                        const Text('Não',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Mora perto de:'),
                const SizedBox(height: 10),
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
                  value: 'Selecione uma opção',
                  items: <String>[
                    'Selecione uma opção',
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
                      _moraPerto.text = value!;
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
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Ligar para Emergência'),
                              content:
                                  const Text('Deseja ligar para o número 192?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _makePhoneCall('192');
                                  },
                                  child: const Text('Ligar'),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Row(
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
                const SizedBox(height: 12),
                //mostrar as ubs mais proximas
                SizedBox(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapsPlace()));
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
      setState(() {
        isLoading = true;
      });

      try {
        var response = await SetCasosService().adicionarCaso('Emergencia', -1,
            _moraPerto.text, null, ajudaMedicaOrMedicou, _parteCorpo.text);

        if (response == null) {
          showSnackbarMessage(context, 'Caso criado com sucesso');
          var nav = Navigator.of(context);
          nav.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        } else {
          showSnackbarMessage(context, 'Erro ao criar caso');
        }
      } catch (e) {
        showSnackbarMessage(context, 'Erro ao criar caso');
      }
      setState(() {
        isLoading = false;
      });
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
