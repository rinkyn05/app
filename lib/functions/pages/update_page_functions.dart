import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatepageFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updatepage({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String imageUrl,
  }) async {
    await _firestore.collection('pages').doc(id).update({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Imagen': imageUrl,
    });
  }
}
