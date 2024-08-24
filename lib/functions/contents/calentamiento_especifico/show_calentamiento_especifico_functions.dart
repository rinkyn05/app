import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalentamientoEspecificoFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCalentamientoEspecificos(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('calentamientoE')
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

  Future<void> deleteCalentamientoEspecifico(String calentamientoEspecificoId) async {
    await _firestore.collection('calentamientoE').doc(calentamientoEspecificoId).delete();
    await removeCalentamientoEspecificoFromPosts(calentamientoEspecificoId);
    await _firestore.collection('calentamientoEpost').doc(calentamientoEspecificoId).delete();
  }

  Future<void> removeCalentamientoEspecificoFromPosts(String calentamientoEspecificoId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('CalentamientoEspecificos', arrayContains: calentamientoEspecificoId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'CalentamientoEspecificos': FieldValue.arrayRemove([calentamientoEspecificoId])
      });
    }
  }
}
