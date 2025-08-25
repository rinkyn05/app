import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../screens/rendimiento/rendimiento_f_details.dart';

class MasonryRendimiento extends StatefulWidget {
  const MasonryRendimiento({Key? key}) : super(key: key);

  @override
  _MasonryRendimientoState createState() => _MasonryRendimientoState();
}

class _MasonryRendimientoState extends State<MasonryRendimiento> {
  late YoutubePlayerController _controller;
  bool _isIntensityToggled = false;
  String? _selectedIntensity;
  String _searchQuery = '';
  List<DocumentSnapshot> _searchResults = [];

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
  double _volume = 50.0; // Variable para almacenar el volumen actual

  @override
  void initState() {
    super.initState();
    _controller
        .setVolume(_volume.toInt()); // Establecer el volumen predeterminado
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false, // Deshabilitar subtítulos si es necesario
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final locale = AppLocalizations.of(context)!.locale.languageCode;
            final labels = intensityLabels[locale] ?? intensityLabels['en']!;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Test Dialog',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Intensidad',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isIntensityToggled,
                          onChanged: (value) {
                            setState(() {
                              _isIntensityToggled = value;
                              if (!value) {
                                _selectedIntensity = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isIntensityToggled)
                      Wrap(
                        spacing: 4.0, // Tamaño de espacio entre opciones
                        children: labels.map((label) {
                          return ChoiceChip(
                            label: Text(label,
                                style: TextStyle(
                                    fontSize: 12)), // Tamaño más pequeño
                            selected: _selectedIntensity == label,
                            onSelected: (selected) {
                              setState(() {
                                _selectedIntensity = selected ? label : null;
                              });
                            },
                            selectedColor: Colors.blue,
                            backgroundColor: Colors.grey.shade200,
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _filterByIntensity(); // Llama a la función de filtrado
                            Navigator.of(context)
                                .pop(); // Cierra el diálogo después de filtrar
                          },
                          child: Text('Filtrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _filterByIntensity() async {
    if (_selectedIntensity != null) {
      final locale = AppLocalizations.of(context)!.locale.languageCode;
      final intensityField = locale == 'es' ? 'intensityEsp' : 'intensityEng';

      final results = await FirebaseFirestore.instance
          .collection('rendimientoFisico')
          .where(intensityField, isEqualTo: _selectedIntensity)
          .get();

      setState(() {
        _searchResults = results.docs;
        _searchQuery =
            ''; // Limpiar el cuadro de búsqueda para que solo se muestren los resultados filtrados
      });
    }
  }

  Future<void> _searchInFirebase() async {
    final query = _searchQuery.toLowerCase();
    final results = await FirebaseFirestore.instance
        .collection('rendimientoFisico')
        .where('NombreEsp', isGreaterThanOrEqualTo: query)
        .where('NombreEsp', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      _searchResults = results.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                ),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    Container(
                      width: 100,
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 100,
                        onChanged: (newVolume) {
                          setState(() {
                            _volume = newVolume;
                          });
                          _controller.setVolume(newVolume.toInt());
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons
                          .fullscreen_exit), // Icono que simula el botón de pantalla completa
                      onPressed: () {
                        // No hacer nada para evitar la pantalla completa
                      },
                    ),
                  ],
                  topActions: [
                    // Aquí puedes agregar acciones personalizadas si es necesario
                  ],
                  onReady: () {
                    debugPrint("Video is ready.");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          color: AppColors.adaptableColor(context),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .translate('search'),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 10.0,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: _searchInFirebase,
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterDialog,
                    icon: Icon(
                      Icons.filter_list,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            if (_searchResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_searchResults.length} resultados encontrados',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (_searchResults.isEmpty && _searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No se encontró ningún resultado',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (_searchQuery.isEmpty)
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rendimientoFisico')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final rendimiento = snapshot.data!.docs;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: List.generate(
                            (rendimiento.length / 3).ceil(),
                            (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                3,
                                (i) => i + index * 3 < rendimiento.length
                                    ? _buildIconItem(
                                        context, rendimiento[i + index * 3])
                                    : SizedBox(width: 100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            if (_searchQuery.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(
                      (_searchResults.length / 3).ceil(),
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (i) => i + index * 3 < _searchResults.length
                              ? _buildIconItem(
                                  context, _searchResults[i + index * 3])
                              : SizedBox(width: 100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, DocumentSnapshot rendimiento) {
    String? imageUrl = rendimiento['URL de la Imagen'];
    String nombre = rendimiento['NombreEsp'] ?? 'Nombre no encontrado';
    String contenido = rendimiento['ContenidoEsp'] ?? 'Contenido no encontrado';
    bool isPremium = rendimiento['MembershipEng'] == 'Premium';

    return GestureDetector(
      onTap: () {
        if (!isPremium) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          nombre,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            contenido,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RendimientoDetailsPage(
                                              rendimiento: rendimiento)),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('seeMore'),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : Icon(Icons.error),
            ),
            if (isPremium)
              Positioned.fill(
                child: Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            Text(
              nombre,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
