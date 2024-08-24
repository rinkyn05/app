import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPageFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPageWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String imageUrl,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    await _firestore.runTransaction((transaction) async {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('pageData');
      DocumentSnapshot metadataSnapshot = await transaction.get(metadataRef);

      int lastId =
          metadataSnapshot.exists ? metadataSnapshot.get('lastpageId') : 0;
      int newId = lastId + 1;

      transaction.set(metadataRef, {'lastpageId': newId});

      DocumentReference newpageRef =
          _firestore.collection('pages').doc(newId.toString());
      transaction.set(newpageRef, {
        'id': newId,
        'NombreEsp': nombreEsp,
        'NombreEng': nombreEng,
        'ContenidoEsp': contenidoEsp,
        'ContenidoEng': contenidoEng,
        'URL de la Imagen': imageUrl,
        'Nombre de Usuario': userName,
        'Correo Electrónico': user.email ?? '',
        'Fecha': DateTime.now(),
      });
    });
  }
}
