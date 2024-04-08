import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  String img;
  GeoPoint latLong;
  int per1;
  String per2;
  String tipo;

  Data({
    required this.img,
    required this.latLong,
    required this.per1,
    required this.per2,
    required this.tipo,
  });

  factory Data.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Data(
      img: data['img'] ?? '',
      latLong: data['latLong'] ?? GeoPoint(0, 0),
      per1: data['per1'] ?? 0,
      per2: data['per2'] ?? '',
      tipo: data['tipo'] ?? '',
    );
  }
}
