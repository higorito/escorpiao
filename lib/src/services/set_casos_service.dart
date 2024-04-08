import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class SetCasosService  { 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarCaso(String tipo ,int per1, String per2, String? img, bool per3, per4) async {
    try {
      // Verifica e solicita permissão de localização
      if (!(await Permission.location.isGranted)) {
        await Permission.location.request();
      }

      LocationData locationData = await getLocation();

      CollectionReference casosCollection = _firestore.collection('casos');

      await casosCollection.add({
        'data': DateTime.now(),
        'latLong': GeoPoint(locationData.latitude!, locationData.longitude!),
        'img': img ?? '',
        'tipo': tipo,
        'tpEscorpiao': per1,
        'perto-de': per2,
        'ajuda-or-medicou': per3,
        'lugar-picada': per4,
      });

      print('Caso adicionado com sucesso!');
    } catch (e) {
      print('Erro ao adicionar caso: $e');
    }
  }

  Future<LocationData> getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }
}
