import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escorpionico_proj/src/pages/read/get_casos.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/get_casos_service.dart';
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

  Future<List<LatLng>> getCasos() async{
    for (var docId in docIds) {
      List<LatLng> latLngList = await GetCasosService.getCasesCoordinates(docId);
      print('LISTAAAA: $latLngList');
    }
    return [];
  }



  @override
  void initState() {
    getDocsID();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
             getCasos();
          },
          child: const Text('Get Casos'),
        )
      ),
    );
  }
}
