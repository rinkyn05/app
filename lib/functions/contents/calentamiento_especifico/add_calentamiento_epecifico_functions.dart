import 'package:cloud_firestore/cloud_firestore.dart';

class AddCalentamientoEspecificoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCalentamientoEspecificoWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('calentamientoEData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastcalentamientoEId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastcalentamientoEId': newId});

      DocumentReference newcalentamientoERef =
          _firestore.collection('calentamientoE').doc(newId.toString());
      transaction.set(newcalentamientoERef, {
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
