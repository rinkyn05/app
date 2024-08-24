import 'package:cloud_firestore/cloud_firestore.dart';

class AddEstiramientoEspecificoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEstiramientoEspecificoWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('estiramientoEData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastestiramientoEId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastestiramientoEId': newId});

      DocumentReference newestiramientoERef =
          _firestore.collection('estiramientoE').doc(newId.toString());
      transaction.set(newestiramientoERef, {
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
