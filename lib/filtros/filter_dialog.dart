import 'package:flutter/material.dart';
import '../config/lang/app_localization.dart';
import 'widgets/BodyPartDropdownWidget.dart';
import 'widgets/CalentamientoEspecificoDropdownWidget.dart';
import 'widgets/EquipmentDropdownWidget.dart';
import 'widgets/ObjetivosDropdownWidget.dart';
import 'widgets/DificultyDropdownWidget.dart';
import 'widgets/IntensityDropdownWidget.dart'; // Importa el widget de intensidad
import 'widgets/MembershipDropdownWidget.dart'; // Importa el widget de membresía
import 'widgets/NivelDeImpactoDropdownWidget.dart'; // Importa el nuevo widget de nivel de impacto
import 'widgets/PosturaDropdownWidget.dart'; // Importa el nuevo widget de postura
import 'widgets/SportsDropdownWidget.dart.dart'; // Importa el nuevo widget de deportes

class FilterDialog extends StatelessWidget {
  const FilterDialog({
    Key? key,
    required this.onFilterApplied,
    required this.onBodyPartSelectionChanged,
    required this.onCalentamientoSelectionChanged,
    required this.onEquipmentSelectionChanged,
    required this.onObjetivosSelectionChanged,
    required this.onDifficultySelectionChanged,
    required this.onIntensitySelectionChanged,
    required this.onMembershipSelectionChanged, // Callback para la membresía
    required this.onImpactLevelSelectionChanged, // Callback para el nivel de impacto
    required this.onPosturaSelectionChanged, // Callback para la postura
    required this.onSportsSelectionChanged, // Callback para deportes
  }) : super(key: key);

  final Function(
    SelectedBodyPart?,
    SelectedCalentamientoEspecifico?,
    SelectedEquipment?,
    SelectedObjetivos?,
    String?, // Dificultad
    String?, // Intensidad
    String?, // Membresía
    String?, // Nivel de impacto
    String?, // Postura
    List<SelectedSports>, // Deportes
  ) onFilterApplied;

  final Function(SelectedBodyPart) onBodyPartSelectionChanged;
  final Function(SelectedCalentamientoEspecifico)
      onCalentamientoSelectionChanged;
  final Function(SelectedEquipment) onEquipmentSelectionChanged;
  final Function(SelectedObjetivos) onObjetivosSelectionChanged;
  final Function(String) onDifficultySelectionChanged;
  final Function(String) onIntensitySelectionChanged;
  final Function(String?)
      onMembershipSelectionChanged; // Callback para membresía
  final Function(String?)
      onImpactLevelSelectionChanged; // Callback para nivel de impacto
  final Function(String?) onPosturaSelectionChanged; // Callback para postura
  final Function(List<SelectedSports>)
      onSportsSelectionChanged; // Callback para deportes

  @override
  Widget build(BuildContext context) {
    SelectedBodyPart? selectedBodyPart;
    SelectedCalentamientoEspecifico? selectedCalentamientoEspecifico;
    SelectedEquipment? selectedEquipment;
    SelectedObjetivos? selectedObjetivos;
    String? selectedDifficulty; // Variable para dificultad
    String? selectedIntensity; // Variable para intensidad
    String? selectedMembership; // Variable para membresía
    String? selectedImpactLevel; // Variable para nivel de impacto
    String? selectedPostura; // Variable para postura
    List<SelectedSports> selectedSports = []; // Lista de deportes seleccionados

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('filterTitle'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de BodyPart
                      BodyPartDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (List<SelectedBodyPart> value) {
                          selectedBodyPart =
                              value.isNotEmpty ? value.last : null;
                        },
                        onSelectionChanged: (SelectedBodyPart bodyPart) {
                          onBodyPartSelectionChanged(bodyPart);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de CalentamientoEspecifico
                      CalentamientoEspecificoDropdownWidget(
                        langKey: 'Esp',
                        onChanged:
                            (List<SelectedCalentamientoEspecifico> value) {
                          selectedCalentamientoEspecifico =
                              value.isNotEmpty ? value.last : null;
                        },
                        onSelectionChanged:
                            (SelectedCalentamientoEspecifico calentamiento) {
                          onCalentamientoSelectionChanged(calentamiento);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Equipment
                      EquipmentDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (String id) {
                          // Callback simple para ID, si es necesario
                        },
                        onSelectionChanged: (SelectedEquipment equipment) {
                          selectedEquipment = equipment;
                          onEquipmentSelectionChanged(equipment);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de NivelDeImpacto
                      NivelDeImpactoDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (String value) {
                          selectedImpactLevel = value;
                        },
                        onSelectionChanged: (String? impactLevel) {
                          onImpactLevelSelectionChanged(impactLevel);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Postura
                      PosturaDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (String value) {
                          selectedPostura = value;
                        },
                        onSelectionChanged: (String? postura) {
                          onPosturaSelectionChanged(postura);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Dificultad
                      DificultyDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (String value) {
                          selectedDifficulty = value;
                        },
                        onSelectionChanged: (String difficulty) {
                          onDifficultySelectionChanged(difficulty);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Objetivos
                      ObjetivosDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (List<SelectedObjetivos> value) {
                          selectedObjetivos =
                              value.isNotEmpty ? value.last : null;
                        },
                        onSelectionChanged: (SelectedObjetivos objetivo) {
                          onObjetivosSelectionChanged(objetivo);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Deportes
                      SportsDropdownWidget(
                        langKey: 'Esp',
                        onSelectionChanged: (SelectedSports selectedSport) {
                          onSportsSelectionChanged([
                            selectedSport
                          ]); // Enviando el valor como una lista
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Intensidad
                      IntensityDropdownWidget(
                        onChanged: (String value) {
                          selectedIntensity = value;
                        },
                        onSelectionChanged: (String intensity) {
                          onIntensitySelectionChanged(intensity);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Dropdown de Membresía
                      MembershipDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (String value) {
                          selectedMembership = value;
                        },
                        onSelectionChanged: (String? membership) {
                          onMembershipSelectionChanged(membership);
                        },
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text(AppLocalizations.of(context)!.translate('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Verifica y procesa las selecciones antes de aplicar el filtro
                      print(
                          'Filtrando con las siguientes opciones seleccionadas:');
                      if (selectedBodyPart != null) {
                        print(
                            'BodyPart - ID: ${selectedBodyPart!.id}, Nombre: ${selectedBodyPart!.bodypartEsp}');
                      }
                      if (selectedCalentamientoEspecifico != null) {
                        print(
                            'CalentamientoEspecifico - ID: ${selectedCalentamientoEspecifico!.id}');
                      }
                      if (selectedEquipment != null) {
                        print('Equipment - ID: ${selectedEquipment!.id}');
                      }
                      if (selectedObjetivos != null) {
                        print('Objetivos - ID: ${selectedObjetivos!.id}');
                      }
                      if (selectedDifficulty != null) {
                        print('Difficulty Selected: $selectedDifficulty');
                      }
                      if (selectedIntensity != null) {
                        print('Intensity Selected: $selectedIntensity');
                      }
                      if (selectedMembership != null) {
                        print('Membership Selected: $selectedMembership');
                      }
                      if (selectedImpactLevel != null) {
                        print('Impact Level Selected: $selectedImpactLevel');
                      }
                      if (selectedPostura != null) {
                        print('Postura Selected: $selectedPostura');
                      }
                      if (selectedSports.isNotEmpty) {
                        print('Sports Selected:');
                        selectedSports.forEach((sport) {
                          print('Sport ID: ${sport.id}');
                        });
                      }

                      // Llamar al callback principal con las selecciones
                      onFilterApplied(
                        selectedBodyPart,
                        selectedCalentamientoEspecifico,
                        selectedEquipment,
                        selectedObjetivos,
                        selectedDifficulty, // Pasar dificultad seleccionada
                        selectedIntensity, // Pasar intensidad seleccionada
                        selectedMembership, // Pasar membresía seleccionada
                        selectedImpactLevel, // Pasar nivel de impacto seleccionado
                        selectedPostura, // Pasar postura seleccionada
                        selectedSports, // Pasar deportes seleccionados
                      );

                      // Cierra el diálogo
                      Navigator.of(context).pop();
                    },
                    child:
                        Text(AppLocalizations.of(context)!.translate('filter')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
