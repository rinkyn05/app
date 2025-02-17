import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

// Definición de la clase para los Estiramientos específicos seleccionados
class SelectedEstiramientoEspecifico {
  final String id;
  final String EstiramientoEspecificoEsp;
  final String EstiramientoEspecificoEng;

  SelectedEstiramientoEspecifico({
    required this.id,
    required this.EstiramientoEspecificoEsp,
    required this.EstiramientoEspecificoEng,
  });
}

class EstiramientoEspecificoDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(List<SelectedEstiramientoEspecifico>) onChanged;
  final Function(SelectedEstiramientoEspecifico)? onSelectionChanged;

  const EstiramientoEspecificoDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  _EstiramientoEspecificoDropdownWidgetState createState() =>
      _EstiramientoEspecificoDropdownWidgetState();
}

class _EstiramientoEspecificoDropdownWidgetState
    extends State<EstiramientoEspecificoDropdownWidget> {
  List<SelectedEstiramientoEspecifico> _selectedEstiramientoEspecifico = [];
  Map<String, Map<String, String>> EstiramientoEspecificoNames = {};

  @override
  void initState() {
    super.initState();
    _loadEstiramientoEspecificoNames();
  }

  void _loadEstiramientoEspecificoNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('estiramientoE').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      EstiramientoEspecificoNames = tempMap;
    });
  }

  // Widget que muestra los Estiramientos específicos seleccionados
  Widget _buildSelectedEstiramientoEspecifico(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('estiramientoEspecifico'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children:
              _selectedEstiramientoEspecifico.map((estiramientoEspecifico) {
            String estiramientoEspecificoName = langKey == 'Esp'
                ? estiramientoEspecifico.EstiramientoEspecificoEsp
                : estiramientoEspecifico.EstiramientoEspecificoEng;
            return Chip(
              label: Text(estiramientoEspecificoName),
              onDeleted: () =>
                  _removeEstiramientoEspecifico(estiramientoEspecifico.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _removeEstiramientoEspecifico(String estiramientoEspecificoId) {
    setState(() {
      _selectedEstiramientoEspecifico.removeWhere(
          (estiramientoEspecifico) => estiramientoEspecifico.id == estiramientoEspecificoId);
    });
    widget.onChanged(_selectedEstiramientoEspecifico);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mostrar los Estiramientos específicos seleccionados
        _buildSelectedEstiramientoEspecifico(widget.langKey),
        // Dropdown de Estiramientos específicos
        FutureBuilder<List<DropdownMenuItem<String>>>(
          future: _getSimplifiedEstiramientoEspecifico(widget.langKey),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectEstiramientoEspecifico')),
                  onChanged: (String? value) {
                    if (value != null) {
                      final selected = SelectedEstiramientoEspecifico(
                        id: value,
                        EstiramientoEspecificoEsp:
                            EstiramientoEspecificoNames[value]?['Esp'] ??
                                'Nombre no disponible',
                        EstiramientoEspecificoEng:
                            EstiramientoEspecificoNames[value]?['Eng'] ??
                                'Nombre no disponible',
                      );

                      setState(() {
                        // Limpiar la lista y añadir solo el nuevo seleccionado
                        _selectedEstiramientoEspecifico = [selected];
                      });

                      // Notificar al callback
                      widget.onSelectionChanged?.call(selected);

                      // Actualizar la lista seleccionada
                      widget.onChanged(_selectedEstiramientoEspecifico);
                    }
                  },
                  items: snapshot.data,
                  value: null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Método para obtener los Estiramientos específicos simplificados desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedEstiramientoEspecifico(
      String langKey) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('estiramientoE').get();
    return snapshot.docs.map((doc) {
      String estiramientoEspecificoName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(estiramientoEspecificoName),
      );
    }).toList();
  }
}
