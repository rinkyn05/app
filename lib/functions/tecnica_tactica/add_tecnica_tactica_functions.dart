import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para la autenticación..

import '../../backend/models/equipment_in_ejercicio_model.dart'; // Importa el modelo de equipo en ejercicio.
import '../../backend/models/sports_in_ejercicio_model.dart'; // Importa el modelo de deportes en ejercicio.

/// Esta clase contiene funciones para agregar una técnica táctica a Firestore.
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
/// Por ejemplo, para la carpeta `tenicaTactica`, el archivo de adición se llama `add_tecnica_tactica_functions`.
class AddTenicaTacticaFunctions {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Agrega una nueva técnica táctica a Firestore con un ID autoincremental.
  Future<void> addTenicaTacticaWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required List<SelectedEquipment> selectedEquipment,
    required List<SelectedSports> selectedSports,
    required String nivelDeImpactoEsp,
    required String nivelDeImpactoEng,
    required List<String> ejercicioParaEsp,
    required List<String> ejercicioParaEng,
    required List<String> faseDeTemporadaEsp,
    required List<String> faseDeTemporadaEng,
    required List<String> faseDeEjercicioEsp,
    required List<String> faseDeEjercicioEng,
    required String stanceEsp,
    required String stanceEng,
    required String zonaPrincipalInvolucradaEsp,
    required String zonaPrincipalInvolucradaEng,
    required String difficultyEsp,
    required String difficultyEng,
    required String intensityEsp,
    required String intensityEng,
    required String video,
    required String descripcionEsp,
    required String descripcionEng,
    required String imageUrl,
    required String membershipEsp,
    required String membershipEng,
  }) async {
    User? user =
        FirebaseAuth.instance.currentUser; // Obtiene el usuario actual.
    if (user == null) return; // Si no hay usuario, sale de la función.

    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get(); // Obtiene el documento del usuario.
    String userName = userDoc.exists
        ? userDoc.get('Nombre')
        : ''; // Obtiene el nombre del usuario.

    DocumentReference metadataRef = _firestore
        .collection('metadata')
        .doc('tenicaTacticaData'); // Referencia a los metadatos.
    DocumentSnapshot metadataSnapshot =
        await metadataRef.get(); // Obtiene los metadatos.
    int lastTenicaTacticaId = metadataSnapshot.exists
        ? metadataSnapshot.get('lastTenicaTacticaId')
        : 0; // ID del último documento.
    int newTenicaTacticaId = lastTenicaTacticaId + 1; // Incrementa el ID.
    String tenicaTacticaId =
        newTenicaTacticaId.toString(); // Convierte el ID a string.

    await metadataRef.set({
      'lastTenicaTacticaId': newTenicaTacticaId
    }); // Actualiza los metadatos.

    // Agrega la nueva técnica táctica a Firestore.
    await _firestore.collection('tenicaTactica').doc(tenicaTacticaId).set({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Equipment': selectedEquipment
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.equipmentEsp,
                'NombreEng': e.equipmentEng,
              })
          .toList(),
      'Sports': selectedSports
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.sportsEsp,
                'NombreEng': e.sportsEng,
              })
          .toList(),
      'NivelDeImpactoEsp': nivelDeImpactoEsp,
      'NivelDeImpactoEng': nivelDeImpactoEng,
      'EjercicioParaEsp': ejercicioParaEsp,
      'EjercicioParaEng': ejercicioParaEng,
      'FaseDeTemporadaEsp': faseDeTemporadaEsp,
      'FaseDeTemporadaEng': faseDeTemporadaEng,
      'FaseDeEjercicioEsp': faseDeEjercicioEsp,
      'FaseDeEjercicioEng': faseDeEjercicioEng,
      'StanceEsp': stanceEsp,
      'StanceEng': stanceEng,
      'ZonaPrincipalInvolucradaEsp': zonaPrincipalInvolucradaEsp,
      'ZonaPrincipalInvolucradaEng': zonaPrincipalInvolucradaEng,
      'DifficultyEsp': difficultyEsp,
      'DifficultyEng': difficultyEng,
      'IntensityEsp': intensityEsp,
      'IntensityEng': intensityEng,
      'Video': video,
      'DescripcionEsp': descripcionEsp,
      'DescripcionEng': descripcionEng,
      'URL de la Imagen': imageUrl,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(), // Establece la fecha actual.
    });

    // Actualiza las referencias en la colección de equipmentTenicaTactica.
    for (var equipment in selectedEquipment) {
      DocumentReference equipmentTenicaTacticaRef =
          _firestore.collection('equipmentTenicaTactica').doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentTenicaTacticaRef);
        if (snapshot.exists) {
          transaction.update(equipmentTenicaTacticaRef, {
            'tenicaTactica': FieldValue.arrayUnion([tenicaTacticaId]),
            'tenicaTacticaDetails': FieldValue.arrayUnion([
              {
                'tenicaTacticaId': tenicaTacticaId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentTenicaTacticaRef, {
            'tenicaTactica': [tenicaTacticaId],
            'tenicaTacticaDetails': [
              {
                'tenicaTacticaId': tenicaTacticaId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    // Actualiza las referencias en la colección de sportsTenicaTactica.
    for (var sports in selectedSports) {
      DocumentReference sportsTenicaTacticaRef =
          _firestore.collection('sportsTenicaTactica').doc(sports.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(sportsTenicaTacticaRef);
        if (snapshot.exists) {
          transaction.update(sportsTenicaTacticaRef, {
            'tenicaTactica': FieldValue.arrayUnion([tenicaTacticaId]),
            'tenicaTacticaDetails': FieldValue.arrayUnion([
              {
                'tenicaTacticaId': tenicaTacticaId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(sportsTenicaTacticaRef, {
            'tenicaTactica': [tenicaTacticaId],
            'tenicaTacticaDetails': [
              {
                'tenicaTacticaId': tenicaTacticaId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }
  }
}
