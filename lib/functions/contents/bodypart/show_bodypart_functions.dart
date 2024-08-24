import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BodyPartFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getBodyParts(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('bodyp')
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

  Future<void> deleteBodyPart(String bodyPartId) async {
    await _firestore.collection('bodyp').doc(bodyPartId).delete();
    await removeBodyPartFromPosts(bodyPartId);
    await _firestore.collection('bodyppost').doc(bodyPartId).delete();
  }

  Future<void> removeBodyPartFromPosts(String bodyPartId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('BodyParts', arrayContains: bodyPartId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'BodyParts': FieldValue.arrayRemove([bodyPartId])
      });
    }
  }
}
