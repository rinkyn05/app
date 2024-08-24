import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnequipmentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUnequipment(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('unequipment')
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

  Future<void> deleteUnequipment(String unequipmentId) async {
    await _firestore.collection('unequipment').doc(unequipmentId).delete();
    await removeUnequipmentFromPosts(unequipmentId);
    await _firestore.collection('unequipmentpost').doc(unequipmentId).delete();
  }

  Future<void> removeUnequipmentFromPosts(String unequipmentId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('Unequipment', arrayContains: unequipmentId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'Unequipment': FieldValue.arrayRemove([unequipmentId])
      });
    }
  }
}
