import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> loadUserInfo(FirebaseAuth auth, FirebaseFirestore firestore,
    Function(Map<String, dynamic>) updateInfo) async {
  User? user = auth.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      updateInfo(userData);
    }
  }
}
