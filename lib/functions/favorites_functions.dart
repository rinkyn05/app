import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Actualiza o crea la lista de favoritos de un usuario en Firestore.
///
/// [email] es el correo electrónico del usuario.
/// [favorites] es una lista de mapas que representa los elementos favoritos del usuario.
Future<void> updateOrCreateUserFavorites(
    String email, List<Map<String, dynamic>> favorites) async {
  final usersRef = FirebaseFirestore.instance
      .collection('users'); // Referencia a la colección de usuarios.

  // Realiza una consulta para encontrar el usuario por correo electrónico.
  final querySnapshot =
      await usersRef.where('Correo Electrónico', isEqualTo: email).get();

  // Verifica si se encontró al menos un documento que coincida.
  if (querySnapshot.docs.isNotEmpty) {
    final userDoc = querySnapshot.docs
        .first; // Obtiene el primer documento del resultado de la consulta.

    // Actualiza el campo 'favorites' del documento del usuario.
    await userDoc.reference.update({'favorites': favorites});
    print(
        'Campo "favorites" actualizado para el usuario con correo electrónico: $email'); // Mensaje de confirmación.
  } else {
    print(
        'No se encontró ningún usuario con el correo electrónico: $email'); // Mensaje de error si no se encuentra el usuario.
  }
}
