import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../backend/models/ejercicio_rutina_model.dart';
import '../../config/lang/app_localization.dart';
import '../../functions/load_user_info.dart';
import '../../functions/users/user_stats_service.dart';
import 'rutinas_screen.dart';

class RutinaEjecucionScreen extends StatefulWidget {
  final List<EjercicioRutina> ejercicios;
  final int intervalo;
  final String nombreRutina;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const RutinaEjecucionScreen({
    Key? key,
    required this.ejercicios,
    required this.intervalo,
    required this.nombreRutina,
    required this.auth,
    required this.firestore,
  }) : super(key: key);

  @override
  RutinaEjecucionScreenState createState() => RutinaEjecucionScreenState();
}

class RutinaEjecucionScreenState extends State<RutinaEjecucionScreen> {
  int currentIndex = 0;
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;
  bool _isIntervalTime = true;
  final UserStatsService _userStatsService = UserStatsService();

  @override
  void initState() {
    super.initState();
    if (widget.intervalo > 0 && widget.ejercicios.isNotEmpty) {
      Future.delayed(Duration.zero, () => _startIntervalTimer());
    } else {
      _startExerciseTimer();
    }
  }

  int _getExerciseDurationInSeconds(String duration) {
    var parts = duration.split(':');
    return int.tryParse(parts[0])! * 60 + int.tryParse(parts[1])!;
  }

  void _startIntervalTimer() {
    setState(() {
      _isPaused = false;
      _isIntervalTime = true;
    });
    _controller.restart(duration: widget.intervalo);
  }

  void _startExerciseTimer() {
    if (currentIndex < widget.ejercicios.length) {
      final currentExercise = widget.ejercicios[currentIndex];
      final parts = currentExercise.duracion.split(":");
      final durationInSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);

      setState(() {
        _isPaused = false;
        _isIntervalTime = false;
      });
      _controller.restart(duration: durationInSeconds);
    }
  }

  void _nextPhase() {
    if (context.mounted) {
      if (_isIntervalTime) {
        if (currentIndex < widget.ejercicios.length) {
          _startExerciseTimer();
        }
      } else {
        if (currentIndex < widget.ejercicios.length - 1) {
          setState(() {
            currentIndex++;
            _isIntervalTime = true;
          });
          _startIntervalTimer();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              _showEndRoutineDialog();
            }
          });
        }

        _updateUserStatsForCurrentExercise();
      }
    }
  }

  void _updateUserStatsForCurrentExercise() {
    loadUserInfo(widget.auth, widget.firestore, (userData) {
      final userEmail = userData['Correo Electrónico'];
      final currentExercise = widget.ejercicios[currentIndex];
      final exerciseTime =
          _getExerciseDurationInSeconds(currentExercise.duracion);
      final caloriesBurned = int.parse(currentExercise.calorias);
      _userStatsService.updateUserStats(
          userEmail, exerciseTime, caloriesBurned);
    });
  }

  void _toggleTimerPause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _controller.pause();
    } else {
      _controller.resume();
    }
  }

  void _showEndRoutineDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.translate('routineComplete')),
          content: Text(AppLocalizations.of(context)!.translate('repeatOrEnd')),
          actions: <Widget>[
            TextButton(
              child:
                  Text(AppLocalizations.of(context)!.translate('okForToday')),
              onPressed: () {
                _sendCompletedRoutinesToFirebase();

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const RutinasScreen()),
                );
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('repeat')),
              onPressed: () {
                _sendCompletedRoutinesToFirebase();

                Navigator.of(context).pop();
                setState(() {
                  currentIndex = 0;
                  _isIntervalTime = true;
                  _startIntervalTimer();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _sendCompletedRoutinesToFirebase() {
    final currentUserEmail = widget.auth.currentUser!.email!;

    final UserStatsService userStatsService = UserStatsService();
    userStatsService.updateUserStatsForRutinas(currentUserEmail);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercise = currentIndex < widget.ejercicios.length
        ? widget.ejercicios[currentIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombreRutina,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (exercise != null) ...[
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.network(
                  exercise.imagen,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          CircularCountDownTimer(
            key: UniqueKey(),
            duration: _isIntervalTime
                ? widget.intervalo
                : (int.tryParse(exercise!.duracion.split(":")[0]) ?? 0) * 60 +
                    (int.tryParse(exercise.duracion.split(":")[1]) ?? 0),
            initialDuration: 0,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 2.9,
            height: MediaQuery.of(context).size.height / 2.9,
            ringColor: Colors.grey[300]!,
            fillColor: Colors.blueAccent,
            backgroundColor: Colors.purple[500],
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
                fontSize: 33.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onComplete: _nextPhase,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 48),
                  onPressed: currentIndex > 0
                      ? () {
                          setState(() {
                            currentIndex--;
                            _isIntervalTime = false;
                          });
                          _startExerciseTimer();
                        }
                      : null,
                ),
                GestureDetector(
                  onTap: _toggleTimerPause,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(_isPaused ? Icons.play_arrow : Icons.pause,
                          size: 48),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 48),
                  onPressed: currentIndex < widget.ejercicios.length - 1
                      ? () {
                          setState(() {
                            currentIndex++;
                            _isIntervalTime = true;
                          });
                          _startIntervalTimer();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
