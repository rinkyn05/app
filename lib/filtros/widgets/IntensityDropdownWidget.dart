import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class IntensityDropdownWidget extends StatefulWidget {
  final String langKey;
final Function(String) onChanged;

const IntensityDropdownWidget({
  Key? key,
  required this.langKey,
  required this.onChanged, // Añadido aquí
}) : super(key: key);


  @override
  _IntensityDropdownWidgetState createState() =>
      _IntensityDropdownWidgetState();
}

class _IntensityDropdownWidgetState extends State<IntensityDropdownWidget> {
  String? _intensityEsp;
  String? _intensityEng;

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
        if (_intensityEsp != null || _intensityEng != null)
          _buildSelectedIntensity(),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Ascendente',
      'Descendente',
      'Baja',
      'Muy Baja',
      'Moderada',
      'Alta',
      'Muy Alta'
    ];
    List<String> optionsEng = [
      'Ascending',
      'Descending',
      'Low',
      'Very Low',
      'Moderate',
      'High',
      'Very High'
    ];

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

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? currentIntensity = isEsp ? _intensityEsp : _intensityEng;

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
                  AppLocalizations.of(context)!.translate('selectIntensity')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _intensityEsp = newValue!;
                    _intensityEng = intensityMapEspToEng[newValue]!;
                  } else {
                    _intensityEng = newValue!;
                    _intensityEsp = intensityMapEngToEsp[newValue]!;
                  }
                });
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
        ],
      ),
    );
  }

  Widget _buildSelectedIntensity() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String intensityName = isEsp ? _intensityEsp! : _intensityEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(intensityName),
        onDeleted: () {
          setState(() {
            _intensityEsp = null;
            _intensityEng = null;
          });
        },
      ),
    );
  }
}
