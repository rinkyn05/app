import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MejPreLesionesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getMejPreLesiones(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('mejPreLesiones')
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

  Future<Map<String, dynamic>?> getMejPreLesionesDetails(String mejPreLesionesId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('mejPreLesiones').doc(mejPreLesionesId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteMejPreLesiones(String mejPreLesionesId) async {
    try {
      await _firestore.collection('mejPreLesiones').doc(mejPreLesionesId).delete();
    } catch (e) {
      throw Exception('Error deleting mejPreLesiones: $e');
    }
  }
}
