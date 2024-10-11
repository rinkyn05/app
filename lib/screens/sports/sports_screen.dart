import 'package:flutter/material.dart'; // Importa Flutter Material para el diseño.
import '../../widgets/custom_appbar_new.dart'; // Importa un AppBar personalizado.
import '../../widgets/grid_view/mansory_sports.dart'; // Importa el widget que muestra la cuadrícula de deportes.

class SportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(), // Establece el AppBar personalizado en la pantalla.
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Aplica un padding de 8 píxeles en todos los lados.
        child: MasonrySports(), // Muestra la cuadrícula de deportes en el cuerpo de la pantalla.
      ),
    );
  }
}
