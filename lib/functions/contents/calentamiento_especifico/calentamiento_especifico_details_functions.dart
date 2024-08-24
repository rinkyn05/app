import 'package:cloud_firestore/cloud_firestore.dart';

class CalentamientoEspecificoDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getCalentamientoEspecificoDetails(String calentamientoEspecificoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('calentamientoE').doc(calentamientoEspecificoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
