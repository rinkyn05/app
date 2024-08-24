import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../backend/models/ejercicio_model.dart';
import '../../functions/rutinas/front_end_firestore_services.dart';
import '../../functions/rutinas/rutina_service.dart';
import '../../widgets/custom_appbar_new.dart';
import 'rutinas_screen.dart';

class AddRutinasScreen extends StatefulWidget {
  final List<Ejercicio> ejerciciosSeleccionados;

  const AddRutinasScreen({Key? key, required this.ejerciciosSeleccionados})
      : super(key: key);

  @override
  AddRutinasScreenState createState() => AddRutinasScreenState();
}

class AddRutinasScreenState extends State<AddRutinasScreen> {
  TextEditingController routineNameController = TextEditingController();
  Future<List<Ejercicio>> _ejerciciosFuture = Future.value([]);
  int selectedInterval = 10;
  int maxEjercicios = 10;
  late String languageCode;
  late List<Ejercicio> ejerciciosSeleccionados;

  @override
  void initState() {
    super.initState();
    languageCode = 'es';
    ejerciciosSeleccionados = widget.ejerciciosSeleccionados;
    _ejerciciosFuture = Future.value([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        languageCode = Provider.of<LanguageNotifier>(context, listen: false)
            .currentLocale
            .languageCode;
        _ejerciciosFuture =
            FrontEndFirestoreServices().getEjercicios(languageCode);
        _fetchEjercicios();
      });
    });
  }

  void _fetchEjercicios() {
    _ejerciciosFuture = FrontEndFirestoreServices().getEjercicios(languageCode);
  }

  void agregarEjercicio(Ejercicio ejercicio) {
    setState(() {
      if (!ejerciciosSeleccionados.contains(ejercicio)) {
        ejerciciosSeleccionados.add(ejercicio);
      }
    });
  }

  void removerEjercicio(Ejercicio ejercicio) {
    setState(() {
      ejerciciosSeleccionados.remove(ejercicio);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.translate('selectedExercises'),
                  style: theme.textTheme.titleLarge),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: maxEjercicios,
                itemBuilder: (context, index) {
                  final ejercicio = index < ejerciciosSeleccionados.length
                      ? ejerciciosSeleccionados[index]
                      : null;

                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: ejercicio != null
                              ? Image.network(
                                  ejercicio.imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(Icons.fitness_center,
                                      color: Colors.grey[400]),
                                ),
                        ),
                      ),
                      if (ejercicio != null)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => removerEjercicio(ejercicio),
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.translate('routineName'),
                  style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: routineNameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.translate('routineName'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.translate('intervalLabel'),
                  style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: List.generate(
                    3,
                    (index) => ChoiceChip(
                          label: Text('${[10, 20, 30][index]} s'),
                          selected: selectedInterval == [10, 20, 30][index],
                          onSelected: (bool selected) {
                            setState(
                                () => selectedInterval = [10, 20, 30][index]);
                          },
                        )),
              ),
            ),
            FutureBuilder<List<Ejercicio>>(
              future: _ejerciciosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        AppLocalizations.of(context)!
                            .translate('errorLoadingExercises'),
                        style: theme.textTheme.titleMedium),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        AppLocalizations.of(context)!
                            .translate('noExercisesFound'),
                        style: theme.textTheme.titleMedium),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: snapshot.data!.map((ejercicio) {
                        bool isPremium = ejercicio.membershipEng == "Premium" ||
                            ejercicio.membershipEsp == "Premium";
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(ejercicio.imageUrl,
                                  width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            title: Text(ejercicio.nombre,
                                style: theme.textTheme.titleLarge),
                            subtitle: Text(
                                AppLocalizations.of(context)!
                                    .translate('tapForAdd'),
                                style: theme.textTheme.bodyLarge),
                            trailing: isPremium
                                ? const Icon(Icons.lock,
                                    color: Colors.red, size: 35)
                                : const Icon(Icons.add,
                                    color: Colors.green, size: 35),
                            onTap: () {
                              if (!isPremium) {
                                agregarEjercicio(ejercicio);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ejerciciosSeleccionados.length >= 2
          ? ElevatedButton.icon(
              onPressed: () async {
                if (routineNameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('routineNameRequired')),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final String correoUsuario =
                    FirebaseAuth.instance.currentUser?.email ??
                        "usuario_sin_correo@example.com";
                final String nombreRutina = routineNameController.text.trim();
                final int intervalo = selectedInterval;

                List<Map<String, dynamic>> ejercicios =
                    ejerciciosSeleccionados.map((ejercicio) {
                  return {
                    'imagen': ejercicio.imageUrl,
                    'nombre': ejercicio.nombre,
                    'duracion': ejercicio.duracion,
                    'calorias': ejercicio.calorias,
                  };
                }).toList();

                try {
                  await RutinaService().guardarRutina(
                    correoUsuario: correoUsuario,
                    nombreRutina: nombreRutina,
                    intervalo: intervalo,
                    ejercicios: ejercicios,
                  );

                  final totalRutinasRef = FirebaseFirestore.instance
                      .collection('totalrutinas')
                      .doc('contador');
                  await totalRutinasRef.set({
                    'total': FieldValue.increment(1),
                  }, SetOptions(merge: true));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('routinePublishSuccess')),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 2));

                  routineNameController.clear();
                  ejerciciosSeleccionados.clear();
                  selectedInterval = 10;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RutinasScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('publishErrorMessage')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 2, 11, 59)
                    : Colors.white,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : const Color.fromARGB(255, 2, 11, 59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                padding: const EdgeInsets.all(15.0),
              ),
              icon: const Icon(Icons.check, size: 40),
              label: Text(
                AppLocalizations.of(context)!
                    .translate('addRoutinesScreenTitle'),
                style: const TextStyle(fontSize: 26),
              ),
            )
          : null,
    );
  }
}
