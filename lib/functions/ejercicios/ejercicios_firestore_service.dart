import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EjercicioFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getEjercicios(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('ejercicios')
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

  Future<Map<String, dynamic>?> getEjercicioDetails(String ejercicioId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('ejercicios').doc(ejercicioId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteEjercicio(String ejercicioId) async {
    try {
      await _firestore.collection('ejercicios').doc(ejercicioId).delete();
    } catch (e) {
      throw Exception('Error deleting ejercicio: $e');
    }
  }
}
