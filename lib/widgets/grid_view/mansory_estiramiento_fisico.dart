import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/notifiers/selected_notifier.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../filtros/estiramiento_fisico/estiramiento_fisico_filter_screen.dart';
import '../../filtros/widgets/BodyPartDropdownWidget.dart';
import '../../filtros/widgets/EstiramientoEspecificoDropdownWidget.dart';
import '../../filtros/widgets/EquipmentDropdownWidget.dart';
import '../../filtros/widgets/ObjetivosDropdownWidget.dart';

class MasonryEstiramientoFisico extends StatefulWidget {
  const MasonryEstiramientoFisico({Key? key}) : super(key: key);

  @override
  _MasonryEstiramientoFisicoState createState() =>
      _MasonryEstiramientoFisicoState();
}

class _MasonryEstiramientoFisicoState extends State<MasonryEstiramientoFisico> {
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _filterEstiramientosByQuery(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  // En tu widget principal
  void _showEstiramientoFisicoFilterDialog() {
    // Redirigir a FilterScreen sin lógica adicional
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstiramientoFisicoFilterScreen(
            onFilterApplied: (
              SelectedBodyPart? selectedBodyPart,
              SelectedEstiramientoEspecifico? selectedEstiramientoEspecifico,
              SelectedEquipment? selectedEquipment,
              SelectedObjetivos? selectedObjetivos,
              String? selectedDifficulty,
              String? selectedIntensity,
              String? selectedMembership,
              String? selectedImpactLevel,
              String? selectedPostura,
            ) {
              // Aquí no hace falta lógica extra
            },
            onBodyPartSelectionChanged: (SelectedBodyPart selectedBodyPart) {},
            onEstiramientoSelectionChanged: (SelectedEstiramientoEspecifico
                selectedEstiramientoEspecifico) {},
            onEquipmentSelectionChanged:
                (SelectedEquipment selectedEquipment) {},
            onObjetivosSelectionChanged:
                (SelectedObjetivos selectedObjetivos) {},
            onDifficultySelectionChanged: (String selectedDifficulty) {},
            onIntensitySelectionChanged: (String selectedIntensity) {},
            onMembershipSelectionChanged: (String? selectedMembership) {},
            onImpactLevelSelectionChanged: (String? selectedImpactLevel) {},
            onPosturaSelectionChanged: (String? selectedPostura) {},
          ),
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

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
                  controller: _controller,
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
                              _filterEstiramientosByQuery(
                                  _searchController.text);
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
                    onPressed: _showEstiramientoFisicoFilterDialog,
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
                  .collection('estiramientoFisico')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final estiramientosFisicos = snapshot.data!.docs;

                  final filteredEstiramientos =
                      estiramientosFisicos.where((estiramiento) {
                    String nombre =
                        estiramiento[searchField].toString().toLowerCase();
                    return _searchQuery.isEmpty ||
                        nombre.contains(_searchQuery);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          (filteredEstiramientos.length / 3).ceil(),
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              3,
                              (i) =>
                                  i + index * 3 < filteredEstiramientos.length
                                      ? _buildIconItem(
                                          context,
                                          filteredEstiramientos[i + index * 3],
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

  Widget _buildIconItem(
    BuildContext context,
    DocumentSnapshot estiramientoFisico,
    SelectedItemsNotifier notifier,
  ) {
    String? imageUrl = estiramientoFisico['URL de la Imagen'];
    String nombre = estiramientoFisico['NombreEsp'] ?? 'Nombre no encontrado';
    bool isPremium = estiramientoFisico['MembershipEng'] == 'Premium';

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
