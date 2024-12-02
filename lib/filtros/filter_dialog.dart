// lib/widgets/filter_dialog.dart

import 'package:flutter/material.dart';
import '../config/lang/app_localization.dart';
import 'widgets/BodyPartDropdownWidget.dart';
import 'widgets/CalentamientoEspecificoDropdownWidget.dart';
import 'widgets/DificultyDropdownWidget.dart';
import 'widgets/EquipmentDropdownWidget.dart';
import 'widgets/IntensityDropdownWidget.dart';
import 'widgets/MembershipDropdownWidget.dart';
import 'widgets/NivelDeImpactoDropdownWidget.dart';
import 'widgets/ObjetivosDropdownWidget.dart';
import 'widgets/PosturaDropdownWidget.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({
    Key? key,
    required this.onFilterApplied,
  }) : super(key: key);

  final Function(
    String? selectedBodyPart,
    String? selectedCalentamiento,
    String? selectedEquipment,
    String? selectedImpactLevel,
    String? selectedPosture,
    String? selectedDificulty,
    String? selectedObjective,
    String? selectedIntensity,
    String? selectedMembership,
  ) onFilterApplied;

  @override
  Widget build(BuildContext context) {
    String? selectedBodyPart;
    String? selectedCalentamiento;
    String? selectedEquipment;
    String? selectedImpactLevel;
    String? selectedPosture;
    String? selectedDificulty;
    String? selectedObjective;
    String? selectedIntensity;
    String? selectedMembership;

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
                          selectedBodyPart = value.isNotEmpty
                              ? value.last.bodypartEsp
                              : null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Otros Dropdowns
                      CalentamientoEspecificoDropdownWidget(
                        langKey: 'Esp',
                        onChanged:
                            (List<SelectedCalentamientoEspecifico> value) {
                          selectedCalentamiento = value.isNotEmpty
                              ? value.last.CalentamientoEspecificoEsp
                              : null;
                        },
                      ),

                      const SizedBox(height: 20),

                      EquipmentDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedEquipment = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      NivelDeImpactoDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (List<String> value) {
                          selectedImpactLevel = value.isNotEmpty
                              ? value.last
                              : null;
                        },
                      ),

                      const SizedBox(height: 20),

                      PosturaDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedPosture = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      DificultyDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedDificulty = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      ObjetivosDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedObjective = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      IntensityDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedIntensity = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      MembershipDropdownWidget(
                        langKey: 'Esp',
                        onChanged: (value) {
                          selectedMembership = value;
                        },
                      ),
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
                    child: Text(
                        AppLocalizations.of(context)!.translate('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onFilterApplied(
                        selectedBodyPart,
                        selectedCalentamiento,
                        selectedEquipment,
                        selectedImpactLevel,
                        selectedPosture,
                        selectedDificulty,
                        selectedObjective,
                        selectedIntensity,
                        selectedMembership,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                        AppLocalizations.of(context)!.translate('filter')),
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
