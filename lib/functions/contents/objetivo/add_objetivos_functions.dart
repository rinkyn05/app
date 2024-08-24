import 'package:cloud_firestore/cloud_firestore.dart';

class AddObjetivosFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addObjetivosWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('objetivosData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastobjetivosId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastobjetivosId': newId});

      DocumentReference newobjetivosRef =
          _firestore.collection('objetivos').doc(newId.toString());
      transaction.set(newobjetivosRef, {
        'id': newId,
        'NombreEsp': nombreEsp,
        'DescripcionEsp': descripcionEsp,
        'NombreEng': nombreEng,
        'DescripcionEng': descripcionEng,
        'URL de la Imagen': imageUrl,
        'Fecha': fecha,
      });
    });
  }
}
