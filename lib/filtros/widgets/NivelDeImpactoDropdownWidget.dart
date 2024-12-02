import 'package:flutter/material.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart'; // Ajusta la importación según tu estructura

class NivelDeImpactoDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(List<String>) onChanged;

  const NivelDeImpactoDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged, // Añadido aquí
  }) : super(key: key);

  @override
  _NivelDeImpactoDropdownWidgetState createState() =>
      _NivelDeImpactoDropdownWidgetState();
}

class _NivelDeImpactoDropdownWidgetState
    extends State<NivelDeImpactoDropdownWidget> {
  List<String> _selectedImpactLevels = [];

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
        _buildSelectedNivelDeImpacto(),
      ],
    );
  }

  Widget _buildNivelDeImpactoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Bajo', 'Regular', 'Medio', 'Bueno', 'Alto'];
    List<String> optionsEng = ['Low', 'Regular', 'Medium', 'Good', 'High'];

    // Mapas de traducción para gestionar entre español e inglés

    Map<String, String> nivelDeImpactoMapEngToEsp = {
      'Low': 'Bajo',
      'Regular': 'Regular',
      'Medium': 'Medio',
      'Good': 'Bueno',
      'High': 'Alto',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;

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
              hint: Text(AppLocalizations.of(context)!
                  .translate('selectNivelDeImpacto')),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    // Si el idioma es español, agregamos el valor en español
                    // y el valor correspondiente en inglés
                    if (isEsp) {
                      if (!_selectedImpactLevels.contains(newValue)) {
                        _selectedImpactLevels.add(newValue);
                        widget.onChanged(_selectedImpactLevels);
                      }
                    } else {
                      if (!_selectedImpactLevels.contains(newValue)) {
                        // Convertir el valor en inglés a español
                        _selectedImpactLevels.add(
                            nivelDeImpactoMapEngToEsp[newValue]!);
                        widget.onChanged(_selectedImpactLevels);
                      }
                    }
                  }
                });
              },
              value: null, // No hay un valor seleccionado por defecto
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

  Widget _buildSelectedNivelDeImpacto() {
    if (_selectedImpactLevels.isEmpty) {
      return const SizedBox.shrink(); // No mostrar nada si no hay selecciones
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        spacing: 6.0,
        children: _selectedImpactLevels.map((impacto) {
          return Chip(
            label: Text(impacto),
            onDeleted: () {
              setState(() {
                _selectedImpactLevels.remove(impacto);
                widget.onChanged(_selectedImpactLevels); // Notifica los cambios
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
