import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> publishFrase(String frase, String fraseEng) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();

  await firestore.collection('frases').add({
    'Frase Esp': frase,
    'Frase Eng': fraseEng,
    'Fecha de Publicacion': now,
  });
}
