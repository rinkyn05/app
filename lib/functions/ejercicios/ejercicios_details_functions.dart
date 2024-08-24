import 'package:cloud_firestore/cloud_firestore.dart';

class EjercicioDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getEjercicioDetails(String ejercicioId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('ejercicios').doc(ejercicioId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
