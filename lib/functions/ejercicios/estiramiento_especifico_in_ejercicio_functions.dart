import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstiramientoEspecificoInEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DropdownMenuItem<String>>> getSimplifiedEstiramientoEspecifico(
      String languageCode) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('estiramientoE').orderBy('id').get();

    return querySnapshot.docs.map((doc) {
      String name = doc['Nombre$languageCode'] ?? 'Nombre no disponible';
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(name),
      );
    }).toList();
  }
}
