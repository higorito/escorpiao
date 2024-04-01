import 'dart:io';

import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseImageUploader extends StatefulWidget {
  const FirebaseImageUploader({super.key});

  @override
  _FirebaseImageUploaderState createState() => _FirebaseImageUploaderState();
}

class _FirebaseImageUploaderState extends State<FirebaseImageUploader> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImageToFirebase(BuildContext context) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma imagem primeiro.'),
        ),
      );
      return;
    }

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = ref.putFile(_imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded to Firebase'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagem enviada com sucesso para o Firebase Storage!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar imagem para o Firebase Storage: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _imageFile == null
              ? Column(
                children: [
                  InkWell(
                    onTap: () => _getImageFromGallery(),
                    child: Container(
                      width: size.width * 0.5,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        color: AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.image, size: 100, color: AppTheme.orangeColor),
                    ),
                  ),
                  size.height > 600 ? const SizedBox(height: 20) : const SizedBox(height: 10),
                  const Text('Nenhuma imagem selecionada.'),
                ],
              )
              : Image.file(
                  _imageFile!,
                  width: size.width * 0.7,
                  height: size.height * 0.3,
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            style:  ElevatedButton.styleFrom(
              primary: AppTheme.orangeColor,
              onPrimary: Colors.white,
            ),
            onPressed: () => _getImageFromGallery(),
            child: const Text('Selecionar Imagem'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.7,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _uploadImageToFirebase(context),
              child: const Text('Enviar Imagem '),
            ),
          ),
        ],
      ),
    );
  }
}
