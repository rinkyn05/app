import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRecipesFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRecipesWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String calorias,
    required String imageUrl,
    required String membershipEsp,
    required String membershipEng,
    required String categoryEsp,
    required String categoryEng,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('recipesData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastRecipesId =
        metadataSnapshot.exists ? metadataSnapshot.get('lastRecipesId') : 0;
    int newRecipesId = lastRecipesId + 1;
    String recipesId = newRecipesId.toString();

    await metadataRef.set({'lastRecipesId': newRecipesId});

    await _firestore.collection('recipes').doc(recipesId).set({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'Calorias': calorias,
      'URL de la Imagen': imageUrl,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'CategoryEsp': categoryEsp,
      'CategoryEng': categoryEng,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(),
    });
  }
}
