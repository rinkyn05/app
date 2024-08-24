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
import 'config/notifiers/theme_notifier.dart';
import 'config/notifiers/unequipment_notifier.dart';
import 'desings/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var languageCode = prefs.getString('languageCode') ?? 'es';
  var languageNotifier = await LanguageNotifier.create(languageCode);
  runApp(MyApp(languageNotifier: languageNotifier));
}

class MyApp extends StatelessWidget {
  final LanguageNotifier languageNotifier;

  const MyApp({super.key, required this.languageNotifier});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider.value(value: languageNotifier),
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
      ],
      child: Builder(
        builder: (context) {
          final themeNotifier = Provider.of<ThemeNotifier>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Gabriel Coach',
            theme: themeNotifier.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            locale: languageNotifier.currentLocale,
            supportedLocales: const [
              Locale('es', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            home: const FirstPage(),
          );
        },
      ),
    );
  }
}
