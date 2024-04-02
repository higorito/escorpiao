import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File file) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}