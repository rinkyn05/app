import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../config/notifiers/selected_notifier.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/CalentamientoEspecificoDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
import '../../filtros/widgets/SportsDropdownWidget.dart.dart';

class MasonryCalentamientoFisicoFilterLast extends StatefulWidget {
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

  const MasonryCalentamientoFisicoFilterLast({
    Key? key,
    this.selectedBodyPart,
    this.selectedCalentamientoEspecifico,
    this.selectedEquipment,
    this.selectedObjetivos,
    this.selectedDifficulty,
    this.selectedIntensity,
    this.selectedMembership,
    this.selectedImpactLevel,
    this.selectedPostura,
    required this.selectedSports,
  }) : super(key: key);

  @override
  _MasonryCalentamientoFisicoFilterLastState createState() => _MasonryCalentamientoFisicoFilterLastState();
}

class _MasonryCalentamientoFisicoFilterLastState extends State<MasonryCalentamientoFisicoFilterLast> {
  List<Map<String, dynamic>> filteredDocs = [];

  @override
  void initState() {
    super.initState();
    applyFilters();

    // Impresión detallada de las selecciones recibidas
    print('En Masonry Filter se recibieron los siguientes parámetros:');

    if (widget.selectedBodyPart != null) {
      print(
          'BodyPart - ID: ${widget.selectedBodyPart!.id}, Nombre (Español): ${widget.selectedBodyPart!.bodypartEsp}, Nombre (Inglés): ${widget.selectedBodyPart!.bodypartEng}');
    } else {
      print('BodyPart: No seleccionado');
    }

    if (widget.selectedCalentamientoEspecifico != null) {
      print(
          'CalentamientoEspecifico - ID: ${widget.selectedCalentamientoEspecifico!.id}, Nombre (Español): ${widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp}, Nombre (Inglés): ${widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEng}');
    } else {
      print('CalentamientoEspecifico: No seleccionado');
    }

    if (widget.selectedEquipment != null) {
      print(
          'Equipment - ID: ${widget.selectedEquipment!.id}, Nombre (Español): ${widget.selectedEquipment!.equipmentEsp}, Nombre (Inglés): ${widget.selectedEquipment!.equipmentEng}');
    } else {
      print('Equipment: No seleccionado');
    }

    if (widget.selectedObjetivos != null) {
      print(
          'Objetivos - ID: ${widget.selectedObjetivos!.id}, Nombre (Español): ${widget.selectedObjetivos!.objetivosEsp}, Nombre (Inglés): ${widget.selectedObjetivos!.objetivosEng}');
    } else {
      print('Objetivos: No seleccionado');
    }

    print('Difficulty: ${widget.selectedDifficulty ?? "No seleccionado"}');
    print('Intensity: ${widget.selectedIntensity ?? "No seleccionado"}');
    print('Membership: ${widget.selectedMembership ?? "No seleccionado"}');
    print('ImpactLevel: ${widget.selectedImpactLevel ?? "No seleccionado"}');
    print('Postura: ${widget.selectedPostura ?? "No seleccionado"}');

    if (widget.selectedSports.isNotEmpty) {
      print('Sports seleccionados:');
      for (var sport in widget.selectedSports) {
        print(
            '  - ID: ${sport.id}, Nombre (Español): ${sport.sportsEsp}, Nombre (Inglés): ${sport.sportsEng}');
      }
    } else {
      print('Sports: No seleccionado');
    }
  }

  void applyFilters() async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('calentamientoFisico');

    // Aplicar filtros si los parámetros no son nulos, vacíos o "No seleccionado"
    if (widget.selectedBodyPart != null && widget.selectedBodyPart!.bodypartEsp.isNotEmpty) {
      print('Aplicando filtro en BodyPart: ${widget.selectedBodyPart!.bodypartEsp}');
      query = query.where('BodyPart', arrayContains: {'NombreEsp': widget.selectedBodyPart!.bodypartEsp});
    }
    if (widget.selectedCalentamientoEspecifico != null && widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp.isNotEmpty) {
      print('Aplicando filtro en CalentamientoEspecifico: ${widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp}');
      query = query.where('CalentamientoEspecifico', arrayContains: {'ContenidoEsp': widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp});
    }
    if (widget.selectedEquipment != null && widget.selectedEquipment!.equipmentEsp.isNotEmpty) {
      print('Aplicando filtro en Equipment: ${widget.selectedEquipment!.equipmentEsp}');
      query = query.where('Equipment', arrayContains: {'NombreEsp': widget.selectedEquipment!.equipmentEsp});
    }
    if (widget.selectedObjetivos != null && widget.selectedObjetivos!.objetivosEsp.isNotEmpty) {
      print('Aplicando filtro en Objetivos: ${widget.selectedObjetivos!.objetivosEsp}');
      query = query.where('Objetivos', arrayContains: {'NombreEsp': widget.selectedObjetivos!.objetivosEsp});
    }
    if (widget.selectedDifficulty != null && widget.selectedDifficulty!.isNotEmpty && widget.selectedDifficulty != "No seleccionado") {
      print('Aplicando filtro en Difficulty: ${widget.selectedDifficulty!}');
      query = query.where('DifficultyEsp', isEqualTo: widget.selectedDifficulty!);
    }
    if (widget.selectedIntensity != null && widget.selectedIntensity!.isNotEmpty && widget.selectedIntensity != "No seleccionado") {
      print('Aplicando filtro en Intensity: ${widget.selectedIntensity!}');
      query = query.where('IntensityEsp', isEqualTo: widget.selectedIntensity!);
    }
    if (widget.selectedMembership != null && widget.selectedMembership!.isNotEmpty && widget.selectedMembership != "No seleccionado") {
      print('Aplicando filtro en Membership: ${widget.selectedMembership!}');
      query = query.where('MembershipEsp', isEqualTo: widget.selectedMembership!);
    }
    if (widget.selectedImpactLevel != null && widget.selectedImpactLevel!.isNotEmpty && widget.selectedImpactLevel != "No seleccionado") {
      print('Aplicando filtro en ImpactLevel: ${widget.selectedImpactLevel!}');
      query = query.where('NivelDeImpactoEsp', isEqualTo: widget.selectedImpactLevel!);
    }
    if (widget.selectedPostura != null && widget.selectedPostura!.isNotEmpty && widget.selectedPostura != "No seleccionado") {
      print('Aplicando filtro en Postura: ${widget.selectedPostura!}');
      query = query.where('StanceEsp', isEqualTo: widget.selectedPostura!);
    }

    // Ejecutar la consulta
    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    setState(() {
      filteredDocs = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (filteredDocs.isEmpty)
              Text('Se encontraron: 0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            else
              Text('Se encontraron: ${filteredDocs.length}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                (filteredDocs.length / 3).ceil(),
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (i) {
                      int docIndex = i + index * 3;
                      if (docIndex < filteredDocs.length) {
                        return _buildIconItem(context, filteredDocs[docIndex], selectedItemsNotifier);
                      } else {
                        return SizedBox(width: 100);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, Map<String, dynamic> calentamientosFisicos, SelectedItemsNotifier notifier) {
    String? imageUrl = calentamientosFisicos['URL de la Imagen'];
    String nombre = calentamientosFisicos['NombreEsp'] ?? 'Nombre no encontrado';
    bool isPremium = calentamientosFisicos['MembershipEng'] == 'Premium';

    bool isSelected = notifier.selectedItems.contains(nombre);

    return GestureDetector(
      onTap: () {
        notifier.toggleSelection(nombre);
      },
      child: SizedBox(
        width: 120,
        height: 160,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          )
                        : Icon(Icons.error, size: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      nombre,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: Colors.blue.withOpacity(0.5),
                  ),
                ),
              if (isPremium)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}