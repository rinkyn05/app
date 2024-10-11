import 'package:flutter/material.dart'; // Importa Flutter Material para el diseño.
import '../../widgets/custom_appbar_new.dart'; // Importa un AppBar personalizado.
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para traducir textos.
import '../../widgets/grid_view/mansory_estiramiento_fisico.dart'; // Importa el widget que muestra una cuadrícula de estiramiento físico.

class EstiramientoFisicoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBarNew(), // Establece el AppBar personalizado en la pantalla.
      body: Padding(
        padding: const EdgeInsets.all(
            8.0), // Aplica un padding de 8 píxeles alrededor del contenido.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Centra el contenido en el eje transversal.
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('estiramientoFisico')}", // Traduce y muestra el texto de 'estiramientoFisico'.
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Aplica el estilo de texto grande del tema.
            ),
            SizedBox(height: 10), // Espacio vertical de 10 píxeles.
            Expanded(
                child:
                    MasonryEstiramientoFisico()), // Expande el widget MasonryEstiramientoFisico para llenar el espacio restante.
          ],
        ),
      ),
    );
  }
}
