// archivo: ejercicio_detalle_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Asegúrate de agregar esta dependencia en tu pubspec.yaml
import '../../../backend/models/ejercicio_model.dart';
import '../../../config/lang/app_localization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../widgets/custom_appbar_new.dart';
import '../../../config/utils/appcolors.dart';

class EjercicioDetalleScreen extends StatefulWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreen({Key? key, required this.ejercicio})
      : super(key: key);

  @override
  _EjercicioDetalleScreenState createState() => _EjercicioDetalleScreenState();
}

class _EjercicioDetalleScreenState extends State<EjercicioDetalleScreen> {
  // Estado para controlar qué contenido mostrar
  String _selectedOption = 'Imagen GIF'; // Opción predeterminada

  // Controladores de YouTube
  late YoutubePlayerController _controllerGif;
  late YoutubePlayerController _controllerVidPers;
  late YoutubePlayerController _controllerVidPersFl;
  late YoutubePlayerController _controllerVidPersOb;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores de YouTube
    _controllerGif = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.ejercicio.video) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controllerVidPers = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.ejercicio.videoPTrain) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controllerVidPersFl = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.ejercicio.videoPFlaca) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controllerVidPersOb = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.ejercicio.videoPObese) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    // Liberar controladores de YouTube
    _controllerGif.dispose();
    _controllerVidPers.dispose();
    _controllerVidPersFl.dispose();
    _controllerVidPersOb.dispose();
    super.dispose();
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.translate('show')),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Imagen GIF'),
                onTap: () {
                  setState(() {
                    _selectedOption = 'Imagen GIF';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Imagen 3D'),
                onTap: () {
                  setState(() {
                    _selectedOption = 'Imagen 3D';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Video Personal Trainer'),
                onTap: () {
                  setState(() {
                    _selectedOption = 'Video Personal Trainer';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Video Persona Obesa'),
                onTap: () {
                  setState(() {
                    _selectedOption = 'Video Persona Obesa';
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Video Persona Flaca'),
                onTap: () {
                  setState(() {
                    _selectedOption = 'Video Persona Flaca';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_selectedOption) {
      case 'Imagen GIF':
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.ejercicio.imageUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 16,
            height: 300,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        );
      case 'Imagen 3D':
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.ejercicio.image3dUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 16,
            height: 300,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        );
      case 'Video Personal Trainer':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 50, 50, 50),
            border: Border.all(
              width: 6.0,
              color: AppColors.adaptableColor(context),
            ),
          ),
          width: MediaQuery.of(context).size.width - 16,
          height: 300,
          child: YoutubePlayer(
            controller: _controllerVidPers,
            showVideoProgressIndicator: true,
            onReady: () {},
          ),
        );
      case 'Video Persona Obesa':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 50, 50, 50),
            border: Border.all(
              width: 6.0,
              color: AppColors.adaptableColor(context),
            ),
          ),
          width: MediaQuery.of(context).size.width - 16,
          height: 300,
          child: YoutubePlayer(
            controller: _controllerVidPersOb,
            showVideoProgressIndicator: true,
            onReady: () {},
          ),
        );
      case 'Video Persona Flaca':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 50, 50, 50),
            border: Border.all(
              width: 6.0,
              color: AppColors.adaptableColor(context),
            ),
          ),
          width: MediaQuery.of(context).size.width - 16,
          height: 300,
          child: YoutubePlayer(
            controller: _controllerVidPersFl,
            showVideoProgressIndicator: true,
            onReady: () {},
          ),
        );
      default:
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.ejercicio.imageUrl,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 16,
            height: 300,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        );
    }
  }

  Widget _buildImpactLevel() {
    String nivelDeImpacto;
    if (Localizations.localeOf(context).languageCode == 'es') {
      nivelDeImpacto = widget.ejercicio.nivelDeImpactoEsp;
    } else {
      nivelDeImpacto = widget.ejercicio.nivelDeImpactoEng;
    }

    int starCount;
    switch (nivelDeImpacto) {
      case 'Bajo':
      case 'Low':
        starCount = 1;
        break;
      case 'Regular':
        starCount = 2;
        break;
      case 'Medio':
      case 'Medium':
        starCount = 3;
        break;
      case 'Bueno':
      case 'Good':
        starCount = 4;
        break;
      case 'Alto':
      case 'High':
        starCount = 5;
        break;
      default:
        starCount = 5;
    }

    return Card(
      elevation: 4.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 16,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.translate('nivelDeImpacto'),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                if (index < starCount) {
                  return FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 20,
                  );
                } else {
                  return FaIcon(
                    FontAwesomeIcons.star,
                    color: Colors.grey,
                    size: 20,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyLevel() {
    String dificultad;
    if (Localizations.localeOf(context).languageCode == 'es') {
      dificultad = widget.ejercicio.dificultadEsp;
    } else {
      dificultad = widget.ejercicio.dificultadEng;
    }

    int starCount;
    switch (dificultad) {
      case 'Fácil':
      case 'Easy':
        starCount = 1;
        break;
      case 'Medio':
      case 'Medium':
        starCount = 2;
        break;
      case 'Avanzado':
      case 'Advanced':
        starCount = 3;
        break;
      case 'Difícil':
      case 'Difficult':
        starCount = 4;
        break;
      default:
        starCount = 4;
    }

    return Card(
      elevation: 4.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 16,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.translate('dificultad'),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                if (index < starCount) {
                  return FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 20,
                  );
                } else {
                  return FaIcon(
                    FontAwesomeIcons.star,
                    color: Colors.grey,
                    size: 20,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> details = [
      {
        'key': AppLocalizations.of(context)!.translate('duration'),
        'value': widget.ejercicio.estancia,
        'icon': Icons.access_time,
      },
      _buildImpactLevel(),
      _buildDifficultyLevel(),
    ];

    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildContent(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showOptionsDialog();
                    },
                    child:
                        Text(AppLocalizations.of(context)!.translate('show')),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: details.map((detail) {
                if (detail is Map<String, dynamic>) {
                  return Card(
                    elevation: 4.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 16,
                      padding: const EdgeInsets.all(8.0),
                      child: detail.containsKey('valueWidget')
                          ? Column(children: [detail['valueWidget']])
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(detail['icon'],
                                    size: 50,
                                    color: Theme.of(context).iconTheme.color),
                                const SizedBox(height: 8),
                                Text(
                                  detail['key'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  detail['value'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  );
                } else if (detail is Widget) {
                  return detail;
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),
            ),
            const SizedBox(height: 10),
            // Nuevos elementos agregados
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: FutureBuilder<Map<String, String>>(
                future: _fetchMuscleGroups(widget.ejercicio),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, String> muscleGroups = snapshot.data!;
                    return Card(
                      elevation: 4.0,
                      child: Table(
                        border: TableBorder.all(
                          color: Colors.grey,
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(),
                          1: FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.green,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('Agonista:'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  muscleGroups['Agonista']!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('Sinergista:'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  muscleGroups['Sinergista']!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.orange,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('Estabilizador:'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  muscleGroups['Estabilizador']!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.red,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('Antagonista:'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  muscleGroups['Antagonista']!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>> _fetchMuscleGroups(Ejercicio ejercicio) async {
    try {
      // Asumiendo que el objeto 'ejercicio' ya contiene los campos necesarios
      return {
        'Agonista': ejercicio.agonistMuscle,
        'Antagonista': ejercicio.antagonistMuscle,
        'Sinergista': ejercicio.sinergistnistMuscle,
        'Estabilizador': ejercicio.estabiliMuscle,
      };
    } catch (e) {
      // Manejar el error según sea necesario
      return {
        'Agonista': 'Error',
        'Antagonista': 'Error',
        'Sinergista': 'Error',
        'Estabilizador': 'Error',
      };
    }
  }
}
