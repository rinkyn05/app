// ignore_for_file: use_build_context_synchronously

import 'package:app/screens/account/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/utils/appcolors.dart';
import 'package:app/config/lang/app_localization.dart';
import '../../functions/latest_frase.dart';
import '../../functions/load_user_image.dart';
import '../../functions/load_user_info.dart';
import '../../functions/sign_out.dart';
import '../../functions/upload_image.dart';
import '../../widgets/custom_appbar_new.dart';
import '../medical/medical_history.dart';
import 'referidos_screen_info.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _nombre = '';
  String? _userImageUrl;
  String _latestFrase = "";
  String? _correoUsuario;

  @override
  void initState() {
    super.initState();
    _loadLatestFrase();
    loadUserInfo(_auth, _firestore, (userData) {
      setState(() {
        _nombre = userData['Nombre'] ?? 'Usuario';
        _correoUsuario = userData['Correo Electrónico'] as String?;
      });
    });
    loadUserImage(_auth, (imageUrl) {
      setState(() {
        _userImageUrl = imageUrl ??
            'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3';
      });
    });
  }

  void _loadLatestFrase() async {
    var fraseData = await fetchLatestFrase();
    if (fraseData != null) {
      String currentLang = Localizations.localeOf(context).languageCode;

      setState(() {
        _latestFrase = (currentLang == 'ee')
            ? fraseData['Frase Esp'] ?? ""
            : fraseData['Frase Eng'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBarNew(
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "${AppLocalizations.of(context)!.translate('profile')}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        uploadImage(context, (imageUrl) {
                          setState(() {
                            _userImageUrl = imageUrl;
                          });
                        });
                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CircleAvatar(
                            backgroundImage: _userImageUrl != null
                                ? NetworkImage(_userImageUrl!)
                                : const AssetImage("assets/images/gym.png")
                                    as ImageProvider,
                            radius: 70.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 1.0, left: 1.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.primaryColor,
                ),
                child: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      _latestFrase.isNotEmpty
                          ? _latestFrase
                          : AppLocalizations.of(context)!
                              .translate('inspirationalQuote'),
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              buildOptionTile(
                  Icons.person_2_rounded,
                  AppLocalizations.of(context)!.translate('personalInfo'),
                  _navegarAPantallaPerfil),
              buildOptionTile(
                  Icons.medical_information_rounded,
                  AppLocalizations.of(context)!.translate('medicalHistory'),
                  _navegarAPantallaHistorialMedico),
              buildOptionTile(
                Icons.link_rounded,
                AppLocalizations.of(context)!.translate('referrals'),
                _navegarAPantallaReferidos,
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppColors.orangeColor,
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              buildOptionTile(
                  Icons.logout,
                  AppLocalizations.of(context)!.translate('logOut'),
                  () => signOut(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionTile(IconData icon, String title,
      [VoidCallback? onTapCallback]) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon,
          color:
              theme.brightness == Brightness.dark ? Colors.white : Colors.black,
          size: 30),
      title: Text(title, style: theme.textTheme.bodyLarge),
      onTap: onTapCallback,
    );
  }

  void _navegarAPantallaReferidos() {
    if (_correoUsuario != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaReferidosInfo(
            correoUsuario: _correoUsuario!,
            nombreUsuario: _nombre,
            userImageUrl: _userImageUrl ?? 'URL_POR_DEFECTO',
          ),
        ),
      );
    } else {
      // print('Correo de usuario no disponible.');
    }
  }

  void _navegarAPantallaPerfil() {
    if (_correoUsuario != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    } else {
      // print('Correo de usuario no disponible.');
    }
  }

  void _navegarAPantallaHistorialMedico() {
    if (_correoUsuario != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicalHistory(),
        ),
      );
    } else {
      // print('Correo de usuario no disponible.');
    }
  }
}
