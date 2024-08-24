import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkUserRole() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  if (user == null) {
    return false;
  }

  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!userDoc.exists) {
    return false;
  }

  final userData = userDoc.data() as Map<String, dynamic>;
  final String? userRole = userData['Rol'];

  const List<String> allowedRoles = ['Super Admin', 'Admin', 'Negocios'];
  return allowedRoles.contains(userRole);
}
