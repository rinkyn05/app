import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatEjercicioInEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DropdownMenuItem<int>>> getSimplifiedCatEjercicio(
      String languageCode) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('catEjercicio').orderBy('id').get();

    List<DropdownMenuItem<int>> items = querySnapshot.docs.map((doc) {
      String name = doc['Nombre$languageCode'] ?? 'Nombre no disponible';
      int id = int.tryParse(doc.id) ?? 0;
      return DropdownMenuItem<int>(
        value: id,
        child: Text(name),
      );
    }).toList();

    return items;
  }
}
