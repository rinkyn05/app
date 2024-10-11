import 'package:app/backend/alimentos/adm_alimentos_screen.dart';
import 'package:app/backend/ejercicios/adm_ejercicio_screen.dart';
import 'package:flutter/material.dart';

import '../../config/lang/app_localization.dart'; // Importa las localizaciones para traducciones.
import '../recipes/adm_recipes_screen.dart';
import '../screens/adm_home_screen.dart';
import '../sports/adm_sports_screen.dart';
import 'widgets/admin_main_screen_layout.dart'; // Importa el layout principal del administrador.

class AdminStartScreen extends StatefulWidget {
  final String nombre; // Nombre del administrador.
  final String rol; // Rol del administrador.

  const AdminStartScreen({
    Key? key,
    required this.nombre, // Requiere el nombre como parámetro.
    required this.rol, // Requiere el rol como parámetro.
  }) : super(key: key);

  @override
  AdminStartScreenState createState() =>
      AdminStartScreenState(); // Crea el estado del widget.
}

class AdminStartScreenState extends State<AdminStartScreen> {
  int _selectedIndex =
      0; // Índice del elemento seleccionado en la barra de navegación.

  // Método para obtener el título de la AppBar según el índice seleccionado.
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

  // Método que se llama al pulsar un elemento en la barra de navegación.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado.
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminMainScreenLayout(
      appBarTitle: _getTitle(_selectedIndex, context), // Título de la AppBar.
      body: IndexedStack(
        index:
            _selectedIndex, // Muestra el widget correspondiente al índice seleccionado.
        children: const [
          AdmHomeScreen(), // Pantalla de inicio del administrador.
          AdmEjerciciosScreen(), // Pantalla de administración de ejercicios.
          AdmRecipesScreen(), // Pantalla de administración de recetas.
          AdmAlimentosScreen(), // Pantalla de administración de alimentos.
          AdmSportsScreen(), // Pantalla de administración de deportes.
        ],
      ),
      selectedIndex: _selectedIndex, // Índice actualmente seleccionado.
      onItemTapped:
          _onItemTapped, // Callback para manejar la selección de elementos.
      nombre: widget.nombre, // Pasa el nombre del administrador al layout.
      rol: widget.rol, // Pasa el rol del administrador al layout.
    );
  }
}
