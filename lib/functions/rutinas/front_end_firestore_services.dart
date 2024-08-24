import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/ejercicio_model.dart';

class FrontEndFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ejercicio>> getEjercicios(String languageCode) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('ejercicios').get();
    return querySnapshot.docs
        .map((doc) => Ejercicio.fromMap(
            doc.data() as Map<String, dynamic>, doc.id, languageCode))
        .toList();
  }

  Future<List<Ejercicio>> getEjerciciosDeltoid(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsDeltoide = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('deltoide'));

        if (containsDeltoide) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosPectoral(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsPectoral = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('pectoral'));

        if (containsPectoral) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosBiceps(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsBiceps = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('bícep'));

        if (containsBiceps) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosAbdomen(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsAbdomen = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('abdomen'));

        if (containsAbdomen) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosAntebrazo(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsAntebrazo = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('antebrazo'));

        if (containsAntebrazo) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosCuadriceps(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsCuadriceps = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('cuádriceps'));

        if (containsCuadriceps) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }

  Future<List<Ejercicio>> getEjerciciosTibialA(String languageCode) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejercicios')
          .get();

      List<Ejercicio> ejercicios = [];
      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        bool containsTibialA = data.values.any((value) => value
            .toString()
            .toLowerCase()
            .contains('tibial anterior'));

        if (containsTibialA) {
          ejercicios.add(Ejercicio.fromMap(
              data, doc.id, languageCode));
        }
      });

      return ejercicios;
    } catch (e) {
      print('Error al obtener ejercicios: $e');
      return [];
    }
  }
}
