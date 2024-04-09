import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class SetCasosService  { 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future adicionarCaso(String tipo ,int tpEscorpiao, String perto, String? img, bool ajudaMedicou, lugarPic) async {
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
        'tpEscorpiao': tpEscorpiao,
        'perto-de': perto,
        'ajuda-or-medicou': ajudaMedicou,
        'lugar-picada': lugarPic,
      });

      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<LocationData> getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }
}
