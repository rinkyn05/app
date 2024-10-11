import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Importa el paquete para visualizar modelos 3D.
import '../widgets/custom_appbar_adap.dart'; // Importa la barra de navegación personalizada.
import 'ejercicios/Exercises_todos_screen.dart'; // Importa la pantalla de ejercicios.
import 'ejercicios/exercises_abdomen_screen_vid.dart'; // Importa la pantalla de ejercicios de abdomen.
import 'ejercicios/exercises_antebrazo_screen_vid.dart'; // Importa la pantalla de ejercicios de antebrazo.
import 'ejercicios/exercises_biceps_screen_vid.dart'; // Importa la pantalla de ejercicios de bíceps.
import 'ejercicios/exercises_cuadriceps_screen_vid.dart'; // Importa la pantalla de ejercicios de cuádriceps.
import 'ejercicios/exercises_deltoide_screen_vid.dart'; // Importa la pantalla de ejercicios de deltoides.
import 'ejercicios/exercises_pectoral_screen_vid.dart'; // Importa la pantalla de ejercicios de pectorales.
import 'ejercicios/exercises_tibial_a_screen_vid.dart'; // Importa la pantalla de ejercicios de tibial anterior.
import '../config/utils/appcolors.dart'; // Importa los colores de la aplicación.
import 'rutinas/rutinas_screen.dart'; // Importa la pantalla de rutinas.

class AdaptacionAnatomicaScreen extends StatefulWidget {
  @override
  _AdaptacionAnatomicaScreenState createState() =>
      _AdaptacionAnatomicaScreenState();
}

class _AdaptacionAnatomicaScreenState extends State<AdaptacionAnatomicaScreen> {
  String selectedCard = ''; // Variable para almacenar la tarjeta seleccionada.

  // Método que retorna la ruta del modelo 3D según el título proporcionado.
  String _getModelSrc(String title) {
    switch (title) {
      case 'Todos':
        return 'assets/tre_d/gabriel.glb'; // Ruta del modelo 3D para "Todos".
      case 'Deltoide':
        return 'assets/tre_d/cuerpo_v04.glb'; // Ruta del modelo 3D para "Deltoide".
      case 'Pectoral':
        return 'assets/tre_d/pectoral_derecho.glb'; // Ruta del modelo 3D para "Pectoral".
      case 'Bíceps':
        return 'assets/tre_d/cuerpo.glb'; // Ruta del modelo 3D para "Bíceps".
      case 'Abdomen':
        return 'assets/tre_d/pruebapp.glb'; // Ruta del modelo 3D para "Abdomen".
      case 'Antebrazo':
        return 'assets/tre_d/pruebapp.glb'; // Ruta del modelo 3D para "Antebrazo".
      case 'Cuádriceps':
        return 'assets/tre_d/pruebapp.glb'; // Ruta del modelo 3D para "Cuádriceps".
      case 'Tibial anterior':
        return 'assets/tre_d/pruebapp.glb'; // Ruta del modelo 3D para "Tibial anterior".
      case 'Rutinas':
        return 'assets/tre_d/pruebapp.glb'; // Ruta del modelo 3D para "Rutinas".
      default:
        return 'assets/tre_d/cuerpo07.glb'; // Ruta del modelo 3D por defecto.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNewAdapt(
        // Crea una barra de navegación personalizada.
        onBackButtonPressed: () {
          Navigator.pop(
              context); // Regresa a la pantalla anterior al presionar el botón de retroceso.
        },
      ),
      body: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Estira los elementos del Row.
        children: [
          Expanded(
            flex: 4, // Proporción del espacio horizontal para esta columna.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 600, // Altura fija para la lista de tarjetas.
                  child: ListView(
                    scrollDirection:
                        Axis.vertical, // Permite el desplazamiento vertical.
                    children: [
                      _buildCard(context, 'Todos',
                          'Aquí puedes ver todos los ejercicios.'),
                      _buildCard(context, 'Deltoide',
                          'Músculo en la parte superior del brazo y el hombro.'),
                      _buildCard(context, 'Pectoral', 'Músculo del pecho.'),
                      _buildCard(context, 'Bíceps',
                          'Músculo en la parte frontal del brazo.'),
                      _buildCard(context, 'Abdomen',
                          'Parte del cuerpo entre el pecho y la pelvis.'),
                      _buildCard(context, 'Antebrazo',
                          'Parte del brazo entre el codo y la muñeca.\nParte del cuerpo entre el pecho y la pelvis.'),
                      _buildCard(context, 'Cuádriceps',
                          'Músculos en la parte frontal del muslo.'),
                      _buildCard(context, 'Tibial anterior',
                          'Músculo en la parte frontal de la espinilla.'),
                      _buildCard(context, 'Rutinas',
                          'Puedes Crear tus propias rutinas de ejercicios.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7, // Proporción del espacio horizontal para esta columna.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10), // Espacio superior.
                Expanded(
                  child: ModelViewer(
                    backgroundColor: Color.fromARGB(
                        255, 50, 50, 50), // Color de fondo del modelo 3D.
                    src: _getModelSrc(
                        selectedCard), // Fuente del modelo 3D según la tarjeta seleccionada.
                    alt:
                        'A 3D model of a Human Body', // Texto alternativo para el modelo.
                    ar: true, // Habilita la visualización en realidad aumentada.
                    autoRotate:
                        false, // Desactiva la rotación automática del modelo.
                    disableZoom: true, // Desactiva el zoom en el modelo.
                  ),
                ),
                SizedBox(height: 10), // Espacio inferior.
                selectedCard.isNotEmpty
                    ? _buildInfoCard(
                        selectedCard) // Muestra la tarjeta de información si hay una tarjeta seleccionada.
                    : SizedBox(), // Si no hay tarjeta seleccionada, muestra un espacio vacío.
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir una tarjeta de ejercicio.
  Widget _buildCard(BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        // Detecta el toque en la tarjeta.
        setState(() {
          selectedCard = title; // Actualiza la tarjeta seleccionada.
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Bordes redondeados de la tarjeta.
        ),
        child: Padding(
          padding: EdgeInsets.all(10), // Padding interno de la tarjeta.
          child: Center(
            child: Text(
              title, // Título de la tarjeta.
              style: Theme.of(context).textTheme.bodyLarge, // Estilo del texto.
            ),
          ),
        ),
      ),
    );
  }

  // Método que construye una tarjeta de información según el título proporcionado.
Widget _buildInfoCard(String title) {
  String content = ''; // Variable para almacenar el contenido de la tarjeta.

  // Determina el contenido de la tarjeta basado en el título.
  if (title == 'Todos') {
    content = 'Aqui puedes ver todos los ejercicios.'; // Contenido para "Todos".
  } else if (title == 'Deltoide') {
    content = 'Músculo en la parte superior del brazo y el hombro.'; // Contenido para "Deltoide".
  } else if (title == 'Pectoral') {
    content = 'Músculo del pecho.'; // Contenido para "Pectoral".
  } else if (title == 'Bíceps') {
    content = 'Músculo en la parte frontal del brazo.'; // Contenido para "Bíceps".
  } else if (title == 'Abdomen') {
    content = 'Parte del cuerpo entre el pecho y la pelvis.'; // Contenido para "Abdomen".
  } else if (title == 'Antebrazo') {
    content =
        'Parte del brazo entre el codo y la muñeca.\nParte del cuerpo entre el pecho y la pelvis.'; // Contenido para "Antebrazo".
  } else if (title == 'Cuádriceps') {
    content = 'Músculos en la parte frontal del muslo.'; // Contenido para "Cuádriceps".
  } else if (title == 'Tibial anterior') {
    content = 'Músculo en la parte frontal de la espinilla.'; // Contenido para "Tibial anterior".
  } else if (title == 'Rutinas') {
    content = 'Puedes Crear tus propias rutinas de ejercicios.'; // Contenido para "Rutinas".
  }

  // Retorna la tarjeta con información del ejercicio.
  return Card(
    elevation: 4, // Elevación de la tarjeta.
    margin: EdgeInsets.all(16), // Margen externo de la tarjeta.
    child: Padding(
      padding: EdgeInsets.all(16), // Padding interno de la tarjeta.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea los hijos al inicio.
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacia los elementos del Row.
            children: [
              Text(
                title, // Muestra el título de la tarjeta.
                style: Theme.of(context).textTheme.bodyLarge, // Estilo del texto.
              ),
              IconButton(
                icon: Icon(Icons.close), // Ícono de cerrar.
                onPressed: () {
                  setState(() {
                    selectedCard = ''; // Resetea la tarjeta seleccionada al cerrar.
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 5), // Espacio entre el título y el contenido.
          Text(
            content, // Muestra el contenido de la tarjeta.
            style: TextStyle(
              fontSize: 18, // Tamaño de fuente del contenido.
            ),
          ),
          SizedBox(height: 5), // Espacio entre el contenido y el botón.
          ElevatedButton(
            onPressed: () {
              // Navega a la pantalla correspondiente según el título.
              switch (title) {
                case 'Todos':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesTodosScreen()),
                  );
                  break;
                case 'Deltoide':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesDeltoideScreenVid()),
                  );
                  break;
                case 'Pectoral':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesPectoralScreenVid()),
                  );
                  break;
                case 'Bíceps':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesBicepsScreenVid()),
                  );
                  break;
                case 'Abdomen':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesAbdomenScreenVid()),
                  );
                  break;
                case 'Antebrazo':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesAntebrazoScreenVid()),
                  );
                  break;
                case 'Cuádriceps':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesCuadricepsScreenVid()),
                  );
                  break;
                case 'Tibial anterior':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExercisesTibialAScreenVid()),
                  );
                  break;
                case 'Rutinas':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RutinasScreen()),
                  );
                  break;
                default:
                  break; // Si no coincide con ningún caso, no hace nada.
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Bordes redondeados del botón.
              ),
              foregroundColor: Colors.white, // Color del texto del botón.
              backgroundColor: AppColors.gdarkblue2, // Color de fondo del botón.
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0), // Padding interno del botón.
              textStyle: Theme.of(context).textTheme.labelMedium, // Estilo del texto del botón.
            ),
            child: Center(
              child: Text('Ver Ejercicios $title'), // Texto del botón.
            ),
          ),
        ],
      ),
    ),
  );
}
}