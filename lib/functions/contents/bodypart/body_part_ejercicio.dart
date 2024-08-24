import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/models/body_part_ejercicio_model.dart';

Future<List<BodyPart>> fetchBodyPartEjercicio() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('bodyp').get();
  return querySnapshot.docs
      .map(
          (doc) => BodyPart.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}
