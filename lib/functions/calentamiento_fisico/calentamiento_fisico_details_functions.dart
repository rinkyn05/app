import 'package:cloud_firestore/cloud_firestore.dart';

class CalentamientoFisicoDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getCalentamientoFisicoDetails(String calentamientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('calentamientoFisico').doc(calentamientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
