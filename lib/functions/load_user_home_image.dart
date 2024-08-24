import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> loadUserHomeImage(
    FirebaseAuth auth, Function(String?) updateImage) async {
  User? user = auth.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        String? imageUrl = userSnapshot.get('image_home_url');
        updateImage(imageUrl);
      } else {
        updateImage(null);
      }
    } catch (e) {
      print('Error al cargar la imagen del usuario: $e');
      updateImage(null);
    }
  } else {
    updateImage(null);
  }
}
