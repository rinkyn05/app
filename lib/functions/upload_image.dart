import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication para manejar la autenticación de usuarios.
import 'package:firebase_storage/firebase_storage.dart'; // Importa Firebase Storage para subir y almacenar imágenes.
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets.
import 'package:image_picker/image_picker.dart'; // Importa la biblioteca para seleccionar imágenes de la galería o cámara.
import 'package:permission_handler/permission_handler.dart'; // Importa para manejar permisos de la aplicación.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos.
import 'dart:io'; // Importa para manejar archivos en el sistema.

import 'image_source_dialog.dart'; // Importa el diálogo para seleccionar la fuente de la imagen.

Future<void> uploadImage(
    BuildContext context, Function(String) updateImageUrl) async {
  final picker = ImagePicker(); // Crea una instancia de ImagePicker.

  // Solicita permisos necesarios para la cámara y el almacenamiento.
  bool permissionsGranted = await requestPermissions();
  if (!permissionsGranted) {
    // Si los permisos no son concedidos, cierra el diálogo si es posible.
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    return; // Sale de la función si no hay permisos.
  }

  // Llama a la función para seleccionar y subir la imagen.
  await selectAndUploadImage(context, picker, updateImageUrl);
}

Future<bool> requestPermissions() async {
  // Comprueba el estado de los permisos de cámara y almacenamiento.
  var cameraStatus = await Permission.camera.status;
  var storageStatus = await Permission.storage.status;

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

Future<void> selectAndUploadImage(BuildContext context, ImagePicker picker,
    Function(String) updateImageUrl) async {
  // Muestra el diálogo para seleccionar la fuente de la imagen (cámara o galería).
  ImageSource? source = await showImageSourceDialog(context);

  // Si se seleccionó una fuente válida.
  if (source != null) {
    // Utiliza el picker para elegir la imagen de la fuente seleccionada.
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

        // Actualiza o crea el campo de la imagen del usuario en Firestore.
        await updateOrCreateUserImageField(userId, imageUrl);

        // Actualiza la imagen de amigo de gimnasio en Firestore.
        await updateGymFriendImage(userId, imageUrl);

        // Llama a la función proporcionada para actualizar la URL de la imagen en la UI.
        updateImageUrl(imageUrl);
      } catch (e) {
        // Manejar errores al intentar subir la imagen o actualizar la base de datos.
      }
    }
  }
}

// Función para subir la imagen a Firebase Storage y retornar la URL de descarga.
Future<String> uploadImageToFirebaseStorage(
    String userId, File imageFile, String fileExtension) async {
  await FirebaseStorage.instance
      .ref(
          'user_images/$userId.$fileExtension') // Define la ruta donde se subirá la imagen.
      .putFile(imageFile); // Sube el archivo de imagen.
  // Retorna la URL de descarga de la imagen recién subida.
  return await FirebaseStorage.instance
      .ref('user_images/$userId.$fileExtension')
      .getDownloadURL();
}

// Función para actualizar o crear el campo de imagen del usuario en Firestore.
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
    await userDoc.reference
        .update({'image_url': imageUrl}); // Actualiza el campo 'image_url'.
    print(
        'Campo "image_url" actualizado para el usuario con correo electrónico: $email');
  } else {
    // Si no se encuentra el usuario, muestra un mensaje en la consola.
    print('No se encontró ningún usuario con el correo electrónico: $email');
  }
}

// Función para actualizar la imagen del amigo de gimnasio en Firestore.
Future<void> updateGymFriendImage(String userId, String imageUrl) async {
  final gymFriendRef = FirebaseFirestore.instance
      .collection('gymfriends')
      .doc(userId); // Referencia al amigo de gimnasio.
  final gymFriendData =
      await gymFriendRef.get(); // Obtiene los datos del amigo de gimnasio.
  if (gymFriendData.exists) {
    // Si los datos existen, actualiza la imagen.
    await gymFriendRef.update({'image_url': imageUrl});
  }
}
