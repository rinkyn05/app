import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para utilizar widgets y el sistema de localización.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca para manejar Shared Preferences.

class LanguageNotifier with ChangeNotifier {
  final SharedPreferences
      _prefs; // Instancia de SharedPreferences para guardar y recuperar datos.
  Locale _currentLocale; // Almacena el idioma actual.

  // Constructor privado que inicializa el objeto con el idioma actual y las preferencias.
  LanguageNotifier._(this._currentLocale, this._prefs);

  // Método estático para crear una instancia de LanguageNotifier.
  static Future<LanguageNotifier> create(String defaultLanguageCode) async {
    final prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de Shared Preferences.
    String? savedLanguage = prefs
        .getString('languageCode'); // Intenta recuperar el idioma guardado.
    Locale locale;

    // Si no hay un idioma guardado, utiliza el idioma por defecto y lo guarda.
    if (savedLanguage == null) {
      locale = Locale(
          defaultLanguageCode, ''); // Crea un Locale con el idioma por defecto.
      await prefs.setString('languageCode',
          defaultLanguageCode); // Guarda el idioma por defecto en Shared Preferences.
    } else {
      locale =
          Locale(savedLanguage, ''); // Crea un Locale con el idioma guardado.
    }
    return LanguageNotifier._(
        locale, prefs); // Retorna una nueva instancia de LanguageNotifier.
  }

  // Getter para obtener el idioma actual.
  Locale get currentLocale => _currentLocale;

  // Método para cambiar el idioma actual y guardar el cambio.
  Future<void> changeLanguage(Locale newLocale) async {
    _currentLocale = newLocale; // Actualiza el idioma actual.
    await _saveLanguage(); // Guarda el nuevo idioma en Shared Preferences.
    notifyListeners(); // Notifica a los oyentes que el estado ha cambiado.
  }

  // Método para actualizar el idioma actual sin guardar.
  void updateLocale(Locale newLocale) {
    _currentLocale = newLocale; // Actualiza el idioma actual.
    notifyListeners(); // Notifica a los oyentes sobre el cambio.
  }

  // Método privado para guardar el idioma actual en Shared Preferences.
  Future<void> _saveLanguage() async {
    await _prefs.setString('languageCode',
        _currentLocale.languageCode); // Guarda el código del idioma actual.
  }
}
