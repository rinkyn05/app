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
  }

  List<DocumentSnapshot> filtrarCalentamientos({
    required List<DocumentSnapshot> calentamientosFisicos,
    dynamic bodyPartId,
    dynamic calentamientoEspecificoId,
    dynamic equipmentId,
    dynamic objetivosId,
    dynamic difficulty,
    dynamic intensity,
    dynamic membership,
    dynamic impactLevel,
    dynamic postura,
    List<dynamic>? sportsIds,
    required bool isSpanish,
  }) {
    return calentamientosFisicos.where((calentamiento) {
      var data = calentamiento.data() as Map<String, dynamic>;

      // Si no hay filtros aplicados, devolver todos los elementos
      if ([
        bodyPartId,
        calentamientoEspecificoId,
        equipmentId,
        objetivosId,
        difficulty,
        intensity,
        membership,
        impactLevel,
        postura,
        sportsIds
      ].every((filtro) => filtro == null)) {
        return true;
      }

      // Función para verificar si una lista de objetos contiene un ID
      bool contieneId(List<dynamic>? lista, dynamic id) {
        return lista?.any((item) => item['id'] == id) ?? false;
      }

      // Filtros por ID en listas (se combinan con "||")
      bool coincide = (bodyPartId != null &&
              contieneId(data['BodyPart'], bodyPartId)) ||
          (calentamientoEspecificoId != null &&
              contieneId(data['CalentamientoEspecifico'],
                  calentamientoEspecificoId)) ||
          (equipmentId != null && contieneId(data['Equipment'], equipmentId)) ||
          (objetivosId != null && contieneId(data['Objetivos'], objetivosId));

      // Filtro especial para Sports (lista de IDs)
      if (sportsIds != null && sportsIds.isNotEmpty) {
        var sportsLista = data['Sports'] as List<dynamic>? ?? [];
        coincide |= sportsIds.every((id) => contieneId(sportsLista, id));
      }

      // Filtros por texto combinados (no discriminativos)
      coincide |= (difficulty != null &&
          data[isSpanish ? 'DifficultyEsp' : 'DifficultyEng'] == difficulty);
      coincide |= (intensity != null &&
          data[isSpanish ? 'IntensityEsp' : 'IntensityEng'] == intensity);
      coincide |= (membership != null &&
          data[isSpanish ? 'MembershipEsp' : 'MembershipEng'] == membership);
      coincide |= (impactLevel != null &&
          data[isSpanish ? 'NivelDeImpactoEsp' : 'NivelDeImpactoEng'] ==
              impactLevel);
      coincide |= (postura != null &&
          data[isSpanish ? 'StanceEsp' : 'StanceEng'] == postura);

      return coincide;
    }).toList();
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
              var calentamientosFisicos = snapshot.data!.docs;

              final String languageCode =
                  Localizations.localeOf(context).languageCode;
              final bool isSpanish = languageCode == 'es';

              List<DocumentSnapshot> resultados = filtrarCalentamientos(
                calentamientosFisicos:
                    calentamientosFisicos, // Lista original de Firebase
                bodyPartId: widget.selectedBodyPart?.id,
                calentamientoEspecificoId:
                    widget.selectedCalentamientoEspecifico?.id,
                equipmentId: widget.selectedEquipment?.id,
                objetivosId: widget.selectedObjetivos?.id,
                difficulty: widget.selectedDifficulty,
                intensity: widget.selectedIntensity,
                membership: widget.selectedMembership,
                impactLevel: widget.selectedImpactLevel,
                postura: widget.selectedPostura,
                sportsIds: widget.selectedSports.map((s) => s.id).toList(),
                isSpanish: isSpanish,
              );

              //for (var resultado in resultados) {
              print("resultados");
              print(resultados.length);
              //}

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Se Encontraron: ${resultados.length}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: resultados.length > 0
                        ? List.generate(
                            (resultados.length / 3).ceil(),
                            (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                3,
                                (i) => i + index * 3 < resultados.length
                                    ? _buildIconItem(
                                        context,
                                        resultados[i + index * 3],
                                        selectedItemsNotifier,
                                      )
                                    : SizedBox(width: 100),
                              ),
                            ),
                          )
                        : [
                            Container(
                              child: Center(
                                child: Text(isSpanish
                                    ? "Sin resultados"
                                    : "Not records"),
                              ),
                            )
                          ],
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
