import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/mej_prev_lesiones/mej_prev_les_details_functions.dart';
import '../../functions/mej_prev_lesiones/mej_prev_les_firestore_service.dart';
import '../../functions/role_checker.dart';
import '../admin/admin_start_screen.dart';
import 'add_mej_prev_les_screen.dart';
import 'edit_mej_prev_les_screen.dart';

class AdmMejPreLesionesScreen extends StatefulWidget {
  const AdmMejPreLesionesScreen({Key? key}) : super(key: key);

  @override
  AdmMejPreLesionesScreenState createState() =>
      AdmMejPreLesionesScreenState();
}

class AdmMejPreLesionesScreenState
    extends State<AdmMejPreLesionesScreen> {
  late Future<List<Map<String, dynamic>>> _mejPreLesionesFuture;
  final Set<String> _selectedMejPreLesionesIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> mejPreLesiones = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _mejPreLesionesFuture = MejPreLesionesFirestoreService()
          .getMejPreLesiones(Localizations.localeOf(context));
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
            AppLocalizations.of(context)!.translate('tecnica/tactica')),
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
              'addMejPreLesiones',
              _navigateToAddMejPreLesionesScreen,
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
              future: _mejPreLesionesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingMejPreLesiones'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  mejPreLesiones = snapshot.data!;
                  return _buildMejPreLesionesGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noMejPreLesionesFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedMejPreLesionesIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedMejPreLesiones,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteMejPreLesiones'),
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

  Widget _buildMejPreLesionesGrid(
      List<Map<String, dynamic>> mejPreLesiones) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: mejPreLesiones.map((mejPreLesiones) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildMejPreLesionesCard(mejPreLesiones),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMejPreLesionesCard(
      Map<String, dynamic> mejPreLesiones) {
    var theme = Theme.of(context);
    bool isSelected =
        _selectedMejPreLesionesIds.contains(mejPreLesiones['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedMejPreLesionesIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedMejPreLesionesIds.remove(mejPreLesiones['id']);
            } else {
              _selectedMejPreLesionesIds.add(mejPreLesiones['id']);
            }
          });
        } else {
          _navigateToEditScreen(mejPreLesiones['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedMejPreLesionesIds.add(mejPreLesiones['id']);
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
                child: mejPreLesiones['URL de la Imagen'] != null &&
                        mejPreLesiones['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        mejPreLesiones['URL de la Imagen'],
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
            Text(mejPreLesiones['Nombre'],
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

  void _navigateToAddMejPreLesionesScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddMejPreLesionesScreen()),
    );
    if (result == true) {
      _reloadMejPreLesiones();
    }
  }

  void _navigateToEditScreen(String mejPreLesionesId) async {
    var mejPreLesionesDetails = await MejPreLesionesDetailsFunctions()
        .getMejPreLesionesDetails(mejPreLesionesId);
    if (mejPreLesionesDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditMejPreLesionesScreen(
              mejPreLesionesId: mejPreLesionesId,
              mejPreLesionesData: mejPreLesionesDetails),
        ),
      );
      if (result == true) {
        _reloadMejPreLesiones();
      }
    }
  }

  void _reloadMejPreLesiones() {
    setState(() {
      _mejPreLesionesFuture = MejPreLesionesFirestoreService()
          .getMejPreLesiones(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedMejPreLesiones() {
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
                for (String mejPreLesionesId
                    in _selectedMejPreLesionesIds) {
                  await MejPreLesionesFirestoreService()
                      .deleteMejPreLesiones(mejPreLesionesId);
                }
                setState(() {
                  _selectedMejPreLesionesIds.clear();
                });
                _reloadMejPreLesiones();
              },
            ),
          ],
        );
      },
    );
  }
}
