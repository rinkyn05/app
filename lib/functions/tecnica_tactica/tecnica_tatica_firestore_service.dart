import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TenicaTacticaFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTenicaTactica(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('tenicaTactica')
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

  Future<Map<String, dynamic>?> getTenicaTacticaDetails(String tenicaTacticaId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('tenicaTactica').doc(tenicaTacticaId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteTenicaTactica(String tenicaTacticaId) async {
    try {
      await _firestore.collection('tenicaTactica').doc(tenicaTacticaId).delete();
    } catch (e) {
      throw Exception('Error deleting tenicaTactica: $e');
    }
  }
}
