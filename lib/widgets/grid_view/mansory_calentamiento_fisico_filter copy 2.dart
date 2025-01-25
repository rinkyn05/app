import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../config/notifiers/selected_notifier.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/CalentamientoEspecificoDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
import '../../filtros/widgets/SportsDropdownWidget.dart.dart';

class MasonryCalentamientoFisicoFilter extends StatefulWidget {
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

  const MasonryCalentamientoFisicoFilter({
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
  _MasonryCalentamientoFisicoFilterState createState() =>
      _MasonryCalentamientoFisicoFilterState();
}

class _MasonryCalentamientoFisicoFilterState
    extends State<MasonryCalentamientoFisicoFilter> {
  late Future<List<QueryDocumentSnapshot>> _filteredResults;

  @override
  void initState() {
    super.initState();
    _filteredResults = _fetchFilteredResults();
  }

  Future<List<QueryDocumentSnapshot>> _fetchFilteredResults() async {
  final query = FirebaseFirestore.instance.collection('calentamientoFisico');

  // Crear una lista de condiciones de filtro
  Query filteredQuery = query;

  if (widget.selectedBodyPart != null) {
    filteredQuery = filteredQuery.where('BodyPart.id',
        arrayContains: widget.selectedBodyPart!.id);
  }
  if (widget.selectedCalentamientoEspecifico != null) {
    filteredQuery = filteredQuery.where('CalentamientoEspecifico',
        isEqualTo: widget.selectedCalentamientoEspecifico!.id);
  }
  if (widget.selectedEquipment != null) {
    filteredQuery = filteredQuery.where('Equipment.id',
        arrayContains: widget.selectedEquipment!.id);
  }
  if (widget.selectedObjetivos != null) {
    filteredQuery = filteredQuery.where('Objetivos.id',
        arrayContains: widget.selectedObjetivos!.id);
  }
  if (widget.selectedDifficulty != null) {
    filteredQuery = filteredQuery.where('DifficultyEng',
        isEqualTo: widget.selectedDifficulty!);
  }
  if (widget.selectedIntensity != null) {
    filteredQuery = filteredQuery.where('IntensityEng',
        isEqualTo: widget.selectedIntensity!);
  }
  if (widget.selectedMembership != null) {
    filteredQuery = filteredQuery.where('MembershipEng',
        isEqualTo: widget.selectedMembership!);
  }
  if (widget.selectedImpactLevel != null) {
    filteredQuery = filteredQuery.where('NivelDeImpactoEng',
        isEqualTo: widget.selectedImpactLevel!);
  }
  if (widget.selectedPostura != null) {
    filteredQuery = filteredQuery.where('Postura',
        isEqualTo: widget.selectedPostura!);
  }
  if (widget.selectedSports.isNotEmpty) {
    filteredQuery = filteredQuery.where('Sports.id',
        arrayContainsAny:
            widget.selectedSports.map((e) => e.id).toList());
  }

  try {
    final snapshot = await filteredQuery.get();
    return snapshot.docs;
  } catch (e) {
    print('Error al realizar la consulta: $e');
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: _filteredResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No se encontraron resultados.'));
        }

        final results = snapshot.data!;
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Se encontraron: ${results.length} resultados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: List.generate(
                    (results.length / 3).ceil(),
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                        (i) => i + index * 3 < results.length
                            ? _buildIconItem(
                                context,
                                results[i + index * 3],
                                selectedItemsNotifier,
                              )
                            : SizedBox(width: 100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconItem(BuildContext context,
      DocumentSnapshot calentamientoFisico, SelectedItemsNotifier notifier) {
    String? imageUrl = calentamientoFisico['URL de la Imagen'];
    String nombre = calentamientoFisico['NombreEsp'] ?? 'Nombre no encontrado';
    bool isPremium = calentamientoFisico['MembershipEng'] == 'Premium';

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
