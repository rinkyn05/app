import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../rendimiento/rendimiento_screen.dart';

class SportsDetailsPage extends StatelessWidget {
  final DocumentSnapshot sport;

  const SportsDetailsPage({Key? key, required this.sport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nombre =
        _getTranslatedField('Nombre', context) ?? 'Nombre no encontrado';
    String contenido =
        _getTranslatedField('Contenido', context) ?? 'Contenido no encontrado';
    String videoUrl = sport['Video'] ?? '';

    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    if (videoUrl.isEmpty) {
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
                border: Border.all(
                    color: Colors.black, width: 2),
              ),
              child: SizedBox(
                height: 250,
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                  onReady: () {},
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
                    double.parse(sport['Resistencia'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!
                        .translate('aestheticPhysical'),
                    double.parse(sport['FisicoEstetico'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!.translate('anaerobicPower'),
                    double.parse(sport['PotenciaAnaerobica'] ?? '0'),
                  ),
                  _buildCircularProgress(
                    context,
                    AppLocalizations.of(context)!.translate('healthWellness'),
                    double.parse(sport['SaludBienestar'] ?? '0'),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RendimientoScreen(),
                      ),
                    );
                },
                ),
                SizedBox(height: 8),
                _buildObjectivesButton(
                  context,
                  text: AppLocalizations.of(context)!
                      .translate('Técnica deportiva'),
                  onPressed: () {},
                ),
                SizedBox(height: 8),
                _buildObjectivesButton(
                  context,
                  text: AppLocalizations.of(context)!
                      .translate('rendimiento'),
                  onPressed: () {},
                ),
                SizedBox(height: 40),
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
    return sport[fieldKey];
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
