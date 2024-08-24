import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ObjetivosFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getObjetivos(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('objetivos')
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

  Future<void> deleteObjetivos(String objetivosId) async {
    await _firestore.collection('objetivos').doc(objetivosId).delete();
    await removeObjetivosFromPosts(objetivosId);
    await _firestore.collection('objetivospost').doc(objetivosId).delete();
  }

  Future<void> removeObjetivosFromPosts(String objetivosId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('Objetivos', arrayContains: objetivosId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'Objetivos': FieldValue.arrayRemove([objetivosId])
      });
    }
  }
}
