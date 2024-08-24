import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/models/calentamiento_especifico_model.dart';

Future<List<CalentamientoEspecifico>>
    fetchCalentamientoEspecificoEjercicio() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('calentamientoE').get();
  return querySnapshot.docs
      .map((doc) => CalentamientoEspecifico.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}
