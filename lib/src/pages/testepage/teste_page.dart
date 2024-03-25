import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escorpionico_proj/src/pages/read/get_casos.dart';
import 'package:flutter/material.dart';

import '../read/get_user_name.dart';

class TestePage extends StatefulWidget {
  const TestePage({super.key});

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  List<String> docIds = [];

  Future getDocsID() async {
    await FirebaseFirestore.instance.collection('casos').get().then(
          (snapshot) => snapshot.docs.forEach(
            (doc) {
              docIds.add(doc.reference.id);
            },
          ),
        );
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body:Center(
        child: Expanded(
          flex: 2,
          child: FutureBuilder(
            future: getDocsID(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: docIds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: GetCasos(documentId: docIds[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
