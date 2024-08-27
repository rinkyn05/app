import 'package:cloud_firestore/cloud_firestore.dart';

class MejPreLesionesDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getMejPreLesionesDetails(String mejPreLesionesId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('mejPreLesiones').doc(mejPreLesionesId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
