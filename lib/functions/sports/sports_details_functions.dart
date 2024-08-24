import 'package:cloud_firestore/cloud_firestore.dart';

class SportsDetailsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getSportsDetails(String sportsId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('sports').doc(sportsId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
