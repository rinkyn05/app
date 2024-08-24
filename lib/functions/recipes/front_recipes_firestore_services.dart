import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/recipes_model.dart';

class FrontRecipesFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Recipes>> getRecipes(String languageCode) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('recipes')
        .where('CategoryEng', isEqualTo: 'Animals')
        .where('CategoryEsp', isEqualTo: 'Animal')
        .get();
    return querySnapshot.docs
        .map((doc) => Recipes.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
              languageCode,
            ))
        .toList();
  }
}
