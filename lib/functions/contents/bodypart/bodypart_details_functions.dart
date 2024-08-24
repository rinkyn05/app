import 'package:cloud_firestore/cloud_firestore.dart';

class BodyPartDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getBodyPartDetails(String bodyPartId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('bodyp').doc(bodyPartId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
