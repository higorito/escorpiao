import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escorpionico_proj/src/pages/add_novos_casos/add_novos_casos.dart';
import 'package:escorpionico_proj/src/pages/login_page/auth_page.dart';
import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:escorpionico_proj/src/pages/read/get_user_name.dart';
import 'package:escorpionico_proj/src/pages/testepage/teste_page.dart';
import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'maps_page/maps_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    FirebaseAuth.instance.signOut();
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
            decoration: BoxDecoration(
              color: AppTheme.blueColor,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    radius: 50,
                    //imagem do usuario vindo do firebase auth
                    backgroundImage: Image.network(
                            FirebaseAuth.instance.currentUser!.photoURL!)
                        .image,
                  ),
                ),
                Expanded(
                    child: const Text(
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
          ListTile(
            title: const Text('Testes'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TestePage()));
            },
          ),
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
          SizedBox(
            height: 100,
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              _showDialog(context);
            },),
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

  final usuario = FirebaseAuth.instance.currentUser!.displayName;

  final foto = Image.network(FirebaseAuth.instance.currentUser!.photoURL!);

  // final usuario =  'Higor';
  @override
  void initState() {
    getDocsID();
    super.initState();
  }

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
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppTheme.blueColor,
                    letterSpacing: 1.5),
              ),
              Text(
                'Seja bem vindo, $usuario ! ',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
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
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'Banner de conscientização ou notícias',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Casos recentes',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.blueColor),
                    ),
                    SizedBox(
                      height: size.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: Text('Caso ${index + 1}'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Adicionar novo caso',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.blueColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddNovosCasosPage()));
                        },
                        child: const Text(
                          'Adicionar novo caso',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Visualizar os casos e UBSs próximas',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.blueColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapsPlace()));
                        },
                        child: const Text(
                          'Acessar o Mapa',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
