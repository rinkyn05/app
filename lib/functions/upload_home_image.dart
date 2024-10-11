import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication para manejar la autenticación de usuarios.
import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage para subir y almacenar imágenes.
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets.
import 'package:image_picker/image_picker.dart'; // Importa la biblioteca para seleccionar imágenes de la galería o cámara.
import 'package:permission_handler/permission_handler.dart'; // Importa para manejar permisos de la aplicación.
import 'dart:io'; // Importa para manejar archivos en el sistema.

import 'image_source_dialog.dart'; // Importa el diálogo para seleccionar la fuente de la imagen.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos.

// Función principal para subir una imagen de la casa.
Future<void> uploadHomeImage(
    Function(String) updateImageUrl, BuildContext context) async {
  final picker = ImagePicker(); // Crea una instancia de ImagePicker.

  // Solicita permisos necesarios para la cámara y el almacenamiento.
  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    return; // Si no se conceden los permisos, sale de la función.
  }

  // Muestra el diálogo para seleccionar la fuente de la imagen (cámara o galería).
  ImageSource? source = await showImageSourceDialog(context);
  if (source != null) {
    // Si se selecciona una fuente válida, utiliza el picker para elegir la imagen.
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile
          .path); // Crea un archivo a partir de la imagen seleccionada.
      try {
        String userId = FirebaseAuth.instance.currentUser!
            .email!; // Obtiene el ID de usuario a partir del correo electrónico.
        String fileExtension = pickedFile.path
            .split('.')
            .last; // Extrae la extensión del archivo de la imagen.
        // Sube la imagen a Firebase Storage y obtiene la URL.
        String imageUrl = await uploadImageToFirebaseStorage(
            userId, imageFile, fileExtension);

        // Llama a la función proporcionada para actualizar la URL de la imagen en la UI.
        updateImageUrl(imageUrl);

        // Actualiza o crea el campo de la imagen de la casa del usuario en Firestore.
        await updateOrCreateUserImageField(userId, imageUrl);
      } catch (e) {
        // Manejar errores al intentar subir la imagen o actualizar la base de datos.
      }
    }
  }
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
      print('Permiso de Photos solicitado: $photosStatus');
    }
  }

  // Si el permiso de cámara no está concedido, solicita permiso.
  if (!cameraStatus.isGranted) {
    cameraStatus = await Permission.camera.request();
    print('Permiso de cámara solicitado: $cameraStatus');
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

// Función para subir la imagen a Firebase Storage y retornar la URL de descarga.
Future<String> uploadImageToFirebaseStorage(
    String userId, File imageFile, String fileExtension) async {
  final storageRef = FirebaseStorage.instance.ref(
      'user_home_images/$userId.$fileExtension'); // Define la ruta donde se subirá la imagen.
  await storageRef.putFile(imageFile); // Sube el archivo de imagen.
  // Retorna la URL de descarga de la imagen recién subida.
  return await storageRef.getDownloadURL();
}

// Función para actualizar o crear el campo de imagen de la casa del usuario en Firestore.
Future<void> updateOrCreateUserImageField(String email, String imageUrl) async {
  final usersRef = FirebaseFirestore.instance
      .collection('users'); // Referencia a la colección de usuarios.
  // Busca el documento del usuario por su correo electrónico.
  final querySnapshot =
      await usersRef.where('Correo Electrónico', isEqualTo: email).get();

  // Si se encuentra al menos un usuario, actualiza su imagen.
  if (querySnapshot.docs.isNotEmpty) {
    final userDoc =
        querySnapshot.docs.first; // Obtiene el primer documento encontrado.
    await userDoc.reference.update(
        {'image_home_url': imageUrl}); // Actualiza el campo 'image_home_url'.
    print(
        'Campo "image_home_url" actualizado para el usuario con correo electrónico: $email');
  } else {
    // Si no se encuentra el usuario, muestra un mensaje en la consola.
    print('No se encontró ningún usuario con el correo electrónico: $email');
  }
}
