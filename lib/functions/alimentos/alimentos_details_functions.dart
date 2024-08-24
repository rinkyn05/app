import 'package:cloud_firestore/cloud_firestore.dart';

class AlimentosDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getAlimentosDetails(String alimentosId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('alimentos').doc(alimentosId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
