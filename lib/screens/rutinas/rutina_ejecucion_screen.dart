import 'package:app/screens/rutinas/rutinas_screen.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class RutinaEjecucionScreen extends StatefulWidget {
  final List<EjercicioRutina> ejercicios;
  final int intervalo;
  final String nombreRutina;
  final String intensidadEsp;
  final String intensidadEng;
  final String calentamientoFisicoEsp;
  final String calentamientoFisicoEng;
  final String descansoEntreEjerciciosEsp;
  final String descansoEntreEjerciciosEng;
  final String descansoEntreCircuitoEsp;
  final String descansoEntreCircuitoEng;
  final String estiramientoEstaticoEsp;
  final String estiramientoEstaticoEng;
  final String calentamientoArticularEsp;
  final String calentamientoArticularEng;
  final int cantidadDeEjerciciosEsp;
  final int cantidadDeEjerciciosEng;
  final int repeticionesPorEjerciciosEsp;
  final int repeticionesPorEjerciciosEng;
  final int cantidadDeCircuitosEsp;
  final int cantidadDeCircuitosEng;
  final String nombreRutinaEsp;
  final String nombreRutinaEng;
  final String selectedCalentamientoFisicoNameEsp;
  final String selectedCalentamientoFisicoNameEng;
  final String selectedEstiramientoFisicoNameEsp;
  final String selectedEstiramientoFisicoNameEng;

  const RutinaEjecucionScreen({
    Key? key,
    required this.ejercicios,
    required this.intervalo,
    required this.nombreRutina,
    required this.intensidadEsp,
    required this.intensidadEng,
    required this.calentamientoFisicoEsp,
    required this.calentamientoFisicoEng,
    required this.descansoEntreEjerciciosEsp,
    required this.descansoEntreEjerciciosEng,
    required this.descansoEntreCircuitoEsp,
    required this.descansoEntreCircuitoEng,
    required this.estiramientoEstaticoEsp,
    required this.estiramientoEstaticoEng,
    required this.calentamientoArticularEsp,
    required this.calentamientoArticularEng,
    required this.cantidadDeEjerciciosEsp,
    required this.cantidadDeEjerciciosEng,
    required this.repeticionesPorEjerciciosEsp,
    required this.repeticionesPorEjerciciosEng,
    required this.cantidadDeCircuitosEsp,
    required this.cantidadDeCircuitosEng,
    required this.nombreRutinaEsp,
    required this.nombreRutinaEng,
    required this.selectedCalentamientoFisicoNameEsp,
    required this.selectedCalentamientoFisicoNameEng,
    required this.selectedEstiramientoFisicoNameEsp,
    required this.selectedEstiramientoFisicoNameEng,
  }) : super(key: key);

  @override
  RutinaEjecucionScreenState createState() => RutinaEjecucionScreenState();
}

class EjercicioRutina {
  final String imagen;
  final String duracion;
  final String calorias;

  EjercicioRutina({
    required this.imagen,
    required this.duracion,
    required this.calorias,
  });
}

class RutinaEjecucionScreenState extends State<RutinaEjecucionScreen> {
  int currentIndex = 0;
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;
  bool _isIntervalTime = true;

  @override
  void initState() {
    super.initState();
    _showInfoDialog();
    if (widget.intervalo > 0 && widget.ejercicios.isNotEmpty) {
      _startIntervalTimer();
    } else {
      _startExerciseTimer();
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información de la Rutina'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Intensidad (Esp): ${widget.intensidadEsp}'),
                Text('Intensidad (Eng): ${widget.intensidadEng}'),
                Text(
                    'Calentamiento Físico (Esp): ${widget.calentamientoFisicoEsp}'),
                Text(
                    'Calentamiento Físico (Eng): ${widget.calentamientoFisicoEng}'),
                Text(
                    'Descanso Entre Ejercicios (Esp): ${widget.descansoEntreEjerciciosEsp}'),
                Text(
                    'Descanso Entre Ejercicios (Eng): ${widget.descansoEntreEjerciciosEng}'),
                Text(
                    'Descanso Entre Circuito (Esp): ${widget.descansoEntreCircuitoEsp}'),
                Text(
                    'Descanso Entre Circuito (Eng): ${widget.descansoEntreCircuitoEng}'),
                Text(
                    'Estiramiento Estático (Esp): ${widget.estiramientoEstaticoEsp}'),
                Text(
                    'Estiramiento Estático (Eng): ${widget.estiramientoEstaticoEng}'),
                Text(
                    'Calentamiento Articular (Esp): ${widget.calentamientoArticularEsp}'),
                Text(
                    'Calentamiento Articular (Eng): ${widget.calentamientoArticularEng}'),
                Text(
                    'Cantidad de Ejercicios (Esp): ${widget.cantidadDeEjerciciosEsp}'),
                Text(
                    'Cantidad de Ejercicios (Eng): ${widget.cantidadDeEjerciciosEng}'),
                Text(
                    'Repeticiones por Ejercicios (Esp): ${widget.repeticionesPorEjerciciosEsp}'),
                Text(
                    'Repeticiones por Ejercicios (Eng): ${widget.repeticionesPorEjerciciosEng}'),
                Text(
                    'Cantidad de Circuitos (Esp): ${widget.cantidadDeCircuitosEsp}'),
                Text(
                    'Cantidad de Circuitos (Eng): ${widget.cantidadDeCircuitosEng}'),
                Text('Nombre de la Rutina (Esp): ${widget.nombreRutinaEsp}'),
                Text('Nombre de la Rutina (Eng): ${widget.nombreRutinaEng}'),
                Text(
                    'Calentamiento Físico Seleccionado (Esp): ${widget.selectedCalentamientoFisicoNameEsp}'),
                Text(
                    'Calentamiento Físico Seleccionado (Eng): ${widget.selectedCalentamientoFisicoNameEng}'),
                Text(
                    'Estiramiento Físico Seleccionado (Esp): ${widget.selectedEstiramientoFisicoNameEsp}'),
                Text(
                    'Estiramiento Físico Seleccionado (Eng): ${widget.selectedEstiramientoFisicoNameEng}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startIntervalTimer();
              },
              child: Text('Comenzar'),
            ),
          ],
        );
      },
    );
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
        _showEndRoutineDialog();
      }
    }
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
          title: Text('Rutina Completa'),
          content: Text('¿Quieres repetir la rutina o terminarla?'),
          actions: <Widget>[
            TextButton(
              child: Text('Terminar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const RutinasScreen()),
                );
              },
            ),
            TextButton(
              child: Text('Repetir'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentIndex = 0;
                  _isIntervalTime = true;
                });
                _startIntervalTimer();
              },
            ),
          ],
        );
      },
    );
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
              child: Icon(
                Icons.fitness_center,
                size: 100,
                color: Colors.blueAccent,
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
