import 'package:escorpionico_proj/src/pages/maps_place/maps_place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'maps_page/maps_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                Navigator.of(context).pop();
                logout();
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  Drawer drawer( BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        
          // appBar: AppBar(
          //   leading: const Icon(Icons.menu),
          //   centerTitle: true,
          //   title: const Text(
          //     'Nome app',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          //   ),
          //   actions: [
          //     IconButton(
          //       onPressed: logout ,
          //       icon: const Icon(Icons.logout),
          //     ),
          //   ],
          // ),
          body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only( top: 12, left: 6, right: 6, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {
                    _showDialog(context);
 

                  }, icon: const Icon(Icons.logout)),
                  const Column(
                    
                    children: [
                      Expanded(
                        child: Text(
                          "Olá, Higor",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Seja bem vindo!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      backgroundImage: const AssetImage('assets/icons/avatar.png'),
                    ),
                    onTap: () {
                      debugPrint("clicou");
                      // _showDialog(context);
                    },
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.orangeAccent,
                    child: const Center(
                      child: Text(
                        'Banner',
                        style:
                            TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 100,
                          width: 100,
                          color: Colors.grey[300],
                          child: Text('Item $index'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 58,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MapsPlace()));
                    }, child: const Text('Acessar o Maps')),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
