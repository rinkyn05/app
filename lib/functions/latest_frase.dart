import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Función para obtener la última frase publicada desde Firestore.
///
/// Esta función devuelve un mapa que contiene los datos de la frase más reciente
/// o null si no se encuentra ninguna frase o si ocurre un error.
Future<Map<String, dynamic>?> fetchLatestFrase() async {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Crea una instancia de Firestore.

  try {
    // Realiza una consulta a la colección 'frases' ordenando por 'Fecha de Publicacion' en orden descendente.
    QuerySnapshot querySnapshot = await firestore
        .collection('frases')
        .orderBy('Fecha de Publicacion',
            descending: true) // Ordena las frases más recientes primero.
        .limit(1) // Limita el resultado a 1 documento.
        .get(); // Ejecuta la consulta.

    // Verifica si hay documentos en el resultado de la consulta.
    if (querySnapshot.docs.isNotEmpty) {
      // Si hay documentos, devuelve los datos del primero como un mapa.
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      // Si no hay documentos, devuelve null.
      return null;
    }
  } catch (e) {
    // Si ocurre un error durante la consulta, devuelve null.
    return null;
  }
}
