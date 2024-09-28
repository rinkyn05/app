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

  print('Iniciando proceso para cargar la imagen...');

  bool permissionsGranted = await requestPermissions();

  print('Permisos otorgados: $permissionsGranted');

  if (!permissionsGranted) {
    print('Permisos no otorgados, volviendo atrás.');
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

Future<void> selectAndUploadExerciseImage(BuildContext context,
    ImagePicker picker, Function(String) updateImageUrl) async {
  ImageSource? source = await showImageSourceDialog(context);

  print('Fuente de imagen seleccionada: $source');

  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      print('Imagen seleccionada: ${pickedFile.path}');
      File imageFile = File(pickedFile.path);

      try {
        var uuid = const Uuid();
        String fileExtension = pickedFile.path.split('.').last;
        String uniqueFileName = '${uuid.v4()}.$fileExtension';

        print('Cargando imagen a Firebase Storage con nombre: $uniqueFileName');
        await FirebaseStorage.instance
            .ref('exercise_images/$uniqueFileName')
            .putFile(imageFile);

        String imageUrl = await FirebaseStorage.instance
            .ref('exercise_images/$uniqueFileName')
            .getDownloadURL();

        updateImageUrl(imageUrl);
        print('Imagen cargada y URL obtenida: $imageUrl');
      } catch (e) {
        print('Error al cargar la imagen: $e');
      }
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  } else {
    print('No se seleccionó ninguna fuente de imagen.');
  }
}
