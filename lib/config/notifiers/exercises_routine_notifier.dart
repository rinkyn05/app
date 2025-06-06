import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca para manejar Shared Preferences.

class ExerciseNotifier extends ChangeNotifier {
  // Mapa que almacena los ejercicios seleccionados y su estado (true/false).
  Map<String, bool> selectedExercises = {};

  // Constructor que carga los ejercicios seleccionados al inicializar la clase.
  ExerciseNotifier() {
    _loadSelectedExercises(); // Carga los ejercicios seleccionados al crear el objeto.
  }

  // Método privado que carga los ejercicios seleccionados desde Shared Preferences.
  Future<void> _loadSelectedExercises() async {
    final prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de Shared Preferences.

    // Carga el estado de cada parte del cuerpo desde Shared Preferences y lo asigna al mapa.
    selectedExercises = {
      'Deltoide': prefs.getString('selected_body_part_deltoid') == 'Deltoide',
      'Pectoral': prefs.getString('selected_body_part_pectoral') == 'Pectoral',
      'Bíceps': prefs.getString('selected_body_part_biceps') == 'Bíceps',
      'Abdomen': prefs.getString('selected_body_part_abdomen') == 'Abdomen',
      'Antebrazo':
          prefs.getString('selected_body_part_antebrazo') == 'Antebrazo',
      'Cuádriceps':
          prefs.getString('selected_body_part_cuadriceps') == 'Cuádriceps',
      'Tibial anterior':
          prefs.getString('selected_body_part_tibial_anterior') ==
              'Tibial anterior',
      'Espalda': prefs.getString('selected_body_part_espalda') == 'Espalda',
      'Triceps': prefs.getString('selected_body_part_triceps') == 'Triceps',
      'Glúteo ': prefs.getString('selected_body_part_gluteos') == 'Glúteo ',
      'Piernas': prefs.getString('selected_body_part_piernas') == 'Piernas',
      'Pantorrillas': prefs.getString('selected_body_part_pantorrillas') == 'Pantorrillas',
      'Cuello': prefs.getString('selected_body_part_cuello') == 'Cuello',
      'Isquiotibiales': prefs.getString('selected_body_part_isquiotibiales') == 'Isquiotibiales',

      'Cuadriceps Gluteos o Isquiotibiales': prefs.getString('selected_body_part_cuadriceps_gluteos_o_isquiotibiales') == 'Cuadriceps Gluteos o Isquiotibiales',
      'Espalda o Pectoral': prefs.getString('selected_body_part_espalda_o_pectoral') == 'Espalda o Pectoral',
    };

    notifyListeners(); // Notifica a los oyentes que el estado ha cambiado.
  }

  // Método para seleccionar un ejercicio basado en la parte del cuerpo.
  Future<void> selectExercise(String bodyPart) async {
    final prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de Shared Preferences.

    // Elimina los ejercicios seleccionados anteriores de Shared Preferences.
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

    await prefs.remove('selected_body_part_cuadriceps_gluteos_o_isquiotibiales');
    await prefs.remove('selected_body_part_espalda_o_pectoral');

    // Almacena el nuevo ejercicio seleccionado en Shared Preferences.
    if (bodyPart == 'Deltoide') {
      await prefs.setString('selected_body_part_deltoid', bodyPart);
    } else if (bodyPart == 'Pectoral') {
      await prefs.setString('selected_body_part_pectoral', bodyPart);
    } else if (bodyPart == 'Bíceps') {
      await prefs.setString('selected_body_part_biceps', bodyPart);
    } else if (bodyPart == 'Abdomen') {
      await prefs.setString('selected_body_part_abdomen', bodyPart);
    } else if (bodyPart == 'Antebrazo') {
      await prefs.setString('selected_body_part_antebrazo', bodyPart);
    } else if (bodyPart == 'Cuádriceps') {
      await prefs.setString('selected_body_part_cuadriceps', bodyPart);
    } else if (bodyPart == 'Tibial anterior') {
      await prefs.setString('selected_body_part_tibial_anterior', bodyPart);
    } else if (bodyPart == 'Espalda') {
      await prefs.setString('selected_body_part_espalda', bodyPart);
    } else if (bodyPart == 'Triceps') {
      await prefs.setString('selected_body_part_triceps', bodyPart);
    } else if (bodyPart == 'Glúteo') {
      await prefs.setString('selected_body_part_gluteos', bodyPart);
    } else if (bodyPart == 'Piernas') {
      await prefs.setString('selected_body_part_piernas', bodyPart);
    } else if (bodyPart == 'Pantorrillas') {
      await prefs.setString('selected_body_part_pantorrillas', bodyPart);
    } else if (bodyPart == 'Cuello') {
      await prefs.setString('selected_body_part_cuello', bodyPart);
    } else if (bodyPart == 'Isquiotibiales') {
      await prefs.setString('selected_body_part_isquiotibiales', bodyPart);
    } else if (bodyPart == 'Cuadriceps Gluteos o Isquiotibiales') {
      await prefs.setString('selected_body_part_cuadriceps_gluteos_o_isquiotibiales', bodyPart);
    } else if (bodyPart == 'Espalda o Pectoral') {
      await prefs.setString('selected_body_part_espalda_o_pectoral', bodyPart);
    }

    // Carga nuevamente los ejercicios seleccionados después de actualizar.
    await _loadSelectedExercises();
  }
}
