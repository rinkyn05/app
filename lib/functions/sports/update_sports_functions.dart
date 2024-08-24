import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateSportsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateSports({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String imageUrl,
    required String gifUrl,
    required String membershipEsp,
    required String membershipEng,
    required String resistencia,
    required String fisicoEstetico,
    required String potenciaAnaerobica,
    required String saludBienestar,
  }) async {
    await _firestore.collection('sports').doc(id).update({
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
    });
  }
}
