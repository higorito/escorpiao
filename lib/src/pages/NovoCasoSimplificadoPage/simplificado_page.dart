import 'package:escorpionico_proj/src/pages/NovoCasoSimplificadoPage/widgets/documento.dart';
import 'package:escorpionico_proj/src/pages/home_page.dart';
import 'package:escorpionico_proj/src/services/estado_foto.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../services/set_casos_service.dart';
import '../../services/upload_image.dart';

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
  final TextEditingController _pergunta2Controller = TextEditingController();

  bool isLoading = false;

  int selectedIndex = -1;

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

  final List<String> imageUrls = [
    'https://s2-g1.glbimg.com/xd8Rs8Yw-ub60tqnc5dWtcuzdHw=/0x0:1024x714/1000x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2024/i/t/75zw0sTWehjA0rPOJBWQ/large-46-.jpeg',
    'https://s2-g1.glbimg.com/lU4g3RHdxMyeFGvI7__NcZNczGI=/0x0:768x1024/1000x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2024/R/t/3d5nhNQEKmPrg3kKDIcw/large-95-.jpg',
    'https://s2-g1.glbimg.com/ZNBxI6kEnLZziH__k08vyisDUxs=/0x0:1024x683/1000x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2024/i/1/Yi2ZKyRiKTMgd9NlgBfg/large-47-.jpeg',
    'https://kelldrin.com.br/wp-content/uploads/2022/08/escorpiao.jpg',
    'https://static.mundoeducacao.uol.com.br/mundoeducacao/conteudo_legenda/fa48f290f347a1a53553286d51baf118.jpg',
    'https://www.biomax-mep.com.br/wp-content/webp-express/webp-images/uploads/2012/05/escorpiao-filhotes.jpg.webp',
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/150',
  ];

  final FirebaseImageUploader uploadImageService = FirebaseImageUploader();

  @override
  void initState() {
    _pergunta2Controller.text = 'Selecione uma opção';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avistamento de Escorpião'),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text('Acidente'),
                //         Checkbox(
                //             value: isAvistamento,
                //             onChanged: (bool? value) {
                //               qualCaso(value!);
                //             }),
                //       ],
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text('Avistamento'),
                //         Checkbox(
                //             value: isAcidente,
                //             onChanged: (bool? value) {
                //               qualCaso(!value!);
                //             }),
                //       ],
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 28,
                // ),
                const Text('Aonde você viu:',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height * 0.13,
                  width: size.width * 0.4,
                  child: DocumentBoxWidget(
                    icon: Image.asset('assets/icons/photo-camera.png'),
                    labels: 'Foto do local',
                    uploaded: false,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Envie sua Imagem'),
                                content: SizedBox(
                                    width: size.width * 0.9,
                                    height: size.height * 0.5,
                                    child: const FirebaseImageUploader()),
                              ));
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('Selecione o tipo de Escorpião (clique)',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: size.height * 0.45,
                  width: size.width * 0.95,
                  child: SizedBox.expand(
                    child: GridView.builder(
                      itemCount: imageUrls.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: index == selectedIndex
                                    ? Colors.redAccent
                                    : Colors.transparent,
                                width: 5.0,
                              ),
                            ),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                const Text('Mora perto de:',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  // style: const TextStyle(color: AppTheme.orangeColor, fontSize: 16),
                  value: 'Selecione uma opção',
                  validator: (value) {
                    if (value == null || value == 'Selecione uma opção') {
                      return 'Selecione uma opção';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
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
                      _pergunta2Controller.text = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    'Sua localização atual será enviada junto com o caso.',
                    style: TextStyle(fontWeight: FontWeight.w500)),

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
                      tratar();
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Adicionar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tratar() async {
    if (_formKey.currentState!.validate()) {
      //validar foto

      //validar tipo de escorpião
      if (selectedIndex == null || selectedIndex == -1) {
        showSnackbarMessage(context, 'Selecione um tipo de escorpião');
        setState(() {
          isLoading = false;
        });
        return;
      }

      //validar local perto
      if (_pergunta2Controller.text == 'Selecione uma opção') {
        showSnackbarMessage(context, 'Selecione "Mora perto de"');
        setState(() {
          isLoading = false;
        });
        return;
      }

      await _adicionarCaso(selectedIndex, _pergunta2Controller.text);
    }
  }

  Future<void> _adicionarCaso(int slINdex, String per) async {
    if (_formKey.currentState!.validate()) {
      await SetCasosService().adicionarCaso('avistamento',slINdex, per, AppState().nomeFoto);
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
