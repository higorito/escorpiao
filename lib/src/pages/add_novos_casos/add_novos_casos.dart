import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class AddNovosCasosPage extends StatefulWidget {
  const AddNovosCasosPage({super.key});

  @override
  State<AddNovosCasosPage> createState() => _AddNovosCasosPageState();
}

class _AddNovosCasosPageState extends State<AddNovosCasosPage> {
  bool localVerificado = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController contatoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar novos casos'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                  validator: Validatorless.required('Nome obrigatório'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: enderecoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Endereço',
                  ),
                  validator: Validatorless.required('Endereço obrigatório'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descrição',
                  ),
                  validator: Validatorless.required('Descrição obrigatória'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: horaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hora',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: contatoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contato',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fotoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Foto',
                  ),
                ),
              ),
              Visibility(
                visible: localVerificado,
                replacement: ElevatedButton(
                  onPressed: () {
                    _showVerificar(context);
                  },
                  child: const Text('Verificar localização'),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Adicionado com sucesso!'),
                                  content: const Text(
                                      'O caso foi adicionado com sucesso!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ));
                        clearCampos();
                      },
                      child: const Text('Adicionar'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void clearCampos() {
    nomeController.clear();
    enderecoController.clear();
    descricaoController.clear();
    dataController.clear();
    horaController.clear();
    contatoController.clear();
    emailController.clear();
    fotoController.clear();
    setState(() {
      localVerificado = false;
    });
  }

  _showVerificar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verificar localização'),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              const Text('Por favor, verifique a sua localização no mapa'),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: const Center(
                  child: Text('Mapa ou ir para a tela de mapa'),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  localVerificado = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
        ],
      ),
    );
  }
}
