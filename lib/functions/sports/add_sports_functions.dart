import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSportsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSportsWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String imageUrl,
    required String membershipEsp,
    required String membershipEng,
    required String resistencia,
    required String fisicoEstetico,
    required String potenciaAnaerobica,
    required String saludBienestar,
    required String gifUrl,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('sportsData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastSportsId =
        metadataSnapshot.exists ? metadataSnapshot.get('lastSportsId') : 0;
    int newSportsId = lastSportsId + 1;
    String sportsId = newSportsId.toString();

    await metadataRef.set({'lastSportsId': newSportsId});

    await _firestore.collection('sports').doc(sportsId).set({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'URL de la Imagen': imageUrl,
      'URL del Gif': gifUrl,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'Resistencia': resistencia,
      'FisicoEstetico': fisicoEstetico,
      'PotenciaAnaerobica': potenciaAnaerobica,
      'SaludBienestar': saludBienestar,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(),
    });
  }
}
