import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FirebaseImageDownloader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Uint8List?> getImage(String imageName) async {
    try {
      Reference ref = _storage.ref().child('images/$imageName');

      final Uint8List? imageData = await ref.getData();

      return imageData;
    } catch (e) {
      print('Erro ao obter imagem do Firebase Storage: $e');
      return null;
    }
  }
}
