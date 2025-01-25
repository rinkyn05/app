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

    Future<void> _performSearch(
        String fieldEsp, String fieldEng, dynamic value) async {
      if (value == null || (value is String && value.isEmpty)) {
        return;
      }

      try {
        print('Buscando en $fieldEsp y $fieldEng con valor: $value');

        final querySnapshotEsp =
            await calentamientosRef.where(fieldEsp, isEqualTo: value).get();

        final querySnapshotEng =
            await calentamientosRef.where(fieldEng, isEqualTo: value).get();

        final allResults = [...querySnapshotEsp.docs, ...querySnapshotEng.docs];

        print(
            'Resultados obtenidos en $fieldEsp/$fieldEng: ${allResults.map((doc) => doc.id).toList()}');

        if (allResults.isNotEmpty) {
          if (filteredResults.isNotEmpty) {
            filteredResults = filteredResults
                .where((doc) => allResults.any((newDoc) => newDoc.id == doc.id))
                .toList();
          } else {
            filteredResults = allResults;
          }
        }
      } catch (e) {
        print('Error al buscar datos para $fieldEsp/$fieldEng: $e');
      }
    }

    // Impresión detallada de las selecciones recibidas
    print('En Results Filter se recibió:');

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

    await _performSearch(
        'BodyPart.id', 'BodyPart.eng', widget.selectedBodyPart?.id);
    await _performSearch(
        'CalentamientoEspecifico.id',
        'CalentamientoEspecifico.eng',
        widget.selectedCalentamientoEspecifico?.id);
    await _performSearch(
        'Equipment.id', 'Equipment.eng', widget.selectedEquipment?.id);
    await _performSearch(
        'Objetivos.id', 'Objetivos.eng', widget.selectedObjetivos?.id);
    await _performSearch('difficultyEsp', 'difficultyEng',
        widget.selectedDifficulty?.toLowerCase());
    await _performSearch('intensityEsp', 'intensityEng',
        widget.selectedIntensity?.toLowerCase());
    await _performSearch(
        'MembershipEsp', 'MembershipEng', widget.selectedMembership?.trim());
    await _performSearch('nivelDeImpactoEsp', 'nivelDeImpactoEng',
        widget.selectedImpactLevel?.toLowerCase());
    await _performSearch(
        'stanceEsp', 'stanceEng', widget.selectedPostura?.toLowerCase());

    if (widget.selectedSports.isNotEmpty) {
      final sportsIds = widget.selectedSports.map((sport) => sport.id).toList();
      try {
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
      } catch (e) {
        print('Error fetching sports data: $e');
      }
    }

    // Mostrar los resultados obtenidos
    print('Filtered Results:');
    for (var doc in filteredResults) {
      print('ID: ${doc.id}, Data: ${doc.data()}');
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
