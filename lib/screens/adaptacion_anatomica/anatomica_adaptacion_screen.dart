import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../widgets/custom_appbar_new.dart';

class AnatomicaAdaptacionScreen extends StatefulWidget {
  @override
  _AnatomicaAdaptacionScreenState createState() =>
      _AnatomicaAdaptacionScreenState();
}

class _AnatomicaAdaptacionScreenState extends State<AnatomicaAdaptacionScreen> {
  bool _isVideoVisible = true;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    debugPrint("Controller initialized.");
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint("Controller disposed.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4),
          CustomAppBarNew(
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isVideoVisible)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 6.0,
                        color: AppColors.adaptableColor(context),
                      ),
                    ),
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        debugPrint("Video is ready.");
                      },
                    ),
                  ),
                SizedBox(height: 4),
                ElevatedButton.icon(
                  onPressed: () {
                    try {
                      setState(() {
                        _isVideoVisible = !_isVideoVisible;
                        debugPrint(
                            "Video visibility toggled: $_isVideoVisible");
                      });
                    } catch (e) {
                      debugPrint("Error toggling video visibility: $e");
                    }
                  },
                  icon: Icon(_isVideoVisible ? Icons.close : Icons.play_arrow),
                  label: Text(
                    _isVideoVisible
                        ? AppLocalizations.of(context)!.translate('hideVideo')
                        : AppLocalizations.of(context)!.translate('showVideo'),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildCard(context, 'Deltoide'),
                                  _buildCard(context, 'Pectoral'),
                                  _buildCard(context, 'Bíceps'),
                                  _buildCard(context, 'Abdomen'),
                                  _buildCard(context, 'Antebrazo'),
                                  _buildCard(context, 'Cuádriceps'),
                                  _buildCard(context, 'Tibial Anterior'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ModelViewer(
                                backgroundColor:
                                    Color.fromARGB(255, 50, 50, 50),
                                src: 'assets/tre_d/cuerpo07.glb',
                                alt: 'A 3D model of a Human Body',
                                ar: true,
                                autoRotate: false,
                                disableZoom: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
