import 'package:cloud_firestore/cloud_firestore.dart';

class ObjectivesFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  static Future<void> updateUserObjectives(
      String email, List<String> objectives) async {
    try {
      print('Buscando usuario con correo electrónico: $email');
      final usersRef = _firestore.collection(_collection);
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        if (userDoc.exists) {
          print('Usuario encontrado. Actualizando objetivos...');
          final data = userDoc.data();
          if (data.containsKey('misobjetivos')) {
            List<dynamic> currentObjectives = data['misobjetivos'];
            currentObjectives.addAll(objectives);
            await userDoc.reference.update({'misobjetivos': currentObjectives});
            print(
                'Objetivos agregados correctamente para el usuario con correo electrónico: $email');
          } else {
            await userDoc.reference
                .set({'misobjetivos': objectives}, SetOptions(merge: true));
            print(
                'Campo "misobjetivos" creado y objetivos agregados correctamente para el usuario con correo electrónico: $email');
          }
        } else {
          print('El documento del usuario no existe');
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico: $email');
      }
    } catch (e) {
      print('Error al actualizar los objetivos del usuario: $e');
      throw Exception('Error al actualizar los objetivos del usuario');
    }
  }

  static Future<List<String>> getUserObjectives(String email) async {
    try {
      print('Buscando objetivos del usuario con correo electrónico: $email');
      final usersRef = _firestore.collection(_collection);
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final data = userDoc.data();
        if (data.containsKey('misobjetivos')) {
          List<dynamic> userObjectives = data['misobjetivos'];
          print(
              'Objetivos del usuario con correo electrónico $email: $userObjectives');
          return userObjectives
              .map((objective) => objective.toString())
              .toList();
        } else {
          print(
              'El usuario con correo electrónico $email no tiene objetivos registrados.');
          return [];
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico: $email');
        return [];
      }
    } catch (e) {
      print('Error al obtener los objetivos del usuario: $e');
      throw Exception('Error al obtener los objetivos del usuario');
    }
  }

  static Future<List<String>> getCompletedObjectives(String email) async {
    try {
      print(
          'Obteniendo objetivos completados del usuario con correo electrónico: $email');
      final usersRef = _firestore.collection(_collection);
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: email).get();

      List<String> completedObjectives = [];
      querySnapshot.docs.forEach((doc) {
        if (doc.data().containsKey('completedObjective')) {
          completedObjectives.add(doc['completedObjective']);
        }
      });

      print(
          'Objetivos completados del usuario con correo electrónico $email: $completedObjectives');
      return completedObjectives;
    } catch (e) {
      print('Error al obtener los objetivos completados del usuario: $e');
      throw Exception('Error al obtener los objetivos completados del usuario');
    }
  }

  static Future<void> markObjectiveAsCompleted(
      String email, String objective) async {
    try {
      print(
          'Marcando objetivo como completado: $objective para el usuario con correo electrónico: $email');
      final usersRef = _firestore.collection(_collection);
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        if (userDoc.exists) {
          print('Usuario encontrado. Marcando objetivo como completado...');
          final data = userDoc.data();
          if (data.containsKey('misobjetivos')) {
            List<dynamic> currentObjectives = data['misobjetivos'];
            for (int i = 0; i < currentObjectives.length; i++) {
              if (currentObjectives[i] == objective) {
                currentObjectives[i] = {
                  'objetivo': objective,
                  'completado': true
                };
                break;
              }
            }
            await userDoc.reference.update({'misobjetivos': currentObjectives});
            print(
                'Objetivo marcado como completado correctamente para el usuario con correo electrónico: $email');
          } else {
            print('No se encontró el campo "misobjetivos"');
          }
        } else {
          print('El documento del usuario no existe');
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico: $email');
      }
    } catch (e) {
      print('Error al marcar objetivo como completado: $e');
      throw Exception('Error al marcar objetivo como completado');
    }
  }

  static Future<void> updateObjectiveCompletion(
      String email, List<Map<String, dynamic>> objectives) async {
    try {
      print('Actualizando estado de completado para los objetivos...');
      final usersRef = _firestore.collection(_collection);
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        if (userDoc.exists) {
          print('Usuario encontrado. Actualizando estado de completado...');
          final data = userDoc.data();
          if (data.containsKey('misobjetivos')) {
            List<dynamic> currentObjectives = data['misobjetivos'];
            for (var obj in objectives) {
              for (int i = 0; i < currentObjectives.length; i++) {
                if (currentObjectives[i]['objetivo'] == obj['objetivo']) {
                  currentObjectives[i]['completado'] = obj['completado'];
                  break;
                }
              }
            }
            await userDoc.reference.update({'misobjetivos': currentObjectives});
            print('Estado de completado actualizado para los objetivos.');
          } else {
            print('No se encontró el campo "misobjetivos"');
          }
        } else {
          print('El documento del usuario no existe');
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico: $email');
      }
    } catch (e) {
      print('Error al actualizar el estado de completado de los objetivos: $e');
      throw Exception(
          'Error al actualizar el estado de completado de los objetivos');
    }
  }
}
