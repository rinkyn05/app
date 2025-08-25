import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../screens/sports/sports_details.dart';

class MasonrySportsOriginal extends StatefulWidget {
  const MasonrySportsOriginal({Key? key}) : super(key: key);

  @override
  _MasonrySportsOriginalState createState() => _MasonrySportsOriginalState();
}

class _MasonrySportsOriginalState extends State<MasonrySportsOriginal> {
  late YoutubePlayerController _controller;
  bool _isIntensityToggled = false;
  String? _selectedIntensity;

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
                        children: _selectedIntensity == null
                            ? labels.map((label) {
                                return ChoiceChip(
                                  label: Text(label,
                                      style: TextStyle(
                                          fontSize: 12)), // Tamaño más pequeño
                                  selected: _selectedIntensity == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedIntensity =
                                          selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedIntensity',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIntensity = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
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
                            // Lógica de filtrado a implementar
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
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
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
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('sports').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final sports = snapshot.data!.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          (sports.length / 3).ceil(),
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              3,
                              (i) => i + index * 3 < sports.length
                                  ? _buildIconItem(
                                      context, sports[i + index * 3])
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
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, DocumentSnapshot sport) {
    String? imageUrl = sport['URL de la Imagen'];
    String? gifUrl = sport['URL del Gif'];
    String nombre = sport['NombreEsp'] ?? 'Nombre no encontrado';
    String contenido = sport['ContenidoEsp'] ?? 'Contenido no encontrado';
    double resistencia = double.parse(sport['Resistencia'] ?? '0');
    double fisicoEstetico = double.parse(sport['FisicoEstetico'] ?? '0');
    double potenciaAnaerobica =
        double.parse(sport['PotenciaAnaerobica'] ?? '0');
    double saludBienestar = double.parse(sport['SaludBienestar'] ?? '0');
    bool isPremium = sport['MembershipEng'] == 'Premium';

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
                        gifUrl != null && gifUrl.isNotEmpty
                            ? Image.network(
                                gifUrl,
                                width: 400,
                                height: 400,
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.error),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('resistance'),
                                resistencia),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('aestheticPhysical'),
                                fisicoEstetico),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('anaerobicPower'),
                                potenciaAnaerobica),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('healthWellness'),
                                saludBienestar),
                          ],
                        ),
                        SizedBox(height: 16),
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
                                          SportsDetailsPage(sport: sport)),
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(
      BuildContext context, String label, double value) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 6,
            percent: value / 100,
            center: Text(
              '${value.toInt()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            progressColor: Colors.blue,
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
