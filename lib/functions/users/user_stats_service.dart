import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserStats(
      String userEmail, int exerciseTimeSeconds, int caloriesBurned) async {
    final userStatsRef = _firestore.collection('userstats').doc(userEmail);
    final userStatsDoc = await userStatsRef.get();

    int existingExerciseSeconds = 0;
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('tiempoDeEjercicios')) {
      existingExerciseSeconds =
          _timeToSeconds(userStatsDoc['tiempoDeEjercicios']);
    }

    int totalExerciseSeconds = existingExerciseSeconds + exerciseTimeSeconds;

    String formattedExerciseTime = _secondsToTime(totalExerciseSeconds);

    int existingCaloriesBurned = 0;
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('caloriasQuemadas')) {
      existingCaloriesBurned = userStatsDoc['caloriasQuemadas'];
    }

    int totalCaloriesBurned = existingCaloriesBurned + caloriesBurned;

    int existingExerciseCount = 0;
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('ejerciciosRealizados')) {
      existingExerciseCount = userStatsDoc['ejerciciosRealizados'];
    }

    int totalExerciseCount = existingExerciseCount + 1;

    final Map<String, dynamic> userData = {
      'correoUsuario': userEmail,
      'tiempoDeEjercicios': formattedExerciseTime,
      'ejerciciosRealizados': totalExerciseCount,
      'caloriasQuemadas': totalCaloriesBurned,
    };

    await userStatsRef.set(userData, SetOptions(merge: true));
  }

  String _secondsToTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:${_formatTimeComponent(minutes)}:${_formatTimeComponent(remainingSeconds)}';
  }

  int _timeToSeconds(String time) {
    List<String> components = time.split(':');
    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

  String _formatTimeComponent(int component) {
    return component < 10 ? '0$component' : '$component';
  }

  Future<void> updateUserStatsForRutinas(String userEmail) async {
    final userStatsRef = _firestore.collection('userstats').doc(userEmail);
    final userStatsDoc = await userStatsRef.get();

    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('rutinascompletadas')) {
      int existingCompletedRoutines = userStatsDoc['rutinascompletadas'];
      int totalCompletedRoutines = existingCompletedRoutines + 1;
      await userStatsRef.update({'rutinascompletadas': totalCompletedRoutines});
    } else {
      await userStatsRef
          .set({'rutinascompletadas': 1}, SetOptions(merge: true));
    }
  }
}
