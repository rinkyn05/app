// import 'package:flutter/material.dart';
// import '../../config/lang/app_localization.dart';
// import '../../filtros/widgets/BodyPartDropdownWidget.dart';
// import '../../filtros/widgets/CalentamientoEspecificoDropdownWidget.dart';
// import '../../filtros/widgets/EquipmentDropdownWidget.dart';
// import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
// import '../../filtros/widgets/SportsDropdownWidget.dart.dart';
// import '../../widgets/custom_appbar_new.dart';
// import '../../widgets/grid_view/mansory_calentamiento_fisico_filter.dart';

// class ResultsCalentamientoFisicoScreen extends StatelessWidget {
//   final SelectedBodyPart? selectedBodyPart;
//   final SelectedCalentamientoEspecifico? selectedCalentamientoEspecifico;
//   final SelectedEquipment? selectedEquipment;
//   final SelectedObjetivos? selectedObjetivos;
//   final String? selectedDifficulty;
//   final String? selectedIntensity;
//   final String? selectedMembership;
//   final String? selectedImpactLevel;
//   final String? selectedPostura;
//   final List<SelectedSports> selectedSports;

//   const ResultsCalentamientoFisicoScreen({
//     Key? key,
//     required this.selectedBodyPart,
//     required this.selectedCalentamientoEspecifico,
//     required this.selectedEquipment,
//     required this.selectedObjetivos,
//     required this.selectedDifficulty,
//     required this.selectedIntensity,
//     required this.selectedMembership,
//     required this.selectedImpactLevel,
//     required this.selectedPostura,
//     required this.selectedSports,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Agregar el print para verificar los valores recibidos.
//     print('En Results se recibió:');
//     print('selectedBodyPart: $selectedBodyPart');
//     print('selectedCalentamientoEspecifico: $selectedCalentamientoEspecifico');
//     print('selectedEquipment: $selectedEquipment');
//     print('selectedObjetivos: $selectedObjetivos');
//     print('selectedDifficulty: $selectedDifficulty');
//     print('selectedIntensity: $selectedIntensity');
//     print('selectedMembership: $selectedMembership');
//     print('selectedImpactLevel: $selectedImpactLevel');
//     print('selectedPostura: $selectedPostura');
//     print('selectedSports: $selectedSports');

//     return Scaffold(
//       appBar: CustomAppBarNew(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "${AppLocalizations.of(context)!.translate('ResultsCalentamientoFisico')}",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: MasonryCalentamientoFisicoFilter(
//                 selectedBodyPart: selectedBodyPart,
//                 selectedCalentamientoEspecifico: selectedCalentamientoEspecifico,
//                 selectedEquipment: selectedEquipment,
//                 selectedObjetivos: selectedObjetivos,
//                 selectedDifficulty: selectedDifficulty,
//                 selectedIntensity: selectedIntensity,
//                 selectedMembership: selectedMembership,
//                 selectedImpactLevel: selectedImpactLevel,
//                 selectedPostura: selectedPostura,
//                 selectedSports: selectedSports,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
