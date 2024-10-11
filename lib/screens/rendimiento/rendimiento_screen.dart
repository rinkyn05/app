import 'package:flutter/material.dart'; // Importa Flutter Material para el diseño.
import '../../widgets/custom_appbar_new.dart'; // Importa un AppBar personalizado.
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para traducir textos.
import '../../widgets/grid_view/rendimiento/mansory_rendimiento.dart'; // Importa el widget que muestra la cuadrícula de rendimiento.

class RendimientoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBarNew(), // Establece el AppBar personalizado en la pantalla.
      body: Padding(
        padding: const EdgeInsets.all(
            8.0), // Aplica un padding de 8 píxeles en todos los lados.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Alinea el contenido del eje transversal al centro.
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('rendimiento')}", // Traduce y muestra el texto de 'rendimiento'.
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Aplica el estilo de texto grande del tema.
            ),
            SizedBox(height: 10), // Espacio vertical de 10 píxeles.
            Expanded(
                child:
                    MasonryRendimiento()), // Muestra la cuadrícula de rendimiento ocupando el espacio disponible.
          ],
        ),
      ),
    );
  }
}
