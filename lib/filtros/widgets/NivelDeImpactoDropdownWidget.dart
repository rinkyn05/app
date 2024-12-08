import 'package:flutter/material.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class NivelDeImpactoDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(String) onChanged; // Notifica cambios en la selección
  final Function(String?) onSelectionChanged; // Notifica selección actual o eliminación

  const NivelDeImpactoDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _NivelDeImpactoDropdownWidgetState createState() =>
      _NivelDeImpactoDropdownWidgetState();
}

class _NivelDeImpactoDropdownWidgetState
    extends State<NivelDeImpactoDropdownWidget> {
  String? _selectedImpactLevelEsp; // Valor seleccionado en español
  String? _selectedImpactLevelEng; // Valor seleccionado en inglés

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseNivelDeImpacto'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildNivelDeImpactoSelector(),
        if (_selectedImpactLevelEsp != null || _selectedImpactLevelEng != null)
          _buildSelectedImpactLevel(),
      ],
    );
  }

  Widget _buildNivelDeImpactoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Bajo', 'Regular', 'Medio', 'Bueno', 'Alto'];
    List<String> optionsEng = ['Low', 'Regular', 'Medium', 'Good', 'High'];

    Map<String, String> impactLevelMapEspToEng = {
      'Bajo': 'Low',
      'Regular': 'Regular',
      'Medio': 'Medium',
      'Bueno': 'Good',
      'Alto': 'High',
    };
    Map<String, String> impactLevelMapEngToEsp = {
      'Low': 'Bajo',
      'Regular': 'Regular',
      'Medium': 'Medio',
      'Good': 'Bueno',
      'High': 'Alto',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _selectedImpactLevelEsp : _selectedImpactLevelEng;

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
          hint: Text(AppLocalizations.of(context)!
              .translate('selectNivelDeImpacto')),
          onChanged: (String? newValue) {
            setState(() {
              if (isEsp) {
                _selectedImpactLevelEsp = newValue!;
                _selectedImpactLevelEng = impactLevelMapEspToEng[newValue]!;
              } else {
                _selectedImpactLevelEng = newValue!;
                _selectedImpactLevelEsp = impactLevelMapEngToEsp[newValue]!;
              }
              widget.onChanged(isEsp
                  ? _selectedImpactLevelEsp!
                  : _selectedImpactLevelEng!);
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

  Widget _buildSelectedImpactLevel() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String impactLevelName = isEsp
        ? _selectedImpactLevelEsp!
        : _selectedImpactLevelEng!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(impactLevelName),
        onDeleted: () {
          setState(() {
            _selectedImpactLevelEsp = null;
            _selectedImpactLevelEng = null;
            widget.onSelectionChanged(null);
          });
        },
      ),
    );
  }
}
