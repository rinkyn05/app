import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../widgets/custom_appbar_new.dart';
import 'ejercicios/Exercises_espalda_screen.dart';
import 'ejercicios/Exercises_todos_screen.dart';
import 'ejercicios/exercises_abdomen_screen_vid.dart';
import 'ejercicios/exercises_antebrazo_screen_vid.dart';
import 'ejercicios/exercises_biceps_screen_vid.dart';
import 'ejercicios/exercises_cuadriceps_screen_vid.dart';
import 'ejercicios/exercises_cuello_screen.dart';
import 'ejercicios/exercises_deltoide_screen_vid.dart';
import 'ejercicios/exercises_gluteo_screen.dart';
import 'ejercicios/exercises_isquiotibiales_screen.dart';
import 'ejercicios/exercises_pantorilla_screen.dart';
import 'ejercicios/exercises_pectoral_screen_vid.dart';
import 'ejercicios/exercises_pierna_screen.dart';
import 'ejercicios/exercises_tibial_a_screen_vid.dart';
import '../config/utils/appcolors.dart';
import '../../config/lang/app_localization.dart';
import 'ejercicios/exercises_triceps_screen.dart';

class ThreeDImageScreen extends StatefulWidget {
  @override
  _ThreeDImageScreenState createState() => _ThreeDImageScreenState();
}

class _ThreeDImageScreenState extends State<ThreeDImageScreen> {
  String selectedCard = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('exercises'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ModelViewer(
              backgroundColor: Color.fromARGB(255, 50, 50, 50),
              src: 'assets/tre_d/cuerpo07.glb',
              alt: 'A 3D model of a Human Body',
              ar: true,
              autoRotate: false,
              disableZoom: false,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCard(
                    context, 'Todos', 'Aquí puedes ver todos los ejercicios.'),
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
                 _buildCard(context, 'Espalda',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Triceps',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Gluteos',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Piernas',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Pantorrillas',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Cuello',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Isquiotibiales',
                    'Músculos en la parte frontal del muslo.'),
                _buildCard(context, 'Tibial anterior',
                    'Músculo en la parte frontal de la espinilla.'),
              ],
            ),
          ),
          selectedCard.isNotEmpty ? _buildInfoCard(selectedCard) : SizedBox(),
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
    } else if (title == 'Espalda') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Triceps') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Gluteos') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Piernas') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Isquiotibiales') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Pantorrillas') {
      content = 'Músculo en la parte frontal de la espinilla.';
    } else if (title == 'Cuello') {
      content = 'Músculo en la parte frontal de la espinilla.';
    }else if (title == 'Tibial anterior') {
      content = 'Músculo en la parte frontal de la espinilla.';
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
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
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
                  case 'Espalda':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesEspaldaScreen()),
                    );
                    break;
                  case 'Triceps':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesTricepsScreen()),
                    );
                    break;
                  case 'Gluteos':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesGluteosScreen()),
                    );
                    break;
                  case 'Piernas':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesPiernasScreen()),
                    );
                    break;
                  case 'Pantorrillas':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesPantorrillasScreen()),
                    );
                    break;
                  case 'Cuello':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesCuelloScreen()),
                    );
                    break;
                  case 'Isquiotibiales':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisesIsquiotibialesScreen()),
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
                child: Text('Ver Todos los Ejercicios de $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
