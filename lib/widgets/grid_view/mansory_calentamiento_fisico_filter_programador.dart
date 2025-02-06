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

    /*
{
    dynamic? bodyPartId,// widget.selectedBodyPart -> en la iteracion es BodyPart es array busca por id
    dynamic? calentamientoEspecificoId,// widget.selectedCalentamientoEspecifico -> en la iteracion es CalentamientoEspecifico es array busca por id
    dynamic? equipmentId,// widget.selectedEquipment <----- en la iteracion es  Equipment es array busca por id
    dynamic? objetivosId,// widget.selectedObjetivos <-- en la iteracion es array Objetivos busca por id
    dynamic? difficulty,// widget.selectedDifficulty  <---- hay 2 DifficultyEng y DifficultyEsp esto se busca considerando que hay una bandera isSpanish true para español false para inglés
    dynamic? intensity,// widget.selectedIntensity  <----- IntensityEsp y IntensityEng esto se busca considerando que hay una bandera isSpanish true para español false para inglés
    dynamic? membership,// widget.selectedMembership <----- MembershipEsp y MembershipEng esto se busca considerando que hay una bandera isSpanish true para español false para inglés
    dynamic? impactLevel,// widget.selectedImpactLevel <--- NivelDeImpactoEsp y NivelDeImpactoEng esto se busca considerando que hay una bandera isSpanish true para español false para inglés
    dynamic? postura,// widget.selectedPostura <-- StanceEng y StanceEsp esto se busca considerando que hay una bandera isSpanish true para español false para inglés
    dynamic? sports,// widget.selectedSports <--- en la iteracion es Sports es array busca por id
  }

 */

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Se remueve la modal que es meramente informativa
      //_showParameterDialog();
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

  List<DocumentSnapshot> filtrarCalentamientosDiscriminativo({
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

      bool coincide = true;

      // Función para verificar si una lista de objetos contiene un ID
      bool contieneId(List<dynamic>? lista, dynamic id) {
        return lista?.any((item) => item['id'] == id) ?? false;
      }

      // Filtros por ID en listas
      if (bodyPartId != null) {
        coincide &= contieneId(data['BodyPart'], bodyPartId);
      }
      if (calentamientoEspecificoId != null) {
        coincide &= contieneId(
            data['CalentamientoEspecifico'], calentamientoEspecificoId);
      }
      if (equipmentId != null) {
        coincide &= contieneId(data['Equipment'], equipmentId);
      }
      if (objetivosId != null) {
        coincide &= contieneId(data['Objetivos'], objetivosId);
      }

      // Filtro especial para Sports (lista de IDs)
      if (sportsIds != null && sportsIds.isNotEmpty) {
        var sportsLista = data['Sports'] as List<dynamic>? ?? [];
        coincide &= sportsIds.every((id) => contieneId(sportsLista, id));
      }

      // Filtros por texto según el idioma seleccionado
      if (difficulty != null) {
        coincide &=
            data[isSpanish ? 'DifficultyEsp' : 'DifficultyEng'] == difficulty;
      }
      if (intensity != null) {
        coincide &=
            data[isSpanish ? 'IntensityEsp' : 'IntensityEng'] == intensity;
      }
      if (membership != null) {
        coincide &=
            data[isSpanish ? 'MembershipEsp' : 'MembershipEng'] == membership;
      }
      if (impactLevel != null) {
        coincide &=
            data[isSpanish ? 'NivelDeImpactoEsp' : 'NivelDeImpactoEng'] ==
                impactLevel;
      }
      if (postura != null) {
        coincide &= data[isSpanish ? 'StanceEsp' : 'StanceEng'] == postura;
      }

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
                sportsIds: widget.selectedSports?.map((s) => s.id).toList(),
                isSpanish: isSpanish,
              );

              //for (var resultado in resultados) {
              print("resultados");
              print(resultados.length);
              //}

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: resultados != null && resultados!.length > 0
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
