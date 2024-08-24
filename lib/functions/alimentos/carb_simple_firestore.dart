import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/carb_simple_model.dart';

class CarbSimpleFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CarbSimple>> filterCarbSimple(String languageCode) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('alimentos')
      .where('TipoEsp', isEqualTo: 'Simple')
      .get();
  return querySnapshot.docs
      .map((doc) => CarbSimple.fromMap(
          doc.data() as Map<String, dynamic>, doc.id, languageCode))
      .toList();
}

}
