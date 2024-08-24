import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateEstiramientoEspecificoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateEstiramientoEspecifico({
    required String id,
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
  }) async {
    await _firestore.collection('estiramientoE').doc(id).update({
      'NombreEsp': nombreEsp,
      'DescripcionEsp': descripcionEsp,
      'NombreEng': nombreEng,
      'DescripcionEng': descripcionEng,
      'URL de la Imagen': imageUrl,
    });
  }
}
