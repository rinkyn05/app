import 'package:cloud_firestore/cloud_firestore.dart';

class EstiramientoEspecificoDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getEstiramientoEspecificoDetails(String estiramientoEspecificoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('estiramientoE').doc(estiramientoEspecificoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
