import 'package:app/backend/alimentos/adm_alimentos_screen.dart';
import 'package:app/backend/ejercicios/adm_ejercicio_screen.dart';
import 'package:flutter/material.dart';

import '../../config/lang/app_localization.dart';
import '../recipes/adm_recipes_screen.dart';
import '../screens/adm_home_screen.dart';
import '../sports/adm_sports_screen.dart';
import 'widgets/admin_main_screen_layout.dart';

class AdminStartScreen extends StatefulWidget {
  final String nombre;
  final String rol;

  const AdminStartScreen({
    Key? key,
    required this.nombre,
    required this.rol,
  }) : super(key: key);

  @override
  AdminStartScreenState createState() => AdminStartScreenState();
}

class AdminStartScreenState extends State<AdminStartScreen> {
  int _selectedIndex = 0;

  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.translate('exercise_home');
      case 1:
        return AppLocalizations.of(context)!.translate('exercise');
      case 2:
        return AppLocalizations.of(context)!.translate('recipes');
      case 3:
        return AppLocalizations.of(context)!.translate('food');
      case 4:
        return AppLocalizations.of(context)!.translate('profile');
      default:
        return AppLocalizations.of(context)!.translate('app');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminMainScreenLayout(
      appBarTitle: _getTitle(_selectedIndex, context),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AdmHomeScreen(),
          AdmEjerciciosScreen(),
          AdmRecipesScreen(),
          AdmAlimentosScreen(),
          AdmSportsScreen(),
        ],
      ),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      nombre: widget.nombre,
      rol: widget.rol,
    );
  }
}
