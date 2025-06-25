import 'package:flutter/material.dart'; // Importa los widgets de Flutter
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa el paquete para reproducir videos de YouTube
import '../backend/models/ejercicio_model.dart'; // Importa el modelo de ejercicio
import '../config/lang/app_localization.dart'; // Importa las configuraciones de localización
import '../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación
//import 'adaptacion_anatomica/anatomic_adapt.dart'; // Importación comentada de una posible pantalla de adaptación anatómica
import 'adaptacion_anatomica/anatomic_adapt.dart'; // Importa la pantalla de video de adaptación anatómica
// Importa el creador de planes de entrenamiento mixto

//import 'definicion/definicion_video.dart';
//import 'entrenamiento_mixto/entrenamiento_mixto_video.dart';
//import 'fuerza_maxima/fuerza_maxima_video.dart'; // Importa fuerza máxima
//import 'hipertrofia/hipertrofia_adapt_video.dart'; // Importa la pantalla de video de hipertrofia
//import 'transicion/transicion_video.dart'; // Importa el creador de planes de definición
//import 'adaptacion_anatomica/anatomic_adapt_ori.dart'; // Importación comentada
//import 'adaptacion_anatomica/anatomica_adaptacion_screen.dart'; // Importación comentada
//import 'entrenamiento_con_pesas/adaptacion_anatomica_screen.dart'; // Importación comentada

class EntrenamientoPesas extends StatefulWidget {
  const EntrenamientoPesas({Key? key}) : super(key: key);

  @override
  _EntrenamientoPesasState createState() => _EntrenamientoPesasState();
}

class _EntrenamientoPesasState extends State<EntrenamientoPesas> {
  late YoutubePlayerController _youtubeController;
  late Widget _destinationScreen;
  late String _videoId;
  late String _currentCardTitle;
  String? _selectedCardTitle;
  List<Ejercicio> ejerciciosSeleccionados = [];

  @override
  void initState() {
    super.initState();
    _videoId = 'cTcTIBOgM9E';
    _youtubeController = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false, // Deshabilitar subtítulos si es necesario
      ),
    );
    // Pasa selectedValues a AnatomicAdaptVideo
    _destinationScreen = AnatomicAdaptVideo();
  }

  @override
  void didChangeDependencies() {
    // Método que se llama cuando las dependencias cambian
    super.didChangeDependencies(); // Llama al método de dependencias del padre
    _currentCardTitle =
        AppLocalizations.of(context)! // Obtiene el título de la tarjeta actual
            .translate(
                'adaptacionAnatomica'); // Traduce el texto para la localización
    _selectedCardTitle =
        _currentCardTitle; // Establece el título de la tarjeta seleccionada
  }

  void _updateScreenAndVideo(Widget screen, String videoId, String cardTitle) {
    setState(() {
      _destinationScreen = screen;
      _videoId = videoId;
      _currentCardTitle = cardTitle;
      _selectedCardTitle = cardTitle;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false, // Deshabilitar subtítulos si es necesario
        ),
      );
    });
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.translate('premiumTitle'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.translate('premiumMessage'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              AppLocalizations.of(context)!.translate('close')),
                          SizedBox(width: 5),
                          Icon(Icons.close, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Método que se llama cuando se elimina el estado
    _youtubeController.dispose(); // Libera el controlador de YouTube
    super.dispose(); // Llama al método de eliminación del padre
  }

  @override
  Widget build(BuildContext context) {
    // Método que construye el widget
    return Container(
      // Crea un contenedor para los widgets
      height: 700, // Establece la altura del contenedor
      child: Column(
        // Organiza los widgets en una columna
        children: [
          _buildCardsRow(
              context), // Llama a método para construir la primera fila de tarjetas
          SizedBox(height: 7), // Espacio entre las filas de tarjetas
          _buildCardsRow2(
              context), // Llama a método para construir la segunda fila de tarjetas
          SizedBox(height: 7), // Espacio entre las filas de tarjetas
          _buildButton(context), // Llama a método para construir el botón
          SizedBox(height: 10), // Espacio entre el botón y el texto del video
          Text(
            'Video de $_currentCardTitle', // Muestra el título del video actual
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold), // Estilo del texto
          ),
          SizedBox(height: 5), // Espacio entre el texto y el video
          _buildVideo(
              context), // Llama a método para construir el reproductor de video
        ],
      ),
    );
  }

  Widget _buildCardsRow(BuildContext context) {
    // Método para construir la primera fila de tarjetas
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceEvenly, // Espaciado uniforme entre los elementos
      children: [
        _buildCard(
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('adaptacionAnatomica'),
          fontSize: 10,
          videoId: 'cTcTIBOgM9E',
          destinationScreen: AnatomicAdaptVideo(),
        ),
        _buildCard(
          // Construye la segunda tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('hipertrofia'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'PnYLx4JdjE4', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
          showLock: true, // Muestra un icono de bloqueo
        ),
        _buildCard(
          // Construye la tercera tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('entrenamientoMixto'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'URLZB2Uo_tQ', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
          showLock: true, // Muestra un icono de bloqueo
        ),
      ],
    );
  }

  Widget _buildCardsRow2(BuildContext context) {
    // Método para construir la segunda fila de tarjetas
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceEvenly, // Espaciado uniforme entre los elementos
      children: [
        _buildCard(
          // Construye la primera tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('entrenamientoFuerza'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'tOkSbxV6bj0', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
          showLock: true, // Muestra un icono de bloqueo
        ),
        _buildCard(
          // Construye la segunda tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('definition'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'YwUeY8LDCw4', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
          showLock: true, // Muestra un icono de bloqueo
        ),
        _buildCard(
          // Construye la tercera tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('transition'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'v51EB-fkDgA', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
          showLock: true, // Muestra un icono de bloqueo
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Color color,
      String text, // Método para construir una tarjeta
      {double fontSize = 16, // Tamaño de la fuente
      required String videoId, // ID del video
      required Widget destinationScreen, // Pantalla de destino
      bool showLock = false}) {
    // Indica si se debe mostrar el icono de bloqueo
    bool isSelected = // Comprueba si la tarjeta está seleccionada
        _selectedCardTitle == text;
    return Expanded(
      // Expande la tarjeta para llenar el espacio disponible
      child: GestureDetector(
        // Detecta gestos del usuario
        onTap: () {
          // Maneja el evento de toque
          if (text ==
              AppLocalizations.of(context)!.translate('adaptacionAnatomica')) {
            _updateScreenAndVideo(destinationScreen, videoId,
                text); // Actualiza la pantalla y el video
          } else {
            _showPremiumDialog(); // Muestra el diálogo de premium
          }
        },
        child: Card(
          // Crea una tarjeta
          color: isSelected // Establece el color basado en si está seleccionado
              ? Colors.orange
              : color,
          shape: RoundedRectangleBorder(
            // Establece la forma de la tarjeta
            borderRadius: BorderRadius.circular(10), // Radio de bordes
            side: BorderSide(
                color: isSelected ? Colors.orange : Colors.black,
                width: 2), // Color del borde
          ),
          child: Column(
            // Organiza el contenido de la tarjeta en columnas
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0), // Espaciado interno
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Alinea los elementos en el centro
                  children: [
                    Flexible(
                      // Permite que el texto se ajuste
                      child: Text(
                        text, // Muestra el texto de la tarjeta
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize), // Estilo del texto
                        textAlign: TextAlign.center, // Alineación del texto
                        maxLines: 2, // Máximo número de líneas
                        overflow: TextOverflow
                            .ellipsis, // Muestra puntos suspensivos si hay desbordamiento
                      ),
                    ),
                    if (showLock) ...[
                      // Si se debe mostrar el icono de bloqueo
                      SizedBox(width: 5), // Espacio entre el texto y el icono
                      Icon(Icons.lock,
                          color: Colors.white, size: 16), // Icono de bloqueo
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    // Método para construir el botón
    return ElevatedButton(
      onPressed: () {
        // Maneja el evento de presión del botón
        Navigator.push(
          // Navega a la pantalla de destino
          context,
          MaterialPageRoute(
              builder: (context) => _destinationScreen), // Crea una nueva ruta
        );
      },
      child: Text(AppLocalizations.of(context)!
          .translate('start')), // Texto del botón traducido
    );
  }

  Widget _buildVideo(BuildContext context) {
    // Método para construir el reproductor de video
    return YoutubePlayer(
      // Crea el reproductor de YouTube
      controller: _youtubeController, // Controlador del reproductor
      showVideoProgressIndicator:
          true, // Muestra el indicador de progreso del video
      bottomActions: [
        CurrentPosition(), // Muestra la posición actual del video
        ProgressBar(
            isExpanded: true), // Muestra una barra de progreso expandida
        IconButton(
          icon: Icon(Icons
              .fullscreen_exit), // Icono que simula el botón de pantalla completa
          onPressed: () {
            // No hacer nada para evitar la pantalla completa
          },
        ),
      ],
      topActions: [
        // Aquí puedes agregar acciones personalizadas si es necesario
      ],
      onReady: () {}, // Callback cuando el reproductor está listo
    );
  }
}
