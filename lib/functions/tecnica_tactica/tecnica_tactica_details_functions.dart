import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Esta clase contiene funciones para obtener detalles sobre la técnica y táctica en Firestore.
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
/// Por ejemplo, para la carpeta `tenicaTactica`, el archivo de detalles se llama `tenica_tactica_details_functions`.
class TenicaTacticaDetailsFunctions {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

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
}
