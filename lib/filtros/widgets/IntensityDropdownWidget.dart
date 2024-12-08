import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class IntensityDropdownWidget extends StatefulWidget {
  final Function(String) onChanged; // Notifica cada cambio completo
  final Function(String)? onSelectionChanged; // Notifica cambios de selección específicos

  const IntensityDropdownWidget({
    Key? key,
    required this.onChanged,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  _IntensityDropdownWidgetState createState() =>
      _IntensityDropdownWidgetState();
}

class _IntensityDropdownWidgetState extends State<IntensityDropdownWidget> {
  String? _selectedIntensityEsp;
  String? _selectedIntensityEng;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('intensity'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildIntensitySelector(),
        if (_selectedIntensityEsp != null || _selectedIntensityEng != null)
          _buildSelectedIntensity(), // Mostrar chip solo si hay una selección
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    // Opciones en español e inglés
    List<String> optionsEsp = [
      'Ascendente',
      'Descendente',
      'Baja',
      'Muy Baja',
      'Moderada',
      'Alta',
      'Muy Alta',
    ];
    List<String> optionsEng = [
      'Ascending',
      'Descending',
      'Low',
      'Very Low',
      'Moderate',
      'High',
      'Very High',
    ];

    // Mapas para traducir entre idiomas
    Map<String, String> intensityMapEspToEng = {
      'Ascendente': 'Ascending',
      'Descendente': 'Descending',
      'Baja': 'Low',
      'Muy Baja': 'Very Low',
      'Moderada': 'Moderate',
      'Alta': 'High',
      'Muy Alta': 'Very High',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Ascending': 'Ascendente',
      'Descending': 'Descendente',
      'Low': 'Baja',
      'Very Low': 'Muy Baja',
      'Moderate': 'Moderada',
      'High': 'Alta',
      'Very High': 'Muy Alta',
    };

    // Determina las opciones y selección actual según el idioma
    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? currentIntensity = isEsp ? _selectedIntensityEsp : _selectedIntensityEng;

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
              AppLocalizations.of(context)!.translate('selectIntensity')),
          onChanged: (String? newValue) {
            setState(() {
              // Actualiza la selección en ambos idiomas
              if (isEsp) {
                _selectedIntensityEsp = newValue!;
                _selectedIntensityEng = intensityMapEspToEng[newValue]!;
              } else {
                _selectedIntensityEng = newValue!;
                _selectedIntensityEsp = intensityMapEngToEsp[newValue]!;
              }
            });

            // Notifica el cambio completo
            String intensity = isEsp ? _selectedIntensityEsp! : _selectedIntensityEng!;
            widget.onChanged(intensity);

            // Notifica el cambio de una selección específica
            if (widget.onSelectionChanged != null) {
              widget.onSelectionChanged!(intensity);
            }
          },
          value: currentIntensity,
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

  Widget _buildSelectedIntensity() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String intensityName = isEsp ? _selectedIntensityEsp! : _selectedIntensityEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(intensityName),
        onDeleted: () {
          setState(() {
            _selectedIntensityEsp = null; // Resetea la selección
            _selectedIntensityEng = null;
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
