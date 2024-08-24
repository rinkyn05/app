import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getCategoryDetails(String categoryId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('categories').doc(categoryId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
