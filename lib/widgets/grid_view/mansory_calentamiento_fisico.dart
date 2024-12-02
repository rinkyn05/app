import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/notifiers/selected_notifier.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../filtros/filter_dialog.dart';

class MasonryCalentamientoFisico extends StatefulWidget {
  const MasonryCalentamientoFisico({Key? key}) : super(key: key);

  @override
  _MasonryCalentamientoFisicoState createState() =>
      _MasonryCalentamientoFisicoState();
}

class _MasonryCalentamientoFisicoState
    extends State<MasonryCalentamientoFisico> {
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  late YoutubePlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _filterBySearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  // En tu widget principal
void _showFilterDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FilterDialog(
        onFilterApplied: (
          String? selectedBodyPart,
          String? selectedCalentamiento,
          String? selectedEquipment,
          String? selectedImpactLevel,
          String? selectedPosture,
          String? selectedDificulty,
          String? selectedObjective,
          String? selectedIntensity,
          String? selectedMembership,
        ) {
          // Imprime las selecciones
          print('BodyPart: $selectedBodyPart');
          print('Calentamiento: $selectedCalentamiento');
          print('Equipment: $selectedEquipment');
          print('Impact Level: $selectedImpactLevel');
          print('Posture: $selectedPosture');
          print('Dificulty: $selectedDificulty');
          print('Objective: $selectedObjective');
          print('Intensity: $selectedIntensity');
          print('Membership: $selectedMembership');
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    // Detecta el idioma de la app
    Locale locale = Localizations.localeOf(context);
    String searchField =
        locale.languageCode == 'es' ? 'NombreEsp' : 'NombreEng';

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4.0,
                    color: AppColors.adaptableColor(context),
                  ),
                ),
                child: YoutubePlayer(
                  controller: _videoController,
                  showVideoProgressIndicator: true,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: AppColors.adaptableColor(context),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .translate('search'),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _filterBySearchQuery(_searchController.text);
                            },
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterDialog,
                    icon: Icon(
                      Icons.filter_list,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('calentamientoFisico')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final calentamientosFisicos = snapshot.data!.docs;

                  final filteredCalentamientos =
                      calentamientosFisicos.where((calentamiento) {
                    String nombre =
                        calentamiento[searchField].toString().toLowerCase();
                    return _searchQuery.isEmpty ||
                        nombre.contains(_searchQuery);
                  }).toList();

                  String resultadosEncontrados = AppLocalizations.of(context)!
                          .translate('se_encontraron') +
                      ": ${filteredCalentamientos.length}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          resultadosEncontrados,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          (filteredCalentamientos.length / 3).ceil(),
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              3,
                              (i) =>
                                  i + index * 3 < filteredCalentamientos.length
                                      ? _buildIconItem(
                                          context,
                                          filteredCalentamientos[i + index * 3],
                                          selectedItemsNotifier,
                                        )
                                      : SizedBox(width: 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context,
      DocumentSnapshot calentamientoFisico, SelectedItemsNotifier notifier) {
    String? imageUrl = calentamientoFisico['URL de la Imagen'];
    String nombre = calentamientoFisico['NombreEsp'] ?? 'Nombre no encontrado';
    bool isPremium = calentamientoFisico['MembershipEng'] == 'Premium';

    bool isSelected = notifier.selectedItems.contains(nombre);

    return GestureDetector(
      onTap: () {
        notifier.toggleSelection(nombre);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        )
                      : Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    nombre,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned.fill(
                child: Container(
                  color: Colors.blue.withOpacity(0.5),
                ),
              ),
            if (isPremium)
              Positioned.fill(
                child: Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
