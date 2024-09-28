// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'image_source_dialog.dart';

Future<void> uploadGifImage(
    BuildContext context, Function(String) updateGifUrl) async {
  final picker = ImagePicker();

  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    return;
  }

  await selectAndUploadGifImage(context, picker, updateGifUrl);
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

Future<void> selectAndUploadGifImage(BuildContext context, ImagePicker picker,
    Function(String) updateGifUrl) async {
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
            .ref('gif_images/$uniqueFileName')
            .putFile(imageFile);
        String gifUrl = await FirebaseStorage.instance
            .ref('gif_images/$uniqueFileName')
            .getDownloadURL();
        updateGifUrl(gifUrl);
      } catch (e) {
        // Manejar errores
      }
    }
  }
}
