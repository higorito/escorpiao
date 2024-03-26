import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCasos extends StatelessWidget {
  const GetCasos({super.key, required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context) {
        CollectionReference users = FirebaseFirestore.instance.collection('casos');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          ( context,  snapshot) {
       if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

            var latitude = data['latLong'].latitude;
            var longitude = data['latLong'].longitude;
            List<LatLng> latLngList = [LatLng(latitude, longitude)];
            print('latLngList: $latLngList');
          return Text('Latitude: $latitude, Longitude: $longitude');
        }

        return const Text('carregando...');
      },
    );
  }
}