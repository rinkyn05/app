import 'package:cloud_firestore/cloud_firestore.dart';

class RecipesDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getRecipesDetails(String recipesId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('recipes').doc(recipesId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
