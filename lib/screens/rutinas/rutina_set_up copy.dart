// rutina_set_up.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'rutina_ejecucion_screen.dart';

class RutinaSetUp extends StatefulWidget {
  @override
  _RutinaSetUpState createState() => _RutinaSetUpState();
}

class _RutinaSetUpState extends State<RutinaSetUp> {
  @override
  void initState() {
    super.initState();
    _initializeDataAndNavigate();
  }

  Future<void> _initializeDataAndNavigate() async {
    await _getCalentamientoFisicoImageUrlFromPreferences();
    await _getEstiramientoFisicoImageUrlFromPreferences();
    await _getEjerciciosImageUrlsFromPreferences();

    // Esperar 3 segundos antes de navegar
    await Future.delayed(Duration(seconds: 3));

    // Navegar a RutinaEjecucionScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RutinaEjecucionScreen()),
    );
  }

  Future<void> _getCalentamientoFisicoImageUrlFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final CalentamientoNameEsp =
        prefs.getString('calentamientoFisicoNameEspStart');
    print('calentamientoFisicoNameEspStart: $CalentamientoNameEsp');

    if (CalentamientoNameEsp == null || CalentamientoNameEsp.isEmpty) {
      print('No se encontró el nombre en SharedPreferences');
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('calentamientoFisico')
          .where('NombreEsp', isEqualTo: CalentamientoNameEsp)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final calentamientoImageUrl = doc.get('URL de la Imagen');
        if (calentamientoImageUrl != null && calentamientoImageUrl.isNotEmpty) {
          await prefs.setString(
              'calentamientoFisicoImgUrl', calentamientoImageUrl);
          print('calentamientoFisicoImgUrl: $calentamientoImageUrl');
        } else {
          print('No se encontró la URL en el documento');
        }
      } else {
        print(
            'No se encontraron documentos con el nombre: $CalentamientoNameEsp');
      }
    } catch (e) {
      print('Error al buscar en Firestore: $e');
    }
  }

  Future<void> _getEstiramientoFisicoImageUrlFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final EstiramientoNameEsp =
        prefs.getString('estiramientoFisicoNameEspStart');
    print('estiramientoFisicoNameEspStart: $EstiramientoNameEsp');

    if (EstiramientoNameEsp == null || EstiramientoNameEsp.isEmpty) {
      print('No se encontró el nombre en SharedPreferences');
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('estiramientoFisico')
          .where('NombreEsp', isEqualTo: EstiramientoNameEsp)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final estiramientoImageUrl = doc.get('URL de la Imagen');
        if (estiramientoImageUrl != null && estiramientoImageUrl.isNotEmpty) {
          await prefs.setString(
              'estiramientoFisicoImgUrl', estiramientoImageUrl);
          print('estiramientoFisicoImgUrl: $estiramientoImageUrl');
        } else {
          print('No se encontró la URL en el documento');
        }
      } else {
        print(
            'No se encontraron documentos con el nombre: $EstiramientoNameEsp');
      }
    } catch (e) {
      print('Error al buscar en Firestore: $e');
    }
  }

  Future<void> _getEjerciciosImageUrlsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final ejerciciosList = prefs.getStringList('ejerciciosStart') ?? [];
    print('ejerciciosList: $ejerciciosList');

    // Lista de ejercicios a omitir
    final ejerciciosAExcluir = [
      'Espalda o Pectoral',
      'Cuadriceps Gluteos o Isquiotibiales',
      'Abdomen',
      'Deltoide',
      'Pantorrillas',
      'Espalda',
      'Pectoral',
      'Bicep',
      'Tricep'
    ];

    // Filtrar la lista de ejercicios
    final ejerciciosFiltrados = ejerciciosList
        .where((ejercicio) => !ejerciciosAExcluir.contains(ejercicio))
        .toList();
    print('ejerciciosFiltrados: $ejerciciosFiltrados');

    // Almacenar la lista filtrada en SharedPreferences
    await prefs.setStringList('ejerciciosFiltrados', ejerciciosFiltrados);
    print('Lista de ejercicios filtrados almacenada en SharedPreferences.');

    for (int i = 0; i < ejerciciosFiltrados.length; i++) {
      final ejercicio = ejerciciosFiltrados[i];
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('ejercicios')
            .where('NombreEsp', isEqualTo: ejercicio)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final doc = querySnapshot.docs.first;
          final imageUrl = doc.get('URL de la Imagen');
          if (imageUrl != null && imageUrl.isNotEmpty) {
            final key = 'imgEjercicio${i + 1}';
            await prefs.setString(key, imageUrl);
            print('ejercicio ${i + 1}: $ejercicio');
            print('$key: $imageUrl');
          } else {
            print(
                'No se encontró la URL en el documento para el ejercicio: $ejercicio');
          }
        } else {
          print('No se encontraron documentos con el nombre: $ejercicio');
        }
      } catch (e) {
        print(
            'Error al buscar en Firestore para el ejercicio: $ejercicio, Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preparate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Preparate para comenzar tu rutina',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
