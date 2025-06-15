// ignore_for_file: deprecated_member_use

import 'package:app/screens/rutinas/rutina_set_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_appbar_new.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Asegúrate de tener esta dependencia en tu pubspec.yaml

class RutinasScreen extends StatefulWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  List<Widget> rutinas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRutinas();
  }

  // Función para almacenar los valores de la rutina
  Future<void> _storeRoutineData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'nombreRutinaStart', data['nombreRutinaEsp'] ?? 'N/A');

    // Almacenar EJERCICIOS como List<String>
    List<String> ejerciciosList =
        data['EJERCICIOS'] != null ? List<String>.from(data['EJERCICIOS']) : [];
    await prefs.setStringList('ejerciciosStart', ejerciciosList);

    // Almacenar exercisesTitles como List<String>
    List<String> exercisesTitlesList = data['exercisesTitles'] != null
        ? List<String>.from(data['exercisesTitles'])
        : [];
    await prefs.setStringList('exercisesTitlesStart', exercisesTitlesList);

    await prefs.setString(
        'calentamientoFisicoEspStart', data['calentamientoFisicoEsp'] ?? 'N/A');
    await prefs.setString(
        'calentamientoFisicoIdStart', data['calentamientoFisicoId'] ?? 'N/A');
    await prefs.setString('calentamientoFisicoNameEspStart',
        data['calentamientoFisicoNameEsp'] ?? 'N/A');
    await prefs.setString('cantidadDeEjerciciosEspStart',
        data['cantidadDeEjerciciosEsp'] ?? 'N/A');
    await prefs.setString('repeticionesPorEjerciciosEspStart',
        data['repeticionesPorEjerciciosEsp'] ?? 'N/A');
    await prefs.setString('descansoEntreEjerciciosEspStart',
        data['descansoEntreEjerciciosEsp'] ?? 'N/A');
    await prefs.setString(
        'cantidadDeCircuitosEspStart', data['cantidadDeCircuitosEsp'] ?? 'N/A');
    await prefs.setString('descansoEntreCircuitoEspStart',
        data['descansoEntreCircuitoEsp'] ?? 'N/A');
    await prefs.setString('estiramientoEstaticoEspStart',
        data['estiramientoEstaticoEsp'] ?? 'N/A');
    await prefs.setString('estiramientoFisicoNameEspStart',
        data['estiramientoFisicoNameEsp'] ?? 'N/A');
    await prefs.setString(
        'estiramientoFisicoIdStart', data['estiramientoFisicoId'] ?? 'N/A');
    await prefs.setString('calentamientoArticularEspStart',
        data['calentamientoArticularEsp'] ?? 'N/A');

    // Imprimir los valores almacenados
    print('Valores almacenados en SharedPreferences:');
    print('nombreRutinaStart: ${data['nombreRutinaEsp'] ?? 'N/A'}');
    print('ejerciciosStart: $ejerciciosList');
    print('exercisesTitlesStart: $exercisesTitlesList');
    print(
        'calentamientoFisicoEspStart: ${data['calentamientoFisicoEsp'] ?? 'N/A'}');
    print(
        'calentamientoFisicoIdStart: ${data['calentamientoFisicoId'] ?? 'N/A'}');
    print(
        'calentamientoFisicoNameEspStart: ${data['calentamientoFisicoNameEsp'] ?? 'N/A'}');
    print(
        'cantidadDeEjerciciosEspStart: ${data['cantidadDeEjerciciosEsp'] ?? 'N/A'}');
    print(
        'repeticionesPorEjerciciosEspStart: ${data['repeticionesPorEjerciciosEsp'] ?? 'N/A'}');
    print(
        'descansoEntreEjerciciosEspStart: ${data['descansoEntreEjerciciosEsp'] ?? 'N/A'}');
    print(
        'cantidadDeCircuitosEspStart: ${data['cantidadDeCircuitosEsp'] ?? 'N/A'}');
    print(
        'descansoEntreCircuitoEspStart: ${data['descansoEntreCircuitoEsp'] ?? 'N/A'}');
    print(
        'estiramientoEstaticoEspStart: ${data['estiramientoEstaticoEsp'] ?? 'N/A'}');
    print(
        'estiramientoFisicoNameEspStart: ${data['estiramientoFisicoNameEsp'] ?? 'N/A'}');
    print(
        'estiramientoFisicoIdStart: ${data['estiramientoFisicoId'] ?? 'N/A'}');
    print(
        'calentamientoArticularEspStart: ${data['calentamientoArticularEsp'] ?? 'N/A'}');
  }

  // Función para obtener las rutinas de Firestore
  Future<void> _fetchRutinas() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('misRutinas')
          .where('email', isEqualTo: user.email)
          .get();

      List<Widget> fetchedRutinas = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Crear un Card con la información de la rutina
        fetchedRutinas.add(
          Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['nombreRutinaEsp'] ?? 'Rutina sin nombre',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Columna 1: Intensidad
                      Expanded(
                        child: Column(
                          children: [
                            FaIcon(
                              data['intensidadEsp'] == 'Fácil'
                                  ? FontAwesomeIcons.fireAlt
                                  : data['intensidadEsp'] == 'Intermedio'
                                      ? FontAwesomeIcons.fire
                                      : FontAwesomeIcons.fireAlt,
                              color: data['intensidadEsp'] == 'Fácil'
                                  ? Colors.green
                                  : data['intensidadEsp'] == 'Intermedio'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                            Text(data['intensidadEsp'] ?? ''),
                          ],
                        ),
                      ),
                      // Columna 2: Cantidad de ejercicios
                      Expanded(
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.dumbbell),
                            Text('${data['cantidadDeEjerciciosEsp'] ?? 0}'),
                          ],
                        ),
                      ),
                      // Columna 3: Cantidad de circuitos
                      Expanded(
                        child: Column(
                          children: [
                            FaIcon(FontAwesomeIcons.retweet),
                            Text('${data['cantidadDeCircuitosEsp'] ?? 0}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de eliminar
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.trashAlt,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(doc.id);
                      },
                    ),
                    // Icono de comenzar rutina
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        try {
                          // Almacenar los valores en SharedPreferences
                          await _storeRoutineData(data);

                          // Navegar directamente a la pantalla de configuración de la rutina

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RutinaSetUp()),
                          );
                        } catch (e) {
                          // Mostrar un SnackBar o un diálogo de error si ocurre un problema
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al iniciar la rutina: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      setState(() {
        rutinas = fetchedRutinas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Manejar el error de alguna manera, por ejemplo, mostrar un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se pudieron cargar las rutinas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  // Función para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: FaIcon(
            FontAwesomeIcons.exclamationTriangle,
            color: Colors.red,
          ),
          content: Text('¿Estás seguro que quieres borrar la rutina?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('misRutinas')
                      .doc(docId)
                      .delete();
                  _fetchRutinas();
                } catch (e) {
                  // Manejar el error de eliminación
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('No se pudo borrar la rutina.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Borrar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el diálogo con instrucciones
  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instrucciones para crear una rutina'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('1. Ve a Crear Plan.'),
                Text('2. Configura tu plan y toca Guardar.'),
                Text(
                    '3. Vuelve atrás y selecciona los ejercicios para tu rutina.'),
                Text('4. Toca Guardar Rutina.'),
                Text(
                    '5. Todas las tarjetas deben tener un ejercicio seleccionado para guardar la rutina.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Función para construir la lista de rutinas
  Widget _buildRutinasList() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (rutinas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No hay rutinas guardadas.'),
            SizedBox(height: 10),
            Text('Sigue las instrucciones para crear una.'),
          ],
        ),
      );
    } else {
      return ListView(
        children: rutinas,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: _buildRutinasList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInstructionsDialog,
        tooltip: 'Agregar Rutina',
        child: Icon(Icons.add),
      ),
    );
  }
}
