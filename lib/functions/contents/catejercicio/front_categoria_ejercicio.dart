import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/models/categoria_ejercicio_model.dart';
import '../../../backend/models/ejercicio_model.dart';

Future<List<Ejercicio>> fetchEjerciciosPorCategoria(
    CategoriaEjercicio categoria) async {
  try {
    QuerySnapshot catEjercicioSnapshot = await FirebaseFirestore.instance
        .collection('catEjercicioEjercicio')
        .where('catEjercicio', isEqualTo: categoria.id)
        .get();

    List<String> ejercicioIds = catEjercicioSnapshot.docs
        .map((doc) => doc.get('ejercicioId').toString())
        .toList();

    if (ejercicioIds.isEmpty) {
      return [];
    }

    QuerySnapshot ejerciciosSnapshot = await FirebaseFirestore.instance
        .collection('ejercicios')
        .where(FieldPath.documentId, whereIn: ejercicioIds)
        .get();

    List<Ejercicio> ejercicios = ejerciciosSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Ejercicio.fromMap(data, doc.id, 'es');
    }).toList();

    return ejercicios;
  } catch (error) {
    print('Error al obtener los ejercicios: $error');
    throw error;
  }
}
