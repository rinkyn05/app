import 'package:flutter/material.dart'; // Importa los widgets de Flutter
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa el paquete para reproducir videos de YouTube
import '../backend/models/ejercicio_model.dart'; // Importa el modelo de ejercicio
import '../config/lang/app_localization.dart'; // Importa las configuraciones de localización
import '../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación
//import 'adaptacion_anatomica/anatomic_adapt.dart'; // Importación comentada de una posible pantalla de adaptación anatómica
import 'adaptacion_anatomica/anatomic_adapt_video.dart'; // Importa la pantalla de video de adaptación anatómica
import 'entrenamiento_mixto/entrenamiento_mixto_plan_creator.dart'; // Importa el creador de planes de entrenamiento mixto
import 'fuerza_maxima/fuerza_maxima_plan_creator.dart'; // Importa el creador de planes de fuerza máxima
import 'hipertrofia/hipertrofia_adapt_video.dart'; // Importa la pantalla de video de hipertrofia
import 'definicion/definicion_plan_creator.dart';
import 'transicion/transicion.dart'; // Importa el creador de planes de definición
//import 'adaptacion_anatomica/anatomic_adapt_ori.dart'; // Importación comentada
//import 'adaptacion_anatomica/anatomica_adaptacion_screen.dart'; // Importación comentada
//import 'entrenamiento_con_pesas/adaptacion_anatomica_screen.dart'; // Importación comentada

class EntrenamientoPesas extends StatefulWidget {
  const EntrenamientoPesas({Key? key})
      : super(key: key); // Constructor de la clase

  @override
  _EntrenamientoPesasState createState() =>
      _EntrenamientoPesasState(); // Crea el estado asociado a este widget
}

class _EntrenamientoPesasState extends State<EntrenamientoPesas> {
  late YoutubePlayerController
      _youtubeController; // Controlador para el reproductor de YouTube
  late Widget
      _destinationScreen; // Pantalla de destino que se mostrará al usuario
  late String _videoId; // ID del video de YouTube que se reproducirá
  late String
      _currentCardTitle; // Título de la tarjeta actualmente seleccionada
  String? _selectedCardTitle; // Título de la tarjeta seleccionada
  List<Ejercicio> ejerciciosSeleccionados =
      []; // Lista de ejercicios seleccionados

  @override
  void initState() {
    // Método que se llama al inicializar el estado
    super.initState(); // Llama al método de inicialización del padre
    _videoId = 'cTcTIBOgM9E'; // ID del video inicial
    _youtubeController = YoutubePlayerController(
      // Inicializa el controlador de YouTube
      initialVideoId: _videoId, // Establece el ID del video inicial
      flags: const YoutubePlayerFlags(
        // Configura las opciones del reproductor
        autoPlay: false, // No reproduce el video automáticamente
        mute: false, // No silencia el video
      ),
    );
    _destinationScreen =
        AnatomicAdaptVideo(); // Establece la pantalla de destino inicial
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
    // Método para actualizar la pantalla y el video
    setState(() {
      // Notifica a Flutter que debe volver a construir el widget
      _destinationScreen = screen; // Actualiza la pantalla de destino
      _videoId = videoId; // Actualiza el ID del video
      _currentCardTitle = cardTitle; // Actualiza el título de la tarjeta actual
      _selectedCardTitle =
          cardTitle; // Establece el título de la tarjeta seleccionada
      _youtubeController
          .load(videoId); // Carga el nuevo video en el controlador
    });
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
          // Construye la primera tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('adaptacionAnatomica'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'cTcTIBOgM9E', // ID del video
          destinationScreen: AnatomicAdaptVideo(), // Pantalla de destino
        ),
        _buildCard(
          // Construye la segunda tarjeta
          context,
          AppColors.gdarkblue2, // Color de la tarjeta
          AppLocalizations.of(context)!
              .translate('hipertrofia'), // Título de la tarjeta
          fontSize: 10, // Tamaño de la fuente
          videoId: 'PnYLx4JdjE4', // ID del video
          destinationScreen: HipertrofiaAdaptVideo(), // Pantalla de destino
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
          destinationScreen:
              EntrenamientoMixtoPlanCreator(), // Pantalla de destino
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
          destinationScreen: FuerzaMaximaPlanCreator(), // Pantalla de destino
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
          destinationScreen: DefinicionPlanCreator(), // Pantalla de destino
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
          destinationScreen: transicionPlanCreator(), // Pantalla de destino
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
          _updateScreenAndVideo(destinationScreen, videoId,
              text); // Actualiza la pantalla y el video
        },
        child: Card(
          // Crea una tarjeta
          color: isSelected // Establece el color basado en si está seleccionada
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
      onReady: () {}, // Callback cuando el reproductor está listo
    );
  }
}
