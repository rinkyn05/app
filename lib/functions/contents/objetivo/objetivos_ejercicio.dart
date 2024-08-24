import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../backend/models/objetivo_ejercicio_model.dart';

Future<List<ObjetivoEjercicio>> fetchObjetivoEjercicio() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('objetivos').get();
  return querySnapshot.docs
      .map((doc) =>
          ObjetivoEjercicio.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}
