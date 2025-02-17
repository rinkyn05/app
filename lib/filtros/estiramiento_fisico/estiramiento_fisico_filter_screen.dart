import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../screens/estiramiento_fisico/results_estiramiento_fisico_screen.dart';
import '../widgets/BodyPartDropdownWidget.dart';
import '../widgets/EstiramientoEspecificoDropdownWidget.dart';
import '../widgets/EquipmentDropdownWidget.dart';
import '../widgets/ObjetivosDropdownWidget.dart';
import '../widgets/DificultyDropdownWidget.dart';
import '../widgets/IntensityDropdownWidget.dart'; // Importa el widget de intensidad
import '../widgets/MembershipDropdownWidget.dart'; // Importa el widget de membresía
import '../widgets/NivelDeImpactoDropdownWidget.dart'; // Importa el nuevo widget de nivel de impacto
import '../widgets/PosturaDropdownWidget.dart'; // Importa el nuevo widget de postura

class EstiramientoFisicoFilterScreen extends StatelessWidget {
  const EstiramientoFisicoFilterScreen({
    Key? key,
    required this.onFilterApplied,
    required this.onBodyPartSelectionChanged,
    required this.onEstiramientoSelectionChanged,
    required this.onEquipmentSelectionChanged,
    required this.onObjetivosSelectionChanged,
    required this.onDifficultySelectionChanged,
    required this.onIntensitySelectionChanged,
    required this.onMembershipSelectionChanged, // Callback para la membresía
    required this.onImpactLevelSelectionChanged, // Callback para el nivel de impacto
    required this.onPosturaSelectionChanged, // Callback para la postura
  }) : super(key: key);

  final Function(
    SelectedBodyPart?,
    SelectedEstiramientoEspecifico?,
    SelectedEquipment?,
    SelectedObjetivos?,
    String?, // Dificultad
    String?, // Intensidad
    String?, // Membresía
    String?, // Nivel de impacto
    String?, // Postura
  ) onFilterApplied;

  final Function(SelectedBodyPart) onBodyPartSelectionChanged;
  final Function(SelectedEstiramientoEspecifico)
      onEstiramientoSelectionChanged;
  final Function(SelectedEquipment) onEquipmentSelectionChanged;
  final Function(SelectedObjetivos) onObjetivosSelectionChanged;
  final Function(String) onDifficultySelectionChanged;
  final Function(String) onIntensitySelectionChanged;
  final Function(String?)
      onMembershipSelectionChanged; // Callback para membresía
  final Function(String?)
      onImpactLevelSelectionChanged; // Callback para nivel de impacto
  final Function(String?) onPosturaSelectionChanged; // Callback para postura

  @override
  Widget build(BuildContext context) {
    SelectedBodyPart? selectedBodyPart;
    SelectedEstiramientoEspecifico? selectedEstiramientoEspecifico;
    SelectedEquipment? selectedEquipment;
    SelectedObjetivos? selectedObjetivos;
    String? selectedDifficulty; // Variable para dificultad
    String? selectedIntensity; // Variable para intensidad
    String? selectedMembership; // Variable para membresía
    String? selectedImpactLevel; // Variable para nivel de impacto
    String? selectedPostura; // Variable para postura

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('filterTitle')),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // Dropdown de BodyPart
              BodyPartDropdownWidget(
                langKey: 'Esp',
                onChanged: (List<SelectedBodyPart> value) {
                  selectedBodyPart = value.isNotEmpty ? value.last : null;
                },
                onSelectionChanged: (SelectedBodyPart bodyPart) {
                  onBodyPartSelectionChanged(bodyPart);
                },
              ),
              const SizedBox(height: 20),

              // Dropdown de EstiramientoEspecifico
              EstiramientoEspecificoDropdownWidget(
                langKey: 'Esp',
                onChanged: (List<SelectedEstiramientoEspecifico> value) {
                  selectedEstiramientoEspecifico =
                      value.isNotEmpty ? value.last : null;
                },
                onSelectionChanged:
                    (SelectedEstiramientoEspecifico estiramiento) {
                  onEstiramientoSelectionChanged(estiramiento);
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
                  selectedObjetivos = value.isNotEmpty ? value.last : null;
                },
                onSelectionChanged: (SelectedObjetivos objetivo) {
                  onObjetivosSelectionChanged(objetivo);
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

              // Botones de acción
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          AppLocalizations.of(context)!.translate('cancel')),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Verifica y procesa las selecciones antes de aplicar el filtro
                        print(
                            'Filtrando con las siguientes opciones seleccionadas:');

                        if (selectedBodyPart != null) {
                          print(
                              'BodyPart - ID: ${selectedBodyPart!.id}, Nombre (Español): ${selectedBodyPart!.bodypartEsp}, Nombre (Inglés): ${selectedBodyPart!.bodypartEng}');
                        }
                        if (selectedEstiramientoEspecifico != null) {
                          print(
                              'EstiramientoEspecifico - ID: ${selectedEstiramientoEspecifico!.id}, Nombre (Español): ${selectedEstiramientoEspecifico!.EstiramientoEspecificoEsp}, Nombre (Inglés): ${selectedEstiramientoEspecifico!.EstiramientoEspecificoEng}');
                        }
                        if (selectedEquipment != null) {
                          print(
                              'Equipment - ID: ${selectedEquipment!.id}, Nombre (Español): ${selectedEquipment!.equipmentEsp}, Nombre (Inglés): ${selectedEquipment!.equipmentEng}');
                        }
                        if (selectedObjetivos != null) {
                          print(
                              'Objetivos - ID: ${selectedObjetivos!.id}, Nombre (Español): ${selectedObjetivos!.objetivosEsp}, Nombre (Inglés): ${selectedObjetivos!.objetivosEng}');
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
                          print('ImpactLevel Selected: $selectedImpactLevel');
                        }
                        if (selectedPostura != null) {
                          print('Postura Selected: $selectedPostura');
                        }

                        // Llamada al callback para aplicar el filtro
                        onFilterApplied(
                          selectedBodyPart,
                          selectedEstiramientoEspecifico,
                          selectedEquipment,
                          selectedObjetivos,
                          selectedDifficulty,
                          selectedIntensity,
                          selectedMembership,
                          selectedImpactLevel,
                          selectedPostura,
                        );

                        // Redirige a MasonryEstiramientoFisicoFilter pasando las selecciones
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ResultsEstiramientoFisicoScreen(
                              selectedBodyPart: selectedBodyPart,
                              selectedEstiramientoEspecifico:
                                  selectedEstiramientoEspecifico,
                              selectedEquipment: selectedEquipment,
                              selectedObjetivos: selectedObjetivos,
                              selectedDifficulty: selectedDifficulty,
                              selectedIntensity: selectedIntensity,
                              selectedMembership: selectedMembership,
                              selectedImpactLevel: selectedImpactLevel,
                              selectedPostura: selectedPostura,
                            ),
                          ),
                        );
                      },
                      child: Text(
                          AppLocalizations.of(context)!.translate('apply')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
