import 'package:cloud_firestore/cloud_firestore.dart';

class AddBodyPartFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBodyPartWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('bodypData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastbodypId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastbodypId': newId});

      DocumentReference newbodypRef =
          _firestore.collection('bodyp').doc(newId.toString());
      transaction.set(newbodypRef, {
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
