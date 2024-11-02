import 'package:flutter/material.dart';

class SelectionNotifier extends ChangeNotifier {
  // Todas las variables que gestionarán las selecciones
  String _intensityEsp = 'Seleccionar';
  String _intensityEng = 'Select';
  String _calentamientoFisicoEsp = 'Seleccionar';
  String _calentamientoFisicoEng = 'Select';
  String _descansoEntreEjerciciosEsp = 'Seleccionar';
  String _descansoEntreEjerciciosEng = 'Select';
  String _descansoEntreCircuitoEsp = 'Seleccionar';
  String _descansoEntreCircuitoEng = 'Select';
  String _estiramientoEstaticoEsp = 'Seleccionar';
  String _estiramientoEstaticoEng = 'Select';
  String _diasALaSemanaEsp = 'Seleccionar';
  String _diasALaSemanaEng = 'Select';
  String _calentamientoArticularEsp = '5 Minutos';
  String _calentamientoArticularEng = '5 Minutes';
  String _cantidadDeEjerciciosEsp = 'Seleccionar';
  String _cantidadDeEjerciciosEng = 'Select';
  String _repeticionesPorEjerciciosEsp = 'Seleccionar';
  String _repeticionesPorEjerciciosEng = 'Select';
  String _cantidadDeCircuitosEsp = 'Seleccionar';
  String _cantidadDeCircuitosEng = 'Select';
  String _porcentajeDeRMEsp = 'Seleccionar';
  String _porcentajeDeRMEng = 'Select';

  // Getters para obtener las selecciones
  String get intensityEsp => _intensityEsp;
  String get intensityEng => _intensityEng;
  String get calentamientoFisicoEsp => _calentamientoFisicoEsp;
  String get calentamientoFisicoEng => _calentamientoFisicoEng;
  String get descansoEntreEjerciciosEsp => _descansoEntreEjerciciosEsp;
  String get descansoEntreEjerciciosEng => _descansoEntreEjerciciosEng;
  String get descansoEntreCircuitoEsp => _descansoEntreCircuitoEsp;
  String get descansoEntreCircuitoEng => _descansoEntreCircuitoEng;
  String get estiramientoEstaticoEsp => _estiramientoEstaticoEsp;
  String get estiramientoEstaticoEng => _estiramientoEstaticoEng;
  String get diasALaSemanaEsp => _diasALaSemanaEsp;
  String get diasALaSemanaEng => _diasALaSemanaEng;
  String get calentamientoArticularEsp => _calentamientoArticularEsp;
  String get calentamientoArticularEng => _calentamientoArticularEng;
  String get cantidadDeEjerciciosEsp => _cantidadDeEjerciciosEsp;
  String get cantidadDeEjerciciosEng => _cantidadDeEjerciciosEng;
  String get repeticionesPorEjerciciosEsp => _repeticionesPorEjerciciosEsp;
  String get repeticionesPorEjerciciosEng => _repeticionesPorEjerciciosEng;
  String get cantidadDeCircuitosEsp => _cantidadDeCircuitosEsp;
  String get cantidadDeCircuitosEng => _cantidadDeCircuitosEng;
  String get porcentajeDeRMEsp => _porcentajeDeRMEsp;
  String get porcentajeDeRMEng => _porcentajeDeRMEng;

  // Métodos para actualizar las selecciones
  void updateSelection({
    required String intensityEsp,
    required String intensityEng,
    required String calentamientoFisicoEsp,
    required String calentamientoFisicoEng,
    required String descansoEntreEjerciciosEsp,
    required String descansoEntreEjerciciosEng,
    required String descansoEntreCircuitoEsp,
    required String descansoEntreCircuitoEng,
    required String estiramientoEstaticoEsp,
    required String estiramientoEstaticoEng,
    required String diasALaSemanaEsp,
    required String diasALaSemanaEng,
    required String calentamientoArticularEsp,
    required String calentamientoArticularEng,
    required String cantidadDeEjerciciosEsp,
    required String cantidadDeEjerciciosEng,
    required String repeticionesPorEjerciciosEsp,
    required String repeticionesPorEjerciciosEng,
    required String cantidadDeCircuitosEsp,
    required String cantidadDeCircuitosEng,
    required String porcentajeDeRMEsp,
    required String porcentajeDeRMEng,
  }) {
    _intensityEsp = intensityEsp;
    _intensityEng = intensityEng;
    _calentamientoFisicoEsp = calentamientoFisicoEsp;
    _calentamientoFisicoEng = calentamientoFisicoEng;
    _descansoEntreEjerciciosEsp = descansoEntreEjerciciosEsp;
    _descansoEntreEjerciciosEng = descansoEntreEjerciciosEng;
    _descansoEntreCircuitoEsp = descansoEntreCircuitoEsp;
    _descansoEntreCircuitoEng = descansoEntreCircuitoEng;
    _estiramientoEstaticoEsp = estiramientoEstaticoEsp;
    _estiramientoEstaticoEng = estiramientoEstaticoEng;
    _diasALaSemanaEsp = diasALaSemanaEsp;
    _diasALaSemanaEng = diasALaSemanaEng;
    _calentamientoArticularEsp = calentamientoArticularEsp;
    _calentamientoArticularEng = calentamientoArticularEng;
    _cantidadDeEjerciciosEsp = cantidadDeEjerciciosEsp;
    _cantidadDeEjerciciosEng = cantidadDeEjerciciosEng;
    _repeticionesPorEjerciciosEsp = repeticionesPorEjerciciosEsp;
    _repeticionesPorEjerciciosEng = repeticionesPorEjerciciosEng;
    _cantidadDeCircuitosEsp = cantidadDeCircuitosEsp;
    _cantidadDeCircuitosEng = cantidadDeCircuitosEng;
    _porcentajeDeRMEsp = porcentajeDeRMEsp;
    _porcentajeDeRMEng = porcentajeDeRMEng;

    notifyListeners(); // Notificar a los listeners de los cambios
  }
}
