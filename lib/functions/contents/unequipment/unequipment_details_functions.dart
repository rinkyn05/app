import 'package:cloud_firestore/cloud_firestore.dart';

class UnequipmentDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUnequipmentDetails(
      String unequipmentId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('unequipment').doc(unequipmentId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
