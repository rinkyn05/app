import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getPostsByCategoryId(
    String categoryId, Locale locale) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot categoryDoc =
      await firestore.collection('categorypost').doc(categoryId).get();
  List<dynamic> postDetails =
      categoryDoc.exists ? categoryDoc.get('postDetails') : [];
  String langSuffix = locale.languageCode == 'es' ? 'Esp' : 'Eng';

  List<Map<String, dynamic>> localizedPostsDetails =
      postDetails.map((postDetail) {
    return {
      'id': postDetail['postId'],
      'title': postDetail['Nombre$langSuffix'] ??
          (locale.languageCode == 'es' ? 'Sin Título' : 'No Title'),
      'description': postDetail['Descripcion$langSuffix'] ??
          (locale.languageCode == 'es' ? 'Sin Descripción' : 'No Description'),
    };
  }).toList();

  return localizedPostsDetails;
}
