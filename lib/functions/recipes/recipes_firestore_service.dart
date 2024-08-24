import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRecipes(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('recipes')
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

  Future<Map<String, dynamic>?> getRecipesDetails(String recipesId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('recipes').doc(recipesId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteRecipes(String recipesId) async {
    try {
      await _firestore.collection('recipes').doc(recipesId).delete();
    } catch (e) {
      throw Exception('Error deleting recipes: $e');
    }
  }
}
