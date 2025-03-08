import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/models/ejercicio_model.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/notifiers/language_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../widgets/custom_appbar_new.dart';
import 'ejercicio_detalle_screen_tred.dart';
import 'ejercicio_detalle_screen_vid_pers.dart';
import 'ejercicio_detalle_screen_vid_pers_fl.dart';
import 'ejercicio_detalle_screen_vid_pers_ob.dart';
import '../ejercicio_ejecucion_screen.dart';

class EjercicioDetalleScreen extends StatelessWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreen({Key? key, required this.ejercicio})
      : super(key: key);

  String _translate(BuildContext context, String esp, String eng) {
    String languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    return languageCode == 'es' ? esp : eng;
  }

  void _showOptionsDialog(BuildContext context) {
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
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EjercicioDetalleScreen(ejercicio: ejercicio),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Imagen 3D'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EjercicioDetalleScreenTred(ejercicio: ejercicio),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Video Personal Trainer'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EjercicioDetalleScreenVidPers(ejercicio: ejercicio),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Video Persona Obesa'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EjercicioDetalleScreenVidPersOb(ejercicio: ejercicio),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Video Persona Flaca'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EjercicioDetalleScreenVidPersFl(ejercicio: ejercicio),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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

  String _checkEquipmentRequirement(BuildContext context) {
    bool isWithoutEquipment = ejercicio.equipment.every((equipmentItem) =>
        equipmentItem['NombreEsp'] == 'Sin Equipos' ||
        equipmentItem['NombreEng'] == 'Without Equipment');
    return isWithoutEquipment
        ? AppLocalizations.of(context)!.translate('notEquipmentRequired')
        : AppLocalizations.of(context)!.translate('equipmentRequired');
  }

  Widget _buildIntensityIcons(String intensity, BuildContext context) {
    int filledIcons;
    String translatedIntensity =
        _translate(context, ejercicio.intensityEsp, ejercicio.intensityEng);
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
        _translate(context, ejercicio.stanceEsp, ejercicio.stanceEng);
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

  @override
  Widget build(BuildContext context) {
    final String equipmentMessage = _checkEquipmentRequirement(context);
    String videoId = YoutubePlayer.convertUrlToId(ejercicio.video) ?? '';

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    final String contenido =
        _translate(context, ejercicio.contenidoEsp, ejercicio.contenidoEng);

    final List<Map<String, dynamic>> details = [
      {
        'key': AppLocalizations.of(context)!.translate('duration'),
        'value': ejercicio.duracion,
        'icon': Icons.access_time,
      },
      {
        'key': AppLocalizations.of(context)!.translate('repetitions'),
        'value': ejercicio.repeticiones,
        'icon': Icons.repeat,
      },
      {
        'valueWidget': _buildIntensityIcons(ejercicio.intensidad, context),
      },
      {
        'valueWidget': _getStanceWidget(ejercicio.estancia, context),
      },
      {
        'key': AppLocalizations.of(context)!.translate('calories'),
        'value': ejercicio.calorias,
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
              child: Image.network(ejercicio.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 16,
                  height: 300),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showOptionsDialog(context);
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
                  controller: controller,
                  showVideoProgressIndicator: true,
                  onReady: () {},
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
                  children: ejercicio.catEjercicio
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
                  children: ejercicio.bodyParts
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
                  children: ejercicio.equipment
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
                  children: ejercicio.objetivos
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
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('Activacion de Musculo'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Nuevos elementos agregados
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
              child: FutureBuilder<Map<String, String>>(
                future: _fetchMuscleGroups(ejercicio),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, String> muscleGroups = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Agonista
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.green,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('Agonista:'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              muscleGroups['Agonista']!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Sinergista
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.yellow,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('Sinergista:'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              muscleGroups['Sinergista']!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Estabilizador
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.orange,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('Estabilizador:'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              muscleGroups['Estabilizador']!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Antagonista
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.red,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('Antagonista:'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              muscleGroups['Antagonista']!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 90),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EjercicioEjecucionScreen(
                    key: UniqueKey(),
                    ejercicio: ejercicio,
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
          padding: const EdgeInsets.all(10.0),
        ),
        icon: const Icon(
          Icons.play_arrow,
          size: 40,
        ),
        label: Text(
          AppLocalizations.of(context)!.translate('start'),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
