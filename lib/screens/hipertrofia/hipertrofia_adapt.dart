import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/custom_appbar_new.dart';
import '../ejercicios/Exercises_espalda_screen.dart';
import '../ejercicios/exercises_abdomen_screen_vid.dart';
import '../ejercicios/exercises_antebrazo_screen_vid.dart';
import '../ejercicios/exercises_biceps_screen_vid.dart';
import '../ejercicios/exercises_cuadriceps_screen_vid.dart';
import '../ejercicios/exercises_cuello_screen.dart';
import '../ejercicios/exercises_deltoide_screen_vid.dart';
import '../ejercicios/exercises_gluteo_screen.dart';
import '../ejercicios/exercises_isquiotibiales_screen.dart';
import '../ejercicios/exercises_pantorilla_screen.dart';
import '../ejercicios/exercises_pectoral_screen_vid.dart';
import '../ejercicios/exercises_pierna_screen.dart';
import '../ejercicios/exercises_tibial_a_screen_vid.dart';
import '../../config/utils/appcolors.dart';
import '../ejercicios/exercises_triceps_screen.dart';
import 'hipertrofia_adapt_video.dart';

class HipertrofiaAdapt extends StatefulWidget {
  @override
  _HipertrofiaAdaptState createState() => _HipertrofiaAdaptState();
}

class _HipertrofiaAdaptState extends State<HipertrofiaAdapt> {
  String selectedCard = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onCardTap(String title) async {
    final prefs = await SharedPreferences.getInstance();
    bool isCardTapped = prefs.getBool(title) ?? false;

    if (isCardTapped) {
      _navigateToExerciseScreen(title);
    } else {
      prefs.setBool(title, true);
      setState(() {
        selectedCard = title;
      });
    }
  }

  void _navigateToExerciseScreen(String title) {
    switch (title) {
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

  Future<String> _getSelectedExercise(String title) async {
    final prefs = await SharedPreferences.getInstance();
    String? selectedExerciseName = prefs.getString(
        'selected_exercise_name_${title.toLowerCase().replaceAll(' ', '_')}');
    return selectedExerciseName ?? title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Hipertrofia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HipertrofiaAdaptVideo()),
              );
            },
            icon: const Icon(Icons.close),
            label: Text(AppLocalizations.of(context)!.translate('show')),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 500,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            _buildCard(context, 'Deltoide',
                                'Músculo en la parte superior del brazo y el hombro.'),
                            _buildCard(
                                context, 'Pectoral', 'Músculo del pecho.'),
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 2),
                      Expanded(
                        child: ModelViewer(
                          backgroundColor:
                              const Color.fromARGB(255, 50, 50, 50),
                          src: 'assets/tre_d/cuerpo07.glb',
                          alt: 'A 3D model of a Human Body',
                          ar: true,
                          autoRotate: false,
                          disableZoom: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      selectedCard.isNotEmpty
                          ? _buildInfoCard(selectedCard)
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String description) {
    return FutureBuilder<String>(
      future: _getSelectedExercise(title),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () => _onCardTap(title),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    snapshot.data ?? title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoCard(String title) {
    String content = '';
    if (title == 'Deltoide') {
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
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Triceps') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Gluteos') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Piernas') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Pantorrillas') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Cuello') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Isquiotibiales') {
      content = 'Músculos en la parte frontal del muslo.';
    } else if (title == 'Tibial anterior') {
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
            SizedBox(height: 4),
            Text(
              content,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _navigateToExerciseScreen(title);
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
                child: Text('Ver Ejercicios de $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
