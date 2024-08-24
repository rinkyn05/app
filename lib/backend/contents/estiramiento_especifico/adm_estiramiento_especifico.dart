// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/estiramiento_especifico/estiramiento_especifico_details_functions.dart';
import '../../../functions/contents/estiramiento_especifico/show_estiramiento_especifico_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_estiramiento_especifico.dart';
import 'edit_estiramiento_especifico.dart';

class AdmEstiramientoEspecificoScreen extends StatefulWidget {
  const AdmEstiramientoEspecificoScreen({Key? key}) : super(key: key);

  @override
  AdmEstiramientoEspecificoScreenState createState() =>
      AdmEstiramientoEspecificoScreenState();
}

class AdmEstiramientoEspecificoScreenState
    extends State<AdmEstiramientoEspecificoScreen> {
  late Future<List<Map<String, dynamic>>> _estiramientoEspecificosFuture;
  final Set<int> _selectedEstiramientoEspecificos = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> estiramientoEspecificos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _estiramientoEspecificosFuture =
          EstiramientoEspecificoFirestoreService()
              .getEstiramientoEspecificos(Localizations.localeOf(context));
      _isInit = false;
    }
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    bool hasAccess = await checkUserRole();
    if (!hasAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showAccessDeniedDialog(context);
        }
      });
    }
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.translate('accessDeniedTitle')),
          content: Text(
              AppLocalizations.of(context)!.translate('accessDeniedMessage')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.translate('okButton')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('estiramientoEspecifico')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AdminStartScreen(nombre: '', rol: '')),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCustomButton(
              context,
              'addEstiramientoEspecifico',
              _navigateToAddEstiramientoEspecificoScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate('searchEstiramientoEspecifico'),
                labelStyle: Theme.of(context).textTheme.titleSmall,
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _estiramientoEspecificosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingEstiramientoEspecifico'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  estiramientoEspecificos = snapshot.data!;
                  return _buildEstiramientoEspecificosGrid(
                      estiramientoEspecificos);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noEstiramientoEspecificoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedEstiramientoEspecificos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedEstiramientoEspecificos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteEstiramientoEspecifico'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEstiramientoEspecificosGrid(
      List<Map<String, dynamic>> estiramientoEspecificos) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: estiramientoEspecificos.map((estiramientoEspecifico) {
            int index =
                estiramientoEspecificos.indexOf(estiramientoEspecifico);
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildEstiramientoEspecificoCard(
                  index, estiramientoEspecifico),
            );
          }).toList(),
        ));
  }

  Widget _buildEstiramientoEspecificoCard(
      int index, Map<String, dynamic> estiramientoEspecifico) {
    var theme = Theme.of(context);
    bool isSelected = _selectedEstiramientoEspecificos.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedEstiramientoEspecificos.isNotEmpty) {
          _selectEstiramientoEspecifico(index);
        } else {
          _navigateToEditEstiramientoEspecificoScreen(index);
        }
      },
      onLongPress: () => _selectEstiramientoEspecifico(index),
      child: Card(
        color: isSelected
            ? theme.colorScheme.secondary.withOpacity(0.5)
            : theme.cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: estiramientoEspecifico['URL de la Imagen'] != null &&
                        estiramientoEspecifico['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        estiramientoEspecifico['URL de la Imagen'],
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          "No está disponible",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                estiramientoEspecifico['Nombre'] != null &&
                        estiramientoEspecifico['Nombre'].isNotEmpty
                    ? estiramientoEspecifico['Nombre']
                    : "No está disponible",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context, String translationKey, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        AppLocalizations.of(context)!.translate(translationKey),
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightBlueAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _navigateToEditEstiramientoEspecificoScreen(int index) async {
    if (_selectedEstiramientoEspecificos.isEmpty) {
      String estiramientoEspecificoId =
          estiramientoEspecificos[index]['id'].toString();
      var estiramientoEspecificoDetails =
          await EstiramientoEspecificoDetailsFunctions()
              .getEstiramientoEspecificoDetails(estiramientoEspecificoId);
      if (estiramientoEspecificoDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditEstiramientoEspecificoScreen(
                  estiramientoEspecifico: estiramientoEspecificoDetails)),
        );
        if (result == true) {
          _reloadEstiramientoEspecificos();
        }
      } else {}
    } else {
      _selectEstiramientoEspecifico(index);
    }
  }

  void _selectEstiramientoEspecifico(int index) {
    setState(() {
      if (_selectedEstiramientoEspecificos.contains(index)) {
        _selectedEstiramientoEspecificos.remove(index);
      } else {
        _selectedEstiramientoEspecificos.add(index);
      }
    });
  }

  void _navigateToAddEstiramientoEspecificoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddEstiramientoEspecificoScreen()),
    );
    if (result == true) {
      _reloadEstiramientoEspecificos();
    }
  }

  void _reloadEstiramientoEspecificos() {
    setState(() {
      _estiramientoEspecificosFuture =
          EstiramientoEspecificoFirestoreService()
              .getEstiramientoEspecificos(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedEstiramientoEspecificos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.translate('confirmDeletion')),
          content: Text(
              AppLocalizations.of(context)!.translate('areYouSureToDelete')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('no')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('yes')),
              onPressed: () async {
                Navigator.of(context).pop();
                for (int index in _selectedEstiramientoEspecificos) {
                  String estiramientoEspecificoId =
                      estiramientoEspecificos[index]['id'].toString();
                  await EstiramientoEspecificoFirestoreService()
                      .deleteEstiramientoEspecifico(estiramientoEspecificoId);
                }
                setState(() {
                  _selectedEstiramientoEspecificos.clear();
                });
                _reloadEstiramientoEspecificos();
              },
            ),
          ],
        );
      },
    );
  }
}
