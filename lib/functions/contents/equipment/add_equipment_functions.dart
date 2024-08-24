import 'package:cloud_firestore/cloud_firestore.dart';

class AddEquipmentFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEquipmentWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('equipmentData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastequipmentId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastequipmentId': newId});

      DocumentReference newequipmentRef =
          _firestore.collection('equipment').doc(newId.toString());
      transaction.set(newequipmentRef, {
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
