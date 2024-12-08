import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

// Definición de la clase para los equipos seleccionados
class SelectedEquipment {
  final String id;
  final String equipmentEsp;
  final String equipmentEng;

  SelectedEquipment({
    required this.id,
    required this.equipmentEsp,
    required this.equipmentEng,
  });
}

class EquipmentDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(String) onChanged;
  final Function(SelectedEquipment)? onSelectionChanged; // Callback adicional

  const EquipmentDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged,
    this.onSelectionChanged, // Aceptar función opcional
  }) : super(key: key);

  @override
  _EquipmentDropdownWidgetState createState() =>
      _EquipmentDropdownWidgetState();
}

class _EquipmentDropdownWidgetState extends State<EquipmentDropdownWidget> {
  SelectedEquipment? _selectedEquipment; // Solo un equipo seleccionado
  Map<String, Map<String, String>> equipmentNames = {};

  // Cargar los nombres de los equipos desde Firestore
  @override
  void initState() {
    super.initState();
    _loadEquipmentNames();
  }

  void _loadEquipmentNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('equipment').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      equipmentNames = tempMap;
    });
  }

  void _addEquipment(String equipmentId) {
    String equipmentEsp = equipmentNames[equipmentId]?['Esp'] ?? 'Nombre no disponible';
    String equipmentEng = equipmentNames[equipmentId]?['Eng'] ?? 'Nombre no disponible';
    setState(() {
      _selectedEquipment = SelectedEquipment(
        id: equipmentId,
        equipmentEsp: equipmentEsp,
        equipmentEng: equipmentEng,
      );
    });

    // Notificar al callback onSelectionChanged si está definido
    if (widget.onSelectionChanged != null && _selectedEquipment != null) {
      widget.onSelectionChanged!(_selectedEquipment!);
    }

    widget.onChanged(equipmentId); // Pasar solo el ID seleccionado
  }

  // Widget que muestra los equipos seleccionados
  Widget _buildSelectedEquipment(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('equipmentNew'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // Mostrar el equipo seleccionado o un mensaje si no hay ninguno
        _selectedEquipment == null
            ? Text(AppLocalizations.of(context)!.translate('selectEquipmentNew'))
            : Wrap(
                spacing: 8.0,
                children: [
                  Chip(
                    label: Text(
                      widget.langKey == 'Esp'
                          ? _selectedEquipment!.equipmentEsp
                          : _selectedEquipment!.equipmentEng,
                    ),
                    onDeleted: () => setState(() {
                      _selectedEquipment = null; // Limpiar selección
                    }),
                  ),
                ],
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mostrar los equipos seleccionados
        _buildSelectedEquipment(widget.langKey),
        // Dropdown de equipos
        FutureBuilder<List<DropdownMenuItem<String>>>( // Usar FutureBuilder para cargar los datos
          future: _getSimplifiedEquipment(widget.langKey),
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
                          .translate('selectEquipmentNew')),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _addEquipment(newValue); // Agregar equipo seleccionado
                        }
                      },
                      items: snapshot.data,
                      value: _selectedEquipment != null
                          ? _selectedEquipment!.id
                          : null, // Mostrar el valor seleccionado
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

  // Método para obtener los equipos simplificados desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedEquipment(
      String langKey) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('equipment').get();
    return snapshot.docs.map((doc) {
      String equipmentName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(equipmentName),
      );
    }).toList();
  }
}
