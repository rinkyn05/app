// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'image_source_dialog.dart';

Future<void> uploadExercise3DImage(
    BuildContext context, Function(String) updateImage3dUrl) async {
  final picker = ImagePicker();

  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    return;
  }

  await selectAnduploadExercise3DImage(context, picker, updateImage3dUrl);
}

Future<bool> requestPermissions() async {
  var cameraStatus = await Permission.camera.status;
  var storageStatus = await Permission.storage.status;

  if (Platform.isAndroid) {
    if (await Permission.photos.isDenied) {
      var photosStatus = await Permission.photos.request();
      print('Permiso de Photos solicitado: $photosStatus');
    }
  }

  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
    print('Permiso de cámara solicitado: $cameraStatus');
  }

  if (Platform.isAndroid && (await Permission.photos.isDenied)) {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  } else {
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }
  }

  return cameraStatus.isGranted &&
      (storageStatus.isGranted || await Permission.photos.isGranted);
}

Future<void> selectAnduploadExercise3DImage(BuildContext context,
    ImagePicker picker, Function(String) updateImage3dUrl) async {
  ImageSource? source = await showImageSourceDialog(context);

  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        var uuid = const Uuid();
        String fileExtension = pickedFile.path.split('.').last;
        String uniqueFileName = '${uuid.v4()}.$fileExtension';
        await FirebaseStorage.instance
            .ref('exercise_images_tred/$uniqueFileName')
            .putFile(imageFile);
        String image3dUrl = await FirebaseStorage.instance
            .ref('exercise_images_tred/$uniqueFileName')
            .getDownloadURL();
        updateImage3dUrl(image3dUrl);
      } catch (e) {
        // Manejar errores
      }
    }
  }
}
