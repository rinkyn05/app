import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../backend/models/equipment_in_ejercicio_model.dart';
import '../../backend/models/sports_in_ejercicio_model.dart';

class AddMejPreLesionesFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMejPreLesionesWithAutoIncrementId({
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
    required String articulacionPrincipalEsp,
    required String articulacionPrincipalEng,
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('mejPreLesionesData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastMejPreLesionesId = metadataSnapshot.exists
        ? metadataSnapshot.get('lastMejPreLesionesId')
        : 0;
    int newMejPreLesionesId = lastMejPreLesionesId + 1;
    String mejPreLesionesId = newMejPreLesionesId.toString();

    await metadataRef.set({'lastMejPreLesionesId': newMejPreLesionesId});

    await _firestore
        .collection('mejPreLesiones')
        .doc(mejPreLesionesId)
        .set({
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
      'ArticulacionPrincipalEsp': articulacionPrincipalEsp,
      'ArticulacionPrincipalEng': articulacionPrincipalEng,
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
      'Fecha': DateTime.now(),
    });

    for (var equipment in selectedEquipment) {
      DocumentReference equipmentMejPreLesionesRef =
          _firestore.collection('equipmentMejPreLesiones').doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentMejPreLesionesRef);
        if (snapshot.exists) {
          transaction.update(equipmentMejPreLesionesRef, {
            'mejPreLesiones': FieldValue.arrayUnion([mejPreLesionesId]),
            'mejPreLesionesDetails': FieldValue.arrayUnion([
              {
                'mejPreLesionesId': mejPreLesionesId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentMejPreLesionesRef, {
            'mejPreLesiones': [mejPreLesionesId],
            'mejPreLesionesDetails': [
              {
                'mejPreLesionesId': mejPreLesionesId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var sports in selectedSports) {
      DocumentReference sportsMejPreLesionesRef =
          _firestore.collection('sportsMejPreLesiones').doc(sports.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(sportsMejPreLesionesRef);
        if (snapshot.exists) {
          transaction.update(sportsMejPreLesionesRef, {
            'mejPreLesiones': FieldValue.arrayUnion([mejPreLesionesId]),
            'mejPreLesionesDetails': FieldValue.arrayUnion([
              {
                'mejPreLesionesId': mejPreLesionesId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(sportsMejPreLesionesRef, {
            'mejPreLesiones': [mejPreLesionesId],
            'mejPreLesionesDetails': [
              {
                'mejPreLesionesId': mejPreLesionesId,
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
