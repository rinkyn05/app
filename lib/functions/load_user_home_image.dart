import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para manejar la autenticación de usuarios.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Función para cargar la imagen de la casa del usuario actual desde Firestore.
///
/// [auth] es la instancia de FirebaseAuth para acceder a la autenticación,
/// y [updateImage] es una función que se utiliza para actualizar la URL de la imagen de la casa del usuario en la UI.
Future<void> loadUserHomeImage(
    FirebaseAuth auth, Function(String?) updateImage) async {
  User? user = auth.currentUser; // Obtiene el usuario actual autenticado.

  // Verifica si hay un usuario autenticado.
  if (user != null) {
    try {
      // Intenta obtener el documento del usuario desde la colección 'users' usando su UID.
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Verifica si el documento existe en Firestore.
      if (userSnapshot.exists) {
        // Obtiene la URL de la imagen del campo 'image_home_url' del documento.
        String? imageUrl = userSnapshot.get('image_home_url');

        // Llama a la función updateImage para actualizar la URL de la imagen de la casa del usuario.
        updateImage(imageUrl);
      } else {
        // Si el documento no existe, actualiza la imagen a null.
        updateImage(null);
      }
    } catch (e) {
      // Manejo de errores: imprime el error y actualiza la imagen a null.
      print('Error al cargar la imagen del usuario: $e');
      updateImage(null);
    }
  } else {
    // Si no hay usuario autenticado, actualiza la imagen a null.
    updateImage(null);
  }
}
