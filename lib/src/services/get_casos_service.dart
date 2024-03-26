import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCasosService {
  static Future<List<LatLng>> getCasesCoordinates(String documentId) async {
    CollectionReference cases = FirebaseFirestore.instance.collection('casos');
    DocumentSnapshot snapshot = await cases.doc(documentId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Verifique se 'latLong' está presente e é um mapa
      if (data.containsKey('latLong') ) {
        // Acesse latitude e longitude do mapa 'latLong'
        var latitude = data['latLong'].latitude;
        var longitude = data['latLong'].longitude;

        // Crie uma lista de LatLng com a latitude e longitude
        List<LatLng> latLngList = [LatLng(latitude, longitude)];

        // Você pode adicionar mais pontos à lista aqui se necessário

        return latLngList;
      } else {
        // Se 'latLong' não estiver presente ou não for um mapa
        throw Exception('Dados de localização inválidos');
      }
    } else {
      // Se o documento não existir
      throw Exception('Documento não encontrado');
    }
  }
}
