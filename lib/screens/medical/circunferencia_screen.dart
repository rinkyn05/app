import 'package:flutter/material.dart'; // Importa Flutter Material para el diseño.
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa el paquete de YouTube Player para reproducir videos.

import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para traducir textos.
import '../../config/utils/appcolors.dart'; // Importa la configuración de colores personalizados.
import '../../widgets/custom_appbar_new.dart'; // Importa un AppBar personalizado.

class CircunferenciaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        // Establece el AppBar personalizado en la pantalla.
        onBackButtonPressed: () {
          // Define la acción al presionar el botón de retroceso.
          Navigator.pop(context); // Navega a la pantalla anterior.
        },
      ),
      body: SingleChildScrollView(
        // Permite el desplazamiento en el contenido.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Estira los hijos en el eje transversal.
          children: [
            Padding(
              padding:
                  const EdgeInsets.all(0.0), // Aplica un padding de 0 píxeles.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Centra el contenido en el eje transversal.
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('circunferences')}", // Traduce y muestra el texto de 'circunferences'.
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // Aplica el estilo de texto grande del tema.
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                  14.0), // Aplica un padding de 14 píxeles alrededor del siguiente contenedor.
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    // Añade un borde al contenedor.
                    width: 6.0, // Establece el ancho del borde.
                    color: AppColors.adaptableColor(
                        context), // Establece el color del borde utilizando la configuración de colores.
                  ),
                ),
                child: YoutubePlayer(
                  // Crea un reproductor de YouTube.
                  controller: YoutubePlayerController(
                    initialVideoId:
                        'cTcTIBOgM9E', // ID del video inicial que se reproducirá.
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      enableCaption:
                          false, // Deshabilitar subtítulos si es necesario
                    ),
                  ),
                  showVideoProgressIndicator:
                      true, // Muestra el indicador de progreso del video.
                  bottomActions: [
                    CurrentPosition(), // Muestra la posición actual del video.
                    ProgressBar(
                        isExpanded:
                            true), // Muestra una barra de progreso expandida.
                    IconButton(
                      icon: Icon(Icons
                          .fullscreen_exit), // Icono que simula el botón de pantalla completa.
                      onPressed: () {
                        // No hacer nada para evitar la pantalla completa.
                      },
                    ),
                  ],
                  topActions: [
                    // Aquí puedes agregar acciones personalizadas si es necesario.
                  ],
                  onReady: () {
                    debugPrint(
                        "Video is ready."); // Callback cuando el reproductor está listo.
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
