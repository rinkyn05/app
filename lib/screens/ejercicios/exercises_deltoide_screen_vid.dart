import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/ejercicio_model.dart';
import '../../config/notifiers/exercises_routine_notifier.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../filtros/ejercicios/ejercicios_filter_screen.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
import '../../functions/rutinas/front_end_firestore_services.dart';
import '../../widgets/custom_appbar_new.dart';
import '../adaptacion_anatomica/anatomic_adapt_video.dart';
import 'ejercicio_detalle_screen.dart';

class ExercisesDeltoideScreenVid extends StatefulWidget {

// Constructor opcional
  ExercisesDeltoideScreenVid({Key? key}) : super(key: key);

  @override
  State<ExercisesDeltoideScreenVid> createState() =>
      _ExercisesDeltoideScreenVidState();
}

class _ExercisesDeltoideScreenVidState
    extends State<ExercisesDeltoideScreenVid> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Ejercicio>> _exercisesFuture;
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  final ExerciseNotifier _exerciseNotifier = ExerciseNotifier();

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _fetchExercises();
  }

  void _filterBySearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  void _showEjerciciosFilterDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EjerciciosFilterScreen(
          onFilterApplied: (
            SelectedBodyPart? selectedBodyPart,
            SelectedEquipment? selectedEquipment,
            SelectedObjetivos? selectedObjetivos,
            String? selectedDifficulty,
            String? selectedMembership,
            String? selectedImpactLevel,
            String? selectedPostura,
            String? selectedPhase,
          ) {
            // Aquí no hace falta lógica extra
          },
          onBodyPartSelectionChanged: (SelectedBodyPart selectedBodyPart) {},
          onEquipmentSelectionChanged: (SelectedEquipment selectedEquipment) {},
          onObjetivosSelectionChanged: (SelectedObjetivos SelectedObjetivos) {},
          onDifficultySelectionChanged: (String selectedDifficulty) {},
          onMembershipSelectionChanged: (String? selectedMembership) {},
          onImpactLevelSelectionChanged: (String? selectedImpactLevel) {},
          onPosturaSelectionChanged: (String? selectedPostura) {},
          onPhaseSelectionChanged: (String? selectedPhase) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Deltoide',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 6.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                debugPrint("Video is ready.");
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 10.0,
                              ),
                            ),
                            onChanged: _filterBySearchQuery,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _filterBySearchQuery(_searchController.text);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.search,
                                size: 30,  color: const Color.fromARGB(255, 68, 68, 68)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showEjerciciosFilterDialog,
                  icon: Icon(Icons.filter_list, size: 40),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Ejercicio>>(
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading exercises.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No exercises found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final filteredExercises = snapshot.data!.where((ejercicio) {
                  String nombre = ejercicio.nombre.toLowerCase();
                  return _searchQuery.isEmpty || nombre.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    Ejercicio ejercicio = filteredExercises[index];
                    bool isPremium = ejercicio.membershipEng == "Premium" ||
                        ejercicio.membershipEsp == "Premium";

                    return InkWell(
                      onTap: () {
                        if (isPremium) {
                          _showPremiumDialog();
                        } else {
                          _showOptionsDialog(ejercicio);
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  ejercicio.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ejercicio.nombre,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isPremium
                                    ? Icons.lock
                                    : Icons.arrow_forward_ios,
                                color: isPremium ? Colors.red : Colors.green,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Ejercicio>> _fetchExercises() async {
    String langCode = _getLanguageCode();
    List<Ejercicio> allExercises =
        await FrontEndFirestoreServices().getEjercicios(langCode);
    List<Ejercicio> filteredExercises = allExercises.where((ejercicio) {
      for (var bodypart in ejercicio.bodyParts) {
        if (bodypart['NombreEng'] == 'Deltoide' &&
            bodypart['NombreEsp'] == 'Deltoide') {
          return true;
        }
      }
      return false;
    }).toList();
    return filteredExercises;
  }

  String _getLanguageCode() {
    return Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
  }

  void _showOptionsDialog(Ejercicio ejercicio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('¿Qué quieres hacer?'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectExercise(ejercicio);
              },
              child: Text(
                'Agregar a Rutina',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EjercicioDetalleScreen(
                      ejercicio: ejercicio,
                    ),
                  ),
                );
              },
              child: Text('Ver detalles'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Premium'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Text(
          'Debes ser usuario premium para usar o ver este ejercicio.',
        ),
      ),
    );
  }

  Future<void> _selectExercise(Ejercicio ejercicio) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selected_body_part_deltoide', 'Deltoide');
    await prefs.setString('selected_exercise_name_deltoide', ejercicio.nombre);
    await prefs.setString(
        'selected_exercise_details_deltoide', ejercicio.toJson());

    _exerciseNotifier.selectExercise('Deltoide');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Has seleccionado ${ejercicio.nombre}'),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnatomicAdaptVideo(
        ),
      ),
    );
  }
}

extension EjercicioExtension on Ejercicio {
  String toJson() {
    return '{'
        '"nombre": "$nombre",'
        '"imageUrl": "$imageUrl",'
        '"membershipEng": "$membershipEng",'
        '"membershipEsp": "$membershipEsp",'
        '"bodyParts": ${bodyParts.map((e) => e.toString()).toList()}'
        '}';
  }
}
