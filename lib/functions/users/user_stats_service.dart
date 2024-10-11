import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos.

/// Servicio para manejar las estadísticas del usuario en Firestore.
class UserStatsService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Inicializa la instancia de Firestore.

  /// Actualiza las estadísticas del usuario en Firestore.
  ///
  /// [userEmail] es el correo electrónico del usuario.
  /// [exerciseTimeSeconds] es el tiempo de ejercicio en segundos.
  /// [caloriesBurned] es la cantidad de calorías quemadas.
  Future<void> updateUserStats(
      String userEmail, int exerciseTimeSeconds, int caloriesBurned) async {
    final userStatsRef = _firestore
        .collection('userstats')
        .doc(userEmail); // Referencia al documento de estadísticas del usuario.
    final userStatsDoc =
        await userStatsRef.get(); // Obtiene el documento de estadísticas.

    // Inicializa el tiempo de ejercicio existente.
    int existingExerciseSeconds = 0;
    // Si el documento existe y contiene el campo 'tiempoDeEjercicios', obtén su valor.
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('tiempoDeEjercicios')) {
      existingExerciseSeconds = _timeToSeconds(userStatsDoc[
          'tiempoDeEjercicios']); // Convierte el tiempo formateado a segundos.
    }

    // Suma el tiempo de ejercicio existente al nuevo tiempo de ejercicio.
    int totalExerciseSeconds = existingExerciseSeconds + exerciseTimeSeconds;

    // Formatea el tiempo total de ejercicio en un formato legible.
    String formattedExerciseTime = _secondsToTime(totalExerciseSeconds);

    // Inicializa las calorías quemadas existentes.
    int existingCaloriesBurned = 0;
    // Si el documento existe y contiene el campo 'caloriasQuemadas', obtén su valor.
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('caloriasQuemadas')) {
      existingCaloriesBurned = userStatsDoc['caloriasQuemadas'];
    }

    // Suma las calorías quemadas existentes a las nuevas calorías quemadas.
    int totalCaloriesBurned = existingCaloriesBurned + caloriesBurned;

    // Inicializa el contador de ejercicios realizados existentes.
    int existingExerciseCount = 0;
    // Si el documento existe y contiene el campo 'ejerciciosRealizados', obtén su valor.
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('ejerciciosRealizados')) {
      existingExerciseCount = userStatsDoc['ejerciciosRealizados'];
    }

    // Incrementa el contador total de ejercicios realizados.
    int totalExerciseCount = existingExerciseCount + 1;

    // Crea un mapa con los datos del usuario a actualizar.
    final Map<String, dynamic> userData = {
      'correoUsuario': userEmail,
      'tiempoDeEjercicios': formattedExerciseTime,
      'ejerciciosRealizados': totalExerciseCount,
      'caloriasQuemadas': totalCaloriesBurned,
    };

    // Actualiza el documento de estadísticas del usuario, fusionando con los datos existentes.
    await userStatsRef.set(userData, SetOptions(merge: true));
  }

  /// Convierte segundos a un formato de tiempo "horas:minutos:segundos".
  String _secondsToTime(int seconds) {
    int hours = seconds ~/ 3600; // Calcula las horas.
    int minutes = (seconds % 3600) ~/ 60; // Calcula los minutos restantes.
    int remainingSeconds = seconds % 60; // Calcula los segundos restantes.
    return '$hours:${_formatTimeComponent(minutes)}:${_formatTimeComponent(remainingSeconds)}'; // Formatea y devuelve el tiempo.
  }

  /// Convierte un tiempo en formato "horas:minutos:segundos" a segundos.
  int _timeToSeconds(String time) {
    List<String> components =
        time.split(':'); // Separa la cadena de tiempo en componentes.
    int hours = int.parse(components[0]); // Obtiene las horas.
    int minutes = int.parse(components[1]); // Obtiene los minutos.
    int seconds = int.parse(components[2]); // Obtiene los segundos.
    return hours * 3600 +
        minutes * 60 +
        seconds; // Calcula y devuelve el total de segundos.
  }

  /// Formatea un componente de tiempo para que tenga siempre dos dígitos.
  String _formatTimeComponent(int component) {
    return component < 10
        ? '0$component'
        : '$component'; // Agrega un cero inicial si es necesario.
  }

  /// Actualiza el conteo de rutinas completadas para el usuario.
  ///
  /// [userEmail] es el correo electrónico del usuario.
  Future<void> updateUserStatsForRutinas(String userEmail) async {
    final userStatsRef = _firestore
        .collection('userstats')
        .doc(userEmail); // Referencia al documento de estadísticas del usuario.
    final userStatsDoc =
        await userStatsRef.get(); // Obtiene el documento de estadísticas.

    // Si el documento existe y contiene el campo 'rutinascompletadas', actualiza el contador.
    if (userStatsDoc.exists &&
        userStatsDoc.data()!.containsKey('rutinascompletadas')) {
      int existingCompletedRoutines = userStatsDoc[
          'rutinascompletadas']; // Obtiene las rutinas completadas existentes.
      int totalCompletedRoutines =
          existingCompletedRoutines + 1; // Incrementa el total.
      await userStatsRef.update({
        'rutinascompletadas': totalCompletedRoutines
      }); // Actualiza el documento.
    } else {
      // Si no existe, inicializa el contador a 1.
      await userStatsRef
          .set({'rutinascompletadas': 1}, SetOptions(merge: true));
    }
  }
}
