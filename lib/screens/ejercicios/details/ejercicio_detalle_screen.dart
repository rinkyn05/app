import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../backend/models/ejercicio_model.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/notifiers/language_notifier.dart';
import '../../../config/utils/appcolors.dart';
import '../../../widgets/custom_appbar_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EjercicioDetalleScreen extends StatefulWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreen({Key? key, required this.ejercicio})
      : super(key: key);

  @override
  _EjercicioDetalleScreenState createState() => _EjercicioDetalleScreenState();
}

class _EjercicioDetalleScreenState extends State<EjercicioDetalleScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _translate(BuildContext context, String esp, String eng) {
    String languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    return languageCode == 'es' ? esp : eng;
  }

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

  Widget _getStanceWidget(String stance, BuildContext context) {
    String translatedStance = _translate(
        context, widget.ejercicio.stanceEsp, widget.ejercicio.stanceEng);
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

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2 - 8,
      ),
      child: FutureBuilder(
        future:
            Future.value(true), // Simulamos un Future para usar el mismo diseño
        builder: (context, snapshot) {
          return Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Título
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AppLocalizations.of(context)!.translate('stance'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Icono de la postura
                  Icon(
                    iconData,
                    size: 60,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(height: 8),
                  // Texto de la postura
                  Text(
                    textLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImpactLevel() {
    String nivelDeImpacto;
    if (Localizations.localeOf(context).languageCode == 'es') {
      nivelDeImpacto = widget.ejercicio.nivelDeImpactoEsp;
    } else {
      nivelDeImpacto = widget.ejercicio.nivelDeImpactoEng;
    }

    String starImage;
    switch (nivelDeImpacto) {
      case 'Bajo':
      case 'Low':
        starImage = '1 estrella.png';
        break;
      case 'Regular':
        starImage = '2 estrellas.png';
        break;
      case 'Medio':
      case 'Medium':
        starImage = '3 estrellas.png';
        break;
      case 'Bueno':
      case 'Good':
        starImage = '4 estrellas.png';
        break;
      case 'Alto':
      case 'High':
        starImage = '5 estrellas.png';
        break;
      default:
        starImage = '5 estrella.png';
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2 - 8,
      ),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppLocalizations.of(context)!.translate('nivelDeImpacto'),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Imagen de estrellas
              Image.asset(
                'assets/icons/$starImage',
                width: double.infinity,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              // Valor
              Text(
                nivelDeImpacto,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyLevel() {
    String dificultad;
    if (Localizations.localeOf(context).languageCode == 'es') {
      dificultad = widget.ejercicio.intensidad;
    } else {
      dificultad = widget.ejercicio.intensidad;
    }

    String difficultyImage;
    switch (dificultad) {
      case 'Fácil':
      case 'Easy':
        difficultyImage = 'facil.png';
        break;
      case 'Medio':
      case 'Medium':
        difficultyImage = 'medio.png';
        break;
      case 'Avanzado':
      case 'Advanced':
        difficultyImage = 'avanzado.png';
        break;
      case 'Difícil':
      case 'Difficult':
        difficultyImage = 'dificil.png';
        break;
      default:
        difficultyImage = 'avanzado.png';
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2 - 8,
      ),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppLocalizations.of(context)!.translate('dificultad'),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Imagen de dificultad
              Image.asset(
                'assets/icons/$difficultyImage',
                width: double.infinity,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              // Valor
              Text(
                dificultad,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> _fetchBodyPartDetails(String bodyPartId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('bodyp').doc(bodyPartId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String nombre = Localizations.localeOf(context).languageCode == 'es'
            ? data['NombreEsp'] ?? ''
            : data['NombreEng'] ?? '';
        String imageUrl = data['URL de la Imagen'] ?? '';
        return {'nombre': nombre, 'imageUrl': imageUrl};
      } else {
        return {'nombre': '', 'imageUrl': ''};
      }
    } catch (e) {
      return {'nombre': '', 'imageUrl': ''};
    }
  }

  Widget _buildBodyParts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Widget>>(
          future: Future.wait(widget.ejercicio.bodyParts.map((part) async {
            String bodyPartId = part['id'] ?? '';
            Map<String, String> details =
                await _fetchBodyPartDetails(bodyPartId);
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2 -
                    8, // Ensures the card doesn't exceed half the screen width
              ),
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centrado horizontal
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrado vertical
                    children: [
                      // Nombre de la parte del cuerpo
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          details['nombre'] ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center, // Texto centrado
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Imagen
                      Image.network(
                        details['imageUrl'] ?? '',
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit
                            .contain, // Asegura que la imagen se ajuste al tamaño de la tarjeta
                      ),
                      const SizedBox(height: 8.0),
                      // Título "Músculo Objetivo"
                      Text(
                        AppLocalizations.of(context)!.translate('Musculo'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center, // Texto centrado
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Widget> bodyPartsWidgets = snapshot.data ?? [];
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: bodyPartsWidgets,
              );
            }
          },
        ),
      ],
    );
  }

  Future<Map<String, String>> _fetchEquipmentDetails(String equipmentId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('equipment').doc(equipmentId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String nombre = Localizations.localeOf(context).languageCode == 'es'
            ? data['NombreEsp'] ?? ''
            : data['NombreEng'] ?? '';
        String imageUrl = data['URL de la Imagen'] ?? '';
        return {'nombre': nombre, 'imageUrl': imageUrl};
      } else {
        return {'nombre': '', 'imageUrl': ''};
      }
    } catch (e) {
      return {'nombre': '', 'imageUrl': ''};
    }
  }

  Widget _buildEquipment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Widget>>(
          future: Future.wait(widget.ejercicio.equipment.map((equip) async {
            String equipmentId = equip['id'] ?? '';
            Map<String, String> details =
                await _fetchEquipmentDetails(equipmentId);
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2 -
                    8, // Ensures the card doesn't exceed half the screen width
              ),
              child: Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centrado horizontal
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrado vertical
                    children: [
                      // Nombre del equipo
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          details['nombre'] ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center, // Texto centrado
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Imagen
                      Image.network(
                        details['imageUrl'] ?? '',
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit
                            .contain, // Asegura que la imagen se ajuste al tamaño de la tarjeta
                      ),
                      const SizedBox(height: 8.0),
                      // Título "Equipo"
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context)!.translate('Equipo'),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center, // Texto centrado
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Widget> equipmentWidgets = snapshot.data ?? [];
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: equipmentWidgets,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNombre() {
    return Padding(
      padding:
          const EdgeInsets.all(16.0), // Ajusta el padding según sea necesario
      child: Text(
        widget.ejercicio.nombre,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ), // Usa un estilo de texto adecuado
        textAlign: TextAlign.center, // Centra el texto si lo deseas
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> details = [
      _buildBodyParts(),
      _buildEquipment(),
      _buildImpactLevel(),
      _buildDifficultyLevel(),
      {
        'valueWidget': _getStanceWidget(widget.ejercicio.estancia, context),
      }
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
            _buildNombre(),
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
                left: 8.0,
                top: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('activacionDeMusculos'),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  // Tabla de músculos
                  FutureBuilder<Map<String, String>>(
                    future: _fetchMuscleGroups(widget.ejercicio),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        Map<String, String> muscleGroups = snapshot.data!;
                        return Card(
                          elevation: 4.0,
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
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
                ],
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
