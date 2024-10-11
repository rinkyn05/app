import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Esta clase maneja las operaciones de referidos en Firestore.

/// Por ejemplo, para la carpeta `referidos`, el archivo se llama `referidos_service` y maneja la lógica relacionada con los referidos de usuarios.
/// Esta clase sigue un patrón similar para otras funcionalidades que manejen datos específicos.
class ReferidosService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Agrega un referido a la colección de un usuario en Firestore.
  ///
  /// El [correoUsuario] es el identificador del usuario que está agregando el referido.
  /// Los [datosReferido] son los datos asociados al referido que se almacenarán en Firestore.
  Future<void> agregarReferido(
      String correoUsuario, Map<String, dynamic> datosReferido) async {
    final referidosUsuarioRef = _firestore
        .collection('referidos')
        .doc(correoUsuario)
        .collection(
            'referidosUsuario'); // Referencia a la subcolección de referidos de un usuario.

    // Obtiene el último referido para generar un nuevo ID autoincremental.
    final ultimoReferido = await referidosUsuarioRef
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    // Calcula el nuevo ID. Si no hay referidos previos, el ID será 1, de lo contrario, se incrementa.
    final nuevoId = ultimoReferido.docs.isEmpty
        ? 1
        : (ultimoReferido.docs.first.data()['id'] as int) + 1;

    // Guarda el nuevo referido en Firestore.
    await referidosUsuarioRef.doc(nuevoId.toString()).set({
      'id': nuevoId,
      ...datosReferido, // Usa el spread operator para incluir los datos del referido.
    });
  }

  /// Obtiene un flujo de referidos de un usuario específico.
  ///
  /// El [correoUsuario] es el identificador del usuario para obtener la lista de referidos.
  /// Devuelve un stream que escucha los cambios en la colección de referidos del usuario.
  Stream<List<Map<String, dynamic>>> obtenerReferidos(String correoUsuario) {
    return _firestore
        .collection('referidos')
        .doc(correoUsuario)
        .collection(
            'referidosUsuario') // Escucha los cambios en la colección de referidos del usuario.
        .snapshots() // Devuelve un stream de snapshots.
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data())
            .toList()); // Mapea los datos a una lista de mapas.
  }
}
