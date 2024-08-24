import 'package:cloud_firestore/cloud_firestore.dart';

class AddCatEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCatEjercicioWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String imageUrl,
    required DateTime fecha,
  }) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('catEjercicioData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId = metadataSnapshot.exists
          ? metadataSnapshot.get('lastcatEjercicioId')
          : 0;
      int newId = lastId + 1;
      transaction.set(metadataRef, {'lastcatEjercicioId': newId});

      DocumentReference newcatEjercicioRef =
          _firestore.collection('catEjercicio').doc(newId.toString());
      transaction.set(newcatEjercicioRef, {
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
