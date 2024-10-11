import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces de usuario.
import '../config/lang/app_localization.dart'; // Importa el archivo para la localización y traducción de la app.
import '../widgets/main_screen_layout.dart'; // Importa el widget de diseño principal de la pantalla.
import 'entrenamiento_fisico.dart'; // Importa la pantalla de entrenamiento físico.
import 'gymder_screen.dart'; // Importa la pantalla de GymDer (amigos de gimnasio).
import 'home_screen.dart'; // Importa la pantalla de inicio (home).
import 'join_community_screen.dart'; // Importa la pantalla para unirse a la comunidad.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos de Firebase.

import 'nutrition/nutritions_screen.dart'; // Importa la pantalla de nutrición.

class StartScreen extends StatefulWidget {
  // La pantalla principal que el usuario ve al iniciar la app.
  final String nombre; // El nombre del usuario que se pasa a la pantalla.
  final String rol; // El rol del usuario (administrador, usuario, etc.).
  final String currentUserEmail; // El email del usuario actual para identificarlo en la base de datos.

  const StartScreen({
    Key? key,
    required this.nombre,
    required this.rol,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  StartScreenState createState() => StartScreenState(); // Crea el estado para la pantalla.
}

class StartScreenState extends State<StartScreen> {
  int _selectedIndex = 0; // Variable para mantener el índice del elemento seleccionado en el menú de navegación.

  // Función que retorna el título de la barra de la aplicación según el índice de la pantalla seleccionada.
  String _getTitle(int index, BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.translate('home'); // Título para la pantalla de inicio.
      case 1:
        return AppLocalizations.of(context)!.translate('exercise'); // Título para la pantalla de ejercicios.
      case 2:
        return AppLocalizations.of(context)!.translate('food'); // Título para la pantalla de nutrición.
      case 3:
        return AppLocalizations.of(context)!.translate('gymfriend'); // Título para la pantalla de GymDer.
      default:
        return AppLocalizations.of(context)!.translate('app'); // Título por defecto si no coincide con ningún caso.
    }
  }

  // Función que se ejecuta cuando el usuario selecciona un elemento del menú de navegación.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado.
    });

    if (index == 3) {
      _checkGymFriends(); // Si se selecciona la pestaña GymDer, verifica si hay amigos en el gimnasio.
    }
  }

  // Función que verifica en Firebase si el usuario tiene amigos de gimnasio (GymFriends).
  Future<void> _checkGymFriends() async {
    final gymFriendsDoc = await FirebaseFirestore.instance
        .collection('gymfriends')
        .doc(widget.currentUserEmail)
        .get(); // Busca en la colección 'gymfriends' en Firestore usando el email del usuario actual.
    
    if (gymFriendsDoc.exists) {
      // Si existe un documento de amigos de gimnasio para el usuario actual, navega a la pantalla de GymDer.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GymDerScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenLayout(
      // Usa un widget personalizado para el diseño principal de la pantalla.
      appBarTitle: _getTitle(_selectedIndex, context), // Establece el título de la barra de la app según el índice seleccionado.
      body: IndexedStack(
        // Usa IndexedStack para cambiar entre pantallas manteniendo el estado de las no visibles.
        index: _selectedIndex, // Muestra la pantalla según el índice seleccionado.
        children: [
          HomeScreen(), // Pantalla de inicio.
          EntrenamientoFisico(), // Pantalla de entrenamiento físico.
          NutritionScreen(), // Pantalla de nutrición.
          const JoinCommunityScreen(), // Pantalla para unirse a la comunidad.
        ],
      ),
      selectedIndex: _selectedIndex, // Índice seleccionado para la barra de navegación.
      onItemTapped: _onItemTapped, // Llama a la función cuando se selecciona un elemento de la barra.
      nombre: widget.nombre, // Pasa el nombre del usuario a la pantalla.
      rol: widget.rol, // Pasa el rol del usuario a la pantalla.
    );
  }
}
