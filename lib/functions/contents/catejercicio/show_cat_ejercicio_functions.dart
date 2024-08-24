import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatEjercicioFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCatEjercicio(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('catEjercicio')
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

  Future<void> deleteCatEjercicio(String catejercicioId) async {
    await _firestore.collection('catEjercicio').doc(catejercicioId).delete();
    await removeCatEjercicioFromPosts(catejercicioId);
    await _firestore
        .collection('catEjerciciopost')
        .doc(catejercicioId)
        .delete();
  }

  Future<void> removeCatEjercicioFromPosts(String catejercicioId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('CatEjercicio', arrayContains: catejercicioId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'CatEjercicio': FieldValue.arrayRemove([catejercicioId])
      });
    }
  }
}
