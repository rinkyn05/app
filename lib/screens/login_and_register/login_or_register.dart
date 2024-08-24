import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../role_first_page.dart';
import 'login/login_screen.dart';
import 'register/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final PageController pageController = PageController(initialPage: 0);
  final List<String> imagesUrl = ["assets/images/onboarding1.png"];
  final List<String> titlesKeys = ['onboardingTitle1'];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            controller: pageController,
            itemCount: imagesUrl.length,
            itemBuilder: (context, index) {
              final AppLocalizations? appLocalizations =
                  AppLocalizations.of(context);
              final String title =
                  appLocalizations?.translate(titlesKeys[index]) ?? '';

              return Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Image.asset(imagesUrl[index]),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 420,
                      decoration: BoxDecoration(
                        color: themeData.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              title,
                              style: themeData.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStyledButton(
                                  appLocalizations?.translate('registerr') ??
                                      'Regístrate',
                                  Icons.person,
                                  () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  context,
                                ),
                                const SizedBox(height: 20),
                                _buildStyledButton(
                                  appLocalizations?.translate('logIn') ??
                                      'Inicia sesión',
                                  Icons.login,
                                  () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  context,
                                ),
                                const SizedBox(height: 20),
                                _buildStyledButton(
                                  appLocalizations?.translate('googleLogin') ??
                                      'Inicia con Google',
                                  null,
                                  _handleGoogleSignIn,
                                  context,
                                  iconAsset: 'assets/icons/google.png',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(
      String text, IconData? icon, VoidCallback onPressed, BuildContext context,
      {String? iconAsset}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: AppColors.gdarkblue2, width: 4.0),
        ),
        elevation: 3,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.gdarkblue2,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 40,
            ),
          if (iconAsset != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                iconAsset,
                width: 40,
                height: 40,
              ),
            ),
          Text(text),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Inicio de sesión con Google cancelado.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        print('Inicio de sesión con Google exitoso.');

        String email = userCredential.user!.email ?? '';
        String name = userCredential.user!.displayName ?? '';
        String defaultInfo = '0';

        DateTime currentDate = DateTime.now();

        Map<String, dynamic> userData = {
          'Nombre': name,
          'Correo Electrónico': email,
          'DateTime': currentDate,
          'Rol': 'Usuario',
          'Membership': 'Free',
          'Nivel': 'Basico',
          'Edad': defaultInfo,
          'Género': 'No especificado',
          'Peso': defaultInfo,
          'Estatura': defaultInfo,
          'image_url':
              'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3',
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);

        Map<String, dynamic> generalMeasurements = {
          'Edad': defaultInfo,
          'Género': 'No especificado',
          'Peso': defaultInfo,
          'Estatura': defaultInfo,
          'Estatura Sentado': defaultInfo,
          'Envergadura': defaultInfo,
        };

        Map<String, dynamic> userDataMedical = {
          'Medidas Generales': generalMeasurements,
          'Circunferencias': {},
        };

        await FirebaseFirestore.instance
            .collection('usersmedical')
            .doc(email)
            .set(userDataMedical);

        _showCompletionDialog();
      } else {
        print('Error al iniciar sesión con Google: usuario nulo.');
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('succesGoogleLogin'),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('succesGoogleLoginContent'),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleFirstPage(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!
                    .translate('succesGoogleLoginContinue'),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
