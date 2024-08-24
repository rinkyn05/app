import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../backend/models/equipment_ejercicio_model.dart';

Future<List<EquipmentEjercicio>> fetchEquipmentEjercicio() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('equipment').get();
  return querySnapshot.docs
      .map((doc) => EquipmentEjercicio.fromMap(
          doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}
