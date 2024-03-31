import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escorpionico_proj/src/pages/add_novos_casos/add_novos_casos.dart';
import 'package:escorpionico_proj/src/pages/login_page/auth_page.dart';
import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:escorpionico_proj/src/pages/read/get_user_name.dart';
import 'package:escorpionico_proj/src/pages/testepage/teste_page.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'NovoCasoSimplificadoPage/simplificado_page.dart';
import 'emergencia/emergencia_page.dart';
import 'maps_page/maps_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Deseja sair?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                logout();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AuthPage()));
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.blueColor,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    radius: 50,
                    //imagem do usuario vindo do firebase auth
                    backgroundImage: Image(
                            image: (FirebaseAuth
                                        .instance.currentUser!.photoURL !=
                                    null)
                                ? foto.image
                                : const AssetImage('assets/icons/avatar.png'))
                        .image,
                  ),
                ),
                const Expanded(
                    child: Text(
                  'EscorpMap',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )),
              ],
            ),
          ),
          ListTile(
            title: const Text('Configurações'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Sobre nós'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Sobre nós'),
                      content: const Text(
                          'EscorpMap é um aplicativo para localização de casos de escorpião na cidade de Bambuí-MG. \n\nDesenvolvido por Higor Pereira.\nContato: higorps198@gmail.com \n\nVersão 1.0.0'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Fechar')),
                      ],
                    );
                  });
            },
          ),
          // ListTile(
          //   title: const Text('Testes'),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => const TestePage()));
          //   },
          // ),
          ListTile(
            title: const Text('Termos de uso'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Termos de uso'),
                      content: const Text(
                          'Ao utilizar o aplicativo EscorpMap, você concorda com os termos de uso.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Fechar')),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              _showDialog(context);
            },
          ),
        ],
      ),
    );
  }

  //ler os dados do firebase
  List<String> docIds = [];

  Future getDocsID() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (doc) {
              docIds.add(doc.reference.id);
            },
          ),
        );
  }

  final usuario = (FirebaseAuth.instance.currentUser!.email != null)
      ? FirebaseAuth.instance.currentUser!.displayName
      : Text(FirebaseAuth.instance.currentUser!.email!.substring(
          0, FirebaseAuth.instance.currentUser!.email!.indexOf('@')));

  final foto = (FirebaseAuth.instance.currentUser!.photoURL != null)
      ? Image.network(FirebaseAuth.instance.currentUser!.photoURL!)
      : Image.asset('assets/icons/avatar.png');

  // final usuario =  'Higor';
  @override
  void initState() {
    getDocsID();
    super.initState();
  }

  var url_image =
      'https://www.saude.ce.gov.br/wp-content/uploads/sites/9/2020/12/Banner_CB_Capa_cuidados-basicos-escorpiao_09-12-20.png';

  final List<String> ListImages = [
    'https://www.saude.ce.gov.br/wp-content/uploads/sites/9/2020/12/Banner_CB_Capa_cuidados-basicos-escorpiao_09-12-20.png',
    'https://palotina.pr.gov.br/uploads/articles/2023-03/escorpioes-prevencao-ainda-e-a-melhor-solucao-para-evitar-acidentes-3f2e1b09a7.jpeg',
    'https://scontent.fvag4-1.fna.fbcdn.net/v/t1.6435-9/80327540_2884569578220844_2339922092943736832_n.png?stp=dst-png_p526x296&_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_ohc=-xBhM9h7adgAX8_QZba&_nc_ht=scontent.fvag4-1.fna&oh=00_AfDhV1GhUQKds_y6CdEKDBdFFlEwrgjAs6ZRwNhXUfw1Mw&oe=663005FD',
    'https://www.extrema.mg.gov.br/wp-content/uploads/2020/01/escorpi%C3%A3o-700x500.jpg',
    'https://guaratingueta.sp.gov.br/wp-content/uploads/2022/08/escorpianismo-800x445.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: drawer(context),
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          title: Column(
            children: [
              const Text(
                'EscorpMap',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: AppTheme.blueColor,
                    letterSpacing: 1.5),
              ),
              Text(
                (usuario != null)
                    ? 'Seja bem vindo, $usuario!'
                    : 'Seja bem vindo, ${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}! ',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: size.height * 0.23,
                  width: double.infinity,
                  child: ExpandableCarousel(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                    ),
                    items: ListImages.map((e) => Image.network(
                          e,
                          fit: BoxFit.cover,
                        )).toList(),
                  )),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 24, bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PageEmergencia()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_alert,
                              color: Colors.redAccent,
                              size: size.width * 0.1,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Emergência!',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                                Text(
                                  'Fui picado! O que fazer?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NovoCasoSimplificadoPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_location,
                              color: AppTheme.blueColor,
                              size: size.width * 0.1,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adicionar novo caso',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.blueColor),
                                ),
                                Text(
                                  'Viu um escorpião? ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapsPlace()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.map,
                              color: AppTheme.blueColor,
                              size: size.width * 0.1,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mapa de casos',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.blueColor),
                                ),
                                Text(
                                  'Visualize os casos',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
