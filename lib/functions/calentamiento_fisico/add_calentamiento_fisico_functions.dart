import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../backend/models/bodypart_in_ejercicio_model.dart';
import '../../backend/models/calentamiento_especifico_in_ejercicio_model.dart';
import '../../backend/models/equipment_in_ejercicio_model.dart';
import '../../backend/models/objetivos_in_ejercicio_model.dart';
import '../../backend/models/sports_in_ejercicio_model.dart';

class AddCalentamientoFisicoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCalentamientoFisicoWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required List<SelectedBodyPart> selectedBodyPart,
    required List<SelectedCalentamientoEspecifico> SelectedCalentamientoEspecifico,
    required List<SelectedEquipment> selectedEquipment,
    required List<SelectedSports> selectedSports,
    required String nivelDeImpactoEsp,
    required String nivelDeImpactoEng,
    required String stanceEsp,
    required String stanceEng,
    required String difficultyEsp,
    required String difficultyEng,
    required List<SelectedObjetivos> selectedObjetivos,
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
        _firestore.collection('metadata').doc('calentamientoFisicoData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastCalentamientoFisicoId = metadataSnapshot.exists
        ? metadataSnapshot.get('lastCalentamientoFisicoId')
        : 0;
    int newCalentamientoFisicoId = lastCalentamientoFisicoId + 1;
    String calentamientoFisicoId = newCalentamientoFisicoId.toString();

    await metadataRef
        .set({'lastCalentamientoFisicoId': newCalentamientoFisicoId});

    await _firestore
        .collection('calentamientoFisico')
        .doc(calentamientoFisicoId)
        .set({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'BodyPart': selectedBodyPart
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.bodypartEsp,
                'NombreEng': e.bodypartEsp,
              })
          .toList(),
      'CalentamientoEspecifico': SelectedCalentamientoEspecifico
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.CalentamientoEspecificoEsp,
                'NombreEng': e.CalentamientoEspecificoEsp,
              })
          .toList(),
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
      'StanceEsp': stanceEsp,
      'StanceEng': stanceEng,
      'DifficultyEsp': difficultyEsp,
      'DifficultyEng': difficultyEng,
      'Objetivos': selectedObjetivos
          .map((c) => {
                'id': c.id,
                'NombreEsp': c.objetivosEsp,
                'NombreEng': c.objetivosEng,
              })
          .toList(),
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
    for (var bodypart in selectedBodyPart) {
      DocumentReference bodypartCalentamientoFisicoRef =
          _firestore.collection('bodypartCalentamientoFisico').doc(bodypart.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(bodypartCalentamientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(bodypartCalentamientoFisicoRef, {
            'calentamientoFisico':
                FieldValue.arrayUnion([calentamientoFisicoId]),
            'calentamientoFisicoDetails': FieldValue.arrayUnion([
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(bodypartCalentamientoFisicoRef, {
            'calentamientoFisico': [calentamientoFisicoId],
            'calentamientoFisicoDetails': [
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var calentamientoEspecifico in SelectedCalentamientoEspecifico) {
      DocumentReference calentamientoEspecificoCalentamientoFisicoRef =
          _firestore.collection('calentamientoEspecificoCalentamientoFisico').doc(calentamientoEspecifico.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(calentamientoEspecificoCalentamientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(calentamientoEspecificoCalentamientoFisicoRef, {
            'calentamientoFisico':
                FieldValue.arrayUnion([calentamientoFisicoId]),
            'calentamientoFisicoDetails': FieldValue.arrayUnion([
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(calentamientoEspecificoCalentamientoFisicoRef, {
            'calentamientoFisico': [calentamientoFisicoId],
            'calentamientoFisicoDetails': [
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var equipment in selectedEquipment) {
      DocumentReference equipmentCalentamientoFisicoRef = _firestore
          .collection('equipmentCalentamientoFisico')
          .doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentCalentamientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(equipmentCalentamientoFisicoRef, {
            'calentamientoFisico':
                FieldValue.arrayUnion([calentamientoFisicoId]),
            'calentamientoFisicoDetails': FieldValue.arrayUnion([
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentCalentamientoFisicoRef, {
            'calentamientoFisico': [calentamientoFisicoId],
            'calentamientoFisicoDetails': [
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var sports in selectedSports) {
      DocumentReference sportsCalentamientoFisicoRef = _firestore
          .collection('sportsCalentamientoFisico')
          .doc(sports.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(sportsCalentamientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(sportsCalentamientoFisicoRef, {
            'calentamientoFisico':
                FieldValue.arrayUnion([calentamientoFisicoId]),
            'calentamientoFisicoDetails': FieldValue.arrayUnion([
              {
                'calentamientoFisicoId': calentamientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(sportsCalentamientoFisicoRef, {
            'calentamientoFisico': [calentamientoFisicoId],
            'calentamientoFisicoDetails': [
              {
                'calentamientoFisicoId': calentamientoFisicoId,
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
