import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/models/ejercicio_rutina_model.dart';

class ShowRutinaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Rutina>> obtenerRutinasUsuario() async {
    List<Rutina> rutinas = [];
    try {
      final usuario = FirebaseAuth.instance.currentUser;
      if (usuario != null) {
        final correoUsuario = usuario.email;
        final resultado = await _firestore
            .collection('rutinas')
            .doc(correoUsuario)
            .collection('rutinasUsuario')
            .orderBy('fechaCreacion', descending: true)
            .get();

        rutinas = resultado.docs
            .map((doc) => Rutina.fromMap(doc.data(), doc.id))
            .toList();
      }
    } catch (e) {
      // print("Error al obtener las rutinas: $e");
    }
    return rutinas;
  }
}
