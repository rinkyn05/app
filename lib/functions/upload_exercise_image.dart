// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'image_source_dialog.dart';

Future<void> uploadExerciseImage(
    BuildContext context, Function(String) updateImageUrl) async {
  final picker = ImagePicker();

  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    return;
  }

  await selectAndUploadExerciseImage(context, picker, updateImageUrl);
}

Future<bool> requestPermissions() async {
  var cameraStatus = await Permission.camera.status;
  var storageStatus = await Permission.storage.status;

  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
  }

  if (!storageStatus.isGranted) {
    storageStatus = await Permission.storage.request();
  }

  return cameraStatus.isGranted && storageStatus.isGranted;
}

Future<void> selectAndUploadExerciseImage(BuildContext context,
    ImagePicker picker, Function(String) updateImageUrl) async {
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
            .ref('exercise_images/$uniqueFileName')
            .putFile(imageFile);
        String imageUrl = await FirebaseStorage.instance
            .ref('exercise_images/$uniqueFileName')
            .getDownloadURL();
        updateImageUrl(imageUrl);
      } catch (e) {
        // Manejar errores
      }
    }
  }
}