import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/calentamiento_fisico_in_ejercicio_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/ejercicios/calentamiento_fisico_in_ejercicio_functions.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../config/notifiers/selected_notifier.dart';
import '../calentamiento_fisico/calentamiento_fisico_screen.dart';
import '../estiramiento_fisico/estiramiento_fisico_screen.dart';

class AnatAadaptPlanCreator extends StatefulWidget {
  const AnatAadaptPlanCreator({Key? key}) : super(key: key);

  @override
  State<AnatAadaptPlanCreator> createState() => _AnatAadaptPlanCreatorState();
}

class _AnatAadaptPlanCreatorState extends State<AnatAadaptPlanCreator> {
  final List<SelectedCalentamientoFisico> _selectedCalentamientoFisico = [];
  Map<String, Map<String, String>> calentamientoFisicoNames = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Widget _buildEstiramientoEstaticoButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CalentamientoFisicoScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.gdarkblue2,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            textStyle: Theme.of(context).textTheme.labelMedium,
          ),
          child: const Text('Calentamiento Fisico'),
        ),
        const SizedBox(height: 6),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EstiramientoFisicoScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.gdarkblue2,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            textStyle: Theme.of(context).textTheme.labelMedium,
          ),
          child: const Text('Estiramiento Fisico'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCalentamientoFisicoNames();
  }

  void _loadCalentamientoFisicoNames() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('calentamientoFisico')
        .get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      calentamientoFisicoNames = tempMap;
    });
  }

  void _addCalentamientoFisico(String calentamientoFisicoId) {
    if (!_selectedCalentamientoFisico
        .any((selected) => selected.id == calentamientoFisicoId)) {
      String calentamientoFisicoEsp =
          calentamientoFisicoNames[calentamientoFisicoId]?['Esp'] ??
              'Nombre no disponible';
      String calentamientoFisicoEng =
          calentamientoFisicoNames[calentamientoFisicoId]?['Eng'] ??
              'Nombre no disponible';
      setState(() {
        _selectedCalentamientoFisico.add(SelectedCalentamientoFisico(
          id: calentamientoFisicoId,
          calentamientoFisicoEsp: calentamientoFisicoEsp,
          calentamientoFisicoEng: calentamientoFisicoEng,
        ));
      });

      Provider.of<SelectedItemsNotifier>(context, listen: false).addSelection(calentamientoFisicoEsp);
      Provider.of<SelectedItemsNotifier>(context, listen: false).addSelection(calentamientoFisicoEng);
    }
  }

  void _removeCalentamientoFisico(String calentamientoFisicoId) {
    String? calentamientoFisicoEsp;
    String? calentamientoFisicoEng;
    _selectedCalentamientoFisico.removeWhere((calentamientoFisico) {
      if (calentamientoFisico.id == calentamientoFisicoId) {
        calentamientoFisicoEsp = calentamientoFisico.calentamientoFisicoEsp;
        calentamientoFisicoEng = calentamientoFisico.calentamientoFisicoEng;
      }
      return calentamientoFisico.id == calentamientoFisicoId;
    });

    setState(() {});

    if (calentamientoFisicoEsp != null) {
      Provider.of<SelectedItemsNotifier>(context, listen: false).removeSelection(calentamientoFisicoEsp!);
      Provider.of<SelectedItemsNotifier>(context, listen: false).removeSelection(calentamientoFisicoEng!);
    }
  }

  Widget _buildSelectedCalentamientoFisico(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.translate('calentamientoFisico'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedCalentamientoFisico.map((calentamientoFisico) {
            String calentamientoFisicoName = langKey == 'es'
                ? calentamientoFisico.calentamientoFisicoEsp
                : calentamientoFisico.calentamientoFisicoEng;
            return Chip(
              label: Text(calentamientoFisicoName),
              onDeleted: () =>
                  _removeCalentamientoFisico(calentamientoFisico.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String langKey = Localizations.localeOf(context).languageCode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'Plan de Entrenamiento',
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
            const SizedBox(height: 8),
            _buildEstiramientoEstaticoButtons(),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildSelectedCalentamientoFisico(langKey),
                    FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: CalentamientoFisicoInEjercicioFunctions()
                          .getSimplifiedCalentamientoFisico(
                              langKey == 'es' ? 'NombreEsp' : 'NombreEng'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text(
                              'No se encontraron calentamientos físicos');
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.lightBlueAccentColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('selectCalentamientoFisico'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(AppLocalizations.of(context)!
                                        .translate(
                                            'selectCalentamientoFisico')),
                                    onChanged: (String? newValue) {
                                      _addCalentamientoFisico(newValue!);
                                    },
                                    items: snapshot.data,
                                    value: _selectedCalentamientoFisico
                                            .isNotEmpty
                                        ? _selectedCalentamientoFisico.first.id
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
