import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../backend/models/ejercicio_model.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../functions/rutinas/front_end_firestore_services.dart';
import '../../widgets/custom_appbar_new.dart';
import 'ejercicio_detalle_screen.dart';

class ExercisesTodosScreen extends StatefulWidget {
  const ExercisesTodosScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesTodosScreen> createState() => _ExercisesTodosScreenState();
}

class _ExercisesTodosScreenState extends State<ExercisesTodosScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Ejercicio>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              backgroundColor: Color.fromARGB(255, 50, 50, 50),
              src:
                  'assets/tre_d/pruebapp.glb',
              alt: 'A 3D model of a Human Body',
              ar: false,
              autoRotate: false,
              disableZoom: false,
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

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Ejercicio ejercicio = snapshot.data![index];
                    bool isPremium = ejercicio.membershipEng == "Premium" ||
                        ejercicio.membershipEsp == "Premium";

                    return InkWell(
                      onTap: isPremium
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EjercicioDetalleScreen(
                                    ejercicio: ejercicio,
                                  ),
                                ),
                              ),
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
    return await FrontEndFirestoreServices().getEjercicios(langCode);
  }

  String _getLanguageCode() {
    return Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
  }
}
