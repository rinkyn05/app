import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Esta clase contiene funciones para actualizar la información relacionada con la técnica y táctica en la aplicación.
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
/// Por ejemplo, para la carpeta `tenicaTactica`, el archivo de actualización se llama `update_tecnia_tactica_functions`.
class UpdateTenicaTacticaFunctions {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Actualiza la información de una técnica táctica en la colección de Firestore.
  ///
  /// [id] es el identificador del documento que se va a actualizar.
  /// [nombreEsp] es el nombre en español de la técnica táctica.
  /// [nombreEng] es el nombre en inglés de la técnica táctica.
  /// [contenidoEsp] es el contenido en español que describe la técnica.
  /// [contenidoEng] es el contenido en inglés que describe la técnica.
  /// [video] es la URL del video relacionado con la técnica.
  /// [membershipEsp] es la información de membresía en español.
  /// [membershipEng] es la información de membresía en inglés.
  /// [imageUrl] es la URL de la imagen representativa de la técnica.
  Future<void> updateTenicaTactica({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String membershipEsp,
    required String membershipEng,
    required String imageUrl,
  }) async {
    // Realiza la actualización del documento en Firestore.
    await _firestore.collection('tenicaTactica').doc(id).update({
      'NombreEsp': nombreEsp, // Actualiza el nombre en español.
      'NombreEng': nombreEng, // Actualiza el nombre en inglés.
      'ContenidoEsp': contenidoEsp, // Actualiza el contenido en español.
      'ContenidoEng': contenidoEng, // Actualiza el contenido en inglés.
      'Video': video, // Actualiza la URL del video.
      'MembershipEsp':
          membershipEsp, // Actualiza la información de membresía en español.
      'MembershipEng':
          membershipEng, // Actualiza la información de membresía en inglés.
      'Imagen': imageUrl, // Actualiza la URL de la imagen.
    });
  }
}
