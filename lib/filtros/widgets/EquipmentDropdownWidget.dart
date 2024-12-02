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

const EquipmentDropdownWidget({
  Key? key,
  required this.langKey,
  required this.onChanged, // Añadido aquí
}) : super(key: key);


  @override
  _EquipmentDropdownWidgetState createState() =>
      _EquipmentDropdownWidgetState();
}

class _EquipmentDropdownWidgetState extends State<EquipmentDropdownWidget> {
  final List<SelectedEquipment> _selectedEquipment = [];
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
    if (!_selectedEquipment.any((selected) => selected.id == equipmentId)) {
      String equipmentEsp =
          equipmentNames[equipmentId]?['Esp'] ?? 'Nombre no disponible';
      String equipmentEng =
          equipmentNames[equipmentId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedEquipment.add(SelectedEquipment(
          id: equipmentId,
          equipmentEsp: equipmentEsp,
          equipmentEng: equipmentEng,
        ));
      });
    }
  }

  void _removeEquipment(String equipmentId) {
    setState(() {
      _selectedEquipment
          .removeWhere((equipment) => equipment.id == equipmentId);
    });
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
        Wrap(
          spacing: 8.0,
          children: _selectedEquipment.map((equipment) {
            String equipmentName = langKey == 'Esp'
                ? equipment.equipmentEsp
                : equipment.equipmentEng;
            return Chip(
              label: Text(equipmentName),
              onDeleted: () => _removeEquipment(equipment.id),
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
        // Mostrar los equipos seleccionados
        _buildSelectedEquipment(widget.langKey),
        // Dropdown de equipos
        FutureBuilder<List<DropdownMenuItem<String>>>(
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
                          _addEquipment(newValue); // Agregar equipo
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
