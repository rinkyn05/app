import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class PosturaDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(String) onChanged; // Notifica cambios en la selección
  final Function(String?)
      onSelectionChanged; // Notifica selección actual o eliminación

  const PosturaDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    required this.onSelectionChanged, // Cambié esto a 'required'
  }) : super(key: key);

  @override
  _PosturaDropdownWidgetState createState() => _PosturaDropdownWidgetState();
}

class _PosturaDropdownWidgetState extends State<PosturaDropdownWidget> {
  String? _stanceEsp; // Valor seleccionado en español
  String? _stanceEng; // Valor seleccionado en inglés

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseStance'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildStanceSelector(),
        if (_stanceEsp != null || _stanceEng != null) _buildSelectedStance(),
      ],
    );
  }

  Widget _buildStanceSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Parado',
      'Sentado',
      'Inclinado',
      'Declinado',
      'De Pie Horizontal',
      'Maquina Gimnasion'
    ];
    List<String> optionsEng = [
      'Standing',
      'Sitting',
      'Inclined',
      'Declined',
      'Horizontal Standing',
      'Gym Machine'
    ];

    Map<String, String> stanceMapEspToEng = {
      'Parado': 'Standing',
      'Sentado': 'Sitting',
      'Inclinado': 'Inclined',
      'Declinado': 'Declined',
      'De Pie Horizontal': 'Horizontal Standing',
      'Maquina Gimnasion': 'Gym Machine',
    };

    Map<String, String> stanceMapEngToEsp = {
      'Standing': 'Parado',
      'Sitting': 'Sentado',
      'Inclined': 'Inclinado',
      'Declined': 'Declinado',
      'Horizontal Standing': 'De Pie Horizontal',
      'Gym Machine': 'Maquina Gimnasion',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _stanceEsp : _stanceEng;

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
              AppLocalizations.of(context)!.translate('selectExerciseStance')),
          onChanged: (String? newValue) {
            setState(() {
              if (isEsp) {
                _stanceEsp = newValue!;
                _stanceEng = stanceMapEspToEng[newValue]!;
              } else {
                _stanceEng = newValue!;
                _stanceEsp = stanceMapEngToEsp[newValue]!;
              }

              // Notifica el cambio general
              widget.onChanged(isEsp ? _stanceEsp! : _stanceEng!);
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

  Widget _buildSelectedStance() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String stanceName = isEsp ? _stanceEsp! : _stanceEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Chip(
        label: Text(stanceName),
        onDeleted: () {
          setState(() {
            _stanceEsp = null;
            _stanceEng = null;
            widget.onSelectionChanged(null); // Pasamos null cuando se elimina
          });
        },
      ),
    );
  }
}
