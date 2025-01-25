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
  @override
  void initState() {
    super.initState();

    // Impresión detallada de las selecciones recibidas
    print('Se recibieron los siguientes parámetros:');

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showParameterDialog();
    });
  }

  void _showParameterDialog() {
    // Detectar el idioma de la aplicación
    final String languageCode = Localizations.localeOf(context).languageCode;
    final bool isSpanish = languageCode == 'es';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isSpanish ? 'Parámetros recibidos' : 'Parameters received'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedBodyPart != null
                      ? isSpanish
                          ? 'BodyPart - ID: ${widget.selectedBodyPart!.id}, Nombre: ${widget.selectedBodyPart!.bodypartEsp}'
                          : 'BodyPart - ID: ${widget.selectedBodyPart!.id}, Name: ${widget.selectedBodyPart!.bodypartEng}'
                      : isSpanish
                          ? 'BodyPart: No seleccionado'
                          : 'BodyPart: Not selected',
                ),
                Text(
                  widget.selectedCalentamientoEspecifico != null
                      ? isSpanish
                          ? 'CalentamientoEspecifico - ID: ${widget.selectedCalentamientoEspecifico!.id}, Nombre: ${widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEsp}'
                          : 'SpecificWarmup - ID: ${widget.selectedCalentamientoEspecifico!.id}, Name: ${widget.selectedCalentamientoEspecifico!.CalentamientoEspecificoEng}'
                      : isSpanish
                          ? 'CalentamientoEspecifico: No seleccionado'
                          : 'SpecificWarmup: Not selected',
                ),
                Text(
                  widget.selectedEquipment != null
                      ? isSpanish
                          ? 'Equipment - ID: ${widget.selectedEquipment!.id}, Nombre: ${widget.selectedEquipment!.equipmentEsp}'
                          : 'Equipment - ID: ${widget.selectedEquipment!.id}, Name: ${widget.selectedEquipment!.equipmentEng}'
                      : isSpanish
                          ? 'Equipment: No seleccionado'
                          : 'Equipment: Not selected',
                ),
                Text(
                  widget.selectedObjetivos != null
                      ? isSpanish
                          ? 'Objetivos - ID: ${widget.selectedObjetivos!.id}, Nombre: ${widget.selectedObjetivos!.objetivosEsp}'
                          : 'Objectives - ID: ${widget.selectedObjetivos!.id}, Name: ${widget.selectedObjetivos!.objetivosEng}'
                      : isSpanish
                          ? 'Objetivos: No seleccionado'
                          : 'Objectives: Not selected',
                ),
                Text(isSpanish
                    ? 'Dificultad: ${widget.selectedDifficulty ?? "No seleccionado"}'
                    : 'Difficulty: ${widget.selectedDifficulty ?? "Not selected"}'),
                Text(isSpanish
                    ? 'Intensidad: ${widget.selectedIntensity ?? "No seleccionado"}'
                    : 'Intensity: ${widget.selectedIntensity ?? "Not selected"}'),
                Text(isSpanish
                    ? 'Membresía: ${widget.selectedMembership ?? "No seleccionado"}'
                    : 'Membership: ${widget.selectedMembership ?? "Not selected"}'),
                Text(isSpanish
                    ? 'Nivel de impacto: ${widget.selectedImpactLevel ?? "No seleccionado"}'
                    : 'Impact level: ${widget.selectedImpactLevel ?? "Not selected"}'),
                Text(isSpanish
                    ? 'Postura: ${widget.selectedPostura ?? "No seleccionado"}'
                    : 'Posture: ${widget.selectedPostura ?? "Not selected"}'),
                Text(
                    isSpanish ? 'Deportes seleccionados:' : 'Selected sports:'),
                if (widget.selectedSports.isNotEmpty)
                  ...widget.selectedSports.map((sport) {
                    return Text(
                      isSpanish
                          ? '  - ID: ${sport.id}, Nombre: ${sport.sportsEsp}'
                          : '  - ID: ${sport.id}, Name: ${sport.sportsEng}',
                    );
                  }).toList()
                else
                  Text(isSpanish
                      ? 'Deportes: No seleccionado'
                      : 'Sports: Not selected'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(isSpanish ? 'Cerrar' : 'Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('calentamientoFisico')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final calentamientosFisicos = snapshot.data!.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(
                      (calentamientosFisicos.length / 3).ceil(),
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (i) => i + index * 3 < calentamientosFisicos.length
                              ? _buildIconItem(
                                  context,
                                  calentamientosFisicos[i + index * 3],
                                  selectedItemsNotifier,
                                )
                              : SizedBox(width: 100),
                        ),
                      ),
                    ),
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
