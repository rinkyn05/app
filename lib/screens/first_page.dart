import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app/screens/login_and_register/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'role_first_page.dart';
import 'onboarding/onboarding_screen.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/splash.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        _controller.setVolume(0.0);
        setState(() {});
      });

    Timer(const Duration(seconds: 4), _checkAuthStatus);
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
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const RoleFirstPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Empieza desde la derecha
              const end = Offset.zero; // Termina en su posición normal
              const curve = Curves.ease;

              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      }
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
