import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class PhaseDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(String) onChanged; // Notifica cambios en la selección
  final Function(String?)
      onSelectionChanged; // Notifica selección actual o eliminación

  const PhaseDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    required this.onSelectionChanged, // Cambié esto a 'required'
  }) : super(key: key);

  @override
  _PhaseDropdownWidgetState createState() => _PhaseDropdownWidgetState();
}

class _PhaseDropdownWidgetState extends State<PhaseDropdownWidget> {
  String? _phaseEsp; // Valor seleccionado en español
  String? _phaseEng; // Valor seleccionado en inglés

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exercisePhase'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildPhaseSelector(),
        if (_phaseEsp != null || _phaseEng != null) _buildSelectedPhase(),
      ],
    );
  }

  Widget _buildPhaseSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Adaptación Anatómica',
      'Hipertrofia',
      'Entrenamiento de Fuerza',
      'Entrenamiento Mixto',
      'Definición',
      'Transición'
    ];
    List<String> optionsEng = [
      'Anatomical Adaptation',
      'Hypertrophy',
      'Strength Training',
      'Mixed Training',
      'Definition',
      'Transition'
    ];

    Map<String, String> phaseMapEspToEng = {
      'Adaptación Anatómica': 'Anatomical Adaptation',
      'Hipertrofia': 'Hypertrophy',
      'Entrenamiento de Fuerza': 'Strength Training',
      'Entrenamiento Mixto': 'Mixed Training',
      'Definición': 'Definition',
      'Transición': 'Transition',
    };

    Map<String, String> phaseMapEngToEsp = {
      'Anatomical Adaptation': 'Adaptación Anatómica',
      'Hypertrophy': 'Hipertrofia',
      'Strength Training': 'Entrenamiento de Fuerza',
      'Mixed Training': 'Entrenamiento Mixto',
      'Definition': 'Definición',
      'Transition': 'Transición',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _phaseEsp : _phaseEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
              AppLocalizations.of(context)!.translate('selectExercisePhase')),
          onChanged: (String? newValue) {
            setState(() {
              if (isEsp) {
                _phaseEsp = newValue!;
                _phaseEng = phaseMapEspToEng[newValue]!;
              } else {
                _phaseEng = newValue!;
                _phaseEsp = phaseMapEngToEsp[newValue]!;
              }

              // Notifica el cambio general
              widget.onChanged(isEsp ? _phaseEsp! : _phaseEng!);
              widget.onSelectionChanged(newValue);
            });
          },
          value: selectedValue,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectedPhase() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String phaseName = isEsp ? _phaseEsp! : _phaseEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Chip(
        label: Text(phaseName),
        onDeleted: () {
          setState(() {
            _phaseEsp = null;
            _phaseEng = null;
            widget.onSelectionChanged(null); // Pasamos null cuando se elimina
          });
        },
      ),
    );
  }
}
