import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../backend/models/ejercicio_model.dart';
import '../config/lang/app_localization.dart';
import '../config/utils/appcolors.dart';
//import 'adaptacion_anatomica/anatomic_adapt.dart';
import 'adaptacion_anatomica/anatomic_adapt_video.dart';
import 'destination_screen.dart';
//import 'adaptacion_anatomica/anatomic_adapt_ori.dart';
//import 'adaptacion_anatomica/anatomica_adaptacion_screen.dart';
//import 'entrenamiento_con_pesas/adaptacion_anatomica_screen.dart';


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
      ),
    );
    _destinationScreen = AnatomicAdaptVideo(
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentCardTitle = AppLocalizations.of(context)!
        .translate('adaptacionAnatomica');
    _selectedCardTitle = _currentCardTitle;
  }

  void _updateScreenAndVideo(Widget screen, String videoId, String cardTitle) {
    setState(() {
      _destinationScreen = screen;
      _videoId = videoId;
      _currentCardTitle = cardTitle;
      _selectedCardTitle = cardTitle;
      _youtubeController.load(videoId);
    });
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: Column(
        children: [
          _buildCardsRow(context),
          SizedBox(height: 7),
          _buildCardsRow2(context),
          SizedBox(height: 7),
          _buildButton(context),
          SizedBox(height: 10),
          Text(
            'Video de $_currentCardTitle',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          _buildVideo(context),
        ],
      ),
    );
  }

  Widget _buildCardsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('hipertrofia'),
          fontSize: 10,
          videoId: 'PnYLx4JdjE4',
          destinationScreen: DestinationScreen(),
          showLock: true,
        ),
        _buildCard(
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('entrenamientoMixto'),
          fontSize: 10,
          videoId: 'URLZB2Uo_tQ',
          destinationScreen: DestinationScreen(),
          showLock: true,
        ),
      ],
    );
  }

  Widget _buildCardsRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard(
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('entrenamientoFuerza'),
          fontSize: 10,
          videoId: 'tOkSbxV6bj0',
          destinationScreen: DestinationScreen(),
          showLock: true,
        ),
        _buildCard(
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('definition'),
          fontSize: 10,
          videoId: 'YwUeY8LDCw4',
          destinationScreen: DestinationScreen(),
          showLock: true,
        ),
        _buildCard(
          context,
          AppColors.gdarkblue2,
          AppLocalizations.of(context)!.translate('transition'),
          fontSize: 10,
          videoId: 'v51EB-fkDgA',
          destinationScreen: DestinationScreen(),
          showLock: true,
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Color color, String text,
      {double fontSize = 16,
      required String videoId,
      required Widget destinationScreen,
      bool showLock = false}) {
    bool isSelected =
        _selectedCardTitle == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _updateScreenAndVideo(destinationScreen, videoId, text);
        },
        child: Card(
          color: isSelected
              ? Colors.orange
              : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: isSelected ? Colors.orange : Colors.black, width: 2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        text,
                        style:
                            TextStyle(color: Colors.white, fontSize: fontSize),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showLock) ...[
                      SizedBox(width: 5),
                      Icon(Icons.lock, color: Colors.white, size: 16),
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
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _destinationScreen),
        );
      },
      child: Text(AppLocalizations.of(context)!.translate('start')),
    );
  }

  Widget _buildVideo(BuildContext context) {
    return YoutubePlayer(
      controller: _youtubeController,
      showVideoProgressIndicator: true,
      onReady: () {},
    );
  }
}
