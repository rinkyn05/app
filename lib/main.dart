import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/lang/app_localization.dart';
import 'config/notifiers/body_part_notifier.dart';
import 'config/notifiers/calentamiento_especifico_notifier.dart';
import 'config/notifiers/category_ejercicio_notifier.dart';
import 'config/notifiers/category_notifier.dart';
import 'config/notifiers/equipment_notifier.dart';
import 'config/notifiers/estiramiento_especifico_notifier.dart';
import 'config/notifiers/exercises_routine_notifier.dart';
import 'config/notifiers/language_notifier.dart';
import 'config/notifiers/objetivos_notifier.dart';
import 'config/notifiers/selected_notifier.dart';
import 'config/notifiers/selection_notifier.dart';
import 'config/notifiers/theme_notifier.dart';
import 'config/notifiers/unequipment_notifier.dart';
import 'desings/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/first_page.dart';

void main() async {
  // Asegura que Flutter esté completamente inicializado antes de ejecutar cualquier otro código.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones actuales para la plataforma (web, Android, iOS, etc.).
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Obtiene una instancia de SharedPreferences para acceder a los valores guardados en el dispositivo.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Recupera el idioma guardado en las preferencias o establece 'es' (español) por defecto si no existe.
  var languageCode = prefs.getString('languageCode') ?? 'es';

  // Inicializa el LanguageNotifier usando el código de idioma recuperado.
  var languageNotifier = await LanguageNotifier.create(languageCode);

  // Ejecuta la aplicación, pasándole el LanguageNotifier como argumento para gestionar el idioma seleccionado.
  runApp(MyApp(languageNotifier: languageNotifier));
}

class MyApp extends StatelessWidget {
  // Variable para gestionar el cambio de idioma en toda la app.
  final LanguageNotifier languageNotifier;

  // Constructor que recibe el LanguageNotifier.
  const MyApp({super.key, required this.languageNotifier});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Proveedor múltiple para manejar todos los notifiers (gestores de estado) que se usan en la app.
      providers: [
        // Proveedor que gestiona el tema (oscuro o claro) de la app.
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        // Proveedor que gestiona el idioma de la app.
        ChangeNotifierProvider.value(value: languageNotifier),
        // Proveedores que gestionan distintas partes de la app, como categorías de ejercicios, objetivos, etc.
        ChangeNotifierProvider(create: (_) => CategoryNotifier()),
        ChangeNotifierProvider(create: (_) => BodyPartNotifier()),
        ChangeNotifierProvider(create: (_) => EquipmentNotifier()),
        ChangeNotifierProvider(create: (_) => UnequipmentNotifier()),
        ChangeNotifierProvider(create: (_) => ObjetivoNotifier()),
        ChangeNotifierProvider(create: (_) => CatEjercicioNotifier()),
        ChangeNotifierProvider(create: (_) => ExerciseNotifier()),
        ChangeNotifierProvider(create: (_) => CalentamientoEspecificoNotifier()),
        ChangeNotifierProvider(create: (_) => EstiramientoEspecificoNotifier()),
        ChangeNotifierProvider(create: (_) => SelectedItemsNotifier()),
        ChangeNotifierProvider(create: (_) => SelectionNotifier()),
      ],
      child: Builder(
        builder: (context) {
          // Recupera el estado del tema (oscuro o claro) desde el ThemeNotifier.
          final themeNotifier = Provider.of<ThemeNotifier>(context);

          return MaterialApp(
            // Oculta el banner de depuración de la app.
            debugShowCheckedModeBanner: false,

            // Título de la aplicación.
            title: 'Gabriel Coach',

            // Configura el tema de la app basado en el estado (oscuro o claro).
            theme: themeNotifier.isDarkMode
                ? AppTheme.darkTheme // Si el modo oscuro está activado, usa el tema oscuro.
                : AppTheme.lightTheme, // De lo contrario, usa el tema claro.

            // Establece el idioma de la app según el LanguageNotifier.
            locale: languageNotifier.currentLocale,

            // Idiomas soportados por la app (español e inglés en este caso).
            supportedLocales: const [
              Locale('es', ''), // Español.
              Locale('en', ''), // Inglés.
            ],

            // Delegados que permiten la localización de textos y widgets de Flutter en diferentes idiomas.
            localizationsDelegates: const [
              AppLocalizations.delegate, // Soporte para localización personalizada.
              GlobalMaterialLocalizations.delegate, // Localización de widgets de Material.
              GlobalWidgetsLocalizations.delegate, // Localización de widgets.
              GlobalCupertinoLocalizations.delegate, // Localización de widgets de estilo Cupertino (iOS).
            ],

            // Lógica que determina qué idioma utilizar basado en el idioma del dispositivo.
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                // Si el idioma del dispositivo coincide con alguno soportado, úsalo.
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              // Si no hay coincidencia, usa el primer idioma soportado (español).
              return supportedLocales.first;
            },

            // Página de inicio de la app.
            home: const FirstPage(),
          );
        },
      ),
    );
  }
}
