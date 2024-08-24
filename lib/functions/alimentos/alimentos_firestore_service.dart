import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlimentosFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAlimentos(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('alimentos')
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

  Future<Map<String, dynamic>?> getAlimentosDetails(String alimentosId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('alimentos').doc(alimentosId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteAlimentos(String alimentosId) async {
    try {
      await _firestore.collection('alimentos').doc(alimentosId).delete();
    } catch (e) {
      throw Exception('Error deleting alimentos: $e');
    }
  }
}
