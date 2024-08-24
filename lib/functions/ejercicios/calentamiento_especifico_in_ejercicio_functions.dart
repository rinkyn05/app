import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalentamientoEspecificoInEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DropdownMenuItem<String>>> getSimplifiedCalentamientoEspecifico(
      String languageCode) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('calentamientoE').orderBy('id').get();

    return querySnapshot.docs.map((doc) {
      String name = doc['Nombre$languageCode'] ?? 'Nombre no disponible';
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(name),
      );
    }).toList();
  }
}
