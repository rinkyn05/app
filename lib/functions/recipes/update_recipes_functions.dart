import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateRecipesFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateRecipes({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String calorias,
    required String categoryEsp,
    required String categoryEng,
    required String membershipEsp,
    required String membershipEng,
    required String imageUrl,
  }) async {
    await _firestore.collection('recipes').doc(id).update({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'Calorias': calorias,
      'CategoryEsp': categoryEsp,
      'CategoryEng': categoryEng,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'Imagen': imageUrl,
    });
  }
}
