import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces de usuario.
import 'package:provider/provider.dart'; // Importa Provider para manejar el estado de la aplicación.
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth para autenticación de usuarios.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos de Firebase.
import '../backend/admin/admin_start_screen.dart'; // Importa la pantalla de inicio para administradores.
import '../config/lang/app_localization.dart'; // Importa el archivo para la localización y traducción de la app.
import '../config/notifiers/theme_notifier.dart'; // Importa el notificador de tema para cambiar entre modo oscuro y claro.
import '../desings/themes.dart'; // Importa los temas y estilos de la app.
import 'login_and_register/login/login_screen.dart'; // Importa la pantalla de inicio de sesión.
import 'start_screen.dart'; // Importa la pantalla de inicio para usuarios regulares.

class RoleFirstPage extends StatefulWidget {
  // Este widget maneja la primera pantalla que el usuario ve al abrir la app.
  const RoleFirstPage({super.key});

  @override
  State<RoleFirstPage> createState() => _RoleFirstPageState(); // Crea el estado de la pantalla.
}

class _RoleFirstPageState extends State<RoleFirstPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia para manejar la autenticación de Firebase.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia para acceder a la base de datos de Firestore.

  @override
  void initState() {
    // Función que se ejecuta al iniciar el widget.
    super.initState();
    _checkAuthStatus(); // Verifica el estado de autenticación del usuario.
  }

  // Función que verifica si el usuario está autenticado y redirige según su rol.
  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Añade un retraso de 2 segundos para simular carga.

    if (!mounted) return; // Si el widget no está montado, retorna.

    User? user = _auth.currentUser; // Obtiene el usuario actual autenticado.

    if (user != null) {
      // Si el usuario está autenticado...
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get(); // Obtiene el documento del usuario desde Firestore.

      if (!mounted) return; // Verifica si el widget sigue montado.

      if (userDoc.exists) {
        // Si el documento del usuario existe...
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?; // Convierte los datos del documento en un mapa.
        String rol = userData?['Rol'] ?? ''; // Obtiene el rol del usuario.
        String nombre = userData?['Nombre'] ?? ''; // Obtiene el nombre del usuario.

        // Redirige al usuario dependiendo de su rol.
        if (rol == 'Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminStartScreen(nombre: nombre, rol: rol))); // Si el usuario es "Admin", redirige a la pantalla de admin.
        } else if (rol == 'Super Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminStartScreen(
                        nombre: nombre,
                        rol: rol,
                      ))); // Si el usuario es "Super Admin", también redirige a la pantalla de admin.
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StartScreen(
                  nombre: nombre, rol: rol, currentUserEmail: user.email ?? ''), // Si el rol es otro, redirige a la pantalla de usuario.
            ),
          );
        }
      } else {
        // Si el documento del usuario no existe, no hace nada.
      }
    } else {
      // Si el usuario no está autenticado, lo redirige a la pantalla de inicio de sesión.
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Función que construye la interfaz de usuario.
    final themeNotifier = Provider.of<ThemeNotifier>(context); // Obtiene el estado del tema (modo oscuro/claro).
    final isDarkTheme = themeNotifier.isDarkMode; // Verifica si el tema actual es oscuro.

    // Selecciona las imágenes de acuerdo con el tema (oscuro o claro).
    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png'; // Selecciona la imagen para el logo "cg".
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png'; // Selecciona la imagen para el logo "coachG".

    return Scaffold(
      // Construye la estructura de la pantalla.
      backgroundColor: themeNotifier.isDarkMode
          ? AppTheme.darkTheme.scaffoldBackgroundColor // Establece el color de fondo según el tema.
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Center(
        // El cuerpo principal de la pantalla.
        child: SingleChildScrollView(
          // Permite hacer scroll si la pantalla es muy pequeña.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente.
            children: [
              Image.asset(cgImage, width: 500, height: 150), // Muestra el logo "cg".
              Image.asset(coachGImage, width: 500, height: 100), // Muestra el logo "coachG".
              const SizedBox(height: 25), // Añade un espacio de 25 píxeles.
              CircularProgressIndicator(
                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black), // Muestra un indicador de carga (círculo giratorio).
              const SizedBox(height: 25), // Añade otro espacio de 25 píxeles.
              Text(
                // Muestra un texto de "verificando información del usuario".
                AppLocalizations.of(context)!.translate('checkingUserInfo'),
                textAlign: TextAlign.center, // Centra el texto.
                style: themeNotifier.isDarkMode
                    ? AppTheme.darkTheme.textTheme.titleLarge // Aplica el estilo de texto dependiendo del tema.
                    : AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
