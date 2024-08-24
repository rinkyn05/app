import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/animal_protein_model.dart';

class ProteinVegetalFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProteinaAnimal>> filterProteinaVegetal(String languageCode) async {
  QuerySnapshot querySnapshot = await _firestore
      .collection('alimentos')
      .where('CategoryEsp', isEqualTo: 'Vegetal')
      .get();
  return querySnapshot.docs
      .map((doc) => ProteinaAnimal.fromMap(
          doc.data() as Map<String, dynamic>, doc.id, languageCode))
      .toList();
}

}
