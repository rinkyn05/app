import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class CalentamientoFisicoDetailsPage extends StatefulWidget {
  final DocumentSnapshot calentamientoFisico;

  const CalentamientoFisicoDetailsPage(
      {Key? key, required this.calentamientoFisico})
      : super(key: key);

  @override
  CalentamientoFisicoDetailsPageState createState() =>
      CalentamientoFisicoDetailsPageState();
}

class CalentamientoFisicoDetailsPageState
    extends State<CalentamientoFisicoDetailsPage> {
  late YoutubePlayerController _controller;
  double _volume = 100.0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    String videoUrl = widget.calentamientoFisico['Video'] ?? '';
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false, // Deshabilitar subtítulos si es necesario
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String nombre = _getTranslatedField('Nombre', context) ?? 'Nombre no encontrado';
    String contenido = _getTranslatedField('Contenido', context) ?? 'Contenido no encontrado';

    if (widget.calentamientoFisico['Video'] == null ||
        widget.calentamientoFisico['Video'].toString().isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 50, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error: No se ha proporcionado un enlace de video válido',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBarNew(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                nombre,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: SizedBox(
                height: 250,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    IconButton(
                      icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                      onPressed: _toggleVolume,
                    ),
                    IconButton(
                      icon: Icon(Icons.fullscreen_exit),
                      onPressed: () {
                        // No hacer nada para evitar la pantalla completa
                      },
                    ),
                  ],
                  topActions: [
                    // Aquí puedes agregar acciones personalizadas si es necesario
                  ],
                  onReady: () {
                    debugPrint("Video is ready.");
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!.translate('resistance'),
                    double.parse(widget.calentamientoFisico['Resistencia'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!
                        .translate('aestheticPhysical'),
                    double.parse(widget.calentamientoFisico['FisicoEstetico'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!.translate('anaerobicPower'),
                    double.parse(widget.calentamientoFisico['PotenciaAnaerobica'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!.translate('healthWellness'),
                    double.parse(widget.calentamientoFisico['SaludBienestar'] ?? '0'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                contenido,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildObjectivesButton(
                  context,
                  text: AppLocalizations.of(context)!
                      .translate('Rendimiento físico'),
                  onPressed: () {},
                ),
                SizedBox(height: 8),
                _buildObjectivesButton(
                  context,
                  text: AppLocalizations.of(context)!
                      .translate('Técnica deportiva'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _getTranslatedField(String fieldName, BuildContext context) {
    String locale = AppLocalizations.of(context)!.locale.languageCode;
    String fieldKey = '$fieldName${locale == 'en' ? 'Eng' : 'Esp'}';
    return widget.calentamientoFisico[fieldKey];
  }

  void _toggleVolume() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = 100.0;
      } else {
        _isMuted = true;
        _volume = 0.0;
      }
      _controller.setVolume(_volume.toInt());
    });
  }

  Widget _buildCircularProgress(
      BuildContext context, String label, double value) {
    return SizedBox(
      width: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 8,
            percent: value / 100,
            center: Text(
              '${value.toInt()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            progressColor: Colors.blue,
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivesButton(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 350,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.gdarkblue2,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          textStyle: Theme.of(context).textTheme.titleMedium,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}