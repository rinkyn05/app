// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage para almacenar imágenes.
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets.
import 'package:image_picker/image_picker.dart'; // Importa la biblioteca para seleccionar imágenes de la cámara o galería.
import 'package:permission_handler/permission_handler.dart'; // Importa para manejar permisos de la aplicación.
import 'dart:io'; // Importa para manejar archivos en el sistema.
import 'package:uuid/uuid.dart'; // Importa para generar identificadores únicos.
import 'image_source_dialog.dart'; // Importa el diálogo para seleccionar la fuente de la imagen.

// Función principal para subir una imagen 3D de ejercicio.
Future<void> uploadExercise3DImage(
    BuildContext context, Function(String) updateImage3dUrl) async {
  final picker = ImagePicker(); // Crea una instancia de ImagePicker.

  // Solicita permisos necesarios para la cámara y el almacenamiento.
  bool permissionsGranted = await requestPermissions();

  // Si no se conceden los permisos, cierra el diálogo actual.
  if (!permissionsGranted) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Cierra el diálogo si es posible.
    }
    return; // Sale de la función si no hay permisos.
  }

  // Selecciona y sube la imagen 3D de ejercicio.
  await selectAnduploadExercise3DImage(context, picker, updateImage3dUrl);
}

// Función para solicitar permisos para la cámara y el almacenamiento.
Future<bool> requestPermissions() async {
  var cameraStatus = await Permission
      .camera.status; // Verifica el estado del permiso de cámara.
  var storageStatus = await Permission
      .storage.status; // Verifica el estado del permiso de almacenamiento.

  // Si la plataforma es Android, solicita permiso para fotos.
  if (Platform.isAndroid) {
    if (await Permission.photos.isDenied) {
      var photosStatus = await Permission.photos.request();
      print(
          'Permiso de Photos solicitado: $photosStatus'); // Mensaje sobre el permiso de fotos.
    }
  }

  // Si el permiso de cámara no está concedido, solicita permiso.
  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
    print(
        'Permiso de cámara solicitado: $cameraStatus'); // Mensaje sobre el permiso de cámara.
  }

  // Si es Android y el permiso de fotos está denegado, solicita el permiso.
  if (Platform.isAndroid && (await Permission.photos.isDenied)) {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  } else {
    // Si el permiso de almacenamiento no está concedido, solicita permiso.
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }
  }

  // Retorna verdadero si todos los permisos necesarios están concedidos.
  return cameraStatus.isGranted &&
      (storageStatus.isGranted || await Permission.photos.isGranted);
}

// Función para seleccionar y subir la imagen 3D de ejercicio.
Future<void> selectAnduploadExercise3DImage(BuildContext context,
    ImagePicker picker, Function(String) updateImage3dUrl) async {
  // Muestra el diálogo para seleccionar la fuente de la imagen (cámara o galería).
  ImageSource? source = await showImageSourceDialog(context);

  // Si se selecciona una fuente válida, utiliza el picker para elegir la imagen.
  if (source != null) {
    final pickedFile =
        await picker.pickImage(source: source); // Selecciona la imagen.

    // Si se selecciona una imagen, procesa la carga.
    if (pickedFile != null) {
      File imageFile = File(pickedFile
          .path); // Crea un archivo a partir de la imagen seleccionada.
      try {
        var uuid =
            const Uuid(); // Crea una instancia de Uuid para generar un identificador único.
        String fileExtension = pickedFile.path
            .split('.')
            .last; // Extrae la extensión del archivo de la imagen.
        // Genera un nombre de archivo único para la imagen 3D de ejercicio.
        String uniqueFileName = '${uuid.v4()}.$fileExtension';

        // Sube la imagen 3D de ejercicio a Firebase Storage.
        await FirebaseStorage.instance
            .ref('exercise_images_tred/$uniqueFileName')
            .putFile(imageFile);

        // Obtiene la URL de descarga de la imagen 3D recién subida.
        String image3dUrl = await FirebaseStorage.instance
            .ref('exercise_images_tred/$uniqueFileName')
            .getDownloadURL();

        updateImage3dUrl(
            image3dUrl); // Llama a la función proporcionada para actualizar la URL de la imagen en la UI.
      } catch (e) {
        // Manejar errores aquí (opcionalmente, podrías agregar un mensaje de error).
      }
    }
  }
}
