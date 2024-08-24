import 'package:cloud_firestore/cloud_firestore.dart';

class RutinaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> guardarRutina({
    required String correoUsuario,
    required String nombreRutina,
    required int intervalo,
    required List<Map<String, dynamic>> ejercicios,
  }) async {
    try {
      DocumentReference metadataRef =
          _firestore.collection('metadata').doc('rutinasData');
      DocumentSnapshot metadataSnapshot = await metadataRef.get();

      Map<String, dynamic>? data =
          metadataSnapshot.data() as Map<String, dynamic>?;

      int ultimoId = data != null && data.containsKey('ultimoId')
          ? data['ultimoId'] as int
          : 0;

      int nuevoId = ultimoId + 1;

      final rutinaData = {
        'nombreRutina': nombreRutina,
        'intervalo': intervalo,
        'ejercicios': ejercicios,
        'idRutina': nuevoId.toString(),
        'fechaCreacion': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('rutinas')
          .doc(correoUsuario)
          .collection('rutinasUsuario')
          .doc(nuevoId.toString())
          .set(rutinaData);

      await metadataRef.set({'ultimoId': nuevoId}, SetOptions(merge: true));
    } catch (e) {
      // print("Error al guardar la rutina: $e");
    }
  }
}
