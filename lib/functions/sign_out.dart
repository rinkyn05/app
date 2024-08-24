import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/login_and_register/login_or_register.dart';

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
    );
  } catch (e) {
    print('Error al cerrar sesión: $e');
  }
}
