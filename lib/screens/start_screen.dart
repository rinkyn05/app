import 'package:flutter/material.dart';
import '../config/lang/app_localization.dart';
import '../widgets/main_screen_layout.dart';
import 'entrenamiento_fisico.dart';
import 'gymder_screen.dart';
import 'home_screen.dart';
import 'join_community_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'nutrition/nutritions_screen.dart';

class StartScreen extends StatefulWidget {
  final String nombre;
  final String rol;
  final String currentUserEmail;

  const StartScreen({
    Key? key,
    required this.nombre,
    required this.rol,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  int _selectedIndex = 0;

  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.translate('home');
      case 1:
        return AppLocalizations.of(context)!.translate('exercise');
      case 2:
        return AppLocalizations.of(context)!.translate('food');
      case 3:
        return AppLocalizations.of(context)!.translate('gymfriend');
      default:
        return AppLocalizations.of(context)!.translate('app');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      _checkGymFriends();
    }
  }

  Future<void> _checkGymFriends() async {
    final gymFriendsDoc = await FirebaseFirestore.instance
        .collection('gymfriends')
        .doc(widget.currentUserEmail)
        .get();
    if (gymFriendsDoc.exists) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GymDerScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenLayout(
      appBarTitle: _getTitle(_selectedIndex, context),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          EntrenamientoFisico(),
          NutritionScreen(),
          const JoinCommunityScreen(),
        ],
      ),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      nombre: widget.nombre,
      rol: widget.rol,
    );
  }
}
