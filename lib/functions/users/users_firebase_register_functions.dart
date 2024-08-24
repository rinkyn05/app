import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserStats(String userEmail) async {
    try {
      final userStatsRef = _firestore.collection('userstats').doc(userEmail);
      final userStatsDoc = await userStatsRef.get();

      if (!userStatsDoc.exists) {
        await userStatsRef.set({});
      }
    } catch (e) {
      // print('Error al actualizar userstats: $e');
    }
  }

  Future<void> updateReferrals(String userEmail) async {
    try {
      final referralsRef = _firestore.collection('referidos').doc(userEmail);
      final referralsDoc = await referralsRef.get();

      if (!referralsDoc.exists) {
        await referralsRef.set({});
      }
    } catch (e) {
      //  print('Error al actualizar referidos: $e');
    }
  }

  Future<void> updateTotalUsers() async {
    try {
      final totalUsersRef = _firestore.collection('totalusers').doc('counter');
      final totalUsersDoc = await totalUsersRef.get();

      int currentCount = totalUsersDoc.exists ? totalUsersDoc['count'] ?? 0 : 0;

      currentCount++;

      await totalUsersRef.set({'count': currentCount});
    } catch (e) {
      // print('Error al actualizar totalusers: $e');
    }
  }
}
