import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/recipes_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/language_notifier.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../widgets/custom_appbar_new.dart';

class RecipesDetalleScreen extends StatefulWidget {
  final Recipes recipes;

  const RecipesDetalleScreen({Key? key, required this.recipes})
      : super(key: key);

  @override
  RecipesDetalleScreenState createState() => RecipesDetalleScreenState();
}

class RecipesDetalleScreenState extends State<RecipesDetalleScreen> {
  late YoutubePlayerController _controller;
  double _volume = 100.0;
  bool _isMuted = false;

  String _translate(BuildContext context, String esp, String eng) {
    String languageCode =
        Provider.of<LanguageNotifier>(context, listen: false)
            .currentLocale
            .languageCode;
    return languageCode == 'es' ? esp : eng;
  }

  Widget _buildCaloriasIcons(String calorias, BuildContext context) {
    int filledIcons;
    int caloriasValue = int.tryParse(calorias) ?? 0;

    if (caloriasValue <= 50) {
      filledIcons = 1;
    } else if (caloriasValue > 50 && caloriasValue <= 100) {
      filledIcons = 2;
    } else if (caloriasValue > 100) {
      filledIcons = 3;
    } else {
      filledIcons = 0;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (index) => Icon(
                    Icons.flash_on,
                    color: index < filledIcons
                        ? Theme.of(context).iconTheme.color
                        : Theme.of(context).disabledColor,
                    size: 50,
                  )),
        ),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.translate('calories'),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center),
        Text("${caloriasValue} kcal",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _getCategoryWidget(String category, BuildContext context) {
    String translatedCategory =
        _translate(context, widget.recipes.categoryEsp, widget.recipes.categoryEng);
    IconData iconData;
    String textLabel;

    switch (translatedCategory.toLowerCase()) {
      case 'vegetal':
      case 'vegetable':
        iconData = Icons.person;
        textLabel = AppLocalizations.of(context)!.translate('vegetal');
        break;
      case 'animal':
      case 'animals':
        iconData = Icons.pets;
        textLabel = AppLocalizations.of(context)!.translate('animal');
        break;
      default:
        iconData = Icons.help_outline;
        textLabel = AppLocalizations.of(context)!.translate('Unknown');
    }

    return Column(
      children: [
        Icon(iconData, size: 50, color: Theme.of(context).iconTheme.color),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.translate('recipesCategory'),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center),
        Text(textLabel,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
      ],
    );
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

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.recipes.video) ?? '';
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
    final String contenido =
        _translate(context, widget.recipes.contenidoEsp, widget.recipes.contenidoEng);

    final List<Map<String, dynamic>> details = [
      {
        'valueWidget': _buildCaloriasIcons(widget.recipes.calorias, context),
      },
      {
        'valueWidget': _getCategoryWidget(widget.recipes.estancia, context),
      },
      {
        'key': AppLocalizations.of(context)!.translate('calories'),
        'value': widget.recipes.calorias,
        'icon': Icons.local_fire_department,
      },
    ];

    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.recipes.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 16,
                  height: 300),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: details.map((detail) {
                return Card(
                  elevation: 4.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 16,
                    padding: const EdgeInsets.all(8.0),
                    child: detail.containsKey('valueWidget')
                        ? Column(children: [detail['valueWidget']])
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(detail['icon'],
                                  size: 50,
                                  color: Theme.of(context).iconTheme.color),
                              const SizedBox(height: 8),
                              Text(detail['key'],
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(detail['value'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                contenido,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.translate('howToDoExercise'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0)
                  .copyWith(left: 8.0, right: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}