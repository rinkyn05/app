import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../widgets/custom_appbar_new.dart';
import 'mansory_ejercicios_filter.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';

class ResultsEjerciciosScreen extends StatelessWidget {
  final SelectedBodyPart? selectedBodyPart;
  final SelectedEquipment? selectedEquipment;
  final SelectedObjetivos? selectedObjetivos;
  final String? selectedDifficulty;
  final String? selectedMembership;
  final String? selectedImpactLevel;
  final String? selectedPostura;
  final String? selectedPhase;

  const ResultsEjerciciosScreen({
    Key? key,
    required this.selectedBodyPart,
    required this.selectedEquipment,
    required this.selectedObjetivos,
    required this.selectedDifficulty,
    required this.selectedMembership,
    required this.selectedImpactLevel,
    required this.selectedPostura, String? selectedIntensity,
    required this.selectedPhase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Impresión detallada de las selecciones recibidas
    print('En Results se recibió:');
    
    if (selectedBodyPart != null) {
      print(
          'BodyPart - ID: ${selectedBodyPart!.id}, Nombre (Español): ${selectedBodyPart!.bodypartEsp}, Nombre (Inglés): ${selectedBodyPart!.bodypartEng}');
    } else {
      print('BodyPart: No seleccionado');
    }
    
    if (selectedEquipment != null) {
      print(
          'Equipment - ID: ${selectedEquipment!.id}, Nombre (Español): ${selectedEquipment!.equipmentEsp}, Nombre (Inglés): ${selectedEquipment!.equipmentEng}');
    } else {
      print('Equipment: No seleccionado');
    }

    if (selectedObjetivos != null) {
      print(
          'Objetivos - ID: ${selectedObjetivos!.id}, Nombre (Español): ${selectedObjetivos!.objetivosEsp}, Nombre (Inglés): ${selectedObjetivos!.objetivosEng}');
    } else {
      print('Objetivos: No seleccionado');
    }
    
    print('Difficulty: ${selectedDifficulty ?? "No seleccionado"}');
    print('Membership: ${selectedMembership ?? "No seleccionado"}');
    print('ImpactLevel: ${selectedImpactLevel ?? "No seleccionado"}');
    print('Postura: ${selectedPostura ?? "No seleccionado"}');
    print('Fase: ${selectedPhase ?? "No seleccionado"}');

    return Scaffold(
      appBar: CustomAppBarNew(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('ResultsExercises')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: MasonryEjerciciosFilter(
                selectedBodyPart: selectedBodyPart,
                selectedEquipment: selectedEquipment,
                selectedObjetivos: selectedObjetivos,
                selectedDifficulty: selectedDifficulty,
                selectedMembership: selectedMembership,
                selectedImpactLevel: selectedImpactLevel,
                selectedPostura: selectedPostura,
                selectedPhase: selectedPhase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
