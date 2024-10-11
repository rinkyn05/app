import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para manejar la autenticación de usuarios.

// Función para verificar el rol del usuario autenticado.
Future<bool> checkUserRole() async {
  final FirebaseAuth auth =
      FirebaseAuth.instance; // Obtiene la instancia de FirebaseAuth.
  final User? user =
      auth.currentUser; // Obtiene el usuario actualmente autenticado.

  // Si no hay un usuario autenticado, retorna false.
  if (user == null) {
    return false; // El usuario no está autenticado.
  }

  // Obtiene el documento del usuario de la colección 'users' usando su UID.
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  // Si el documento del usuario no existe, retorna false.
  if (!userDoc.exists) {
    return false; // El documento del usuario no se encontró en la base de datos.
  }

  // Obtiene los datos del documento como un mapa de tipo dinámico.
  final userData = userDoc.data() as Map<String, dynamic>;
  final String? userRole =
      userData['Rol']; // Obtiene el rol del usuario desde los datos.

  // Define una lista de roles permitidos.
  const List<String> allowedRoles = ['Super Admin', 'Admin', 'Negocios'];

  // Verifica si el rol del usuario está en la lista de roles permitidos y retorna el resultado.
  return allowedRoles.contains(
      userRole); // Retorna true si el rol está permitido, de lo contrario false.
}
