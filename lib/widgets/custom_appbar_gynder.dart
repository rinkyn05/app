import 'package:flutter/material.dart';
import '../screens/account/community_profile_screen.dart'; // Importa la pantalla del perfil de la comunidad.
import '../screens/temporizador/temporizador.dart'; // Importa el widget StopwatchWidget desde la pantalla del temporizador.

class CustomAppBarGynder extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed; // Callback opcional para manejar el evento del botón de retroceso.

  const CustomAppBarGynder({Key? key, this.onBackButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0), // Margen superior del contenedor.
      child: AppBar(
        automaticallyImplyLeading: false, // Evita mostrar el botón de retroceso por defecto.
        centerTitle: true, // Centra el título del AppBar.
        toolbarHeight: 70, // Altura del AppBar.
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono del botón de retroceso.
          onPressed: () {
            if (onBackButtonPressed != null) { // Verifica si hay un callback definido.
              onBackButtonPressed!(); // Llama al callback si está definido.
            } else {
              Navigator.pop(context); // Regresa a la pantalla anterior si no hay callback.
            }
          },
          iconSize: 50, // Tamaño del ícono del botón de retroceso.
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Icono para acceder al perfil de la comunidad.
            onPressed: () {
              // Navega a la pantalla del perfil de la comunidad cuando se presiona el botón.
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CommunityProfileScreen(),
              ));
            },
            iconSize: 50, // Tamaño del ícono del botón del perfil.
          ),
        ],
        title: StopwatchWidget(), // Muestra el widget del temporizador como el título del AppBar.
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80); // Devuelve la altura preferida del AppBar.
}
