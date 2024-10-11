import 'package:flutter/material.dart'; // Importa el paquete de Material Design para Flutter.
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa el reproductor de videos de YouTube.
import '../config/utils/appcolors.dart'; // Importa los colores personalizados desde la configuración.
import '../../config/lang/app_localization.dart'; // Importa la localización de la aplicación para traducciones.
import 'entreniento_con_pesas.dart'; // Importa la pantalla de entrenamiento con pesas.
import 'sports/sports_screen.dart'; // Importa la pantalla de deportes.
import 'three_d_image_screen.dart'; // Importa la pantalla de imagen 3D.

class EntrenamientoFisico extends StatefulWidget {
  @override
  _EntrenamientoFisicoState createState() =>
      _EntrenamientoFisicoState(); // Crea el estado de la pantalla.
}

class _EntrenamientoFisicoState extends State<EntrenamientoFisico> {
  String dropdownValue = 'physicalTraining'; // Valor inicial del dropdown.
  late YoutubePlayerController
      _controller; // Controlador para el reproductor de YouTube.

  // Mapa que relaciona los nombres de los ejercicios con sus IDs de video de YouTube.
  final Map<String, String> videoIds = {
    'physicalTraining': 'cTcTIBOgM9E',
    'children': 'Oj2NxPKnfSk',
    'muscleGain': 'pcCPO6ppm8k',
    'stretching': '1Hd7Pw30i7c',
    'elderly': 'pP87urgc2Q',
    'weightLoss': 'nHb_GjQvJPY',
    'athleticPerformance': 'qUL0EyCRAgM',
    'strengthGain': 'hXBHRFgn_Ms',
    'cardio': 'cTcTIBOgM9E',
    'power': 'Oj2NxPKnfSk',
    'mobility': 'pcCPO6ppm8k',
    'rehabilitation': 'qUL0EyCRAgM',
  };

  @override
  void initState() {
    super.initState(); // Inicializa el estado de la clase padre.
    // Configura el controlador del reproductor de YouTube con el video inicial.
    _controller = YoutubePlayerController(
      initialVideoId: videoIds[
          dropdownValue]!, // Carga el video según el valor del dropdown.
      flags: const YoutubePlayerFlags(
        autoPlay: false, // No reproduce automáticamente.
        mute: false, // No está en silencio por defecto.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Permite el desplazamiento si el contenido es largo.
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Alinea los elementos al centro.
          children: [
            const SizedBox(height: 10), // Espaciado vertical.
            // Título de la pantalla, traducido según la configuración de localización.
            Text(
              "${AppLocalizations.of(context)!.translate('physicalTraining')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Espaciado interno.
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0, // Ancho del borde.
                    color: AppColors.adaptableColor(
                        context), // Color del borde adaptado al tema.
                  ),
                ),
                // Reproductor de YouTube que muestra el video seleccionado.
                child: YoutubePlayer(
                  controller: _controller, // Controlador del reproductor.
                  showVideoProgressIndicator:
                      true, // Muestra el indicador de progreso del video.
                  onReady: () {}, // Callback cuando el reproductor está listo.
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6), // Espaciado interno.
              child: Card(
                elevation: 3.0, // Sombra de la tarjeta.
                color: AppColors.gdarkblue2, // Color de la tarjeta.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Alinea los elementos a lo largo de la tarjeta.
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0), // Espaciado interno.
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('exerciseFor'), // Texto traducido.
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white, // Color del texto.
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        children: [
                          _buildExerciseDropdown(
                              context), // Dropdown para seleccionar el ejercicio.
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20), // Espaciado interno.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Alinea los botones a lo largo.
                children: [
                  // Botón para navegar a la pantalla de ejercicios.
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!.translate('exercises'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ThreeDImageScreen()), // Navega a la pantalla 3D.
                      );
                    },
                  ),
                  const SizedBox(height: 10), // Espacio entre botones.
                  // Botón para navegar a la pantalla de deportes.
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!.translate('sports'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SportsScreen()), // Navega a la pantalla de deportes.
                      );
                    },
                  ),
                  const SizedBox(height: 10), // Espacio entre botones.
                  // Botón para navegar a la pantalla de entrenamiento con pesas.
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!
                        .translate('entrenamientoPesas'), // Texto traducido.
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EntrenamientoConPesas()), // Navega a la pantalla de entrenamiento con pesas.
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90), // Espaciado al final de la columna.
          ],
        ),
      ),
    );
  }

  // Método para construir un botón con estilo.
  Widget _buildObjectivesButton(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed, // Acción al presionar el botón.
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Radio de los bordes del botón.
        ),
        foregroundColor: Colors.white, // Color del texto.
        backgroundColor: AppColors.gdarkblue2, // Color de fondo del botón.
        padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 4.0), // Espaciado interno del botón.
        textStyle: Theme.of(context)
            .textTheme
            .labelMedium, // Estilo del texto del botón.
      ),
      child: Align(
        alignment: Alignment.center, // Alinea el texto en el centro del botón.
        child: Text(
          text, // Texto del botón.
          textAlign: TextAlign.center, // Alineación del texto.
        ),
      ),
    );
  }

  // Método para construir un dropdown para seleccionar ejercicios.
  Widget _buildExerciseDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 6.0, horizontal: 30.0), // Espaciado interno.
      child: DropdownButton<String>(
        value: dropdownValue, // Valor seleccionado actualmente.
        icon: const Icon(Icons.arrow_downward), // Icono del dropdown.
        iconSize: 30, // Tamaño del icono.
        elevation: 26, // Elevación del dropdown.
        style: TextStyle(
            color: Colors.white,
            fontSize: 18), // Estilo del texto del dropdown.
        underline: Container(
          height: 1, // Altura de la línea debajo del dropdown.
          color: Colors.white, // Color de la línea.
        ),
        // Callback para manejar el cambio de selección en el dropdown.
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!; // Actualiza el valor seleccionado.
            _controller.load(
                videoIds[dropdownValue]!); // Carga el video correspondiente.
          });
        },
        // Genera los elementos del dropdown a partir del mapa de IDs de video.
        items: videoIds.keys.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              AppLocalizations.of(context)!
                  .translate(value), // Texto traducido para cada opción.
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge, // Estilo del texto de la opción.
            ),
          );
        }).toList(),
      ),
    );
  }
}
