import 'package:cloud_firestore/cloud_firestore.dart';

class AddUnequipmentFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUnequipmentWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('unequipmentData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId = metadataSnapshot.exists
          ? metadataSnapshot.get('lastunequipmentId')
          : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastunequipmentId': newId});

      DocumentReference newunequipmentRef =
          _firestore.collection('unequipment').doc(newId.toString());
      transaction.set(newunequipmentRef, {
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
