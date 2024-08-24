import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../backend/models/equipment_in_ejercicio_model.dart';
import '../../backend/models/sports_in_ejercicio_model.dart';

class AddRendimientoFisicoFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRendimientoFisicoWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required List<SelectedEquipment> selectedEquipment,
    required List<SelectedSports> selectedSports,
    required String nivelDeImpactoEsp,
    required String nivelDeImpactoEng,
    required String stanceEsp,
    required String stanceEng,
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
        _firestore.collection('metadata').doc('rendimientoFisicoData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastRendimientoFisicoId = metadataSnapshot.exists
        ? metadataSnapshot.get('lastRendimientoFisicoId')
        : 0;
    int newRendimientoFisicoId = lastRendimientoFisicoId + 1;
    String rendimientoFisicoId = newRendimientoFisicoId.toString();

    await metadataRef
        .set({'lastRendimientoFisicoId': newRendimientoFisicoId});

    await _firestore
        .collection('rendimientoFisico')
        .doc(rendimientoFisicoId)
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
      'StanceEsp': stanceEsp,
      'StanceEng': stanceEng,
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
      DocumentReference equipmentRendimientoFisicoRef = _firestore
          .collection('equipmentRendimientoFisico')
          .doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentRendimientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(equipmentRendimientoFisicoRef, {
            'rendimientoFisico':
                FieldValue.arrayUnion([rendimientoFisicoId]),
            'rendimientoFisicoDetails': FieldValue.arrayUnion([
              {
                'rendimientoFisicoId': rendimientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentRendimientoFisicoRef, {
            'rendimientoFisico': [rendimientoFisicoId],
            'rendimientoFisicoDetails': [
              {
                'rendimientoFisicoId': rendimientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ]
          });
        }
      });
    }

    for (var sports in selectedSports) {
      DocumentReference sportsRendimientoFisicoRef = _firestore
          .collection('sportsRendimientoFisico')
          .doc(sports.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(sportsRendimientoFisicoRef);
        if (snapshot.exists) {
          transaction.update(sportsRendimientoFisicoRef, {
            'rendimientoFisico':
                FieldValue.arrayUnion([rendimientoFisicoId]),
            'rendimientoFisicoDetails': FieldValue.arrayUnion([
              {
                'rendimientoFisicoId': rendimientoFisicoId,
                'NombreEsp': nombreEsp,
                'NombreEng': nombreEng,
              }
            ])
          });
        } else {
          transaction.set(sportsRendimientoFisicoRef, {
            'rendimientoFisico': [rendimientoFisicoId],
            'rendimientoFisicoDetails': [
              {
                'rendimientoFisicoId': rendimientoFisicoId,
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
