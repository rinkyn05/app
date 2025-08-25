import 'package:flutter/material.dart'; // Importa los widgets de Flutter
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa el paquete para reproducir videos de YouTube
import '../../config/lang/app_localization.dart'; // Importa las configuraciones de localización
import '../../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación
import '../widgets/custom_appbar_new.dart'; // Importa la barra de aplicación personalizada
import 'entrenamiento_pesas.dart'; // Importa la clase EntrenamientoPesas

class EntrenamientoConPesas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Método que construye el widget
    return Scaffold(
      // Crea una estructura básica de diseño
      appBar: CustomAppBarNew(
        // Barra de aplicación personalizada
        onBackButtonPressed: () {
          // Acción al presionar el botón de retroceso
          Navigator.pop(context); // Navega hacia atrás en la pila de navegación
        },
      ),
      body: SingleChildScrollView(
        // Permite el desplazamiento si el contenido excede la pantalla
        child: Column(
          // Organiza los widgets en una columna
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Estira los widgets a lo largo del eje horizontal
          children: [
            SizedBox(height: 4), // Espacio en la parte superior
            Padding(
              padding: const EdgeInsets.all(
                  10.0), // Agrega un padding alrededor del contenido
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Estira los widgets a lo largo del eje horizontal
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('entrenamientoPesas')}", // Texto que muestra el título de la sección
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // Estilo del texto basado en el tema actual
                    textAlign: TextAlign.center, // Alinea el texto al centro
                  ),
                  SizedBox(
                      height: 10), // Espacio entre el título y el contenedor
                  Container(
                    decoration: BoxDecoration(
                      // Configuración del contenedor que rodea el video
                      border: Border.all(
                        // Crea un borde alrededor del contenedor
                        width: 6.0, // Ancho del borde
                        color: AppColors.adaptableColor(
                            context), // Color del borde que se adapta al contexto
                      ),
                    ),
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: 'cTcTIBOgM9E',
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                          enableCaption:
                              false, // Deshabilitar subtítulos si es necesario
                        ),
                      ),
                      showVideoProgressIndicator: true,
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
                ],
              ),
            ),
            SizedBox(
                height: 10), // Espacio entre el video y la siguiente sección

            // Pasamos selectedValues si están disponibles; de lo contrario, pasamos un mapa vacío
            EntrenamientoPesas(), // Usamos "?? {}" para evitar valores nulos

            SizedBox(height: 90), // Espacio en la parte inferior
          ],
        ),
      ),
    );
  }
}
