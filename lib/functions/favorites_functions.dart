import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateOrCreateUserFavorites(
    String email, List<Map<String, dynamic>> favorites) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final querySnapshot =
      await usersRef.where('Correo Electrónico', isEqualTo: email).get();

  if (querySnapshot.docs.isNotEmpty) {
    final userDoc = querySnapshot.docs.first;
    await userDoc.reference.update({'favorites': favorites});
    print(
        'Campo "favorites" actualizado para el usuario con correo electrónico: $email');
  } else {
    print('No se encontró ningún usuario con el correo electrónico: $email');
  }
}
