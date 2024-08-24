import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../widgets/custom_appbar_new.dart';

class AnatomicAdaptOri extends StatefulWidget {
  @override
  _AnatomicAdaptOriState createState() => _AnatomicAdaptOriState();
}

class _AnatomicAdaptOriState extends State<AnatomicAdaptOri> {
  bool _isVideoVisible = true;
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  void _toggleVideoVisibility() {
    setState(() {
      _isVideoVisible = !_isVideoVisible;
      debugPrint("Video visibility toggled: $_isVideoVisible");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isVideoVisible
                ? Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 6.0,
                            color: Theme.of(context).primaryColor,
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
                      TextButton.icon(
                        onPressed: _toggleVideoVisibility,
                        icon: Icon(Icons.close),
                        label: Text('Ocultar'),
                      ),
                    ],
                  )
                : TextButton.icon(
                    onPressed: _toggleVideoVisibility,
                    icon: Icon(Icons.visibility),
                    label: Text('Mostrar'),
                  ),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 2,
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
                Flexible(
                  flex: 3,
                  child: ModelViewer(
                    backgroundColor: Color.fromARGB(255, 50, 50, 50),
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
