import 'package:flutter/material.dart';


class SelectionNotifier extends ChangeNotifier {
  // Todas las variables que gestionarán las selecciones
  String _intensityEsp = 'Seleccionar';
  String _intensityEng = 'Select';
  
  String _cantidadDeEjerciciosEsp = 'Seleccionar';
  String _cantidadDeEjerciciosEng = 'Select';

  String partesDelCuerpoEsp = 'Seleccionar';
  String partesDelCuerpoEng = 'Select';

  

  // Getters para obtener las selecciones
  String get intensityEsp => _intensityEsp;
  String get intensityEng => _intensityEng;
  
  String get cantidadDeEjerciciosEsp => _cantidadDeEjerciciosEsp;
  String get cantidadDeEjerciciosEng => _cantidadDeEjerciciosEng;

  // Métodos para actualizar las selecciones
  void updateSelection({
    required String intensityEsp,
    required String intensityEng,
    
    required String cantidadDeEjerciciosEsp,
    required String cantidadDeEjerciciosEng,

    required String partesDelCuerpoEsp,
    required String partesDelCuerpoEng,
    
  }) {
    _intensityEsp = intensityEsp;
    _intensityEng = intensityEng;
    
    _cantidadDeEjerciciosEsp = cantidadDeEjerciciosEsp;
    _cantidadDeEjerciciosEng = cantidadDeEjerciciosEng;

    partesDelCuerpoEsp = partesDelCuerpoEsp;
    partesDelCuerpoEng = partesDelCuerpoEng;
    

    notifyListeners(); // Notificar a los listeners de los cambios
  }

}