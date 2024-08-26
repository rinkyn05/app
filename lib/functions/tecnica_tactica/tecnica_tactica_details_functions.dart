import 'package:cloud_firestore/cloud_firestore.dart';

class TenicaTacticaDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getTenicaTacticaDetails(String tenicaTacticaId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('tenicaTactica').doc(tenicaTacticaId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
