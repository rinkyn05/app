import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

// Definición de la clase para los calentamientos específicos seleccionados
class SelectedCalentamientoEspecifico {
  final String id;
  final String CalentamientoEspecificoEsp;
  final String CalentamientoEspecificoEng;

  SelectedCalentamientoEspecifico({
    required this.id,
    required this.CalentamientoEspecificoEsp,
    required this.CalentamientoEspecificoEng,
  });
}

class CalentamientoEspecificoDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(List<SelectedCalentamientoEspecifico>) onChanged;

  const CalentamientoEspecificoDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged, // Añadido aquí
  }) : super(key: key);

  @override
  _CalentamientoEspecificoDropdownWidgetState createState() =>
      _CalentamientoEspecificoDropdownWidgetState();
}

class _CalentamientoEspecificoDropdownWidgetState
    extends State<CalentamientoEspecificoDropdownWidget> {
  final List<SelectedCalentamientoEspecifico> _selectedCalentamientoEspecifico =
      [];
  Map<String, Map<String, String>> CalentamientoEspecificoNames = {};

  // Cargar los nombres de los calentamientos específicos desde Firestore
  @override
  void initState() {
    super.initState();
    _loadCalentamientoEspecificoNames();
  }

  void _loadCalentamientoEspecificoNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('calentamientoE').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      CalentamientoEspecificoNames = tempMap;
    });
  }

  void _addCalentamientoEspecifico(String calentamientoEspecificoId) {
    if (!_selectedCalentamientoEspecifico
        .any((selected) => selected.id == calentamientoEspecificoId)) {
      String calentamientoEspecificoEsp =
          CalentamientoEspecificoNames[calentamientoEspecificoId]?['Esp'] ??
              'Nombre no disponible';
      String calentamientoEspecificoEng =
          CalentamientoEspecificoNames[calentamientoEspecificoId]?['Eng'] ??
              'Nombre no disponible';
      setState(() {
        _selectedCalentamientoEspecifico.add(SelectedCalentamientoEspecifico(
          id: calentamientoEspecificoId,
          CalentamientoEspecificoEsp: calentamientoEspecificoEsp,
          CalentamientoEspecificoEng: calentamientoEspecificoEng,
        ));
        widget.onChanged(_selectedCalentamientoEspecifico);
      });
    }
  }

  void _removeCalentamientoEspecifico(String CalentamientoEspecificoId) {
    setState(() {
      _selectedCalentamientoEspecifico.removeWhere((CalentamientoEspecifico) =>
          CalentamientoEspecifico.id == CalentamientoEspecificoId);
      widget.onChanged(_selectedCalentamientoEspecifico);
    });
  }

  Widget _buildSelectedCalentamientoEspecifico(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('calentamientoEspecifico'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children:
              _selectedCalentamientoEspecifico.map((calentamientoEspecifico) {
            String calentamientoEspecificoName = langKey == 'Esp'
                ? (calentamientoEspecifico.CalentamientoEspecificoEsp)
                : (calentamientoEspecifico.CalentamientoEspecificoEng);
            return Chip(
              label: Text(calentamientoEspecificoName),
              onDeleted: () =>
                  _removeCalentamientoEspecifico(calentamientoEspecifico.id),
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
        // Mostrar los calentamientos específicos seleccionados
        _buildSelectedCalentamientoEspecifico(widget.langKey),
        // Dropdown de calentamientos específicos
        FutureBuilder<List<DropdownMenuItem<String>>>(
          future: _getSimplifiedCalentamientoEspecifico(widget.langKey),
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
                          .translate('selectCalentamientoEspecifico')),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _addCalentamientoEspecifico(newValue);
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

  // Método para obtener los calentamientos específicos simplificados desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedCalentamientoEspecifico(
      String langKey) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('calentamientoE').get();
    return snapshot.docs.map((doc) {
      String calentamientoEspecificoName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(calentamientoEspecificoName),
      );
    }).toList();
  }
}
