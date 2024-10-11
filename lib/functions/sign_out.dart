import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para manejar autenticación.
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets.
import 'package:google_sign_in/google_sign_in.dart'; // Importa la biblioteca para manejar el inicio de sesión con Google.
import 'package:shared_preferences/shared_preferences.dart'; // Importa para manejar almacenamiento de preferencias.
import 'package:app/screens/login_and_register/login_or_register.dart'; // Importa la pantalla de inicio de sesión o registro.

// Función para cerrar sesión del usuario.
Future<void> signOut(BuildContext context) async {
  try {
    // Cierra la sesión del usuario autenticado en Firebase.
    await FirebaseAuth.instance.signOut();

    // Crea una instancia de GoogleSignIn para cerrar la sesión de Google.
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut(); // Cierra la sesión de Google.

    // Obtiene una instancia de SharedPreferences para manejar datos persistentes.
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences
        .clear(); // Limpia todas las preferencias almacenadas (como el estado de inicio de sesión).

    // Redirige al usuario a la pantalla de inicio de sesión o registro.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const LoginOrRegister()), // Reemplaza la pantalla actual con LoginOrRegister.
    );
  } catch (e) {
    // Manejo de errores: imprime un mensaje si ocurre un error al cerrar sesión.
    print('Error al cerrar sesión: $e');
  }
}
