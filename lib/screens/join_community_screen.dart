import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/lang/app_localization.dart';
import 'gymder_screen.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({Key? key}) : super(key: key);

  @override
  _JoinCommunityScreenState createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;

        print('Correo electrónico del usuario: $_userEmail');
      });
    }
  }

  Future<void> _joinCommunity() async {
    if (_userEmail != null) {
      try {
        print(
            'Correo electrónico del usuario para buscar en Firestore: $_userEmail');

        final gymFriendDoc =
            await _firestore.collection('gymfriends').doc(_userEmail).get();

        if (gymFriendDoc.exists) {
          print('El usuario ya existe en la comunidad.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GymDerScreen()),
          );
        } else {
          print(
              'El usuario no existe en la comunidad. Procediendo con el registro...');

          final userSnapshot = await _firestore
              .collection('users')
              .where('Correo Electrónico', isEqualTo: _userEmail)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            final userData = userSnapshot.docs.first.data();

            final userName = userData['Nombre'];
            final membership = userData['Membership'];
            final nivel = userData['Nivel'];
            final edad = userData['Edad'];
            final genero = userData['Género'];
            final image_url = userData['image_url'];

            print('Información del usuario obtenida de Firestore:');
            print('Nombre: $userName');
            print('Membership: $membership');
            print('Nivel: $nivel');
            print('Edad: $edad');
            print('Género: $genero');
            print('image_url: $image_url');

            await _firestore
                .collection('gymfriendsemails')
                .doc(_userEmail)
                .set({
              'like': [],
              'likedyou': [],
              'dislike': [],
              'dislikedyou': [],
              'follow': [],
              'followers': [],
            });

            await _firestore.collection('gymfriends').doc(_userEmail).set({
              'Nombre': userName,
              'Correo Electrónico': _userEmail,
              'Membership': membership,
              'Nivel': nivel,
              'Edad': edad,
              'Género': genero,
              'image_url': image_url,
              'Like': 0,
              'Dislike': 0,
              'Followers': 0,
            });

            print('Te has unido exitosamente a la comunidad.');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GymDerScreen()),
            );
          } else {
            print('No se encontró la información del usuario en Firestore.');
          }
        }
      } catch (error) {
        print('Error al unirse a la comunidad: $error');
      }
    } else {
      print(
          'No se pudo unir a la comunidad debido a falta de correo electrónico.');
    }
  }

  Widget _buildCustomStyledButton(
    String text,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 2, 11, 59)
            : Colors.white,
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .translate('joinCommunityHeading'),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/onboarding3.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!
                      .translate('joinCommunityDescription'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 20),
                _buildCustomStyledButton(
                  AppLocalizations.of(context)!
                      .translate('joinCommunityButton'),
                  _joinCommunity,
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
