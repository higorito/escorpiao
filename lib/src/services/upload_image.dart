import 'dart:io';

import 'package:escorpionico_proj/src/services/estado_foto.dart';
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
  AppState appState = AppState();

  bool isLoading = false;

  Future<void> _getImageFromGallery() async {
    // PermissionManager.requestCameraAndGalleryPermission(context);

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getImageFromCamera() async {
    // PermissionManager.requestCameraAndGalleryPermission(context); arrumar

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
      AppState().nomeFoto = ref.fullPath.replaceAll('images/', '');
      UploadTask uploadTask = ref.putFile(_imageFile!);
      await uploadTask.whenComplete(() {
        appState.fotoCarregada = true;
        Navigator.pop(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Imagem salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar imagem!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        isLoading = false;
      });
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
                        child: const Icon(Icons.image,
                            size: 100, color: AppTheme.orangeColor),
                      ),
                    ),
                    size.height > 600
                        ? const SizedBox(height: 20)
                        : const SizedBox(height: 10),
                    const Text('Nenhuma imagem selecionada.'),
                  ],
                )
              : Image.file(
                  _imageFile!,
                  width: size.width * 0.7,
                  height: size.height * 0.3,
                ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async => await _getImageFromGallery(),
                child: const Text('Galeria'),
              ),
              ElevatedButton(
                onPressed: () async => await _getImageFromCamera(),
                child: const Text('Câmera'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: size.width * 0.7,
            height: 48,
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _uploadImageToFirebase(context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading? const CircularProgressIndicator(): const Text('Salvar Imagem '),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
