import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../backend/models/ejercicio_model.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../functions/rutinas/front_end_firestore_services.dart';
import '../../widgets/custom_appbar_adap.dart';
import '../rutinas/add_rutinas_screen.dart';
import 'adaptacion_anatomica_cuadriceps.dart';
import 'adaptacion_anatomica_antebrazo.dart';
import 'adaptacion_anatomica_biceps.dart';
import 'adaptacion_anatomica_deltoid.dart';
import 'adaptacion_anatomica_pectoral.dart';
import 'adaptacion_anatomica_screen.dart';
import 'adaptacion_anatomica_tibial_a.dart';

class AdaptacionAnatomicaAbdomen extends StatefulWidget {
  final List<Ejercicio> ejerciciosSeleccionados;

  AdaptacionAnatomicaAbdomen({required this.ejerciciosSeleccionados});

  @override
  _AdaptacionAnatomicaAbdomenState createState() =>
      _AdaptacionAnatomicaAbdomenState();
}

class _AdaptacionAnatomicaAbdomenState
    extends State<AdaptacionAnatomicaAbdomen> {
  String selectedCard = 'Abdomen';
  String languageCode = 'es';
  Future<List<Ejercicio>>? _ejerciciosFuture;
  List<Ejercicio> ejerciciosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _ejerciciosFuture = Future.value([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        languageCode = Provider.of<LanguageNotifier>(context, listen: false)
            .currentLocale
            .languageCode;
        _ejerciciosFuture =
            FrontEndFirestoreServices().getEjerciciosAbdomen(languageCode);
        _fetchEjercicios();
      });
    });
  }

  void _fetchEjercicios() {
    _ejerciciosFuture = FrontEndFirestoreServices().getEjerciciosAbdomen(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNewAdapt(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
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
                        height: 320,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            _buildCard(context, 'Todos'),
                            _buildCard(context, 'Deltoide'),
                            _buildCard(context, 'Pectoral'),
                            _buildCard(context, 'Bíceps'),
                            _buildCard(context, 'Abdomen'),
                            _buildCard(context, 'Antebrazo'),
                            _buildCard(context, 'Cuádriceps'),
                            _buildCard(context, 'Tibial Anterior'),
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
                          src: 'assets/tre_d/pectoral_derecho.glb',
                          alt: 'A 3D model of a Human Body',
                          ar: true,
                          autoRotate: false,
                          disableZoom: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Ejercicio>>(
              future: _ejerciciosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error al cargar los ejercicios',
                        style: Theme.of(context).textTheme.titleMedium),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No se encontraron ejercicios',
                        style: Theme.of(context).textTheme.titleMedium),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.map((ejercicio) {
                      bool isSelected =
                          ejerciciosSeleccionados.contains(ejercicio);
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(ejercicio.imageUrl,
                                width: 100, height: 100, fit: BoxFit.cover),
                          ),
                          title: Text(ejercicio.nombre,
                              style: Theme.of(context).textTheme.titleLarge),
                          subtitle: Text(
                              'Tap to ${isSelected ? 'deselect' : 'select'}',
                              style: Theme.of(context).textTheme.bodyLarge),
                          trailing: ejercicio.isPremium
                              ? const Icon(Icons.lock,
                                  color: Colors.red, size: 35)
                              : Icon(
                                  isSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.green,
                                  size: 35),
                          onTap: () {
                            setState(() {
                              if (ejercicio.isPremium) {
                              } else if (isSelected) {
                                ejerciciosSeleccionados.remove(ejercicio);
                              } else {
                                ejerciciosSeleccionados.add(ejercicio);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRutinasScreen(
                    ejerciciosSeleccionados: ejerciciosSeleccionados),
              ),
            );
          },
          label: Text('Crear Rutina'),
          icon: Icon(Icons
              .add),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    Color cardColor = title == 'Abdomen'
        ? const Color.fromARGB(255, 150, 208, 255)
        : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCard = title;
          switch (selectedCard) {
            case 'Todos':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaScreen(ejerciciosSeleccionados: ejerciciosSeleccionados,)),
              );
              break;
            case 'Deltoide':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaDeltoid(
                          ejerciciosSeleccionados: ejerciciosSeleccionados,
                        )),
              );
              break;
            case 'Pectoral':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaPectoral(
                          ejerciciosSeleccionados: ejerciciosSeleccionados,
                        )),
              );
              break;
            case 'Bíceps':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaBiceps(
                          ejerciciosSeleccionados: ejerciciosSeleccionados,
                        )),
              );
              break;
            case 'Abdomen':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaAbdomen(ejerciciosSeleccionados: ejerciciosSeleccionados,)),
              );
              break;
            case 'Antebrazo':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaAntebrazo(ejerciciosSeleccionados: ejerciciosSeleccionados,)),
              );
              break;
            case 'Cuádriceps':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaCuadriceps(ejerciciosSeleccionados: ejerciciosSeleccionados,)),
              );
              break;
            case 'Tibial Anterior':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdaptacionAnatomicaTibialA(ejerciciosSeleccionados: ejerciciosSeleccionados,)),
              );
              break;
            default:
              break;
          }
        });
      },
      child: Card(
        color: cardColor,
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
}
