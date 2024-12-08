// class MasonryCalentamientoFisico extends StatefulWidget {
//   const MasonryCalentamientoFisico({Key? key}) : super(key: key);

//   @override
//   _MasonryCalentamientoFisicoState createState() =>
//       _MasonryCalentamientoFisicoState();
// }

// class _MasonryCalentamientoFisicoState
//     extends State<MasonryCalentamientoFisico> {
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // En tu widget principal
//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return FilterDialog(
//           onFilterApplied: (
//             SelectedBodyPart? selectedBodyPart,
//             SelectedCalentamientoEspecifico? selectedCalentamientoEspecifico,
//             SelectedEquipment? selectedEquipment,
//             SelectedObjetivos? selectedObjetivos,
//           ) {
//             if (selectedBodyPart != null) {
//               print(
//                   'BodyPart - ID: ${selectedBodyPart.id}, Name (Español): ${selectedBodyPart.bodypartEsp}, Name (Inglés): ${selectedBodyPart.bodypartEng}');
//             }
//             if (selectedCalentamientoEspecifico != null) {
//               print(
//                   'CalentamientoEspecifico - ID: ${selectedCalentamientoEspecifico.id}');
//             }
//             if (selectedEquipment != null) {
//               print(
//                   'Equipment - ID: ${selectedEquipment.id}}');
//             }
//             if (selectedObjetivos != null) {
//               print(
//                   'Objetivos - ID: ${selectedObjetivos.id}');
//             }
//           },
//           onBodyPartSelectionChanged: (SelectedBodyPart selectedBodyPart) {
//             print('Seleccionado BodyPart en MasonryCalentamientoFisico:');
//             print('ID: ${selectedBodyPart.id}');
//             print('Nombre (Español): ${selectedBodyPart.bodypartEsp}');
//             print('Nombre (Inglés): ${selectedBodyPart.bodypartEng}');
//           },
//           onCalentamientoSelectionChanged:
//               (SelectedCalentamientoEspecifico selectedCalentamiento) {
//             print('Seleccionado CalentamientoEspecifico en MasonryCalentamientoFisico:');
//             print('ID: ${selectedCalentamiento.id}');
//             //print('Nombre: ${selectedCalentamiento.name}');
//           },
//           onEquipmentSelectionChanged: (SelectedEquipment selectedEquipment) {
//             print('Seleccionado Equipment en MasonryCalentamientoFisico:');
//             print('ID: ${selectedEquipment.id}');
//             //print('Nombre: ${selectedEquipment.name}');
//           },
//           onObjetivosSelectionChanged: (SelectedObjetivos selectedObjetivos) {
//             print('Seleccionado Objetivos en MasonryCalentamientoFisico:');
//             print('ID: ${selectedObjetivos.id}');
//            // print('Nombre: ${selectedObjetivos.name}');
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 2.0,
//                           color: AppColors.adaptableColor(context),
//                         ),
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _searchController,
//                               decoration: InputDecoration(
//                                 hintText: AppLocalizations.of(context)!
//                                     .translate('search'),
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.symmetric(
//                                   vertical: 15.0,
//                                   horizontal: 10.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: Icon(
//                               Icons.search,
//                               size: 30,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _showFilterDialog,
//                     icon: Icon(
//                       Icons.filter_list,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Aquí puedes agregar cualquier otra lógica que necesites mostrar
//           ],
//         ),
//       ),
//     );
//   }
// }
