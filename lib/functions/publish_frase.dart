import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

// Función para publicar una frase en la colección 'frases' de Firestore.
Future<void> publishFrase(String frase, String fraseEng) async {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Obtiene la instancia de Firestore.
  DateTime now = DateTime.now(); // Obtiene la fecha y hora actuales.

  // Agrega un nuevo documento a la colección 'frases' con la frase en español, en inglés y la fecha de publicación.
  await firestore.collection('frases').add({
    'Frase Esp': frase, // Campo para la frase en español.
    'Frase Eng': fraseEng, // Campo para la frase en inglés.
    'Fecha de Publicacion': now, // Campo para la fecha y hora de publicación.
  });
}
