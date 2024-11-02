import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../config/helpers/navigation_helpers.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/selection_notifier.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/info_card_widget.dart';
import 'anatomic_adapt.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AnatomicAdaptVideo extends StatefulWidget {
  @override
  _AnatomicAdaptVideoState createState() => _AnatomicAdaptVideoState();
}

class _AnatomicAdaptVideoState extends State<AnatomicAdaptVideo> {
  String selectedCard = '';

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Future<void> _onCardTap(String title) async {
    if (title == 'Crear Plan') {
      navigateToExerciseScreen(context, title);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    bool isCardTapped = prefs.getBool(title) ?? false;

    if (isCardTapped) {
      navigateToExerciseScreen(context, title);
    } else {
      prefs.setBool(title, true);
      setState(() {
        selectedCard = title;
      });
    }
  }

  List<CardWidget> _getFilteredCards(SelectionNotifier notifier) {
    // Extraer solo el número de la cadena antes de convertir a entero
    int cantidadDeEjerciciosEsp = int.tryParse(notifier.cantidadDeEjerciciosEsp.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int cantidadDeEjerciciosEng = int.tryParse(notifier.cantidadDeEjerciciosEng.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Mostrar los valores actuales de cantidadDeEjerciciosEsp y cantidadDeEjerciciosEng
    print("Valor de cantidadDeEjerciciosEsp: $cantidadDeEjerciciosEsp");
    print("Valor de cantidadDeEjerciciosEng: $cantidadDeEjerciciosEng");

    // Define las tarjetas que se mostrarán según el valor de cantidadDeEjerciciosEsp
    List<String> cardTitles;
    switch (cantidadDeEjerciciosEsp) {
      case 2:
        cardTitles = ['Crear Plan', 'Deltoide', 'Cuádriceps'];
        break;
      case 3:
        cardTitles = ['Crear Plan', 'Deltoide', 'Abdomen', 'Cuádriceps'];
        break;
      case 4:
        cardTitles = [
          'Crear Plan',
          'Pectoral',
          'Deltoide',
          'Abdomen',
          'Cuádriceps'
        ];
        break;
      case 5:
        cardTitles = [
          'Crear Plan',
          'Pectoral',
          'Deltoide',
          'Abdomen',
          'Cuádriceps',
          'Tibial anterior'
        ];
        break;
      case 6:
        cardTitles = [
          'Crear Plan',
          'Pectoral',
          'Deltoide',
          'Abdomen',
          'Bíceps',
          'Cuádriceps',
          'Tibial anterior'
        ];
        break;
      case 7:
      case 8:
        cardTitles = [
          'Crear Plan',
          'Pectoral',
          'Deltoide',
          'Abdomen',
          'Bíceps',
          'Cuádriceps',
          'Antebrazo',
          'Tibial anterior'
        ];
        break;
      default:
        cardTitles = [
          'Crear Plan',
          'Deltoide',
          'Pectoral',
          'Bíceps',
          'Abdomen',
          'Antebrazo',
          'Cuádriceps',
          'Tibial anterior'
        ];
    }

    return [
      CardWidget(title: 'Crear Plan', description: '', onCardTap: _onCardTap),
      CardWidget(
          title: 'Deltoide',
          description: 'Músculo en la parte superior del brazo y el hombro.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Pectoral',
          description: 'Músculo del pecho.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Bíceps',
          description: 'Músculo en la parte frontal del brazo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Abdomen',
          description: 'Parte del cuerpo entre el pecho y la pelvis.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Antebrazo',
          description: 'Parte del brazo entre el codo y la muñeca.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Cuádriceps',
          description: 'Músculos en la parte frontal del muslo.',
          onCardTap: _onCardTap),
      CardWidget(
          title: 'Tibial anterior',
          description: 'Músculo en la parte frontal de la espinilla.',
          onCardTap: _onCardTap),
    ].where((card) => cardTitles.contains(card.title)).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<SelectionNotifier>(
        builder: (context, notifier, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Adaptacion Anatomica',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AnatomicAdapt()),
                  );
                },
                icon: const Icon(Icons.close),
                label: Text(AppLocalizations.of(context)!.translate('show')),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 400,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: _getFilteredCards(notifier),
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
                          const SizedBox(height: 2),
                          Expanded(
                            child: ModelViewer(
                              backgroundColor:
                                  const Color.fromARGB(255, 50, 50, 50),
                              src: 'assets/tre_d/cuerpo07.glb',
                              alt: 'A 3D model of a Human Body',
                              ar: true,
                              autoRotate: false,
                              disableZoom: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          selectedCard.isNotEmpty
                              ? InfoCardWidget(
                                  title: selectedCard,
                                  onClose: () {
                                    setState(() {
                                      selectedCard = '';
                                    });
                                  },
                                  onNavigateToExercise: () {
                                    navigateToExerciseScreen(context, selectedCard);
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
