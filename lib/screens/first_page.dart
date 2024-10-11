import 'package:app/screens/login_and_register/login_or_register.dart'; // Importa la pantalla de inicio de sesión o registro
import 'package:flutter/material.dart'; // Importa los widgets de Flutter
import 'package:provider/provider.dart'; // Importa el paquete Provider para la gestión del estado
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para autenticación
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences para almacenar datos
import '../config/lang/app_localization.dart'; // Importa las configuraciones de localización
import '../config/notifiers/theme_notifier.dart'; // Importa el notifier de tema para gestionar el tema de la aplicación
import '../desings/themes.dart'; // Importa los temas de diseño
import 'role_first_page.dart'; // Importa la pantalla que se muestra después del inicio de sesión
import 'onboarding/onboarding_screen.dart'; // Importa la pantalla de onboarding

class FirstPage extends StatefulWidget {
  const FirstPage(
      {super.key}); // Constructor de la clase con una clave opcional

  @override
  State<FirstPage> createState() =>
      _FirstPageState(); // Crea el estado para la primera página
}

class _FirstPageState extends State<FirstPage> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Instancia de FirebaseAuth para gestionar la autenticación

  @override
  void initState() {
    super.initState(); // Llama al método initState de la clase padre
    _checkAuthStatus(); // Llama a la función para verificar el estado de autenticación
  }

  // Método asíncrono para verificar el estado de autenticación del usuario
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Espera 2 segundos

    if (!mounted) return; // Verifica si el widget está montado

    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de SharedPreferences
    bool isFirstTime = prefs.getBool('isFirstTime') ??
        true; // Comprueba si es la primera vez que se inicia la app

    if (isFirstTime) {
      await prefs.setBool(
          'isFirstTime', false); // Establece que no es la primera vez

      if (!mounted) return; // Verifica si el widget está montado
      Navigator.pushReplacement(
        // Navega a la pantalla de onboarding
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      User? user = _auth.currentUser; // Obtiene el usuario actual
      if (user == null) {
        // Si no hay usuario autenticado
        if (!mounted) return; // Verifica si el widget está montado
        Navigator.pushReplacement(
          // Navega a la pantalla de inicio de sesión o registro
          context,
          MaterialPageRoute(builder: (context) => const LoginOrRegister()),
        );
      } else {
        if (!mounted) return; // Verifica si el widget está montado
        Navigator.pushReplacement(
          // Navega a la pantalla de rol del usuario
          context,
          MaterialPageRoute(builder: (context) => const RoleFirstPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier =
        Provider.of<ThemeNotifier>(context); // Obtiene el notifier de tema
    final isDarkTheme =
        themeNotifier.isDarkMode; // Verifica si el tema es oscuro

    // Define las imágenes a usar dependiendo del tema
    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    return Scaffold(
      backgroundColor: themeNotifier
              .isDarkMode // Establece el color de fondo basado en el tema
          ? AppTheme.darkTheme.scaffoldBackgroundColor
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          // Permite el desplazamiento si el contenido excede la pantalla
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos en la columna
            children: [
              Image.asset(cgImage,
                  width: 500, height: 150), // Muestra la imagen superior
              Image.asset(coachGImage,
                  width: 500, height: 100), // Muestra la imagen inferior
              const SizedBox(
                  height: 25), // Espacio entre las imágenes y el indicador
              CircularProgressIndicator(
                  // Indicador de carga circular
                  color: themeNotifier.isDarkMode
                      ? Colors.white
                      : Colors.black), // Color del indicador basado en el tema
              const SizedBox(
                  height: 25), // Espacio entre el indicador y el texto
              Text(
                AppLocalizations.of(context)!.translate(
                    'checkingAuthStatus'), // Texto que indica que se está verificando el estado de autenticación
                textAlign: TextAlign.center, // Alinea el texto al centro
                style: themeNotifier
                        .isDarkMode // Estilo del texto basado en el tema
                    ? AppTheme.darkTheme.textTheme.titleLarge
                    : AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
