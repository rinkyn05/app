import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/animal_protein_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/alimentos/protein_vegetal_firestore.dart';
import '../../widgets/custom_appbar_new.dart';
import 'protein_detalle_screen.dart';

class ProteinaVegetalScreen extends StatefulWidget {
  const ProteinaVegetalScreen({Key? key}) : super(key: key);

  @override
  ProteinaVegetalScreenState createState() => ProteinaVegetalScreenState();
}

class ProteinaVegetalScreenState extends State<ProteinaVegetalScreen> {
  late Future<List<ProteinaAnimal>> _alimentosFuture;
  late String languageCode;
  bool _sortAscending = true;
  int _currentlySortedColumnIndex = 0;
  int _volume = 100;
  bool _isMuted = false;
  late YoutubePlayerController
      _controller; // Declarar como variable de instancia

  @override
  void initState() {
    super.initState();
    languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    _fetchAlimentos();
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false, // Deshabilitar subtítulos si es necesario
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String newLanguageCode =
        Provider.of<LanguageNotifier>(context, listen: false)
            .currentLocale
            .languageCode;
    if (newLanguageCode != languageCode) {
      languageCode = newLanguageCode;
      _fetchAlimentos();
      _sortByName();
    }
  }

  void _fetchAlimentos() {
    _alimentosFuture = ProteinVegetalFirestoreServices()
        .filterProteinaVegetal(languageCode)
        .then((alimentosList) => alimentosList.reversed.toList());
  }

  void _sortByName() {
    setState(() {
      _sortAscending = !_sortAscending;
      _alimentosFuture =
          _alimentosFuture.then((alimentosList) => alimentosList.toList()
            ..sort((a, b) {
              final int columnIndex = _currentlySortedColumnIndex;
              if (columnIndex == 0) {
                return _sortAscending
                    ? a.nombre.compareTo(b.nombre)
                    : b.nombre.compareTo(a.nombre);
              } else if (columnIndex == 1) {
                return _sortAscending
                    ? a.calorias.compareTo(b.calorias)
                    : b.calorias.compareTo(a.calorias);
              } else if (columnIndex == 2) {
                return _sortAscending
                    ? a.proteina.compareTo(b.proteina)
                    : b.proteina.compareTo(a.proteina);
              } else if (columnIndex == 3) {
                return _sortAscending
                    ? a.grasa.compareTo(b.grasa)
                    : b.grasa.compareTo(a.grasa);
              } else if (columnIndex == 4) {
                return _sortAscending
                    ? a.carbohidrato.compareTo(b.carbohidrato)
                    : b.carbohidrato.compareTo(a.carbohidrato);
              } else if (columnIndex == 5) {
                return _sortAscending
                    ? a.azucar.compareTo(b.azucar)
                    : b.azucar.compareTo(a.azucar);
              } else if (columnIndex == 6) {
                return _sortAscending
                    ? a.fibra.compareTo(b.fibra)
                    : b.fibra.compareTo(a.fibra);
              } else if (columnIndex == 7) {
                return _sortAscending
                    ? a.sodio.compareTo(b.sodio)
                    : b.sodio.compareTo(a.sodio);
              } else if (columnIndex == 8) {
                return _sortAscending
                    ? a.categoryEsp.compareTo(b.categoryEsp)
                    : b.categoryEsp.compareTo(a.categoryEsp);
              } else if (columnIndex == 9) {
                return _sortAscending
                    ? a.vitamina.compareTo(b.vitamina)
                    : b.vitamina.compareTo(a.vitamina);
              } else {
                return 0;
              }
            }));
    });
  }

  void navigateToAlimentosDetalleScreen(
      BuildContext context, ProteinaAnimal alimentos) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProteinDetalleScreen(
          alimentos: alimentos,
        ),
      ),
    );
  }

  void _toggleVolume() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = 100;
      } else {
        _isMuted = true;
        _volume = 0;
      }
      _controller.setVolume(_volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      "${AppLocalizations.of(context)!.translate('proteinVegetal')}",
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
                      IconButton(
                        icon:
                            Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
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
                      // Puedes agregar acciones personalizadas aquí si es necesario
                    ],
                    onReady: () {
                      debugPrint("Video is ready.");
                    },
                  ),
                ),
              ),
              SizedBox(height: 4),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<ProteinaAnimal>>(
                future: _alimentosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('errorLoadingFood'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate('noFoodFound'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  }

                  return Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: DataTable(
                          columnSpacing: 10,
                          dividerThickness: 4,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.adaptableColor(context),
                              width: 2,
                            ),
                            color: AppColors.adaptableColor2Inverse(context),
                          ),
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('name'),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _currentlySortedColumnIndex == 0
                                          ? (_sortAscending
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward)
                                          : Icons.arrow_upward,
                                      size: 18,
                                      color: AppColors.adaptableColor(context),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _currentlySortedColumnIndex = 0;
                                        _sortByName();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              tooltip: AppLocalizations.of(context)!
                                  .translate('name'),
                              onSort: (columnIndex, ascending) => _sortByName(),
                            ),
                          ],
                          rows: snapshot.data!.map((ProteinaAnimal) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    ProteinaAnimal.nombre,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    softWrap: true,
                                  ),
                                  onTap: () => navigateToAlimentosDetalleScreen(
                                      context, ProteinaAnimal),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 2,
                            dividerThickness: 4,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.adaptableColor(context),
                                width: 2,
                              ),
                              color: AppColors.adaptableColor2Inverse(context),
                            ),
                            columns: [
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('calories'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 1
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 1;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('calories'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('protein'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 2
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 2;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('protein'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('totalFats'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 3
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 3;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('totalFats'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('carbohydrates'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 4
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 4;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('carbohydrates'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('sugar'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 5
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 5;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('sugar'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('fiber'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 6
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 6;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('fiber'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('sodio'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 7
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 7;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('sodio'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('category'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 8
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 8;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('category'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                              DataColumn(
                                label: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('vitamins/Minerals'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _currentlySortedColumnIndex == 9
                                            ? (_sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                            : Icons.arrow_upward,
                                        size: 18,
                                        color:
                                            AppColors.adaptableColor(context),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _currentlySortedColumnIndex = 9;
                                          _sortByName();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                tooltip: AppLocalizations.of(context)!
                                    .translate('vitamins/Minerals'),
                                onSort: (columnIndex, ascending) =>
                                    _sortByName(),
                              ),
                            ],
                            rows: snapshot.data!.map((ProteinaAnimal) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.calorias}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.proteina}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.grasa}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.carbohidrato}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.azucar}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.fibra}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.sodio}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.categoryEsp}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                  DataCell(
                                    Text(
                                      '${ProteinaAnimal.vitamina}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () =>
                                        navigateToAlimentosDetalleScreen(
                                            context, ProteinaAnimal),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
