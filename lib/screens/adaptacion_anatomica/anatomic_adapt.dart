import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../config/helpers/navigation_helpers.dart';
import '../../config/notifiers/exercises_routine_notifier.dart';
import '../../config/notifiers/selection_notifier.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/info_card_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../rutinas/rutinas_screen.dart';

class AnatomicAdaptVideo extends StatefulWidget {
  @override
  _AnatomicAdaptVideoState createState() => _AnatomicAdaptVideoState();
}

class _AnatomicAdaptVideoState extends State<AnatomicAdaptVideo> {
  String selectedCard = '';
  bool isVideoVisible = true; // Estado para controlar la visibilidad del video

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  // Función para alternar la visibilidad del video
  void _toggleVideoVisibility() {
    setState(() {
      isVideoVisible = !isVideoVisible;
    });
  }

  Future<void> _onCardTap(String title) async {
    if (title == 'Crear Plan') {
      navigateToExerciseScreen(context, title);
      return;
    } else if (title == 'Espalda o Pectoral') {
      _showEspaldaOPectoralDialog();
      return;
    } else if (title == 'Cuadriceps Gluteos o Isquiotibiales') {
      _showCuadricepsGluteoIsquiotibialDialog();
      return;
    } else if (title == 'Limpiar') {
      _showClearConfirmationDialog();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    bool isCardTapped = prefs.getBool(title) ?? false;

    if (isCardTapped) {
      navigateToExerciseScreen(context, title);
    } else {
      prefs.setBool(title, true);
      setState(() {
        selectedCard = title;
      });
    }
  }

  // Función 1: Obtener los títulos de las tarjetas visibles
  List<String> _getVisibleCardTitles(SelectionNotifier notifier) {
    int cantidadDeEjerciciosEsp = int.tryParse(notifier.cantidadDeEjerciciosEsp
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    List<String> cardTitles;

    switch (cantidadDeEjerciciosEsp) {
      case 2:
        cardTitles = [
          'Espalda o Pectoral',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 3:
        cardTitles = [
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 4:
        cardTitles = [
          'Deltoide',
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 5:
        cardTitles = [
          'Deltoide',
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 6:
        cardTitles = [
          'Deltoide',
          'Espalda',
          'Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 7:
        cardTitles = [
          'Deltoide',
          'Espalda',
          'Bicep',
          'Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 8:
        cardTitles = [
          'Deltoide',
          'Espalda',
          'Bicep',
          'Pectoral',
          'Tricep',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      default:
        cardTitles = [];
    }

    return cardTitles;
  }

// Función 2: Obtener todos los valores almacenados, incluyendo los ejercicios seleccionados
  Future<Map<String, dynamic>> _getAllStoredValues() async {
    final prefs = await SharedPreferences.getInstance();
    final notifier = Provider.of<SelectionNotifier>(context, listen: false);

    // Obtener valores de SharedPreferences
    String intensityEsp = prefs.getString('intensityEsp') ?? 'Seleccionar';
    String intensityEng = prefs.getString('intensityEng') ?? 'Select';
    String calentamientoFisicoEsp =
        prefs.getString('calentamientoFisicoEsp') ?? 'Seleccionar';
    String calentamientoFisicoEng =
        prefs.getString('calentamientoFisicoEng') ?? 'Select';
    String estiramientoEstaticoEsp =
        prefs.getString('estiramientoEstaticoEsp') ?? 'Seleccionar';
    String estiramientoEstaticoEng =
        prefs.getString('estiramientoEstaticoEng') ?? 'Select';
    String cantidadDeEjerciciosEsp =
        prefs.getString('cantidadDeEjerciciosEsp') ?? 'Seleccionar';
    String cantidadDeEjerciciosEng =
        prefs.getString('cantidadDeEjerciciosEng') ?? 'Select';

    String selectedCalentamientoFisicoId =
        prefs.getString('selectedCalentamientoFisicoId') ?? '';
    String selectedCalentamientoFisicoNameEsp =
        prefs.getString('selectedCalentamientoFisicoNameEsp') ?? '';
    String selectedCalentamientoFisicoNameEng =
        prefs.getString('selectedCalentamientoFisicoNameEng') ?? '';

    String selectedEstiramientoFisicoId =
        prefs.getString('selectedEstiramientoFisicoId') ?? '';
    String selectedEstiramientoFisicoNameEsp =
        prefs.getString('selectedEstiramientoFisicoNameEsp') ?? '';
    String selectedEstiramientoFisicoNameEng =
        prefs.getString('selectedEstiramientoFisicoNameEng') ?? '';

    // Obtener valores de SelectionNotifier
    String descansoEntreEjerciciosEsp = notifier.descansoEntreEjerciciosEsp;
    String descansoEntreEjerciciosEng = notifier.descansoEntreEjerciciosEng;
    String descansoEntreCircuitoEsp = notifier.descansoEntreCircuitoEsp;
    String descansoEntreCircuitoEng = notifier.descansoEntreCircuitoEng;
    String diasALaSemanaEsp = notifier.diasALaSemanaEsp;
    String diasALaSemanaEng = notifier.diasALaSemanaEng;
    String calentamientoArticularEsp = notifier.calentamientoArticularEsp;
    String calentamientoArticularEng = notifier.calentamientoArticularEng;
    String repeticionesPorEjerciciosEsp = notifier.repeticionesPorEjerciciosEsp;
    String repeticionesPorEjerciciosEng = notifier.repeticionesPorEjerciciosEng;
    String cantidadDeCircuitosEsp = notifier.cantidadDeCircuitosEsp;
    String cantidadDeCircuitosEng = notifier.cantidadDeCircuitosEng;
    String porcentajeDeRMEsp = notifier.porcentajeDeRMEsp;
    String porcentajeDeRMEng = notifier.porcentajeDeRMEng;
    String nombreRutinaEsp = notifier.nombreRutinaEsp;
    String nombreRutinaEng = notifier.nombreRutinaEng;

    // Obtener los nombres de las tarjetas visibles
    List<String> cardTitles = _getVisibleCardTitles(notifier);

    // Obtener los ejercicios seleccionados
    List<String> exercisesTitles = await _getSelectedExercises(notifier);

    // Crear un mapa con todos los valores y los títulos de las tarjetas
    Map<String, dynamic> allValues = {
      'intensityEsp': intensityEsp,
      'intensityEng': intensityEng,
      'intensidadEsp': intensityEsp,
      'intensidadEng': intensityEng,
      'calentamientoFisicoEsp': calentamientoFisicoEsp,
      'calentamientoFisicoEng': calentamientoFisicoEng,
      'estiramientoEstaticoEsp': estiramientoEstaticoEsp,
      'estiramientoEstaticoEng': estiramientoEstaticoEng,
      'cantidadDeEjerciciosEsp': cantidadDeEjerciciosEsp,
      'cantidadDeEjerciciosEng': cantidadDeEjerciciosEng,
      'descansoEntreEjerciciosEsp': descansoEntreEjerciciosEsp,
      'descansoEntreEjerciciosEng': descansoEntreEjerciciosEng,
      'descansoEntreCircuitoEsp': descansoEntreCircuitoEsp,
      'descansoEntreCircuitoEng': descansoEntreCircuitoEng,
      'diasALaSemanaEsp': diasALaSemanaEsp,
      'diasALaSemanaEng': diasALaSemanaEng,
      'calentamientoArticularEsp': calentamientoArticularEsp,
      'calentamientoArticularEng': calentamientoArticularEng,
      'repeticionesPorEjerciciosEsp': repeticionesPorEjerciciosEsp,
      'repeticionesPorEjerciciosEng': repeticionesPorEjerciciosEng,
      'cantidadDeCircuitosEsp': cantidadDeCircuitosEsp,
      'cantidadDeCircuitosEng': cantidadDeCircuitosEng,
      'porcentajeDeRMEsp': porcentajeDeRMEsp,
      'porcentajeDeRMEng': porcentajeDeRMEng,
      'nombreRutinaEsp': nombreRutinaEsp,
      'nombreRutinaEng': nombreRutinaEng,
      'selectedCalentamientoFisicoId': selectedCalentamientoFisicoId,
      'selectedCalentamientoFisicoNameEsp': selectedCalentamientoFisicoNameEsp,
      'selectedCalentamientoFisicoNameEng': selectedCalentamientoFisicoNameEng,
      'selectedEstiramientoFisicoId': selectedEstiramientoFisicoId,
      'selectedEstiramientoFisicoNameEsp': selectedEstiramientoFisicoNameEsp,
      'selectedEstiramientoFisicoNameEng': selectedEstiramientoFisicoNameEng,
      'calentamientoFisicoId': selectedCalentamientoFisicoId,
      'calentamientoFisicoNameEsp': selectedCalentamientoFisicoNameEsp,
      'calentamientoFisicoNameEng': selectedCalentamientoFisicoNameEng,
      'estiramientoFisicoId': selectedEstiramientoFisicoId,
      'estiramientoFisicoNameEsp': selectedEstiramientoFisicoNameEsp,
      'estiramientoFisicoNameEng': selectedEstiramientoFisicoNameEng,
      'exercisesTitles': exercisesTitles,
      'cardTitles': cardTitles,
    };

    return allValues;
  }

// Función 3: Manejar el guardado de la rutina
  void _handleGuardarRutina() async {
    // Obtener todos los valores almacenados
    Map<String, dynamic> allValues = await _getAllStoredValues();

    // Verificar si algún valor seleccionado es 'Seleccionar' o está vacío
    bool isAnyValueDefault = allValues.values.any((value) {
      if (value is String) {
        return value == 'Seleccionar' || value == 'Select' || value.isEmpty;
      }
      return false;
    });

    if (isAnyValueDefault) {
      // Mostrar el diálogo de instrucciones
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Instrucciones para crear una rutina'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('1. Ve a Crear Plan.'),
                  Text('2. Configura tu plan y toca Guardar.'),
                  Text(
                      '3. Vuelve atrás y selecciona los ejercicios para tu rutina.'),
                  Text('4. Toca Guardar Rutina.'),
                  Text(
                      '5. Todas las tarjetas deben tener un ejercicio seleccionado para guardar la rutina.'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } else {
      // Mostrar el diálogo para guardar la rutina
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Deseas guardar tu rutina?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  sendToFirestore(
                      context); // Llamar a la nueva función para enviar a Firestore
                },
                child: Text('Crear'),
              ),
            ],
          );
        },
      );
    }
  }

// Función 4: Obtener los ejercicios seleccionados desde SharedPreferences
  Future<List<String>> _getSelectedExercises(SelectionNotifier notifier) async {
    final prefs = await SharedPreferences.getInstance();

    int cantidadDeEjerciciosEsp = int.tryParse(notifier.cantidadDeEjerciciosEsp
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    List<String> exercisesTitles = [];

    switch (cantidadDeEjerciciosEsp) {
      case 2:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda_o_pectoral') ??
                'Espalda o Pectoral');
        exercisesTitles.add(await prefs
                .getString('selected_exercise_name_espalda_o_pectoral') ??
            'Ejercicio 1');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 2');
        break;
      case 3:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda_o_pectoral') ??
                'Espalda o Pectoral');
        exercisesTitles.add(await prefs
                .getString('selected_exercise_name_espalda_o_pectoral') ??
            'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 2');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibionales') ??
            'Ejercicio 3');
        break;
      case 4:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_deltoide') ?? 'Deltoide');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_deltoide') ??
                'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda_o_pectoral') ??
                'Espalda o Pectoral');
        exercisesTitles.add(await prefs
                .getString('selected_exercise_name_espalda_o_pectoral') ??
            'Ejercicio 2');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 3');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 4');
        break;
      case 5:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_deltoide') ?? 'Deltoide');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_deltoide') ??
                'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda_o_pectoral') ??
                'Espalda o Pectoral');
        exercisesTitles.add(await prefs
                .getString('selected_exercise_name_espalda_o_pectoral') ??
            'Ejercicio 2');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 3');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 4');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pantorrillas') ??
                'Pantorrillas');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pantorrillas') ??
                'Ejercicio 5');
        break;
      case 6:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_deltoide') ?? 'Deltoide');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_deltoide') ??
                'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda') ?? 'Espalda');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_espalda') ??
                'Ejercicio 2');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pectoral') ?? 'Pectoral');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pectoral') ??
                'Ejercicio 3');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 4');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 5');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pantorrillas') ??
                'Pantorrillas');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pantorrillas') ??
                'Ejercicio 6');
        break;
      case 7:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_deltoide') ?? 'Deltoide');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_deltoide') ??
                'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda') ?? 'Espalda');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_espalda') ??
                'Ejercicio 2');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_bíceps') ?? 'Bíceps');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_bíceps') ??
                'Ejercicio 3');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pectoral') ?? 'Pectoral');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pectoral') ??
                'Ejercicio 4');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 5');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibionales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 6');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pantorrillas') ??
                'Pantorrillas');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pantorrillas') ??
                'Ejercicio 7');
        break;
      case 8:
        exercisesTitles.add(
            await prefs.getString('selected_body_part_deltoide') ?? 'Deltoide');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_deltoide') ??
                'Ejercicio 1');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_espalda') ?? 'Espalda');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_espalda') ??
                'Ejercicio 2');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_bíceps') ?? 'Bíceps');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_bíceps') ??
                'Ejercicio 3');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pectoral') ?? 'Pectoral');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pectoral') ??
                'Ejercicio 4');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_triceps') ?? 'Triceps');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_triceps') ??
                'Ejercicio 5');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_abdomen') ?? 'Abdomen');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_abdomen') ??
                'Ejercicio 6');
        exercisesTitles.add(await prefs.getString(
                'selected_body_part_cuadriceps_gluteos_o_isquiotibiales') ??
            'Cuadriceps Gluteos o Isquiotibiales');
        exercisesTitles.add(await prefs.getString(
                'selected_exercise_name_cuadriceps_gluteos_o_isquiotibiales') ??
            'Ejercicio 7');
        exercisesTitles.add(
            await prefs.getString('selected_body_part_pantorrillas') ??
                'Pantorrillas');
        exercisesTitles.add(
            await prefs.getString('selected_exercise_name_pantorrillas') ??
                'Ejercicio 8');
        break;
      default:
        exercisesTitles = [];
    }

    return exercisesTitles;
  }

//sendToFirestore

// Función para enviar los datos a Firestore
  Future<void> sendToFirestore(BuildContext context) async {
    // Obtener el usuario actual de Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Manejar el caso en que el usuario no está autenticado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Usuario no autenticado.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Obtener todos los valores almacenados
    Map<String, dynamic> allValues = await _getAllStoredValues();

    // Crear el mapa de datos a guardar en Firestore
    Map<String, dynamic> rutinaData = {
      'email': user.email,
      'EJERCICIOS': allValues['exercisesTitles'],
      'fecha': FieldValue.serverTimestamp(),
      'intensityEsp': allValues['intensidadEsp'],
      'intensityEng': allValues['intensidadEng'],
      'intensityEspa': allValues['intensityEsp'],
      'intensityEngl': allValues['intensityEng'],
      'intensidadEsp': allValues['intensidadEsp'],
      'intensidadEng': allValues['intensidadEng'],
      'calentamientoFisicoEsp': allValues['calentamientoFisicoEsp'],
      'calentamientoFisicoEng': allValues['calentamientoFisicoEng'],
      'descansoEntreEjerciciosEsp': allValues['descansoEntreEjerciciosEsp'],
      'descansoEntreEjerciciosEng': allValues['descansoEntreEjerciciosEng'],
      'descansoEntreCircuitoEsp': allValues['descansoEntreCircuitoEsp'],
      'descansoEntreCircuitoEng': allValues['descansoEntreCircuitoEng'],
      'estiramientoEstaticoEsp': allValues['estiramientoEstaticoEsp'],
      'estiramientoEstaticoEng': allValues['estiramientoEstaticoEng'],
      'diasALaSemanaEsp': allValues['diasALaSemanaEsp'],
      'diasALaSemanaEng': allValues['diasALaSemanaEng'],
      'calentamientoArticularEsp': allValues['calentamientoArticularEsp'],
      'calentamientoArticularEng': allValues['calentamientoArticularEng'],
      'cantidadDeEjerciciosEsp': allValues['cantidadDeEjerciciosEsp'],
      'cantidadDeEjerciciosEng': allValues['cantidadDeEjerciciosEng'],
      'repeticionesPorEjerciciosEsp': allValues['repeticionesPorEjerciciosEsp'],
      'repeticionesPorEjerciciosEng': allValues['repeticionesPorEjerciciosEng'],
      'cantidadDeCircuitosEsp': allValues['cantidadDeCircuitosEsp'],
      'cantidadDeCircuitosEng': allValues['cantidadDeCircuitosEng'],
      'porcentajeDeRMEsp': allValues['porcentajeDeRMEsp'],
      'porcentajeDeRMEng': allValues['porcentajeDeRMEng'],
      'nombreRutinaEsp': allValues['nombreRutinaEsp'],
      'nombreRutinaEng': allValues['nombreRutinaEng'],
      'calentamientoFisicoId': allValues['calentamientoFisicoId'],
      'calentamientoFisicoNameEsp': allValues['calentamientoFisicoNameEsp'],
      'calentamientoFisicoNameEng': allValues['calentamientoFisicoNameEng'],
      'estiramientoFisicoId': allValues['estiramientoFisicoId'],
      'estiramientoFisicoNameEsp': allValues['estiramientoFisicoNameEsp'],
      'estiramientoFisicoNameEng': allValues['estiramientoFisicoNameEng'],
      'selectedCalentamientoFisicoId':
          allValues['selectedCalentamientoFisicoId'],
      'selectedCalentamientoFisicoNameEsp':
          allValues['selectedCalentamientoFisicoNameEsp'],
      'selectedCalentamientoFisicoNameEng':
          allValues['selectedCalentamientoFisicoNameEng'],
      'selectedEstiramientoFisicoId': allValues['selectedEstiramientoFisicoId'],
      'selectedEstiramientoFisicoNameEsp':
          allValues['selectedEstiramientoFisicoNameEsp'],
      'selectedEstiramientoFisicoNameEng':
          allValues['selectedEstiramientoFisicoNameEng'],
    };

    // Guardar la rutina en Firestore
    FirebaseFirestore.instance
        .collection('misRutinas')
        .add(rutinaData)
        .then((value) {
      // Mostrar un snackbar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La rutina se guardó con éxito.'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar las selecciones después de guardar
      _limpiarSelecciones();

      // Cerrar el diálogo
      Navigator.of(context).pop();
    }).catchError((error) {
      // Mostrar un diálogo de error si falla el guardado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('La rutina no se pudo guardar.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    });
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.warning,
            color: Colors.red,
            size: 40,
          ),
          content: Text(
              '¿Estás seguro de que deseas borrar tus selecciones para la rutina?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _limpiarSelecciones();
                Navigator.of(context).pop();
              },
              child: Text('Limpiar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _limpiarSelecciones() async {
    final prefs = await SharedPreferences.getInstance();

    // Restablecer valores de SelectionNotifier en SharedPreferences
    await prefs.setBool('isCardTapped', false);
    await prefs.setString('selected_title', '');

    // Restablecer valores de SelectionNotifier
    Provider.of<SelectionNotifier>(context, listen: false).updateSelection(
      intensityEsp: 'Seleccionar',
      intensityEng: 'Select',
      calentamientoFisicoEsp: 'Seleccionar',
      calentamientoFisicoEng: 'Select',
      descansoEntreEjerciciosEsp: 'Seleccionar',
      descansoEntreEjerciciosEng: 'Select',
      descansoEntreCircuitoEsp: 'Seleccionar',
      descansoEntreCircuitoEng: 'Select',
      estiramientoEstaticoEsp: 'Seleccionar',
      estiramientoEstaticoEng: 'Select',
      diasALaSemanaEsp: 'Seleccionar',
      diasALaSemanaEng: 'Select',
      calentamientoArticularEsp: '5 Minutos',
      calentamientoArticularEng: '5 Minutes',
      cantidadDeEjerciciosEsp: 'Seleccionar',
      cantidadDeEjerciciosEng: 'Select',
      repeticionesPorEjerciciosEsp: 'Seleccionar',
      repeticionesPorEjerciciosEng: 'Select',
      cantidadDeCircuitosEsp: 'Seleccionar',
      cantidadDeCircuitosEng: 'Select',
      porcentajeDeRMEsp: 'Seleccionar',
      porcentajeDeRMEng: 'Select',
      nombreRutinaEsp: '',
      nombreRutinaEng: '',
      calentamientoFisicoNames: {},
      selectedCalentamientoFisicoId: null,
      selectedCalentamientoFisicoNameEsp: null,
      selectedCalentamientoFisicoNameEng: null,
      estiramientoFisicoNames: {},
      selectedEstiramientoFisicoId: null,
      selectedEstiramientoFisicoNameEsp: null,
      selectedEstiramientoFisicoNameEng: null,
    );

    // Restablecer valores de ExerciseNotifier en SharedPreferences
    final exerciseNotifier =
        Provider.of<ExerciseNotifier>(context, listen: false);

    // Lista de títulos de ejercicios predeterminados
    List<String> defaultExerciseTitles = [
      'Cuadriceps Gluteos o Isquiotibiales',
      'Espalda o Pectoral',
      'Deltoide',
      'Pectoral',
      'Bicep',
      'Abdomen',
      'Antebrazo',
      'Cuádriceps',
      'Espalda',
      'Triceps',
      'Gluteos',
      'Piernas',
      'Pantorrillas',
      'Cuello',
      'Isquiotibiales',
      'Tibial anterior',
    ];

    // Restablecer los valores de los ejercicios seleccionados en SharedPreferences
    for (String title in defaultExerciseTitles) {
      String key =
          'selected_exercise_name_${title.toLowerCase().replaceAll(' ', '_')}';
      await prefs.setString(key, title);
      await prefs.setString(
          'selected_exercise_details_$title', 'Detalles del ejercicio $title');
      exerciseNotifier.selectedExercises[title] = false;
    }

    // Eliminar los valores de selectedExerciseName
    for (String title in defaultExerciseTitles) {
      String key =
          'selected_exercise_name_${title.toLowerCase().replaceAll(' ', '_')}';
      await prefs.remove(key);
    }

    // Restablecer los valores de las preferencias adicionales
    await prefs.remove('selected_body_part_deltoid');
    await prefs.remove('selected_body_part_pectoral');
    await prefs.remove('selected_body_part_biceps');
    await prefs.remove('selected_body_part_abdomen');
    await prefs.remove('selected_body_part_antebrazo');
    await prefs.remove('selected_body_part_cuadriceps');
    await prefs.remove('selected_body_part_tibial_anterior');
    await prefs.remove('selected_body_part_espalda');
    await prefs.remove('selected_body_part_triceps');
    await prefs.remove('selected_body_part_gluteos');
    await prefs.remove('selected_body_part_piernas');
    await prefs.remove('selected_body_part_pantorrillas');
    await prefs.remove('selected_body_part_cuello');
    await prefs.remove('selected_body_part_isquiotibiales');
    await prefs
        .remove('selected_body_part_cuadriceps_gluteos_o_isquiotibiales');
    await prefs.remove('selected_body_part_espalda_o_pectoral');

    // Restablecer los valores de ExerciseNotifier
    exerciseNotifier.selectedExercises = {
      'Cuadriceps Gluteos o Isquiotibiales': false,
      'Espalda o Pectoral': false,
      'Deltoide': false,
      'Pectoral': false,
      'Bicep': false,
      'Abdomen': false,
      'Antebrazo': false,
      'Cuádriceps': false,
      'Espalda': false,
      'Triceps': false,
      'Gluteos': false,
      'Piernas': false,
      'Pantorrillas': false,
      'Cuello': false,
      'Isquiotibiales': false,
      'Tibial anterior': false,
    };
    //exerciseNotifier.notifyListeners();

    // Restablecer el estado de la tarjeta seleccionada
    setState(() {
      selectedCard = '';
    });

    // Cerrar el diálogo
    // Navigator.of(context).pop();
  }

  void _showEspaldaOPectoralDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una parte del cuerpo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: ListTile(
                  title: Text('Espalda'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToExerciseScreen(context, 'Espalda');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Pectoral'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToExerciseScreen(context, 'Pectoral');
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showCuadricepsGluteoIsquiotibialDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una parte del cuerpo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: ListTile(
                  title: Text('Cuádriceps'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToExerciseScreen(context, 'Cuádriceps');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Glúteos'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToExerciseScreen(context, 'Gluteos');
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Isquiotibiales'),
                  onTap: () {
                    Navigator.pop(context);
                    navigateToExerciseScreen(context, 'Isquiotibiales');
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  List<CardWidget> _getFilteredCards(SelectionNotifier notifier) {
    int cantidadDeEjerciciosEsp = int.tryParse(notifier.cantidadDeEjerciciosEsp
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    print("Valor de cantidadDeEjerciciosEsp: $cantidadDeEjerciciosEsp");

    List<String> cardTitles;

    switch (cantidadDeEjerciciosEsp) {
      case 2:
        cardTitles = [
          'Crear Plan',
          'Espalda o Pectoral',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 3:
        cardTitles = [
          'Crear Plan',
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 4:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales'
        ];
        break;
      case 5:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Espalda o Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 6:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Espalda',
          'Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 7:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Espalda',
          'Bicep',
          'Pectoral',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      case 8:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Espalda',
          'Bicep',
          'Pectoral',
          'Tricep',
          'Abdomen',
          'Cuadriceps Gluteos o Isquiotibiales',
          'Pantorrillas'
        ];
        break;
      default:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Pectoral',
          'Bicep',
          'Abdomen',
          'Antebrazo',
          'Cuadriceps',
          'Espalda',
          'Triceps',
          'Gluteos',
          'Piernas',
          'Pantorrillas',
          'Cuello',
          'Isquiotibiales',
          'Tibial anterior',
          'Limpiar'
        ];
    }

    return [
      CardWidget(title: 'Crear Plan', description: '', onCardTap: _onCardTap),
      CardWidget(
          title: 'Deltoide',
          description:
              'Músculo del hombro responsable de levantar el brazo y rotarlo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Espalda o Pectoral',
          description: 'Zona media y superior del torso.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Espalda',
          description:
              'Conjunto de músculos que permiten la postura, el movimiento de la columna y el soporte del cuerpo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Pectoral',
          description:
              'Músculo grande del pecho que permite mover el brazo hacia adelante y hacia adentro.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Bicep',
          description:
              'Músculo del brazo que permite flexionar el codo y girar el antebrazo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Tricep',
          description:
              'Músculo en la parte posterior del brazo que extiende el codo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Abdomen',
          description:
              'Grupo muscular que ayuda a la postura, respiración y protección de órganos internos.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Cuadriceps Gluteos o Isquiotibiales',
          description:
              'Músculos principales de las piernas responsables del movimiento y soporte.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Pantorrillas',
          description:
              'Músculos en la parte posterior inferior de la pierna que permiten empujar el pie hacia abajo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Antebrazo',
          description:
              'Grupo de músculos entre el codo y la muñeca que controlan el movimiento de la mano y dedos.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Cuadriceps',
          description:
              'Músculo frontal del muslo que permite extender la pierna y estabilizar la rodilla.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Gluteos',
          description:
              'Grupo de músculos grandes de la cadera que permiten caminar, correr y mantenerse de pie.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Piernas',
          description:
              'Músculos que permiten el movimiento y soporte del cuerpo al caminar y correr.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Pantorrillas',
          description:
              'Músculos en la parte posterior inferior de la pierna que permiten empujar el pie hacia abajo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Cuello',
          description:
              'Músculos que soportan la cabeza y permiten sus movimientos.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Isquiotibiales',
          description:
              'Músculos en la parte posterior del muslo que permiten flexionar la rodilla y extender la cadera.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Tibial anterior',
          description:
              'Músculo en la parte frontal de la espinilla que levanta el pie.',
          onCardTap: _onCardTap),
      CardWidget(title: 'Limpiar', description: '', onCardTap: _onCardTap),
    ].where((card) => cardTitles.contains(card.title)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<SelectionNotifier>(
        builder: (context, notifier, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Adaptacion Anatomica',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: isVideoVisible
                    ? YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          debugPrint("Video is ready.");
                        },
                      )
                    : SizedBox.shrink(),
              ),
              TextButton.icon(
                onPressed:
                    _toggleVideoVisibility, // Cambiar la función del botón
                icon: Icon(
                    isVideoVisible ? Icons.visibility_off : Icons.visibility),
                label: Text(isVideoVisible
                    ? 'Ocultar'
                    : 'Mostrar'), // Texto estático en español
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RutinasScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Mis Rutinas'),
                    ),
                  ),

                  SizedBox(width: 10), // Espacio entre botones
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleGuardarRutina();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Guardar Rutina'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: isVideoVisible ? 300 : 550,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: _getFilteredCards(notifier),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 2),
                          Expanded(
                            child: ModelViewer(
                              backgroundColor:
                                  const Color.fromARGB(255, 50, 50, 50),
                              src: 'assets/tre_d/cuerpo07.glb',
                              alt: 'A 3D model of a Human Body',
                              ar: true,
                              autoRotate: false,
                              disableZoom: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          selectedCard.isNotEmpty
                              ? InfoCardWidget(
                                  title: selectedCard,
                                  onClose: () {
                                    setState(() {
                                      selectedCard = '';
                                    });
                                  },
                                  onNavigateToExercise: () {
                                    navigateToExerciseScreen(
                                        context, selectedCard);
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
