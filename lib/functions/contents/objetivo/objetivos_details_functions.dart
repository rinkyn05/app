import 'package:cloud_firestore/cloud_firestore.dart';

class ObjetivosDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getObjetivosDetails(String objetivosId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('objetivos').doc(objetivosId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
