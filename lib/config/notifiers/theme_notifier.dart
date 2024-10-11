import 'package:flutter/material.dart'; // Importa la biblioteca de Material Design de Flutter.
import 'package:flutter/widgets.dart'; // Importa la biblioteca de widgets de Flutter.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca para el almacenamiento de preferencias.

class ThemeNotifier with ChangeNotifier {
  late SharedPreferences _prefs; // Variable para almacenar las preferencias.
  late bool
      _isDarkMode; // Variable que indica si el modo oscuro está habilitado.

  // Constructor que inicializa el modo oscuro en falso y carga el tema almacenado.
  ThemeNotifier() {
    _isDarkMode = false; // Inicializa el modo oscuro en falso por defecto.
    _loadTheme(); // Llama a la función para cargar el tema.
  }

  // Getter que permite acceder al estado del modo oscuro.
  bool get isDarkMode => _isDarkMode;

  // Método para alternar entre el modo claro y el modo oscuro.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode; // Cambia el estado del modo oscuro.
    _saveTheme(); // Guarda el nuevo estado en las preferencias.
    notifyListeners(); // Notifica a los oyentes que ha habido un cambio en el estado.
  }

  // Método que carga el estado del tema desde las preferencias.
  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de SharedPreferences.
    _isDarkMode = _prefs.getBool('isDarkMode') ??
        false; // Carga el valor almacenado o falso por defecto.
    notifyListeners(); // Notifica a los oyentes sobre el estado cargado.
  }

  // Método que guarda el estado del tema en las preferencias.
  Future<void> _saveTheme() async {
    await _prefs.setBool('isDarkMode',
        _isDarkMode); // Almacena el estado actual del modo oscuro.
  }
}
