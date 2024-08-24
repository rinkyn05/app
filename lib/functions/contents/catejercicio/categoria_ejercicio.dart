import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../backend/models/categoria_ejercicio_model.dart';

Future<List<CategoriaEjercicio>> fetchCategoriasEjercicio() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('catEjercicio').get();
  return querySnapshot.docs
      .map((doc) => CategoriaEjercicio.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}
