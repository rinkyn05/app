import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para autenticación de usuarios.

/// Clase que calcula el metabolismo basal utilizando la ecuación de Harris-Benedict.
class HarrisBenedictCalculator {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instancia de Firestore.
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instancia de Firebase Auth.

  /// Calcula el metabolismo basal (BMR) del usuario actual.
  ///
  /// Devuelve un [Future<double>] que contiene el valor del BMR calculado.
  Future<double> calculateHarrisBenedict() async {
    final User? user = _auth.currentUser; // Obtiene el usuario actual.

    if (user != null) {
      try {
        // Obtiene la información del usuario y datos médicos de Firestore.
        DocumentSnapshot userInfo =
            await _firestore.collection('users').doc(user.uid).get();
        DocumentSnapshot userInfoMedical =
            await _firestore.collection('usersmedical').doc(user.uid).get();

        // Obtiene el género y la edad del usuario.
        String gender = userInfo.get('Género');
        int age = userInfo.get('Edad');
        double weight; // Peso del usuario.
        double height; // Estatura del usuario.

        // Verifica si existen las medidas generales y obtiene peso y estatura.
        if (userInfoMedical.exists &&
            userInfoMedical.get('Medidas Generales') != null) {
          Map<String, dynamic> medidasGenerales =
              userInfoMedical.get('Medidas Generales');
          weight = double.parse(
              medidasGenerales['Peso'].toString().split(' ')[0].split('.')[0]);
          height = double.parse(medidasGenerales['Estatura']
              .toString()
              .split(' ')[0]
              .split('.')[0]);
        } else {
          // Si no hay medidas generales, obtiene peso y estatura de la información del usuario.
          weight = double.parse(
              userInfo.get('Peso').toString().split(' ')[0].split('.')[0]);
          height = double.parse(
              userInfo.get('Estatura').toString().split(' ')[0].split('.')[0]);
        }

        double bmr; // Variable para almacenar el BMR calculado.

        // Calcula el BMR según el género.
        if (gender.toLowerCase() == 'masculino') {
          bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
        } else {
          bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
        }

        return bmr; // Devuelve el BMR calculado.
      } catch (e) {
        print(
            'Error al calcular la ecuación de Harris-Benedict: $e'); // Manejo de errores.
        throw e; // Lanza el error para ser manejado en otro lugar.
      }
    } else {
      return 0.0; // Retorna 0.0 si no hay usuario autenticado.
    }
  }
}
