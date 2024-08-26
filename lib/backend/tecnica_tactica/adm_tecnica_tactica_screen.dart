import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/role_checker.dart';
import '../../functions/tecnica_tactica/tecnica_tactica_details_functions.dart';
import '../../functions/tecnica_tactica/tecnica_tatica_firestore_service.dart';
import '../admin/admin_start_screen.dart';
import 'add_tecnica_tactica_screen.dart';
import 'edit_tecnica_tactica_screen.dart';

class AdmTenicaTacticaScreen extends StatefulWidget {
  const AdmTenicaTacticaScreen({Key? key}) : super(key: key);

  @override
  AdmTenicaTacticaScreenState createState() =>
      AdmTenicaTacticaScreenState();
}

class AdmTenicaTacticaScreenState
    extends State<AdmTenicaTacticaScreen> {
  late Future<List<Map<String, dynamic>>> _tenicaTacticaFuture;
  final Set<String> _selectedTenicaTacticaIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> tenicaTactica = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _tenicaTacticaFuture = TenicaTacticaFirestoreService()
          .getTenicaTactica(Localizations.localeOf(context));
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
              'addTenicaTactica',
              _navigateToAddTenicaTacticaScreen,
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
              future: _tenicaTacticaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingTenicaTactica'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  tenicaTactica = snapshot.data!;
                  return _buildTenicaTacticaGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noTenicaTacticaFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedTenicaTacticaIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedTenicaTactica,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteTenicaTactica'),
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

  Widget _buildTenicaTacticaGrid(
      List<Map<String, dynamic>> tenicaTactica) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: tenicaTactica.map((tenicaTactica) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildTenicaTacticaCard(tenicaTactica),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTenicaTacticaCard(
      Map<String, dynamic> tenicaTactica) {
    var theme = Theme.of(context);
    bool isSelected =
        _selectedTenicaTacticaIds.contains(tenicaTactica['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedTenicaTacticaIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedTenicaTacticaIds.remove(tenicaTactica['id']);
            } else {
              _selectedTenicaTacticaIds.add(tenicaTactica['id']);
            }
          });
        } else {
          _navigateToEditScreen(tenicaTactica['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedTenicaTacticaIds.add(tenicaTactica['id']);
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
                child: tenicaTactica['URL de la Imagen'] != null &&
                        tenicaTactica['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        tenicaTactica['URL de la Imagen'],
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
            Text(tenicaTactica['Nombre'],
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

  void _navigateToAddTenicaTacticaScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddTenicaTacticaScreen()),
    );
    if (result == true) {
      _reloadTenicaTactica();
    }
  }

  void _navigateToEditScreen(String tenicaTacticaId) async {
    var tenicaTacticaDetails = await TenicaTacticaDetailsFunctions()
        .getTenicaTacticaDetails(tenicaTacticaId);
    if (tenicaTacticaDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTenicaTacticaScreen(
              tenicaTacticaId: tenicaTacticaId,
              tenicaTacticaData: tenicaTacticaDetails),
        ),
      );
      if (result == true) {
        _reloadTenicaTactica();
      }
    }
  }

  void _reloadTenicaTactica() {
    setState(() {
      _tenicaTacticaFuture = TenicaTacticaFirestoreService()
          .getTenicaTactica(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedTenicaTactica() {
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
                for (String tenicaTacticaId
                    in _selectedTenicaTacticaIds) {
                  await TenicaTacticaFirestoreService()
                      .deleteTenicaTactica(tenicaTacticaId);
                }
                setState(() {
                  _selectedTenicaTacticaIds.clear();
                });
                _reloadTenicaTactica();
              },
            ),
          ],
        );
      },
    );
  }
}
