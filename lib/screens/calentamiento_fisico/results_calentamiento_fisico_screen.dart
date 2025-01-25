import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/CalentamientoEspecificoDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
import '../../filtros/widgets/SportsDropdownWidget.dart.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/grid_view/mansory_calentamiento_fisico_filter.dart';

class ResultsCalentamientoFisicoScreen extends StatelessWidget {
  final SelectedBodyPart? selectedBodyPart;
  final SelectedCalentamientoEspecifico? selectedCalentamientoEspecifico;
  final SelectedEquipment? selectedEquipment;
  final SelectedObjetivos? selectedObjetivos;
  final String? selectedDifficulty;
  final String? selectedIntensity;
  final String? selectedMembership;
  final String? selectedImpactLevel;
  final String? selectedPostura;
  final List<SelectedSports> selectedSports;

  const ResultsCalentamientoFisicoScreen({
    Key? key,
    required this.selectedBodyPart,
    required this.selectedCalentamientoEspecifico,
    required this.selectedEquipment,
    required this.selectedObjetivos,
    required this.selectedDifficulty,
    required this.selectedIntensity,
    required this.selectedMembership,
    required this.selectedImpactLevel,
    required this.selectedPostura,
    required this.selectedSports,
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
    
    if (selectedCalentamientoEspecifico != null) {
      print(
          'CalentamientoEspecifico - ID: ${selectedCalentamientoEspecifico!.id}, Nombre (Español): ${selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp}, Nombre (Inglés): ${selectedCalentamientoEspecifico!.CalentamientoEspecificoEng}');
    } else {
      print('CalentamientoEspecifico: No seleccionado');
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
    print('Intensity: ${selectedIntensity ?? "No seleccionado"}');
    print('Membership: ${selectedMembership ?? "No seleccionado"}');
    print('ImpactLevel: ${selectedImpactLevel ?? "No seleccionado"}');
    print('Postura: ${selectedPostura ?? "No seleccionado"}');
    
    if (selectedSports.isNotEmpty) {
      print('Sports seleccionados:');
      for (var sport in selectedSports) {
        print(
            '  - ID: ${sport.id}, Nombre (Español): ${sport.sportsEsp}, Nombre (Inglés): ${sport.sportsEng}');
      }
    } else {
      print('Sports: No seleccionado');
    }

    return Scaffold(
      appBar: CustomAppBarNew(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('ResultsCalentamientoFisico')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Expanded(
              child: MasonryCalentamientoFisicoFilter(
                selectedBodyPart: selectedBodyPart,
                selectedCalentamientoEspecifico: selectedCalentamientoEspecifico,
                selectedEquipment: selectedEquipment,
                selectedObjetivos: selectedObjetivos,
                selectedDifficulty: selectedDifficulty,
                selectedIntensity: selectedIntensity,
                selectedMembership: selectedMembership,
                selectedImpactLevel: selectedImpactLevel,
                selectedPostura: selectedPostura,
                selectedSports: selectedSports,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
