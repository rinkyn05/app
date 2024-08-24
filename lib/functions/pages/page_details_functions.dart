import 'package:cloud_firestore/cloud_firestore.dart';

class PageDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getPageDetails(String pageId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('pages').doc(pageId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
