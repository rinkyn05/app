import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCategories(Locale locale) async {
    String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';
    QuerySnapshot querySnapshot = await _firestore
        .collection('categories')
        .orderBy('Fecha', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'Nombre': doc['Nombre$langSuffix'],
        'Descripcion': doc['Descripcion$langSuffix'],
        'URL de la Imagen': doc['URL de la Imagen'],
      };
    }).toList();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();

    await removeCategoryFromPosts(categoryId);

    await _firestore.collection('categorypost').doc(categoryId).delete();
  }

  Future<void> removeCategoryFromPosts(String categoryId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('posts')
        .where('Categorias', arrayContains: categoryId)
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference postRef = _firestore.collection('posts').doc(doc.id);
      await postRef.update({
        'Categorias': FieldValue.arrayRemove([categoryId])
      });
    }
  }
}
