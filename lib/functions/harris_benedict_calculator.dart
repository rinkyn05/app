import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HarrisBenedictCalculator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<double> calculateHarrisBenedict() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userInfo =
            await _firestore.collection('users').doc(user.uid).get();
        DocumentSnapshot userInfoMedical =
            await _firestore.collection('usersmedical').doc(user.uid).get();

        String gender = userInfo.get('Género');
        int age = userInfo.get('Edad');
        double weight;
        double height;

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
          weight = double.parse(
              userInfo.get('Peso').toString().split(' ')[0].split('.')[0]);
          height = double.parse(
              userInfo.get('Estatura').toString().split(' ')[0].split('.')[0]);
        }

        double bmr;
        if (gender.toLowerCase() == 'masculino') {
          bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
        } else {
          bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
        }

        return bmr;
      } catch (e) {
        print('Error al calcular la ecuación de Harris-Benedict: $e');
        throw e;
      }
    } else {
      return 0.0;
    }
  }
}
