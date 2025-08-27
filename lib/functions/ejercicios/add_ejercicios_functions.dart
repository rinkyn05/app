import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../backend/models/bodypart_in_ejercicio_model.dart';
import '../../backend/models/objetivos_in_ejercicio_model.dart';
import '../../backend/models/equipment_in_ejercicio_model.dart';

class AddEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEjercicioWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String videoPTrain,
    required String videoPObese,
    required String videoPFlaca,
    required String agonistMuscle,
    required String antagonistMuscle,
    required String sinergistnistMuscle,
    required String estabiliMuscle,
    required String imageUrl,
    required String image3dUrl,
    required List<SelectedObjetivos> selectedObjetivos,
    required List<SelectedEquipment> selectedEquipment,
    required List<SelectedBodyPart> selectedBodyPart,
    required String membershipEsp,
    required String membershipEng,
    required String intensityEsp,
    required String intensityEng,
    required String nivelDeImpactoEsp,
    required String nivelDeImpactoEng,
    required String phaseEsp,
    required String phaseEng,
    required String stanceEsp,
    required String stanceEng,
    String? specificMuscle,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('ejercicioData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastEjercicioId =
        metadataSnapshot.exists ? metadataSnapshot.get('lastEjercicioId') : 0;
    int newEjercicioId = lastEjercicioId + 1;
    String ejercicioId = newEjercicioId.toString();

    await metadataRef.set({'lastEjercicioId': newEjercicioId});

    await _firestore.collection('ejercicios').doc(ejercicioId).set({
      'NombreEsp': nombreEsp,
      'DescripcionEsp': descripcionEsp,
      'NombreEng': nombreEng,
      'DescripcionEng': descripcionEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'VideoPTrain': videoPTrain,
      'VideoPObese': videoPObese,
      'VideoPFlaca': videoPFlaca,
      'agonistMuscle': agonistMuscle,
      'antagonistMuscle': antagonistMuscle,
      'sinergistnistMuscle': sinergistnistMuscle,
      'estabiliMuscle': estabiliMuscle,
      'Objetivos': selectedObjetivos
          .map((c) => {
                'id': c.id,
                'NombreEsp': c.objetivosEsp,
                'NombreEng': c.objetivosEng,
              })
          .toList(),
      'Equipment': selectedEquipment
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.equipmentEsp,
                'NombreEng': e.equipmentEng,
              })
          .toList(),
      'BodyPart': selectedBodyPart
          .map((e) => {
                'id': e.id,
                'NombreEsp': e.bodypartEsp,
                'NombreEng': e.bodypartEsp,
              })
          .toList(),
      'specificMuscle': specificMuscle,
      'URL de la Imagen': imageUrl,
      'URL de la Imagen 3D': image3dUrl,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'IntensityEsp': intensityEsp,
      'IntensityEng': intensityEng,
      'NivelDeImpactoEsp': nivelDeImpactoEsp,
      'NivelDeImpactoEng': nivelDeImpactoEng,
      'PhaseEsp': phaseEsp,
      'PhaseEng': phaseEng,
      'StanceEsp': stanceEsp,
      'StanceEng': stanceEng,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(),
    });

    for (var objetivos in selectedObjetivos) {
      DocumentReference objetivosEjercicioRef =
          _firestore.collection('objetivosejercicio').doc(objetivos.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(objetivosEjercicioRef);
        if (snapshot.exists) {
          transaction.update(objetivosEjercicioRef, {
            'ejercicios': FieldValue.arrayUnion([ejercicioId]),
            'ejercicioDetails': FieldValue.arrayUnion([
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ])
          });
        } else {
          transaction.set(objetivosEjercicioRef, {
            'ejercicios': [ejercicioId],
            'ejercicioDetails': [
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ]
          });
        }
      });
    }

    for (var equipment in selectedEquipment) {
      DocumentReference equipmentEjercicioRef =
          _firestore.collection('equipmentejercicio').doc(equipment.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
            await transaction.get(equipmentEjercicioRef);
        if (snapshot.exists) {
          transaction.update(equipmentEjercicioRef, {
            'ejercicios': FieldValue.arrayUnion([ejercicioId]),
            'ejercicioDetails': FieldValue.arrayUnion([
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ])
          });
        } else {
          transaction.set(equipmentEjercicioRef, {
            'ejercicios': [ejercicioId],
            'ejercicioDetails': [
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ]
          });
        }
      });
    }

    for (var bodypart in selectedBodyPart) {
      DocumentReference bodypartEjercicioRef =
          _firestore.collection('bodypartejercicio').doc(bodypart.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(bodypartEjercicioRef);
        if (snapshot.exists) {
          transaction.update(bodypartEjercicioRef, {
            'ejercicios': FieldValue.arrayUnion([ejercicioId]),
            'ejercicioDetails': FieldValue.arrayUnion([
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ])
          });
        } else {
          transaction.set(bodypartEjercicioRef, {
            'ejercicios': [ejercicioId],
            'ejercicioDetails': [
              {
                'ejercicioId': ejercicioId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ]
          });
        }
      });
    }
  }
}
