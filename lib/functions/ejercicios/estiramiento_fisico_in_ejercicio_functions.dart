import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EstiramientoFisicoInEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DropdownMenuItem<String>>> getSimplifiedEstiramientoFisico(
      String langKey) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('estiramientoFisico').get();
      List<DropdownMenuItem<String>> dropdownItems = snapshot.docs.map((doc) {
        String id = doc.id;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String name =
            data.containsKey(langKey == 'es' ? 'NombreEsp' : 'NombreEng')
                ? data[langKey == 'es' ? 'NombreEsp' : 'NombreEng'] ??
                    'Nombre no disponible'
                : 'Nombre no disponible';

        return DropdownMenuItem<String>(
          value: id,
          child: Text(name),
        );
      }).toList();

      return dropdownItems;
    } catch (e) {
      print('Error fetching estiramientos físicos: $e');
      return [];
    }
  }
}
