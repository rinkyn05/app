import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseNotifier extends ChangeNotifier {
  Map<String, bool> selectedExercises = {};

  ExerciseNotifier() {
    _loadSelectedExercises();
  }

  Future<void> _loadSelectedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    selectedExercises = {
      'Deltoide': prefs.getString('selected_body_part_deltoid') == 'Deltoide',
      'Pectoral': prefs.getString('selected_body_part_pectoral') == 'Pectoral',
      'Bíceps': prefs.getString('selected_body_part_biceps') == 'Bíceps',
      'Abdomen': prefs.getString('selected_body_part_abdomen') == 'Abdomen',
      'Antebrazo': prefs.getString('selected_body_part_antebrazo') == 'Antebrazo',
      'Cuádriceps': prefs.getString('selected_body_part_cuadriceps') == 'Cuádriceps',
      'Tibial anterior': prefs.getString('selected_body_part_tibial_anterior') == 'Tibial anterior',
    };
    notifyListeners();
  }

  Future<void> selectExercise(String bodyPart) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('selected_body_part_deltoid');
    await prefs.remove('selected_body_part_pectoral');
    await prefs.remove('selected_body_part_biceps');
    await prefs.remove('selected_body_part_abdomen');
    await prefs.remove('selected_body_part_antebrazo');
    await prefs.remove('selected_body_part_cuadriceps');
    await prefs.remove('selected_body_part_tibial_anterior');

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
    }

    await _loadSelectedExercises();
  }
}
