import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../widgets/custom_appbar_adap.dart';
import 'ejercicios/Exercises_todos_screen.dart';
import 'ejercicios/exercises_abdomen_screen_vid.dart';
import 'ejercicios/exercises_antebrazo_screen_vid.dart';
import 'ejercicios/exercises_biceps_screen_vid.dart';
import 'ejercicios/exercises_cuadriceps_screen_vid.dart';
import 'ejercicios/exercises_deltoide_screen_vid.dart';
import 'ejercicios/exercises_pectoral_screen_vid.dart';
import 'ejercicios/exercises_tibial_a_screen_vid.dart';
import '../config/utils/appcolors.dart';
import 'rutinas/rutinas_screen.dart';

class AdaptacionAnatomicaScreen extends StatefulWidget {
  @override
  _AdaptacionAnatomicaScreenState createState() =>
      _AdaptacionAnatomicaScreenState();
}

class _AdaptacionAnatomicaScreenState extends State<AdaptacionAnatomicaScreen> {
  String selectedCard = '';

  String _getModelSrc(String title) {
    switch (title) {
      case 'Todos':
        return 'assets/tre_d/gabriel.glb';
      case 'Deltoide':
        return 'assets/tre_d/cuerpo_v04.glb';
      case 'Pectoral':
        return 'assets/tre_d/pectoral_derecho.glb';
      case 'Bíceps':
        return 'assets/tre_d/cuerpo.glb';
      case 'Abdomen':
        return 'assets/tre_d/pruebapp.glb';
      case 'Antebrazo':
        return 'assets/tre_d/pruebapp.glb';
      case 'Cuádriceps':
        return 'assets/tre_d/pruebapp.glb';
      case 'Tibial anterior':
        return 'assets/tre_d/pruebapp.glb';
      case 'Rutinas':
        return 'assets/tre_d/pruebapp.glb';
      default:
        return 'assets/tre_d/cuerpo07.glb';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNewAdapt(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 600,
                  child: ListView(
                    scrollDirection: Axis.vertical,
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
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: ModelViewer(
                    backgroundColor: Color.fromARGB(255, 50, 50, 50),
                    src: _getModelSrc(selectedCard),
                    alt: 'A 3D model of a Human Body',
                    ar: true,
                    autoRotate: false,
                    disableZoom: true,
                  ),
                ),
                SizedBox(height: 10),
                selectedCard.isNotEmpty
                    ? _buildInfoCard(selectedCard)
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCard = title;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title) {
    String content = '';
    if (title == 'Todos') {
      content = 'Aqui puedes ver todos los ejercicios.';
    } else if (title == 'Deltoide') {
      content = 'Músculo en la parte superior del brazo y el hombro.';
    } else if (title == 'Pectoral') {
      content = 'Músculo del pecho.';
    } else if (title == 'Bíceps') {
      content = 'Músculo en la parte frontal del brazo.';
    } else if (title == 'Abdomen') {
      content = 'Parte del cuerpo entre el pecho y la pelvis.';
    } else if (title == 'Antebrazo') {
      content =
          'Parte del brazo entre el codo y la muñeca.\nParte del cuerpo entre el pecho y la pelvis.';
    } else if (title == 'Cuádriceps') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Tibial anterior') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Rutinas') {
      content = 'Puedes Crear tus propias rutinas de ejercicios.';
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      selectedCard = '';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
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
                    break;
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.gdarkblue2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              child: Center(
                child: Text('Ver Ejercicios $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
