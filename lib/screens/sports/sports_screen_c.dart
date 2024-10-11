import 'package:flutter/material.dart'; // Importa Flutter Material para el diseño.
import '../../widgets/custom_appbar_new.dart'; // Importa un AppBar personalizado.
import '../../widgets/grid_view/mansory_sports_original.dart'; // Importa el widget que muestra una cuadrícula de deportes.
import '../../config/lang/app_localization.dart'; // Importa las localizaciones para traducciones.

class SportsScreenC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(), // Establece el AppBar personalizado en la pantalla.
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Aplica un padding de 8 píxeles en todos los lados.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Alinea los elementos en el centro horizontalmente.
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('sports')}", // Traduce y muestra el texto "Deportes".
              style: Theme.of(context).textTheme.titleLarge, // Aplica el estilo de texto grande del tema actual.
            ),
            SizedBox(height: 10), // Espacio vertical de 10 píxeles.
            Expanded(
              child: MasonrySportsOriginal(), // Muestra la cuadrícula de deportes en el espacio restante.
            ),
          ],
        ),
      ),
    );
  }
}
