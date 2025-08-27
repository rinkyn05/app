import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'rutinas_screen.dart';

class RutinaEjecucionScreen extends StatefulWidget {
  @override
  _RutinaEjecucionScreenState createState() => _RutinaEjecucionScreenState();
}

class _RutinaEjecucionScreenState extends State<RutinaEjecucionScreen> {
  String nombreRutina = 'Cargando...';
  String tiempoCalentamientoFisico = '0';
  String descansoEntreEjercicios = '0';
  List ejercicios = [];

  int currentIndex = 0;
  bool isPaused = false;
  int cantidadDeCircuitos =
      3; // Variable para almacenar la cantidad de circuitos
  int repeticiones = 5; // Variable para almacenar el número de repeticiones
  int circuitoActual = 1; // Variable para almacenar el circuito actual

  int descansoEntreCircuitos = 300;

  final CountDownController _controller = CountDownController();

  _RutinaEjecucionScreenState() {
    cargarDatosRutina();
  }

  @override
  void initState() {
    super.initState();
    // Aquí puedes agregar cualquier lógica adicional que necesites después de cargar los datos
  }

  int convertirAMilisegundos(String tiempo) {
    switch (tiempo) {
      case '5 Minutos':
        return 5 * 60 * 1000;
      case '10 Minutos':
        return 10 * 60 * 1000;
      case '15 Minutos':
        return 15 * 60 * 1000;
      case '5 Segundos':
        return 5 * 1000;
      case '10 Segundos':
        return 10 * 1000;
      case '15 Segundos':
        return 15 * 1000;
      default:
        return 0; // Valor por defecto si no coincide con ninguno
    }
  }

  // Función para convertir repeticiones (mantenida para uso futuro si es necesario)
  int convertirARepeticiones(String repeticionesTexto) {
    switch (repeticionesTexto) {
      case '5 Repeticiones':
        return 5;
      case '6 Repeticiones':
        return 6;
      case '7 Repeticiones':
        return 7;
      case '8 Repeticiones':
        return 8;
      case '9 Repeticiones':
        return 9;
      case '10 Repeticiones':
        return 10;
      case '11 Repeticiones':
        return 11;
      case '12 Repeticiones':
        return 12;
      case '13 Repeticiones':
        return 13;
      case '14 Repeticiones':
        return 14;
      case '15 Repeticiones':
        return 15;
      case '16 Repeticiones':
        return 16;
      case '17 Repeticiones':
        return 17;
      default:
        return 5; // Valor por defecto si no coincide con ninguno
    }
  }

  int convertirACircuitos(String circuitosTexto) {
    switch (circuitosTexto) {
      case '2 Circuitos':
        return 2;
      case '3 Circuitos':
        return 3;
      case '4 Circuitos':
        return 4;
      case '5 Circuitos':
        return 5;
      case '6 Circuitos':
        return 6;
      default:
        return 3; // Valor por defecto si no coincide con ninguno
    }
  }

  int convertirADescansoEntreCircuitos(String descansoTexto) {
    switch (descansoTexto) {
      case '5 Minutos':
        return 300;
      case '10 Minutos':
        return 600;
      case '15 Minutos':
        return 900;
      default:
        return 300; // Valor por defecto si no coincide con ninguno
    }
  }

  Future<void> cargarDatosRutina() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Cargar el nombre de la rutina
      nombreRutina = prefs.getString('nombreRutinaStart') ?? 'N/A';

      // Cargar el tiempo de calentamiento físico y convertirlo a milisegundos
      String calentamientoFisicoTexto =
          prefs.getString('calentamientoFisicoEspStart') ?? '0';
      tiempoCalentamientoFisico =
          convertirAMilisegundos(calentamientoFisicoTexto).toString();

      // Cargar la URL de la imagen de calentamiento físico
      String calentamientoImageUrl =
          prefs.getString('calentamientoFisicoImgUrl') ?? '';
      String calentamientoImagePath = calentamientoImageUrl.isNotEmpty
          ? calentamientoImageUrl
          : 'assets/images/cg.png'; // Ruta por defecto si no hay URL

      // Cargar el nombre del ejercicio de calentamiento físico
      String calentamientoNombre =
          prefs.getString('calentamientoFisicoNameEspStart') ??
              'Calentamiento Físico';

      // Cargar la cantidad de circuitos
      String circuitosTexto =
          prefs.getString('cantidadDeCircuitosEspStart') ?? '3 Circuitos';
      cantidadDeCircuitos = convertirACircuitos(circuitosTexto);

      // Cargar el tiempo de descanso entre circuitos
      String descansoTexto =
          prefs.getString('descansoEntreCircuitoEspStart') ?? '5 Minutos';
      int descansoEntreCircuitos =
          convertirADescansoEntreCircuitos(descansoTexto);

      // Cargar el tiempo de descanso entre ejercicios
      String descansoEntreEjerciciosTexto =
          prefs.getString('descansoEntreEjerciciosEspStart') ?? '15 Segundos';
      int descansoEntreEjerciciosSegundos =
          convertirAMilisegundos(descansoEntreEjerciciosTexto) ~/
              1000; // Convertir a segundos

      // Cargar el número de repeticiones utilizando la nueva función
      String repeticionesTexto =
          prefs.getString('repeticionesPorEjerciciosEspStart') ??
              '5 Repeticiones';
      repeticiones = convertirARepeticiones(repeticionesTexto);

      // Cargar el tiempo de estiramiento físico y convertirlo a milisegundos
      String estiramientoFisicoTexto =
          prefs.getString('estiramientoEstaticoEspStart') ?? '0';
      int tiempoEstiramientoFisico =
          convertirAMilisegundos(estiramientoFisicoTexto);

      // Cargar la URL de la imagen de estiramiento físico
      String estiramientoImageUrl =
          prefs.getString('estiramientoFisicoImgUrl') ?? '';
      String estiramientoImagePath = estiramientoImageUrl.isNotEmpty
          ? estiramientoImageUrl
          : 'assets/images/cg.png'; // Ruta por defecto si no hay URL

      // Cargar el nombre del ejercicio de estiramiento físico
      String estiramientoNombre =
          prefs.getString('estiramientoFisicoNameEspStart') ??
              'Estiramiento Físico';

      // Cargar la lista de ejercicios desde SharedPreferences
      List<String> ejerciciosList =
          prefs.getStringList('ejerciciosFiltrados') ?? [];

      // Cargar la lista de URLs de imágenes de ejercicios desde SharedPreferences
      List<String> imagenesEjerciciosList = [];
      for (int i = 0; i < ejerciciosList.length; i++) {
        final key = 'imgEjercicio${i + 1}';
        final imageUrl = prefs.getString(key);
        imagenesEjerciciosList.add(imageUrl ?? '');
      }

      print('Lista de ejercicios: $ejerciciosList');
      print('Lista de URLs de imágenes de ejercicios: $imagenesEjerciciosList');

      // Configurar la lista de ejercicios con sus nombres y duraciones
      ejercicios = [
        {
          'nombre': calentamientoNombre,
          'duracion': (int.tryParse(tiempoCalentamientoFisico) ?? 0) ~/
              1000, // Convertir a segundos
          'CalentamientoImg': calentamientoImagePath,
        },
        {
          'nombre': 'Calentamiento Articular',
          'duracion': 300,
          'CalentamientoImg':
              'assets/images/calentamiento_a.jpeg', // Ruta estática para el segundo ejercicio
        },
      ];

      // Agregar los ejercicios adicionales con sus URLs de imágenes y duraciones alternas
      for (int i = 0; i < ejerciciosList.length; i++) {
        String ejercicioNombre = ejerciciosList[i];
        String imagenUrl =
            imagenesEjerciciosList.length > i ? imagenesEjerciciosList[i] : '';

        // Agregar el ejercicio principal
        ejercicios.add({
          'nombre': ejercicioNombre,
          'duracion': 60, // Duración del ejercicio en segundos
          'CalentamientoImg': imagenUrl.isNotEmpty
              ? imagenUrl
              : 'assets/images/cg.png', // Ruta por defecto si no hay URL
        });
      }

      // Imprimir la lista de ejercicios configurada
      print('Lista de ejercicios configurada: $ejercicios');

      // Repetir los ejercicios según el número de circuitos
      List<Map<String, dynamic>> ejerciciosRepetidos = [];
      for (int r = 0; r < cantidadDeCircuitos; r++) {
        // Agregar un ejercicio de descanso después del primer circuito
        if (r > 0) {
          ejerciciosRepetidos.add({
            'nombre': 'Descanso Entre Circuitos',
            'duracion':
                descansoEntreCircuitos, // Duración del descanso en segundos
            'CalentamientoImg':
                'assets/images/descanso_entre_ejercicio.jpg', // Ruta de la imagen para el descanso entre circuitos
          });
        }

        for (int i = 2; i < ejercicios.length; i++) {
          // Empezar desde el índice 2 para excluir calentamiento
          for (int rep = 0; rep < 1; rep++) {
            // Repetir el ejercicio según el número de repeticiones (ahora siempre 1)
            ejerciciosRepetidos.add({
              'nombre': ejercicios[i]['nombre'],
              'duracion': ejercicios[i]['duracion'],
              'CalentamientoImg': ejercicios[i]['CalentamientoImg'],
            });

            // Agregar un ejercicio de descanso después de cada repetición
            ejerciciosRepetidos.add({
              'nombre': 'Descanso',
              'duracion':
                  descansoEntreEjerciciosSegundos, // Duración del descanso en segundos
              'CalentamientoImg':
                  'assets/images/descanso_entre_ejercicio.jpg', // Ruta de la imagen para el descanso
            });
          }
        }
      }

      // Agregar el ejercicio de estiramiento al final
      ejerciciosRepetidos.add({
        'nombre': estiramientoNombre,
        'duracion': tiempoEstiramientoFisico ~/ 1000, // Convertir a segundos
        'CalentamientoImg': estiramientoImagePath,
      });

      // Actualizar la lista de ejercicios con los ejercicios repetidos
      ejercicios = [
        ejercicios[0], // Calentamiento físico
        ejercicios[1], // Calentamiento articular
      ]..addAll(ejerciciosRepetidos);

      print('Lista de ejercicios configurada con repeticiones: $ejercicios');
    });
  }

  void _nextPhase() {
    setState(() {
      if (currentIndex < ejercicios.length - 1) {
        // Avanzar al siguiente ejercicio
        currentIndex++;
        _controller.restart(duration: ejercicios[currentIndex]['duracion']);
        isPaused = false;

        // Verificar si el ejercicio actual es un descanso entre circuitos
        if (ejercicios[currentIndex]['nombre'] == 'Descanso Entre Circuitos' &&
            ejercicios[currentIndex]['duracion'] == descansoEntreCircuitos) {
          circuitoActual++;
        }
      } else {
        // Si se han completado todos los ejercicios, no incrementar más el circuitoActual
        // Mostrar el primer SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Felicidades, has completado tu rutina'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navegar a la siguiente pantalla después de mostrar el segundo SnackBar
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RutinasScreen()),
          );
        });
      }

      // Verificar si el circuitoActual supera la cantidadDeCircuitos
      if (circuitoActual > cantidadDeCircuitos) {
        circuitoActual =
            cantidadDeCircuitos; // Asegurarse de que no exceda el límite
      }
    });
  }

  void _handleForward() {
    _nextPhase();
  }

  void _togglePause() {
    setState(() {
      if (isPaused) {
        _controller.resume();
      } else {
        _controller.pause();
      }
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nombreRutina,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ejercicios.isNotEmpty
          ? Column(
              children: [
                // Imagen con tamaño reducido
                Expanded(
                  flex: 1, // Reduce el espacio vertical que ocupa la imagen
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight:
                          100, // Establece un límite máximo para la altura de la imagen
                    ),
                    child: ejercicios[currentIndex]['CalentamientoImg']
                            .startsWith('http')
                        ? Image.network(
                            ejercicios[currentIndex]['CalentamientoImg'],
                            fit: BoxFit
                                .fill, // Mantiene la imagen contenida dentro del contenedor
                          )
                        : Image.asset(
                            ejercicios[currentIndex]['CalentamientoImg'],
                            fit: BoxFit
                                .contain, // Mantiene la imagen contenida dentro del contenedor
                          ),
                  ),
                ),
                // Espaciado vertical
                SizedBox(height: 10),
                // Texto del ejercicio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    ejercicios[currentIndex]['nombre'] ?? 'Ejercicio',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Espaciado vertical
                SizedBox(height: 10),
                // Texto de circuitos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    circuitoActual > cantidadDeCircuitos
                        ? 'Circuitos: Completados'
                        : 'Circuitos: $circuitoActual de $cantidadDeCircuitos',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Espaciado vertical
                SizedBox(height: 20),
                // Temporizador
                CircularCountDownTimer(
                  duration: ejercicios[currentIndex]['duracion'],
                  controller: _controller,
                  initialDuration: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 4,
                  ringColor: Colors.grey[300]!,
                  fillColor: Colors.blueAccent,
                  backgroundColor: Colors.purple[500],
                  strokeWidth: 10.0,
                  strokeCap: StrokeCap.round,
                  textStyle: const TextStyle(
                    fontSize: 33.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: true,
                  onComplete: _nextPhase,
                ),
                SizedBox(height: 10),
                // Texto de repeticiones
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Repeticiones de 5 a 16',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Repeticiones: $repeticiones',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Espaciado vertical
                SizedBox(height: 20),
                // Botones de control
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (currentIndex > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 48),
                          onPressed: () {
                            setState(() {
                              currentIndex--;
                              _controller.restart(
                                  duration: ejercicios[currentIndex]
                                      ['duracion']);
                              isPaused = false;
                            });
                          },
                        ),
                      GestureDetector(
                        onTap: _togglePause,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isPaused ? Icons.play_arrow : Icons.pause,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 48),
                        onPressed: () => _handleForward(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          : Center(
              child: Text(
                'No hay ejercicios disponibles',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
