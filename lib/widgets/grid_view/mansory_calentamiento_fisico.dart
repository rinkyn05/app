import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/selected_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../filtros/calentamiento_fisico/calentamiento_fisico_filter_screen.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/CalentamientoEspecificoDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';
import '../../filtros/widgets/SportsDropdownWidget.dart.dart';

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
  void _showCalentamientoFisicoFilterDialog() {
    // Redirigir a FilterScreen sin lógica adicional
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalentamientoFisicoFilterScreen(
            onFilterApplied: (
              SelectedBodyPart? selectedBodyPart,
              SelectedCalentamientoEspecifico? selectedCalentamientoEspecifico,
              SelectedEquipment? selectedEquipment,
              SelectedObjetivos? selectedObjetivos,
              String? selectedDifficulty,
              String? selectedIntensity,
              String? selectedMembership,
              String? selectedImpactLevel,
              String? selectedPostura,
              List<SelectedSports>? selectedSports,
            ) {
              // Aquí no hace falta lógica extra
            },
            onBodyPartSelectionChanged: (SelectedBodyPart selectedBodyPart) {},
            onCalentamientoSelectionChanged: (SelectedCalentamientoEspecifico
                selectedCalentamientoEspecifico) {},
            onEquipmentSelectionChanged:
                (SelectedEquipment selectedEquipment) {},
            onObjetivosSelectionChanged:
                (SelectedObjetivos selectedObjetivos) {},
            onDifficultySelectionChanged: (String selectedDifficulty) {},
            onIntensitySelectionChanged: (String selectedIntensity) {},
            onMembershipSelectionChanged: (String? selectedMembership) {},
            onImpactLevelSelectionChanged: (String? selectedImpactLevel) {},
            onPosturaSelectionChanged: (String? selectedPostura) {},
            onSportsSelectionChanged: (List<SelectedSports> selectedSports) {},
          ),
        ));
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
                    onPressed: _showCalentamientoFisicoFilterDialog,
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
      child: SizedBox(
        width: 120, // Tamaño fijo para el ancho del ítem
        height: 160, // Tamaño fijo para la altura del ítem
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          )
                        : Icon(Icons.error, size: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      nombre,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                      softWrap: true, // Permite el salto de línea
                      overflow: TextOverflow.visible, // Evita cortar el texto
                      maxLines: 2, // Máximo de 2 líneas
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.lock,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
