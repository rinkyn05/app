import 'package:cloud_firestore/cloud_firestore.dart';

class ReferidosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> agregarReferido(
      String correoUsuario, Map<String, dynamic> datosReferido) async {
    final referidosUsuarioRef = _firestore
        .collection('referidos')
        .doc(correoUsuario)
        .collection('referidosUsuario');
    final ultimoReferido = await referidosUsuarioRef
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    final nuevoId = ultimoReferido.docs.isEmpty
        ? 1
        : (ultimoReferido.docs.first.data()['id'] as int) + 1;

    await referidosUsuarioRef.doc(nuevoId.toString()).set({
      'id': nuevoId,
      ...datosReferido,
    });
  }

  Stream<List<Map<String, dynamic>>> obtenerReferidos(String correoUsuario) {
    return _firestore
        .collection('referidos')
        .doc(correoUsuario)
        .collection('referidosUsuario')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
