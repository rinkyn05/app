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
  Future<List<DocumentSnapshot>> _fetchFilteredResults() async {
    final calentamientosRef =
        FirebaseFirestore.instance.collection('calentamientoFisico');

    List<DocumentSnapshot> filteredResults = [];

    // Función para realizar la búsqueda y acumular resultados
    Future<void> _performSearch(String field, dynamic value) async {
      if (value == null || (value is String && value.isEmpty)) {
        return; // Si el campo está vacío o es nulo, no buscar
      }

      final querySnapshot = await calentamientosRef.where(field, isEqualTo: value).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si ya hay resultados acumulados, intersectarlos con los nuevos
        if (filteredResults.isNotEmpty) {
          final newResults = querySnapshot.docs;
          filteredResults = filteredResults
              .where((doc) => newResults.any((newDoc) => newDoc.id == doc.id))
              .toList();
        } else {
          // Si no hay resultados acumulados, simplemente añadir los nuevos
          filteredResults = querySnapshot.docs;
        }
      }
    }

    // Realizar búsquedas secuenciales
    await _performSearch('BodyPart.id', widget.selectedBodyPart?.id);
    await _performSearch('CalentamientoEspecifico.id', widget.selectedCalentamientoEspecifico?.id);
    await _performSearch('Equipment.id', widget.selectedEquipment?.id);
    await _performSearch('Objetivos.id', widget.selectedObjetivos?.id);
    await _performSearch('difficultyEsp', widget.selectedDifficulty?.toLowerCase());
    await _performSearch('intensityEsp', widget.selectedIntensity?.toLowerCase());
    await _performSearch('MembershipEsp', widget.selectedMembership?.trim());
    await _performSearch('nivelDeImpactoEsp', widget.selectedImpactLevel?.toLowerCase());
    await _performSearch('stanceEsp', widget.selectedPostura?.toLowerCase());

    if (widget.selectedSports.isNotEmpty) {
      final sportsIds = widget.selectedSports.map((sport) => sport.id).toList();
      final querySnapshot = await calentamientosRef
          .where('Sports.id', arrayContainsAny: sportsIds)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        if (filteredResults.isNotEmpty) {
          final newResults = querySnapshot.docs;
          filteredResults = filteredResults
              .where((doc) => newResults.any((newDoc) => newDoc.id == doc.id))
              .toList();
        } else {
          filteredResults = querySnapshot.docs;
        }
      }
    }

    return filteredResults;
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _fetchFilteredResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No se encontraron resultados.'));
            } else {
              final calentamientosFisicos = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Se encontraron ${calentamientosFisicos.length} resultados:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: calentamientosFisicos.map((doc) {
                      return _buildIconItem(
                          context, doc, selectedItemsNotifier);
                    }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
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
