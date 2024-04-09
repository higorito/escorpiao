import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: MUDAR UM POUCO AQUI
class Data {
  String img;
  GeoPoint latLong;
  int per1;
  String per2;
  String tipo;
  bool per3;
  String per4;

  Data({
    required this.img,
    required this.latLong,
    required this.per1,
    required this.per2,
    required this.tipo,
    required this.per3,
    required this.per4,
  });

  factory Data.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Data(
      img: data['img'] ?? '',
      latLong: data['latLong'] ?? GeoPoint(0, 0),
      per1: data['per1'] ?? 0,
      per2: data['per2'] ?? '',
      tipo: data['tipo'] ?? '',
      per3: data['per3'] ?? false,
      per4: data['per4'] ?? '',
    );
  }
}
