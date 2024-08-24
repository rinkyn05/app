import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RendimientoFisicoFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRendimientoFisico(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('rendimientoFisico')
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

  Future<Map<String, dynamic>?> getRendimientoFisicoDetails(String rendimientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('rendimientoFisico').doc(rendimientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteRendimientoFisico(String rendimientoFisicoId) async {
    try {
      await _firestore.collection('rendimientoFisico').doc(rendimientoFisicoId).delete();
    } catch (e) {
      throw Exception('Error deleting rendimientoFisico: $e');
    }
  }
}
