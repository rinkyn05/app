import 'package:flutter/material.dart';
import '../../screens/adaptacion_anatomica/anat_adapt_plan_creator.dart';
import '../../screens/ejercicios/exercises_abdomen_screen_vid.dart';
import '../../screens/ejercicios/exercises_antebrazo_screen_vid.dart';
import '../../screens/ejercicios/exercises_biceps_screen_vid.dart';
import '../../screens/ejercicios/exercises_cuadriceps_screen_vid.dart';
import '../../screens/ejercicios/exercises_cuello_screen.dart';
import '../../screens/ejercicios/exercises_deltoide_screen_vid.dart';
import '../../screens/ejercicios/exercises_espalda_screen.dart';
import '../../screens/ejercicios/exercises_gluteo_screen.dart';
import '../../screens/ejercicios/exercises_isquiotibiales_screen.dart';
import '../../screens/ejercicios/exercises_pantorilla_screen.dart';
import '../../screens/ejercicios/exercises_pectoral_screen_vid.dart';
import '../../screens/ejercicios/exercises_pierna_screen.dart';
import '../../screens/ejercicios/exercises_tibial_a_screen_vid.dart';
import '../../screens/ejercicios/exercises_triceps_screen.dart';

void navigateToExerciseScreen(BuildContext context, String title) {
  switch (title) {
    case 'Crear Plan':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnatAadaptPlanCreator()),
      );
    case 'Deltoide':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesDeltoideScreenVid()),
      );
      break;
    case 'Pectoral':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesPectoralScreenVid()),
      );
      break;
    case 'Bíceps':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesBicepsScreenVid()),
      );
      break;
    case 'Abdomen':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesAbdomenScreenVid()),
      );
      break;
    case 'Antebrazo':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesAntebrazoScreenVid()),
      );
      break;
    case 'Cuádriceps':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesCuadricepsScreenVid()),
      );
      break;
    case 'Espalda':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesEspaldaScreen()),
      );
    break;
    case 'Triceps':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesTricepsScreen()),
      );
    break;
    case 'Gluteos':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesGluteosScreen()),
      );
    break;
    case 'Piernas':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesPiernasScreen()),
      );
    break;
    case 'Pantorillas':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesPantorrillasScreen()),
      );
    break;
    case 'Cuello':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesCuelloScreen()),
      );
    break;
    case 'Isquiotibiales':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesIsquiotibialesScreen()),
      );
      break;
    case 'Tibial anterior':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExercisesTibialAScreenVid()),
      );
      break;
    default:
      break;
  }
}
