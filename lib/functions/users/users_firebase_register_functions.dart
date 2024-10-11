import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Clase que contiene funciones para interactuar con Firestore relacionadas con estadísticas y contadores de usuarios.
class FirebaseFunctions {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Actualiza las estadísticas del usuario basándose en su correo electrónico.
  ///
  /// [userEmail] es el correo electrónico del usuario para el cual se actualizarán las estadísticas.
  Future<void> updateUserStats(String userEmail) async {
    try {
      final userStatsRef = _firestore.collection('userstats').doc(
          userEmail); // Referencia al documento de estadísticas del usuario.
      final userStatsDoc = await userStatsRef.get(); // Obtiene el documento.

      // Si el documento no existe, crea uno vacío.
      if (!userStatsDoc.exists) {
        await userStatsRef.set({});
      }
    } catch (e) {
      // Maneja errores en la actualización de estadísticas de usuario.
      // print('Error al actualizar userstats: $e');
    }
  }

  /// Actualiza la colección de referencias de usuarios basándose en su correo electrónico.
  ///
  /// [userEmail] es el correo electrónico del usuario que se utilizará para actualizar las referencias.
  Future<void> updateReferrals(String userEmail) async {
    try {
      final referralsRef = _firestore
          .collection('referidos')
          .doc(userEmail); // Referencia al documento de referidos del usuario.
      final referralsDoc = await referralsRef.get(); // Obtiene el documento.

      // Si el documento no existe, crea uno vacío.
      if (!referralsDoc.exists) {
        await referralsRef.set({});
      }
    } catch (e) {
      // Maneja errores en la actualización de referidos de usuario.
      // print('Error al actualizar referidos: $e');
    }
  }

  /// Actualiza el conteo total de usuarios en Firestore.
  Future<void> updateTotalUsers() async {
    try {
      final totalUsersRef = _firestore.collection('totalusers').doc(
          'counter'); // Referencia al documento que cuenta el total de usuarios.
      final totalUsersDoc = await totalUsersRef.get(); // Obtiene el documento.

      // Si el documento existe, obtiene el conteo actual; si no, lo inicializa a 0.
      int currentCount = totalUsersDoc.exists ? totalUsersDoc['count'] ?? 0 : 0;

      currentCount++; // Incrementa el conteo total de usuarios.

      // Actualiza el documento con el nuevo conteo.
      await totalUsersRef.set({'count': currentCount});
    } catch (e) {
      // Maneja errores en la actualización del conteo total de usuarios.
      // print('Error al actualizar totalusers: $e');
    }
  }
}
