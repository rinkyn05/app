import 'package:cloud_firestore/cloud_firestore.dart';
import '../../backend/models/bodypart_in_ejercicio_model.dart';
import '../../backend/models/equipment_in_ejercicio_model.dart';
import '../../backend/models/objetivos_in_ejercicio_model.dart';
import '../../backend/models/selected_cat_ejercicio_model.dart';
import '../../backend/models/unequipment_in_ejercicio_model.dart';

class UpdateEjercicioFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateEjercicio({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String descripcionEsp,
    required String descripcionEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String calorias,
    required String repeticiones,
    required String intensityEsp,
    required String intensityEng,
    required String stanceEsp,
    required String stanceEng,
    required String membershipEsp,
    required String membershipEng,
    required String duracion,
    required String imageUrl,
    required List<SelectedBodyPart> selectedBodyPart,
    required List<String> bodypart,
    required List<SelectedObjetivos> selectedObjetivos,
    required List<String> objetivos,
    required List<SelectedEquipment> selectedEquipment,
    required List<String> equipment,
    required List<SelectedUnequipment> selectedUnequipment,
    required List<String> unequipment,
    required List<String> catejercicio,
    required List<SelectedCatEjercicio> selectedCatEjercicio,
  }) async {
    await _firestore.collection('ejercicios').doc(id).update({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'DescripcionEsp': descripcionEsp,
      'DescripcionEng': descripcionEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'Calorias': calorias,
      'Repeticiones': repeticiones,
      'IntensityEsp': intensityEsp,
      'IntensityEng': intensityEng,
      'StanceEsp': stanceEsp,
      'StanceEng': stanceEng,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'Duracion': duracion,
      'Imagen': imageUrl,
      'Objetivos': selectedObjetivos.map((c) => c.toMap()).toList(),
      'BodyPart': selectedBodyPart.map((c) => c.toMap()).toList(),
      'Equipment': selectedEquipment.map((c) => c.toMap()).toList(),
      'Unequipment': selectedUnequipment.map((c) => c.toMap()).toList(),
      'CatEjercicio': selectedCatEjercicio.map((c) => c.toMap()).toList(),
    });
  }
}
