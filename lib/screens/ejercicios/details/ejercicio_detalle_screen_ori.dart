import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/models/ejercicio_model.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/notifiers/language_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../widgets/custom_appbar_new.dart';
import '../ejercicio_ejecucion_screen.dart';

class EjercicioDetalleScreenOri extends StatefulWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreenOri({Key? key, required this.ejercicio})
      : super(key: key);

  @override
  EjercicioDetalleScreenOriState createState() => EjercicioDetalleScreenOriState();
}

class EjercicioDetalleScreenOriState extends State<EjercicioDetalleScreenOri> {
  late YoutubePlayerController _controller;
  double _volume = 100.0;
  bool _isMuted = false;

  String _translate(BuildContext context, String esp, String eng) {
    String languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    return languageCode == 'es' ? esp : eng;
  }

  String _checkEquipmentRequirement(BuildContext context) {
    bool isWithoutEquipment = widget.ejercicio.equipment.every((equipmentItem) =>
        equipmentItem['NombreEsp'] == 'Sin Equipos' ||
        equipmentItem['NombreEng'] == 'Without Equipment');
    return isWithoutEquipment
        ? AppLocalizations.of(context)!.translate('notEquipmentRequired')
        : AppLocalizations.of(context)!.translate('equipmentRequired');
  }

  Widget _buildIntensityIcons(String intensity, BuildContext context) {
    int filledIcons;
    String translatedIntensity =
        _translate(context, widget.ejercicio.intensityEsp, widget.ejercicio.intensityEng);
    switch (translatedIntensity.toLowerCase()) {
      case 'low':
      case 'baja':
        filledIcons = 1;
        break;
      case 'medium':
      case 'media':
        filledIcons = 2;
        break;
      case 'high':
      case 'alta':
        filledIcons = 3;
        break;
      default:
        filledIcons = 0;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (index) => Icon(
                    Icons.flash_on,
                    color: index < filledIcons
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).disabledColor,
                    size: 50,
                  )),
        ),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.translate('intensity'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
        Text(translatedIntensity,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _getStanceWidget(String stance, BuildContext context) {
    String translatedStance =
        _translate(context, widget.ejercicio.stanceEsp, widget.ejercicio.stanceEng);
    IconData iconData;
    String textLabel;

    switch (translatedStance.toLowerCase()) {
      case 'parado':
      case 'standing':
        iconData = Icons.person;
        textLabel = AppLocalizations.of(context)!.translate('standing');
        break;
      case 'sentado':
      case 'sitting':
        iconData = Icons.chair_alt_rounded;
        textLabel = AppLocalizations.of(context)!.translate('sitting');
        break;
      case 'acostado':
      case 'lying down':
        iconData = Icons.bed_sharp;
        textLabel = AppLocalizations.of(context)!.translate('lyingDown');
        break;
      case 'saltando':
      case 'jumping':
        iconData = Icons.sports_handball_rounded;
        textLabel = AppLocalizations.of(context)!.translate('jumping');
        break;
      case 'corriendo':
      case 'running':
        iconData = Icons.directions_run;
        textLabel = AppLocalizations.of(context)!.translate('running');
        break;
      default:
        iconData = Icons.help_outline;
        textLabel = AppLocalizations.of(context)!.translate('Unknown');
    }

    return Column(
      children: [
        Icon(iconData, size: 50, color: Theme.of(context).iconTheme.color),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.translate('stance'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
        Text(textLabel,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center),
      ],
    );
  }

  void _toggleVolume() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = 100.0;
      } else {
        _isMuted = true;
        _volume = 0.0;
      }
      _controller.setVolume(_volume.toInt());
    });
  }

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.ejercicio.video) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false, // Deshabilitar subtítulos si es necesario
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String equipmentMessage = _checkEquipmentRequirement(context);
    final String contenido =
        _translate(context, widget.ejercicio.contenidoEsp, widget.ejercicio.contenidoEng);

    final List<Map<String, dynamic>> details = [
      {
        'key': AppLocalizations.of(context)!.translate('duration'),
        'value': widget.ejercicio.duracion,
        'icon': Icons.access_time,
      },
      {
        'key': AppLocalizations.of(context)!.translate('repetitions'),
        'value': widget.ejercicio.repeticiones,
        'icon': Icons.repeat,
      },
      {
        'valueWidget': _buildIntensityIcons(widget.ejercicio.intensidad, context),
      },
      {
        'valueWidget': _getStanceWidget(widget.ejercicio.estancia, context),
      },
      {
        'key': AppLocalizations.of(context)!.translate('calories'),
        'value': widget.ejercicio.calorias,
        'icon': Icons.local_fire_department,
      },
      {
        'key': AppLocalizations.of(context)!.translate('equipment'),
        'value': equipmentMessage,
        'icon': Icons.fitness_center,
      },
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
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.ejercicio.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 16,
                  height: 300),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: details.map((detail) {
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
                              Text(detail['key'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(detail['value'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                contenido,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.translate('howToDoExercise'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0)
                  .copyWith(left: 8.0, right: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    IconButton(
                      icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                      onPressed: _toggleVolume,
                    ),
                    IconButton(
                      icon: Icon(Icons.fullscreen_exit),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.translate('catEjerciciosName'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.ejercicio.catEjercicio
                      .map((e) => Chip(
                          label: Text(
                              _translate(
                                  context, e['NombreEsp'], e['NombreEng']),
                              style: Theme.of(context).textTheme.bodyMedium)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    AppLocalizations.of(context)!.translate('bodyParts'),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.ejercicio.bodyParts
                      .map((e) => Chip(
                          label: Text(
                              _translate(
                                  context, e['NombreEsp'], e['NombreEng']),
                              style: Theme.of(context).textTheme.bodyMedium)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    AppLocalizations.of(context)!.translate('equipments'),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.ejercicio.equipment
                      .map((e) => Chip(
                          label: Text(
                              _translate(
                                  context, e['NombreEsp'], e['NombreEng']),
                              style: Theme.of(context).textTheme.bodyMedium)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    AppLocalizations.of(context)!.translate('ocjetives'),
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: widget.ejercicio.objetivos
                      .map((e) => Chip(
                          label: Text(
                              _translate(
                                  context, e['NombreEsp'], e['NombreEng']),
                              style: Theme.of(context).textTheme.bodyMedium)))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EjercicioEjecucionScreen(
                    key: UniqueKey(),
                    ejercicio: widget.ejercicio,
                    auth: FirebaseAuth.instance,
                    firestore: FirebaseFirestore.instance,
                  )));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 2, 11, 59)
              : Colors.white,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[300]
              : const Color.fromARGB(255, 2, 11, 59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          padding: const EdgeInsets.all(20.0),
        ),
        icon: const Icon(
          Icons.play_arrow,
          size: 40,
        ),
        label: Text(
          AppLocalizations.of(context)!.translate('startt'),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}