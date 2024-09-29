import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../config/utils/appcolors.dart';
import '../../config/lang/app_localization.dart';
import 'entreniento_con_pesas.dart';
import 'sports/sports_screen.dart';
import 'three_d_image_screen.dart';

class EntrenamientoFisico extends StatefulWidget {
  @override
  _EntrenamientoFisicoState createState() => _EntrenamientoFisicoState();
}

class _EntrenamientoFisicoState extends State<EntrenamientoFisico> {
  String dropdownValue = 'physicalTraining';
  late YoutubePlayerController _controller;

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
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoIds[dropdownValue]!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              "${AppLocalizations.of(context)!.translate('physicalTraining')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                ),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                elevation: 3.0,
                color: AppColors.gdarkblue2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        AppLocalizations.of(context)!.translate('exerciseFor'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Column(
                        children: [
                          _buildExerciseDropdown(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!.translate('exercises'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThreeDImageScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!.translate('sports'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SportsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildObjectivesButton(
                    context,
                    text: AppLocalizations.of(context)!
                        .translate('entrenamientoPesas'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EntrenamientoConPesas()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectivesButton(BuildContext context,
      {required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.gdarkblue2,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildExerciseDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 30.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 30,
        elevation: 26,
        style: TextStyle(color: Colors.white, fontSize: 18),
        underline: Container(
          height: 1,
          color: Colors.white,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            _controller.load(videoIds[dropdownValue]!);
          });
        },
        items: videoIds.keys.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              AppLocalizations.of(context)!.translate(value),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }).toList(),
      ),
    );
  }
}
