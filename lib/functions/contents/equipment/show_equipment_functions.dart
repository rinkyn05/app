import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipmentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getEquipment(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('equipment')
        .orderBy('Fecha', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'Nombre': doc['Nombre$langSuffix'],
        'Descripcion': doc['Descripcion$langSuffix'],
        'URL de la Imagen': doc['URL de la Imagen'],
      };
    }).toList();
  }

  Future<void> deleteEquipment(String equipmentId) async {
    await _firestore.collection('equipment').doc(equipmentId).delete();
    await removeEquipmentFromPosts(equipmentId);
    await _firestore.collection('equipmentpost').doc(equipmentId).delete();
  }

  Future<void> removeEquipmentFromPosts(String equipmentId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('Equipment', arrayContains: equipmentId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'Equipment': FieldValue.arrayRemove([equipmentId])
      });
    }
  }
}
