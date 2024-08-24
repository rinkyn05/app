import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/alimentos_model.dart';

class FrontAlimentosFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Alimentos>> getAlimentos(String languageCode) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('alimentos').get();
    return querySnapshot.docs
        .map((doc) => Alimentos.fromMap(
            doc.data() as Map<String, dynamic>, doc.id, languageCode))
        .toList();
  }
}
