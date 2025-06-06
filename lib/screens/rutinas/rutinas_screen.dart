// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_appbar_new.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Asegúrate de tener esta dependencia en tu pubspec.yaml
import 'rutina_ejecucion_screen.dart';

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
                      onPressed: () {
                        // Mostrar el diálogo con la información de la rutina directamente
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Comenzar Rutina'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Estas Listo Para Comenzar tu Rutina Con Esto:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                        'Nombre Español: ${data['nombreRutinaEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Nombre Ingles:    ${data['nombreRutinaEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Intensidad Español: ${data['intensidadEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Intensidad Ingles: ${data['intensidadEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Tiempo de Calentamiento Español: ${data['calentamientoFisicoEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Tiempo de Calentamiento Ingles: ${data['calentamientoFisicoEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Calentamiento Ingles: ${data['calentamientoFisicoId'] ?? 'N/A'}'),

                                    Text(
                                        'Calentamiento Español: ${data['calentamientoFisicoNameEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Calentamiento Ingles: ${data['calentamientoFisicoNameEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Cantidad De Ejercicios Español: ${data['cantidadDeEjerciciosEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Cantidad De Ejercicios Ingles: ${data['cantidadDeEjerciciosEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Repeticiones Por Ejercicios Español: ${data['repeticionesPorEjerciciosEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Repeticiones Por Ejercicios Ingles: ${data['repeticionesPorEjerciciosEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Descanso Entre Ejercicios Español: ${data['descansoEntreEjerciciosEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Descanso Entre Ejercicios Ingles: ${data['descansoEntreEjerciciosEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Cantidad De Circuitos Español: ${data['cantidadDeCircuitosEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Cantidad De Circuitos Ingles: ${data['cantidadDeCircuitosEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Descanso Entre Circuito Español: ${data['descansoEntreCircuitoEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Descanso Entre Circuito Ingles: ${data['descansoEntreCircuitoEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),
                                    Text(
                                        'Tiempo de Estiramiento Estatico Español: ${data['estiramientoEstaticoEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Tiempo de Estiramiento Estatico Ingles: ${data['estiramientoEstaticoEng'] ?? 'N/A'}'),
                                    SizedBox(height: 5),

                                        Text(
                                        'Estiramiento Estatico Español: ${data['estiramientoFisicoNameEsp'] ?? 'N/A'}'),
                                    Text(
                                        'Estiramiento Estatico Ingles: ${data['estiramientoFisicoNameEng'] ?? 'N/A'}'),

                                    Text(
                                        'Estiramiento Estatico Ingles: ${data['estiramientoFisicoId'] ?? 'N/A'}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Acción para comenzar la rutina
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RutinaEjecucionScreen(
                                          ejercicios: [], // Debes proporcionar una lista de ejercicios aquí
                                          intervalo: data[
                                              'intervalo'], // Asegúrate de que este campo existe en tus datos
                                          nombreRutina: data[
                                              'nombreRutinaEsp'], // O el campo que corresponda
                                          intensidadEsp: data['intensidadEsp'],
                                          intensidadEng: data['intensidadEng'],
                                          calentamientoFisicoEsp:
                                              data['calentamientoFisicoEsp'],
                                          calentamientoFisicoEng:
                                              data['calentamientoFisicoEng'],
                                          descansoEntreEjerciciosEsp: data[
                                              'descansoEntreEjerciciosEsp'],
                                          descansoEntreEjerciciosEng: data[
                                              'descansoEntreEjerciciosEng'],
                                          descansoEntreCircuitoEsp:
                                              data['descansoEntreCircuitoEsp'],
                                          descansoEntreCircuitoEng:
                                              data['descansoEntreCircuitoEng'],
                                          estiramientoEstaticoEsp:
                                              data['estiramientoEstaticoEsp'],
                                          estiramientoEstaticoEng:
                                              data['estiramientoEstaticoEng'],
                                          calentamientoArticularEsp:
                                              data['calentamientoArticularEsp'],
                                          calentamientoArticularEng:
                                              data['calentamientoArticularEng'],
                                          cantidadDeEjerciciosEsp:
                                              data['cantidadDeEjerciciosEsp'],
                                          cantidadDeEjerciciosEng:
                                              data['cantidadDeEjerciciosEng'],
                                          repeticionesPorEjerciciosEsp: data[
                                              'repeticionesPorEjerciciosEsp'],
                                          repeticionesPorEjerciciosEng: data[
                                              'repeticionesPorEjerciciosEng'],
                                          cantidadDeCircuitosEsp:
                                              data['cantidadDeCircuitosEsp'],
                                          cantidadDeCircuitosEng:
                                              data['cantidadDeCircuitosEng'],
                                          nombreRutinaEsp:
                                              data['nombreRutinaEsp'],
                                          nombreRutinaEng:
                                              data['nombreRutinaEng'],
                                          selectedCalentamientoFisicoNameEsp: data[
                                              'selectedCalentamientoFisicoNameEsp'],
                                          selectedCalentamientoFisicoNameEng: data[
                                              'selectedCalentamientoFisicoNameEng'],
                                          selectedEstiramientoFisicoNameEsp: data[
                                              'selectedEstiramientoFisicoNameEsp'],
                                          selectedEstiramientoFisicoNameEng: data[
                                              'selectedEstiramientoFisicoNameEng'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Comenzar'),
                                ),
                              ],
                            );
                          },
                        );
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
