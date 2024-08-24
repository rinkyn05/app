import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'image_source_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadHomeImage(
    Function(String) updateImageUrl, BuildContext context) async {
  final picker = ImagePicker();

  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    return;
  }

  ImageSource? source = await showImageSourceDialog(context);
  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        String userId = FirebaseAuth.instance.currentUser!.email!;
        String fileExtension = pickedFile.path.split('.').last;
        String imageUrl = await uploadImageToFirebaseStorage(
            userId, imageFile, fileExtension);

        updateImageUrl(imageUrl);

        await updateOrCreateUserImageField(userId, imageUrl);
      } catch (e) {
        // Manejar errores
      }
    }
  }
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

Future<String> uploadImageToFirebaseStorage(
    String userId, File imageFile, String fileExtension) async {
  final storageRef =
      FirebaseStorage.instance.ref('user_home_images/$userId.$fileExtension');
  await storageRef.putFile(imageFile);
  return await storageRef.getDownloadURL();
}

Future<void> updateOrCreateUserImageField(String email, String imageUrl) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final querySnapshot =
      await usersRef.where('Correo Electrónico', isEqualTo: email).get();

  if (querySnapshot.docs.isNotEmpty) {
    final userDoc = querySnapshot.docs.first;
    await userDoc.reference.update({'image_home_url': imageUrl});
    print(
        'Campo "image_home_url" actualizado para el usuario con correo electrónico: $email');
  } else {
    print('No se encontró ningún usuario con el correo electrónico: $email');
  }
}
