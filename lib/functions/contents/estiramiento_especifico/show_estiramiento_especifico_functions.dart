import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstiramientoEspecificoFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getEstiramientoEspecificos(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('estiramientoE')
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

  Future<void> deleteEstiramientoEspecifico(String estiramientoEspecificoId) async {
    await _firestore.collection('estiramientoE').doc(estiramientoEspecificoId).delete();
    await removeEstiramientoEspecificoFromPosts(estiramientoEspecificoId);
    await _firestore.collection('estiramientoEpost').doc(estiramientoEspecificoId).delete();
  }

  Future<void> removeEstiramientoEspecificoFromPosts(String estiramientoEspecificoId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('EstiramientoEspecificos', arrayContains: estiramientoEspecificoId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'EstiramientoEspecificos': FieldValue.arrayRemove([estiramientoEspecificoId])
      });
    }
  }
}
