import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> requestCameraAndGalleryPermission(BuildContext context) async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    PermissionStatus storagePermissionStatus = await Permission.storage.status;

    if (!cameraPermissionStatus.isGranted) {
      PermissionStatus cameraPermissionResult = await Permission.camera.request();
      if (cameraPermissionResult != PermissionStatus.granted) {
        _showPermissionDeniedDialog(context);
        return false;
      }
    }

    if (!storagePermissionStatus.isGranted) {
      PermissionStatus storagePermissionResult = await Permission.storage.request();
      if (storagePermissionResult != PermissionStatus.granted) {
        _showPermissionDeniedDialog(context);
        return false;
      }
    }

    return true;
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissão negada'),
          content: Text('Por favor, conceda permissão para acessar a câmera e a galeria para continuar.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}