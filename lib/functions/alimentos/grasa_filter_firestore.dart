import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/alimentos_model.dart';

class GrasaFilterFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Alimentos>> filterGrasaSat(String languageCode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('alimentos')
        .where('TipoGrasaEsp', isEqualTo: 'Saturadas')
        .get();
    return querySnapshot.docs
        .map((doc) => Alimentos.fromMap(
            doc.data() as Map<String, dynamic>, doc.id, languageCode))
        .toList();
  }

  Future<List<Alimentos>> filterGrasaUnS(String languageCode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('alimentos')
        .where('TipoGrasaEsp', isEqualTo: 'Insaturadas')
        .get();
    return querySnapshot.docs
        .map((doc) => Alimentos.fromMap(
            doc.data() as Map<String, dynamic>, doc.id, languageCode))
        .toList();
  }

  Future<List<Alimentos>> filterGrasaHydro(String languageCode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('alimentos')
        .where('TipoGrasaEsp', isEqualTo: 'Hidrogenadas')
        .get();
    return querySnapshot.docs
        .map((doc) => Alimentos.fromMap(
            doc.data() as Map<String, dynamic>, doc.id, languageCode))
        .toList();
  }
}
