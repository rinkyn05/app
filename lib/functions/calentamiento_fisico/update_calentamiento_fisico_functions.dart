import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCalentamientoFisicoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateCalentamientoFisico({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String membershipEsp,
    required String membershipEng,
    required String imageUrl,
  }) async {
    await _firestore.collection('calentamientoFisico').doc(id).update({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'Imagen': imageUrl,
    });
  }
}
