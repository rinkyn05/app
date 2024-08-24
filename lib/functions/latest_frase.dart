import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> fetchLatestFrase() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('frases')
        .orderBy('Fecha de Publicacion', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
