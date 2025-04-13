import 'dart:async';

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces de usuario.
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth para autenticación de usuarios.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos de Firebase.
import '../backend/admin/admin_start_screen.dart'; // Importa la pantalla de inicio para administradores.
import 'login_and_register/login/login_screen.dart'; // Importa la pantalla de inicio de sesión.
import 'start_screen.dart'; // Importa la pantalla de inicio para usuarios regulares.

import 'package:video_player/video_player.dart';

class RoleFirstPage extends StatefulWidget {
  // Este widget maneja la primera pantalla que el usuario ve al abrir la app.
  const RoleFirstPage({super.key});

  @override
  State<RoleFirstPage> createState() => _RoleFirstPageState(); // Crea el estado de la pantalla.
}

class _RoleFirstPageState extends State<RoleFirstPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia para manejar la autenticación de Firebase.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia para acceder a la base de datos de Firestore.
  late VideoPlayerController _controller;

  @override
  void initState() {
    // Función que se ejecuta al iniciar el widget.
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/loader.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        _controller.setVolume(0.0);
        setState(() {});
      });

    Timer(const Duration(seconds: 4), _checkAuthStatus); // Verifica el estado de autenticación del usuario.
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Container(color: Colors.black),
    );
  }
}
