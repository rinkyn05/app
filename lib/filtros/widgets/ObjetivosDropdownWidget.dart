import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

// Definición de la clase para los objetivos seleccionados
class SelectedObjetivos {
  final String id;
  final String objetivosEsp;
  final String objetivosEng;

  SelectedObjetivos({
    required this.id,
    required this.objetivosEsp,
    required this.objetivosEng,
  });
}

class ObjetivosDropdownWidget extends StatefulWidget {
  final String langKey;
final Function(String) onChanged;

const ObjetivosDropdownWidget({
  Key? key,
  required this.langKey,
  required this.onChanged, // Añadido aquí
}) : super(key: key);


  @override
  _ObjetivosDropdownWidgetState createState() =>
      _ObjetivosDropdownWidgetState();
}

class _ObjetivosDropdownWidgetState extends State<ObjetivosDropdownWidget> {
  final List<SelectedObjetivos> _selectedObjetivos = [];
  Map<String, Map<String, String>> objetivosNames = {};

  // Cargar los nombres de los objetivos desde Firestore
  @override
  void initState() {
    super.initState();
    _loadObjetivosNames();
  }

  void _loadObjetivosNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('objetivos').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      objetivosNames = tempMap;
    });
  }

  void _addObjetivos(String objetivosId) {
    if (!_selectedObjetivos.any((selected) => selected.id == objetivosId)) {
      String objetivosEsp =
          objetivosNames[objetivosId]?['Esp'] ?? 'Nombre no disponible';
      String objetivosEng =
          objetivosNames[objetivosId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedObjetivos.add(SelectedObjetivos(
          id: objetivosId,
          objetivosEsp: objetivosEsp,
          objetivosEng: objetivosEng,
        ));
      });
    }
  }

  void _removeObjetivos(String objetivosId) {
    setState(() {
      _selectedObjetivos
          .removeWhere((objetivos) => objetivos.id == objetivosId);
    });
  }

  // Widget que muestra los objetivos seleccionados
  Widget _buildSelectedObjetivos(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('applicableTo'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedObjetivos.map((objetivos) {
            String objetivosName = langKey == 'Esp'
                ? objetivos.objetivosEsp
                : objetivos.objetivosEng;
            return Chip(
              label: Text(objetivosName),
              onDeleted: () => _removeObjetivos(objetivos.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mostrar los objetivos seleccionados
        _buildSelectedObjetivos(widget.langKey),
        // Dropdown de objetivos
        FutureBuilder<List<DropdownMenuItem<String>>>(
          future: _getSimplifiedObjetivos(widget.langKey),
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
                          .translate('selectOApplicableTo')),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _addObjetivos(newValue); // Agregar objetivo
                        }
                      },
                      items: snapshot.data,
                      value: snapshot.data!.isNotEmpty
                          ? snapshot.data?.first.value
                          : null,
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

  // Método para obtener los objetivos simplificados desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedObjetivos(
      String langKey) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('objetivos').get();
    return snapshot.docs.map((doc) {
      String objetivosName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(objetivosName),
      );
    }).toList();
  }
}
