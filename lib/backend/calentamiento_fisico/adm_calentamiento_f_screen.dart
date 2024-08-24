import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/calentamiento_fisico/calentamiento_fisico_details_functions.dart';
import '../../functions/calentamiento_fisico/calentaminto_fisico_firestore_service.dart';
import '../../functions/role_checker.dart';
import '../admin/admin_start_screen.dart';
import 'add_calentameinto_f_screen.dart';
import 'edit_calentamiento_f_screen.dart';

class AdmCalentamientoFisicoScreen extends StatefulWidget {
  const AdmCalentamientoFisicoScreen({Key? key}) : super(key: key);

  @override
  AdmCalentamientoFisicoScreenState createState() =>
      AdmCalentamientoFisicoScreenState();
}

class AdmCalentamientoFisicoScreenState
    extends State<AdmCalentamientoFisicoScreen> {
  late Future<List<Map<String, dynamic>>> _calentamientoFisicoFuture;
  final Set<String> _selectedCalentamientoFisicoIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> calentamientoFisico = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _calentamientoFisicoFuture = CalentamientoFisicoFirestoreService()
          .getCalentamientoFisico(Localizations.localeOf(context));
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
            AppLocalizations.of(context)!.translate('calentamientoFisico')),
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
              'addCalentamientoFisico',
              _navigateToAddCalentamientoFisicoScreen,
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
              future: _calentamientoFisicoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingCalentamientoFisico'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  calentamientoFisico = snapshot.data!;
                  return _buildCalentamientoFisicoGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noCalentamientoFisicoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedCalentamientoFisicoIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedCalentamientoFisico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteCalentamientoFisico'),
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

  Widget _buildCalentamientoFisicoGrid(
      List<Map<String, dynamic>> calentamientoFisico) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: calentamientoFisico.map((calentamientoFisico) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildCalentamientoFisicoCard(calentamientoFisico),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalentamientoFisicoCard(
      Map<String, dynamic> calentamientoFisico) {
    var theme = Theme.of(context);
    bool isSelected =
        _selectedCalentamientoFisicoIds.contains(calentamientoFisico['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedCalentamientoFisicoIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedCalentamientoFisicoIds.remove(calentamientoFisico['id']);
            } else {
              _selectedCalentamientoFisicoIds.add(calentamientoFisico['id']);
            }
          });
        } else {
          _navigateToEditScreen(calentamientoFisico['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedCalentamientoFisicoIds.add(calentamientoFisico['id']);
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
                child: calentamientoFisico['URL de la Imagen'] != null &&
                        calentamientoFisico['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        calentamientoFisico['URL de la Imagen'],
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
            Text(calentamientoFisico['Nombre'],
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

  void _navigateToAddCalentamientoFisicoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddCalentamientoFisicoScreen()),
    );
    if (result == true) {
      _reloadCalentamientoFisico();
    }
  }

  void _navigateToEditScreen(String calentamientoFisicoId) async {
    var calentamientoFisicoDetails = await CalentamientoFisicoDetailsFunctions()
        .getCalentamientoFisicoDetails(calentamientoFisicoId);
    if (calentamientoFisicoDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditCalentamientoFisicoScreen(
              calentamientoFisicoId: calentamientoFisicoId,
              calentamientoFisicoData: calentamientoFisicoDetails),
        ),
      );
      if (result == true) {
        _reloadCalentamientoFisico();
      }
    }
  }

  void _reloadCalentamientoFisico() {
    setState(() {
      _calentamientoFisicoFuture = CalentamientoFisicoFirestoreService()
          .getCalentamientoFisico(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedCalentamientoFisico() {
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
                for (String calentamientoFisicoId
                    in _selectedCalentamientoFisicoIds) {
                  await CalentamientoFisicoFirestoreService()
                      .deleteCalentamientoFisico(calentamientoFisicoId);
                }
                setState(() {
                  _selectedCalentamientoFisicoIds.clear();
                });
                _reloadCalentamientoFisico();
              },
            ),
          ],
        );
      },
    );
  }
}
