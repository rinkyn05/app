import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.
import 'package:flutter/material.dart'; // Importa Flutter Material para el uso de clases relacionadas con la interfaz.

/// Esta clase contiene funciones para interactuar con la colección de técnica y táctica en Firestore.
///
/// Las mismas convenciones y estructuras de nombres se aplican a las carpetas y archivos dentro de la carpeta `functions`:
/// - **Carpetas:** `sports`, `rutinas`, `rendimiento_fisico`, `recipes`, `posts`, `pages`, `mej_prev_lesiones`,
///   `estiramiento_fisico`, `ejercicios`, `contents`, `category`, `calentamiento_fisico`, `alimentos`.
/// - **Archivos dentro de estas carpetas:** Se tendrán funciones que siguen una convención de nombres similar, como:
///   - `update_<nombre_de_la_carpeta>_functions` para actualizar información específica.
///   - `firestore_services` para funciones que interactúan con Firestore.
///   - `details_functions` para obtener detalles específicos.
///   - `add_<nombre_de_la_carpeta>_functions` para agregar nuevos registros.
///
/// Por ejemplo, para la carpeta `tenicaTactica`, el archivo de servicios de Firestore se llama `tenica_tactica_firestore_service`.
class TenicaTacticaFirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Obtiene la lista de técnicas y tácticas desde Firestore en función del idioma.
  ///
  /// [locale] es la configuración regional que determina el idioma de los datos.
  Future<List<Map<String, dynamic>>> getTenicaTactica(Locale locale) async {
    String langSuffix = locale.languageCode == 'es'
        ? 'Esp'
        : 'Eng'; // Determina el sufijo del idioma.
    QuerySnapshot querySnapshot = await _firestore
        .collection('tenicaTactica')
        .orderBy('Fecha',
            descending: true) // Ordena por fecha en orden descendente.
        .get();

    // Mapea los documentos a un formato más manejable.
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'Nombre':
            doc['Nombre$langSuffix'], // Obtiene el nombre según el idioma.
        'URL de la Imagen':
            doc['URL de la Imagen'], // Obtiene la URL de la imagen.
      };
    }).toList();
  }

  /// Obtiene los detalles de una técnica táctica específica.
  ///
  /// [tenicaTacticaId] es el identificador de la técnica táctica que se desea obtener.
  Future<Map<String, dynamic>?> getTenicaTacticaDetails(
      String tenicaTacticaId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('tenicaTactica')
          .doc(tenicaTacticaId)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data()
            as Map<String, dynamic>?; // Devuelve los datos del documento.
      }
      return null; // Devuelve null si el documento no existe.
    } catch (e) {
      return null; // Devuelve null en caso de error.
    }
  }

  /// Elimina una técnica táctica de Firestore.
  ///
  /// [tenicaTacticaId] es el identificador de la técnica táctica que se desea eliminar.
  Future<void> deleteTenicaTactica(String tenicaTacticaId) async {
    try {
      await _firestore
          .collection('tenicaTactica')
          .doc(tenicaTacticaId)
          .delete(); // Elimina el documento.
    } catch (e) {
      throw Exception(
          'Error deleting tenicaTactica: $e'); // Lanza excepción en caso de error.
    }
  }
}
