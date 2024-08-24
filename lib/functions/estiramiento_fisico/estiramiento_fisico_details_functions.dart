import 'package:cloud_firestore/cloud_firestore.dart';

class EstiramientoFisicoDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getEstiramientoFisicoDetails(String estiramientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('estiramientoFisico').doc(estiramientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
