import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalentamientoFisicoFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCalentamientoFisico(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('calentamientoFisico')
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

  Future<Map<String, dynamic>?> getCalentamientoFisicoDetails(String calentamientoFisicoId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('calentamientoFisico').doc(calentamientoFisicoId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteCalentamientoFisico(String calentamientoFisicoId) async {
    try {
      await _firestore.collection('calentamientoFisico').doc(calentamientoFisicoId).delete();
    } catch (e) {
      throw Exception('Error deleting calentamientoFisico: $e');
    }
  }
}
