import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getEquipmentDetails(String equipmentId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('equipment').doc(equipmentId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
