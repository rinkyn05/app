import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../widgets/custom_appbar_new.dart';
import 'entrenamiento_pesas.dart';

class EntrenamientoConPesas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('entrenamientoPesas')}",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 6.0,
                        color: AppColors.adaptableColor(context),
                      ),
                    ),
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: 'cTcTIBOgM9E',
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      onReady: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            EntrenamientoPesas(),
            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
