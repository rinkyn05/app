import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

// Definición de la clase para las partes del cuerpo seleccionadas
class SelectedBodyPart {
  final String id;
  final String bodypartEsp;
  final String bodypartEng;

  SelectedBodyPart({
    required this.id,
    required this.bodypartEsp,
    required this.bodypartEng,
  });
}

class BodyPartDropdownWidget extends StatefulWidget {
  final String langKey;
  final Function(List<SelectedBodyPart>) onChanged;

  const BodyPartDropdownWidget({
    Key? key,
    required this.langKey,
    required this.onChanged, // Añadido aquí
  }) : super(key: key);

  @override
  _BodyPartDropdownWidgetState createState() => _BodyPartDropdownWidgetState();
}

class _BodyPartDropdownWidgetState extends State<BodyPartDropdownWidget> {
  final List<SelectedBodyPart> _selectedBodyPart = [];
  Map<String, Map<String, String>> bodypartNames = {};

  // Cargar los nombres de las partes del cuerpo desde Firestore
  @override
  void initState() {
    super.initState();
    _loadBodyPartNames();
  }

  void _loadBodyPartNames() async {
    var snapshot = await FirebaseFirestore.instance.collection('bodyp').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      bodypartNames = tempMap;
    });
  }

  // void _addBodyPart(String bodypartId) {
  //   if (!_selectedBodyPart.any((selected) => selected.id == bodypartId)) {
  //     String bodypartEsp =
  //         bodypartNames[bodypartId]?['Esp'] ?? 'Nombre no disponible';
  //     String bodypartEng =
  //         bodypartNames[bodypartId]?['Eng'] ?? 'Nombre no disponible';
  //     setState(() {
  //       _selectedBodyPart.add(SelectedBodyPart(
  //         id: bodypartId,
  //         bodypartEsp: bodypartEsp,
  //         bodypartEng: bodypartEng,
  //       ));
  //     });
  //   }
  // }

  void _removeBodyPart(String bodypartId) {
    setState(() {
      _selectedBodyPart.removeWhere((bodypart) => bodypart.id == bodypartId);
    });
  }

  // Widget que muestra las partes del cuerpo seleccionadas
  Widget _buildSelectedBodyPart(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('zonaObjetivo'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedBodyPart.map((bodypart) {
            String bodypartName =
                langKey == 'Esp' ? bodypart.bodypartEsp : bodypart.bodypartEng;
            return Chip(
              label: Text(bodypartName),
              onDeleted: () => _removeBodyPart(bodypart.id),
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
        // Mostrar las partes del cuerpo seleccionadas
        _buildSelectedBodyPart(widget.langKey),
        // Dropdown de partes del cuerpo
        FutureBuilder<List<DropdownMenuItem<String>>>(
          future: _getSimplifiedBodyPart(widget.langKey),
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
                          .translate('selectMusculoObjetivo')),
                      // BodyPartDropdownWidget
                      onChanged: (String? value) {
                        if (value != null) {
                          print(
                              'Selected BodyPart ID: $value'); // Esto debería mostrar el id de la parte del cuerpo seleccionada.
                          setState(() {
                            _selectedBodyPart.add(SelectedBodyPart(
                              id: value,
                              bodypartEsp: bodypartNames[value]?['Esp'] ??
                                  'Nombre no disponible',
                              bodypartEng: bodypartNames[value]?['Eng'] ??
                                  'Nombre no disponible',
                            ));
                          });
                          widget.onChanged(
                              _selectedBodyPart); // Esto pasa la lista de partes seleccionadas
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

  // Método para obtener las partes del cuerpo simplificadas desde Firestore
  Future<List<DropdownMenuItem<String>>> _getSimplifiedBodyPart(
      String langKey) async {
    var snapshot = await FirebaseFirestore.instance.collection('bodyp').get();
    return snapshot.docs.map((doc) {
      String bodypartName =
          langKey == 'Esp' ? doc['NombreEsp'] : doc['NombreEng'];
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(bodypartName),
      );
    }).toList();
  }
}