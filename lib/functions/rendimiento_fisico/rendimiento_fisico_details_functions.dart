import 'package:cloud_firestore/cloud_firestore.dart';

class RendimientoFisicoDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getRendimientoFisicoDetails(String rendimientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('rendimientoFisico').doc(rendimientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
