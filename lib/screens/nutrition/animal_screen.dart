import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/grid_view/mansory_animal.dart';

class AnimalScreen extends StatefulWidget {
  @override
  _AnimalScreenState createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      enableCaption: false, // Deshabilitar subtítulos si es necesario
    ),
  );

  double _volume = 50.0; // Variable para almacenar el volumen actual

  @override
  void initState() {
    super.initState();
    _controller
        .setVolume(_volume.toInt()); // Establecer el volumen predeterminado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4),
            CustomAppBarNew(
              onBackButtonPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('Animal')}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
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
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    Container(
                      width: 100,
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 100,
                        onChanged: (newVolume) {
                          setState(() {
                            _volume = newVolume;
                          });
                          _controller.setVolume(newVolume.toInt());
                        },
                      ),
                    ),
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
                  onReady: () {
                    debugPrint(
                        "Video is ready."); // Callback cuando el reproductor está listo
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.translate('search'),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryRecipes(),
            ),
          ],
        ),
      ),
    );
  }
}
