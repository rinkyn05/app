import 'package:flutter/material.dart';
import '../../../config/lang/app_localization.dart';
import 'mansory_rendimiento_results.dart';

class RendimientoFilterScreen extends StatefulWidget {
  const RendimientoFilterScreen({Key? key}) : super(key: key);

  @override
  _RendimientoFilterScreenState createState() =>
      _RendimientoFilterScreenState();
}

class _RendimientoFilterScreenState extends State<RendimientoFilterScreen> {
  bool _isIntensityToggled = false;
  String _selectedIntensity = '';

  final Map<String, List<String>> intensityLabels = {
    'es': [
      'Ascendente',
      'Descendente',
      'Baja',
      'Muy Baja',
      'Moderada',
      'Alta',
      'Muy Alta',
    ],
    'en': [
      'Ascending',
      'Descending',
      'Low',
      'Very Low',
      'Moderate',
      'High',
      'Very High',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.locale.languageCode;
    final labels = intensityLabels[locale] ?? intensityLabels['en']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('filter')),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Intensidad',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: _isIntensityToggled,
                  onChanged: (value) {
                    setState(() {
                      _isIntensityToggled = value;
                      if (!value) {
                        _selectedIntensity = '';
                      }
                    });
                  },
                ),
              ],
            ),
            if (_isIntensityToggled)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: labels.map((intensity) {
                  return ChoiceChip(
                    label: Text(
                      intensity,
                      style: TextStyle(
                          fontSize: 16), // Tamaño de fuente más pequeño
                    ),
                    selected: _selectedIntensity == intensity,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIntensity = selected ? intensity : '';
                      });
                    },
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey.shade200,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0), // Padding reducido
                  );
                }).toList(),
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text(AppLocalizations.of(context)!.translate('cancel')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _searchWithFilter(); // Filtrado
                  },
                  child:
                      Text(AppLocalizations.of(context)!.translate('filter')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchWithFilter() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MasonryRendimientoResults(
          selectedIntensity: _selectedIntensity, // Pasa la selección
        ),
      ),
    );
  }
}
