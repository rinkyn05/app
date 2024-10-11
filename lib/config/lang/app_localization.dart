import 'dart:convert'; // Importa la biblioteca para convertir datos entre diferentes formatos.
import 'package:flutter/material.dart'; // Importa Flutter Material para construir la interfaz de usuario.
import 'package:flutter/services.dart'; // Importa servicios de Flutter para acceder a archivos y recursos.

class AppLocalizations {
  final Locale locale; // Almacena el locale actual para la localización.
  Map<String, String> _localizedStrings =
      {}; // Mapa para almacenar las cadenas localizadas.

  // Constructor que recibe el locale.
  AppLocalizations(this.locale);

  // Método estático para obtener la instancia de AppLocalizations desde el contexto.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Carga las cadenas localizadas desde un archivo JSON.
  Future<bool> load() async {
    // Carga el contenido del archivo JSON que corresponde al idioma actual.
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    // Decodifica el JSON en un mapa.
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Mapea las claves y valores del JSON a un mapa de cadenas.
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true; // Retorna true una vez que se carga el archivo.
  }

  // Traduce una clave usando el mapa de cadenas localizadas.
  String translate(String key, {Map<String, String> params = const {}}) {
    // Obtiene la traducción correspondiente a la clave. Si no existe, retorna la clave.
    String translation = _localizedStrings[key] ?? key;

    // Reemplaza los parámetros en la traducción si se proporcionan.
    params.forEach((key, value) {
      translation = translation.replaceAll('{$key}',
          value); // Reemplaza el marcador por el valor correspondiente.
    });

    return translation; // Retorna la traducción final.
  }

  // Delegado para la localización.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

// Delegado que gestiona la carga de las localizaciones.
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Comprueba si el locale es soportado (solo inglés y español en este caso).
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Crea una instancia de AppLocalizations y carga las localizaciones.
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations
        .load(); // Espera a que se carguen las cadenas localizadas.
    return localizations; // Retorna la instancia cargada.
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) =>
      false; // Indica si se debe recargar la localización (no en este caso).
}
