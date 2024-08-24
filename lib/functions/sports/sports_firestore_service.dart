import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SportsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSports(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('sports')
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

  Future<Map<String, dynamic>?> getSportsDetails(String sportsId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('sports').doc(sportsId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteSports(String sportsId) async {
    try {
      await _firestore.collection('sports').doc(sportsId).delete();
    } catch (e) {
      throw Exception('Error deleting sports: $e');
    }
  }
}
