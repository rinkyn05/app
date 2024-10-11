import 'package:flutter/material.dart';
import '../../../config/lang/app_localization.dart'; // Importa las localizaciones para traducciones.
import '../../../screens/account/profile_screen.dart'; // Importa la pantalla de perfil del usuario.
import 'admin_custom_drawer.dart'; // Importa el drawer personalizado del administrador.

class AdminMainScreenLayout extends StatefulWidget {
  final Widget body; // Cuerpo de la pantalla principal.
  final int
      selectedIndex; // Índice del elemento seleccionado en la barra de navegación.
  final Function(int)
      onItemTapped; // Callback para manejar la selección de elementos en la barra de navegación.
  final String appBarTitle; // Título de la AppBar.
  final String nombre; // Nombre del administrador.
  final String rol; // Rol del administrador.

  const AdminMainScreenLayout({
    Key? key,
    required this.body, // Requiere el cuerpo como parámetro.
    required this.selectedIndex, // Requiere el índice seleccionado como parámetro.
    required this.onItemTapped, // Requiere la función callback como parámetro.
    required this.appBarTitle, // Requiere el título de la AppBar como parámetro.
    required this.nombre, // Requiere el nombre del administrador como parámetro.
    required this.rol, // Requiere el rol del administrador como parámetro.
  }) : super(key: key);

  @override
  AdminMainScreenLayoutState createState() =>
      AdminMainScreenLayoutState(); // Crea el estado del widget.
}

class AdminMainScreenLayoutState extends State<AdminMainScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarTheme = Theme.of(context)
        .bottomNavigationBarTheme; // Obtiene el tema de la barra de navegación inferior.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle), // Establece el título de la AppBar.
        centerTitle: true, // Centra el título en la AppBar.
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Icono del menú.
              onPressed: () => Scaffold.of(context)
                  .openDrawer(), // Abre el drawer al pulsar el icono.
              iconSize: 30, // Tamaño del icono.
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person), // Icono de perfil.
            onPressed: () {
              // Navega a la pantalla de perfil al pulsar el icono.
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ));
            },
            iconSize: 30, // Tamaño del icono.
          ),
        ],
      ),
      drawer:
          const AdminCustomDrawer(), // Drawer personalizado del administrador.
      body: widget.body, // Cuerpo de la pantalla principal.
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home), // Icono de inicio.
            label: AppLocalizations.of(context)!
                .translate('home'), // Etiqueta traducida para inicio.
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center), // Icono de ejercicios.
            label: AppLocalizations.of(context)!
                .translate('exercises'), // Etiqueta traducida para ejercicios.
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book), // Icono de recetas.
            label: AppLocalizations.of(context)!
                .translate('recipes'), // Etiqueta traducida para recetas.
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fastfood), // Icono de alimentos.
            label: AppLocalizations.of(context)!
                .translate('food'), // Etiqueta traducida para alimentos.
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), // Icono de perfil.
            label: AppLocalizations.of(context)!
                .translate('profile'), // Etiqueta traducida para perfil.
          ),
        ],
        currentIndex: widget.selectedIndex, // Índice actualmente seleccionado.
        selectedItemColor: bottomNavigationBarTheme.selectedItemColor ??
            Colors.blue, // Color del elemento seleccionado.
        unselectedItemColor: bottomNavigationBarTheme.unselectedItemColor ??
            Colors.grey, // Color del elemento no seleccionado.
        showUnselectedLabels: bottomNavigationBarTheme.showUnselectedLabels ??
            true, // Muestra etiquetas no seleccionadas.
        backgroundColor: bottomNavigationBarTheme.backgroundColor ??
            Colors.white, // Color de fondo de la barra de navegación.
        type: BottomNavigationBarType.fixed, // Tipo de barra de navegación.
        elevation: 5.0, // Elevación de la barra de navegación.
        iconSize: 30.0, // Tamaño de los iconos en la barra de navegación.
        selectedFontSize:
            bottomNavigationBarTheme.selectedLabelStyle?.fontSize ??
                14.0, // Tamaño de la fuente del elemento seleccionado.
        unselectedFontSize:
            bottomNavigationBarTheme.unselectedLabelStyle?.fontSize ??
                12.0, // Tamaño de la fuente del elemento no seleccionado.
        onTap: widget
            .onItemTapped, // Callback para manejar la selección de elementos en la barra de navegación.
      ),
    );
  }
}
