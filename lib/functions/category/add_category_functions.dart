import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCategoryWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('categoryData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastCategoryId') : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastCategoryId': newId});

      DocumentReference newCategoryRef =
          _firestore.collection('categories').doc(newId.toString());
      transaction.set(newCategoryRef, {
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
