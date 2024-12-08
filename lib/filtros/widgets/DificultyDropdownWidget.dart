import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class DificultyDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(String)
      onChanged; // Notifica cada cambio en la lista de selecciones
  final Function(String)?
      onSelectionChanged; // Notifica cuando cambia un único elemento seleccionado

  const DificultyDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    this.onSelectionChanged, // Es opcional
  }) : super(key: key);

  @override
  _DificultyDropdownWidgetState createState() =>
      _DificultyDropdownWidgetState();
}

class _DificultyDropdownWidgetState extends State<DificultyDropdownWidget> {
  String? _difficultyEsp;
  String? _difficultyEng;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('difficulty'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildDifficultySelector(),
        if (_difficultyEsp != null || _difficultyEng != null)
          _buildSelectedDifficulty(), // Solo muestra la tarjeta cuando se selecciona algo
      ],
    );
  }

  Widget _buildDifficultySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Fácil', 'Medio', 'Avanzado', 'Difícil'];
    List<String> optionsEng = ['Easy', 'Medium', 'Advanced', 'Difficult'];

    Map<String, String> difficultyMapEspToEng = {
      'Fácil': 'Easy',
      'Medio': 'Medium',
      'Avanzado': 'Advanced',
      'Difícil': 'Difficult',
    };

    Map<String, String> difficultyMapEngToEsp = {
      'Easy': 'Fácil',
      'Medium': 'Medio',
      'Advanced': 'Avanzado',
      'Difficult': 'Difícil',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? currentDifficulty = isEsp ? _difficultyEsp : _difficultyEng;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                  AppLocalizations.of(context)!.translate('selectDifficulty')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _difficultyEsp = newValue!;
                    _difficultyEng = difficultyMapEspToEng[newValue]!;
                  } else {
                    _difficultyEng = newValue!;
                    _difficultyEsp = difficultyMapEngToEsp[newValue]!;
                  }
                });

                // Notifica el cambio completo
                String difficulty = isEsp ? _difficultyEsp! : _difficultyEng!;
                widget.onChanged(difficulty);

                // Notifica el cambio de una selección específica
                if (widget.onSelectionChanged != null) {
                  widget.onSelectionChanged!(difficulty);
                }
              },
              value: currentDifficulty,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDifficulty() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String difficultyName = isEsp ? _difficultyEsp! : _difficultyEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(difficultyName),
        onDeleted: () {
          setState(() {
            _difficultyEsp = null; // Reset to null on delete
            _difficultyEng = null; // Reset to null on delete
          });

          // Notifica el cambio al padre
          widget.onChanged('');
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!('');
          }
        },
      ),
    );
  }
}
