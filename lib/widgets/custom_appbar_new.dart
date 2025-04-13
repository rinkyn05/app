import 'package:flutter/material.dart';
import '../screens/temporizador/temporizador.dart'; // Importa el widget StopwatchWidget desde la pantalla del temporizador.

class CustomAppBarNew extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback?
      onBackButtonPressed; // Callback opcional para manejar el evento del botón de retroceso.

  const CustomAppBarNew({Key? key, this.onBackButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0), // Margen superior del contenedor.
      child: AppBar(
        automaticallyImplyLeading:
            false, // Evita mostrar el botón de retroceso por defecto.
        centerTitle: true, // Centra el título del AppBar.
        toolbarHeight: 70, // Altura del AppBar.
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono del botón de retroceso.
          onPressed: () {
            if (onBackButtonPressed != null) {
              // Verifica si hay un callback definido.
              onBackButtonPressed!(); // Llama al callback si está definido.
            } else {
              Navigator.pop(
                  context); // Regresa a la pantalla anterior si no hay callback.
            }
          },
          iconSize: 40, // Tamaño del ícono del botón de retroceso.
        ),
        title:
            StopwatchWidget(), // Muestra el widget del temporizador como el título del AppBar.
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(70); // Devuelve la altura preferida del AppBar.
}
