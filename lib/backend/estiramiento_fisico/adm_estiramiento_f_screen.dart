import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/estiramiento_fisico/estiramiento_fisico_details_functions.dart';
import '../../functions/estiramiento_fisico/estiramiento_fisico_firestore_service.dart';
import '../../functions/role_checker.dart';
import '../admin/admin_start_screen.dart';
import 'add_estirameinto_f_screen.dart';
import 'edit_calentamiento_f_screen.dart';

class AdmEstiramientoFisicoScreen extends StatefulWidget {
  const AdmEstiramientoFisicoScreen({Key? key}) : super(key: key);

  @override
  AdmEstiramientoFisicoScreenState createState() =>
      AdmEstiramientoFisicoScreenState();
}

class AdmEstiramientoFisicoScreenState
    extends State<AdmEstiramientoFisicoScreen> {
  late Future<List<Map<String, dynamic>>> _estiramientoFisicoFuture;
  final Set<String> _selectedEstiramientoFisicoIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> estiramientoFisico = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _estiramientoFisicoFuture = EstiramientoFisicoFirestoreService()
          .getEstiramientoFisico(Localizations.localeOf(context));
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
            AppLocalizations.of(context)!.translate('estiramientoFisico')),
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
              'addEstiramientoFisico',
              _navigateToAddEstiramientoFisicoScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('search'),
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
              future: _estiramientoFisicoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingEstiramientoFisico'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  estiramientoFisico = snapshot.data!;
                  return _buildEstiramientoFisicoGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noEstiramientoFisicoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedEstiramientoFisicoIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedEstiramientoFisico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteEstiramientoFisico'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEstiramientoFisicoGrid(
      List<Map<String, dynamic>> estiramientoFisico) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: estiramientoFisico.map((estiramientoFisico) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildEstiramientoFisicoCard(estiramientoFisico),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEstiramientoFisicoCard(
      Map<String, dynamic> estiramientoFisico) {
    var theme = Theme.of(context);
    bool isSelected =
        _selectedEstiramientoFisicoIds.contains(estiramientoFisico['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedEstiramientoFisicoIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedEstiramientoFisicoIds.remove(estiramientoFisico['id']);
            } else {
              _selectedEstiramientoFisicoIds.add(estiramientoFisico['id']);
            }
          });
        } else {
          _navigateToEditScreen(estiramientoFisico['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedEstiramientoFisicoIds.add(estiramientoFisico['id']);
        });
      },
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
                child: estiramientoFisico['URL de la Imagen'] != null &&
                        estiramientoFisico['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        estiramientoFisico['URL de la Imagen'],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: Text(
                          'Imagen no disponible',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            Text(estiramientoFisico['Nombre'],
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium),
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

  void _navigateToAddEstiramientoFisicoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddEstiramientoFisicoScreen()),
    );
    if (result == true) {
      _reloadEstiramientoFisico();
    }
  }

  void _navigateToEditScreen(String estiramientoFisicoId) async {
    var estiramientoFisicoDetails = await EstiramientoFisicoDetailsFunctions()
        .getEstiramientoFisicoDetails(estiramientoFisicoId);
    if (estiramientoFisicoDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditEstiramientoFisicoScreen(
              estiramientoFisicoId: estiramientoFisicoId,
              estiramientoFisicoData: estiramientoFisicoDetails),
        ),
      );
      if (result == true) {
        _reloadEstiramientoFisico();
      }
    }
  }

  void _reloadEstiramientoFisico() {
    setState(() {
      _estiramientoFisicoFuture = EstiramientoFisicoFirestoreService()
          .getEstiramientoFisico(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedEstiramientoFisico() {
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
                for (String estiramientoFisicoId
                    in _selectedEstiramientoFisicoIds) {
                  await EstiramientoFisicoFirestoreService()
                      .deleteEstiramientoFisico(estiramientoFisicoId);
                }
                setState(() {
                  _selectedEstiramientoFisicoIds.clear();
                });
                _reloadEstiramientoFisico();
              },
            ),
          ],
        );
      },
    );
  }
}
