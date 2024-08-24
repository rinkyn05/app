import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../backend/models/bodypart_in_ejercicio_model.dart';
import '../../backend/models/equipment_in_ejercicio_model.dart';
import '../../backend/models/estiramiento_especifico_in_ejercicio_model.dart';
import '../../backend/models/objetivos_in_ejercicio_model.dart';
import '../../backend/models/sports_in_ejercicio_model.dart';

class AddEstiramientoFisicoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEstiramientoFisicoWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required List<SelectedBodyPart> selectedBodyPart,
    required List<SelectedEstiramientoEspecifico> SelectedEstiramientoEspecifico,
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
        _firestore.collection('metadata').doc('estiramientoFisicoData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastEstiramientoFisicoId = metadataSnapshot.exists
        ? metadataSnapshot.get('lastEstiramientoFisicoId')
        : 0;
    int newEstiramientoFisicoId = lastEstiramientoFisicoId + 1;
    String estiramientoFisicoId = newEstiramientoFisicoId.toString();

    await metadataRef
        .set({'lastEstiramientoFisicoId': newEstiramientoFisicoId});

    await _firestore
        .collection('estiramientoFisico')
        .doc(estiramientoFisicoId)
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
      'EstiramientoEspecifico': SelectedEstiramientoEspecifico
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.EstiramientoEspecificoEsp,
                'NombreEng': e.EstiramientoEspecificoEsp,
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
      DocumentReference bodypartEstiramientoFisicoRef =
          _firestore.collection('bodypartEstiramientoFisico').doc(bodypart.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(bodypartEstiramientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(bodypartEstiramientoFisicoRef, {
            'estiramientoFisico':
                FieldValue.arrayUnion([estiramientoFisicoId]),
            'estiramientoFisicoDetails': FieldValue.arrayUnion([
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(bodypartEstiramientoFisicoRef, {
            'estiramientoFisico': [estiramientoFisicoId],
            'estiramientoFisicoDetails': [
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var estiramientoEspecifico in SelectedEstiramientoEspecifico) {
      DocumentReference estiramientoEspecificoEstiramientoFisicoRef =
          _firestore.collection('estiramientoEspecificoEstiramientoFisico').doc(estiramientoEspecifico.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(estiramientoEspecificoEstiramientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(estiramientoEspecificoEstiramientoFisicoRef, {
            'estiramientoFisico':
                FieldValue.arrayUnion([estiramientoFisicoId]),
            'estiramientoFisicoDetails': FieldValue.arrayUnion([
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(estiramientoEspecificoEstiramientoFisicoRef, {
            'estiramientoFisico': [estiramientoFisicoId],
            'estiramientoFisicoDetails': [
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var equipment in selectedEquipment) {
      DocumentReference equipmentEstiramientoFisicoRef = _firestore
          .collection('equipmentEstiramientoFisico')
          .doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentEstiramientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(equipmentEstiramientoFisicoRef, {
            'estiramientoFisico':
                FieldValue.arrayUnion([estiramientoFisicoId]),
            'estiramientoFisicoDetails': FieldValue.arrayUnion([
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentEstiramientoFisicoRef, {
            'estiramientoFisico': [estiramientoFisicoId],
            'estiramientoFisicoDetails': [
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var sports in selectedSports) {
      DocumentReference sportsEstiramientoFisicoRef = _firestore
          .collection('sportsEstiramientoFisico')
          .doc(sports.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(sportsEstiramientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(sportsEstiramientoFisicoRef, {
            'estiramientoFisico':
                FieldValue.arrayUnion([estiramientoFisicoId]),
            'estiramientoFisicoDetails': FieldValue.arrayUnion([
              {
                'estiramientoFisicoId': estiramientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(sportsEstiramientoFisicoRef, {
            'estiramientoFisico': [estiramientoFisicoId],
            'estiramientoFisicoDetails': [
              {
                'estiramientoFisicoId': estiramientoFisicoId,
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
