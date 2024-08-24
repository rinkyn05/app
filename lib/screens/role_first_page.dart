import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../backend/admin/admin_start_screen.dart';
import '../config/lang/app_localization.dart';
import '../config/notifiers/theme_notifier.dart';
import '../desings/themes.dart';
import 'login_and_register/login/login_screen.dart';
import 'start_screen.dart';

class RoleFirstPage extends StatefulWidget {
  const RoleFirstPage({super.key});

  @override
  State<RoleFirstPage> createState() => _RoleFirstPageState();
}

class _RoleFirstPageState extends State<RoleFirstPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!mounted) return;

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        String rol = userData?['Rol'] ?? '';
        String nombre = userData?['Nombre'] ?? '';

        if (rol == 'Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminStartScreen(nombre: nombre, rol: rol)));
        } else if (rol == 'Super Admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminStartScreen(
                        nombre: nombre,
                        rol: rol,
                      )));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StartScreen(
                  nombre: nombre, rol: rol, currentUserEmail: user.email ?? ''),
            ),
          );
        }
      } else {}
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkTheme = themeNotifier.isDarkMode;

    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    return Scaffold(
      backgroundColor: themeNotifier.isDarkMode
          ? AppTheme.darkTheme.scaffoldBackgroundColor
          : AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cgImage, width: 500, height: 150),
              Image.asset(coachGImage, width: 500, height: 100),
              const SizedBox(height: 25),
              CircularProgressIndicator(
                  color:
                      themeNotifier.isDarkMode ? Colors.white : Colors.black),
              const SizedBox(height: 25),
              Text(
                AppLocalizations.of(context)!.translate('checkingUserInfo'),
                textAlign: TextAlign.center,
                style: themeNotifier.isDarkMode
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
