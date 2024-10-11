import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para autenticación de usuarios.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Función para cargar la información del usuario actual desde Firestore.
///
/// [auth] es la instancia de FirebaseAuth para acceder a la autenticación,
/// [firestore] es la instancia de FirebaseFirestore para acceder a la base de datos,
/// y [updateInfo] es una función que se utiliza para actualizar la información del usuario en la UI.
Future<void> loadUserInfo(FirebaseAuth auth, FirebaseFirestore firestore,
    Function(Map<String, dynamic>) updateInfo) async {
  User? user = auth.currentUser; // Obtiene el usuario actual autenticado.

  // Verifica si el usuario está autenticado.
  if (user != null) {
    // Obtiene el documento del usuario desde la colección 'users' usando su UID.
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user.uid).get();

    // Verifica si el documento existe en Firestore.
    if (userDoc.exists) {
      // Convierte los datos del documento a un mapa.
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Llama a la función updateInfo para actualizar la información del usuario.
      updateInfo(userData);
    }
  }
}
