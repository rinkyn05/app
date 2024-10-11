import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa la librería para almacenar preferencias compartidas.
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Importa la librería para reproducir videos de YouTube.
import '../config/lang/app_localization.dart'; // Importa el archivo de localización de la aplicación.
import '../screens/temporizador/temporizador.dart'; // Importa el widget StopwatchWidget desde la pantalla del temporizador.

class CustomAppBarNewAdapt extends StatefulWidget
    implements PreferredSizeWidget {
  final VoidCallback?
      onBackButtonPressed; // Callback opcional para manejar el evento del botón de retroceso.

  const CustomAppBarNewAdapt({Key? key, this.onBackButtonPressed})
      : super(key: key);

  @override
  _CustomAppBarNewAdaptState createState() =>
      _CustomAppBarNewAdaptState(); // Crea el estado del AppBar.

  @override
  Size get preferredSize =>
      Size.fromHeight(170); // Devuelve la altura preferida del AppBar.
}

class _CustomAppBarNewAdaptState extends State<CustomAppBarNewAdapt> {
  late YoutubePlayerController
      _controller; // Controlador para el reproductor de YouTube.
  bool _firstVisit = true; // Bandera para determinar si es la primera visita.

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de YouTube con un video por defecto.
    _controller = YoutubePlayerController(
      initialVideoId: 'nPt8bK2gbaU', // ID del video de YouTube.
      flags: YoutubePlayerFlags(
        autoPlay: false, // No reproduce automáticamente.
        mute: false, // No está en silencio por defecto.
      ),
    );
    _checkFirstVisit(); // Verifica si es la primera visita del usuario.
  }

  Future<void> _checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene la instancia de SharedPreferences.
    bool? firstVisit = prefs.getBool(
        'firstVisitAdaptacionAnatomica'); // Verifica si el usuario ha visitado antes.
    if (firstVisit == null || firstVisit) {
      // Si es la primera visita o no se ha establecido.
      await prefs.setBool('firstVisitAdaptacionAnatomica',
          false); // Marca como no primera visita.
      setState(() {
        _firstVisit = true; // Actualiza la bandera a true.
      });
      _showVideoDialog(); // Muestra el diálogo con el video.
    } else {
      setState(() {
        _firstVisit = false; // Actualiza la bandera a false.
      });
    }
  }

  void _showVideoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: YoutubePlayer(
            controller:
                _controller, // Asigna el controlador al reproductor de YouTube.
            showVideoProgressIndicator:
                true, // Muestra el indicador de progreso del video.
            onReady: () {}, // Callback cuando el reproductor está listo.
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'), // Texto del botón para cerrar el diálogo.
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo.
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleVideoVisibility() {
    _showVideoDialog(); // Muestra el diálogo del video.
  }

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
            if (widget.onBackButtonPressed != null) {
              // Verifica si hay un callback definido.
              widget
                  .onBackButtonPressed!(); // Llama al callback si está definido.
            } else {
              Navigator.pop(
                  context); // Regresa a la pantalla anterior si no hay callback.
            }
          },
          iconSize: 50, // Tamaño del ícono del botón de retroceso.
        ),
        title:
            StopwatchWidget(), // Muestra el widget del temporizador como el título del AppBar.
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              50), // Altura preferida del área inferior del AppBar.
          child: Padding(
            padding: const EdgeInsets.all(
                2.0), // Relleno alrededor de los elementos en la parte inferior.
            child: Center(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate(
                        'adaptacionAnatomica'), // Texto traducido para el título.
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed:
                        _toggleVideoVisibility, // Llama a la función para mostrar el video.
                    child: Text(
                        'Mostrar Video Explicativo'), // Texto del botón para mostrar el video.
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
