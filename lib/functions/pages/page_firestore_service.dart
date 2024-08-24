import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getPages(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('pages')
        .orderBy('Fecha', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'Nombre': doc['Nombre$langSuffix'],
        'URL de la Imagen': doc['URL de la Imagen'],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> getPageDetails(String pageId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('pages').doc(pageId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePage(String pageId) async {
    try {
      await _firestore.collection('pages').doc(pageId).delete();
    } catch (e) {
      //manejo de errores
    }
  }
}
