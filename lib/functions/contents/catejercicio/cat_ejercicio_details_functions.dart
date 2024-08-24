import 'package:cloud_firestore/cloud_firestore.dart';

class CatEjercicioDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getCatEjercicioDetails(
      String catEjercicioId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('catEjercicio').doc(catEjercicioId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
