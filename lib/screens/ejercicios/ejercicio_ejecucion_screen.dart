import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../backend/models/ejercicio_model.dart';
import '../../config/lang/app_localization.dart';
import '../../functions/load_user_info.dart';
import '../../functions/users/user_stats_service.dart';

class EjercicioEjecucionScreen extends StatefulWidget {
  final Ejercicio ejercicio;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const EjercicioEjecucionScreen({
    Key? key,
    required this.ejercicio,
    required this.auth,
    required this.firestore,
  }) : super(key: key);

  @override
  EjercicioEjecucionScreenState createState() =>
      EjercicioEjecucionScreenState();
}

class EjercicioEjecucionScreenState extends State<EjercicioEjecucionScreen> {
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;
  bool _isIntervalTime = true;
  int _remainingTime = 10;
  final UserStatsService _userStatsService = UserStatsService();

  @override
  void initState() {
    super.initState();
  }

  int _getExerciseDurationInSeconds(String duration) {
    var parts = duration.split(':');
    return int.tryParse(parts[0])! * 60 + int.tryParse(parts[1])!;
  }

  void _toggleTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _controller.pause();
    } else {
      _controller.resume();
    }
  }

  void _nextPhase() {
    if (_isIntervalTime) {
      var exerciseDuration =
          _getExerciseDurationInSeconds(widget.ejercicio.duracion);
      setState(() {
        _isIntervalTime = false;
        _remainingTime = exerciseDuration;
      });
      _controller.restart(duration: _remainingTime);
    } else {
      _updateUserStats();
      _showCompletionDialog();
    }
  }

  void _updateUserStats() {
    loadUserInfo(widget.auth, widget.firestore, (userData) {
      final userEmail = userData['Correo Electrónico'];
      final exerciseTime =
          _getExerciseDurationInSeconds(widget.ejercicio.duracion);
      final caloriesBurned = int.parse(widget.ejercicio.calorias);
      _userStatsService.updateUserStats(
          userEmail, exerciseTime, caloriesBurned);
    });
  }

  void _restartExercise() {
    setState(() {
      _isIntervalTime = true;
      _remainingTime = 10;
    });
    _controller.restart(duration: _remainingTime);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.translate('exerciseCompletedTitle')),
        content: Text(AppLocalizations.of(context)!
            .translate('exerciseCompletedContent')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartExercise();
            },
            child: Text(AppLocalizations.of(context)!.translate('repeat')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.translate('finish')),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ejercicio.nombre),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Image.network(
              widget.ejercicio.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CircularCountDownTimer(
              duration: _remainingTime,
              initialDuration: 0,
              controller: _controller,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              ringColor: Colors.grey.shade300,
              fillColor: Colors.blueAccent,
              backgroundColor: Colors.purple[500],
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(fontSize: 36.0, color: Colors.white),
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: true,
              onComplete: _nextPhase,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _toggleTimer,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
