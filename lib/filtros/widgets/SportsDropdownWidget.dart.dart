import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

// Definición de la clase para los deportes seleccionados
class SelectedSports {
  final String id;
  final String sportsEsp;
  final String sportsEng;

  SelectedSports({
    required this.id,
    required this.sportsEsp,
    required this.sportsEng,
  });
}

class SportsDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(SelectedSports) onSelectionChanged; // Solo un deporte seleccionado

  const SportsDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _SportsDropdownWidgetState createState() => _SportsDropdownWidgetState();
}

class _SportsDropdownWidgetState extends State<SportsDropdownWidget> {
  SelectedSports? _selectedSport;
  Map<String, Map<String, String>> sportsNames = {};

  // Cargar los nombres de los deportes desde Firestore
  void _loadSportsNames() async {
    var snapshot = await FirebaseFirestore.instance.collection('sports').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      sportsNames = tempMap;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSportsNames();
  }

  // Construir la lista de deportes seleccionados
  Widget _buildSelectedSport(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('sport'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (_selectedSport != null)
          Chip(
            label: Text(langKey == 'Esp'
                ? _selectedSport!.sportsEsp
                : _selectedSport!.sportsEng),
            onDeleted: () => setState(() {
              _selectedSport = null;
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String langKey = widget.langKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSelectedSport(langKey),
        FutureBuilder<List<DropdownMenuItem<String>>>(
          // Llamar a un método que devuelva los deportes disponibles
          future: _getSimplifiedSports(langKey),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          .translate('selectSports')),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          // Asignar un solo deporte seleccionado
                          setState(() {
                            _selectedSport = SelectedSports(
                              id: newValue,
                              sportsEsp:
                                  sportsNames[newValue]?['Esp'] ?? 'Nombre no disponible',
                              sportsEng:
                                  sportsNames[newValue]?['Eng'] ?? 'Nombre no disponible',
                            );
                          });

                          // Notificar al callback para la selección específica
                          widget.onSelectionChanged(
                            _selectedSport!,
                          );
                        }
                      },
                      items: snapshot.data,
                      value: _selectedSport != null ? _selectedSport!.id : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Método para obtener los deportes simplificados desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedSports(
      String langKey) async {
    var snapshot = await FirebaseFirestore.instance.collection('sports').get();
    return snapshot.docs.map((doc) {
      String sportsName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(sportsName),
      );
    }).toList();
  }
}
