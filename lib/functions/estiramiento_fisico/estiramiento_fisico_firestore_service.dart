import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstiramientoFisicoFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getEstiramientoFisico(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('estiramientoFisico')
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

  Future<Map<String, dynamic>?> getEstiramientoFisicoDetails(String estiramientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('estiramientoFisico').doc(estiramientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteEstiramientoFisico(String estiramientoFisicoId) async {
    try {
      await _firestore.collection('estiramientoFisico').doc(estiramientoFisicoId).delete();
    } catch (e) {
      throw Exception('Error deleting estiramientoFisico: $e');
    }
  }
}
