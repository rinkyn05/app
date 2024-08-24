// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/alimentos/alimentos_details_functions.dart';
import '../../functions/alimentos/alimentos_firestore_service.dart';
import '../../functions/role_checker.dart';
import 'add_alimentos_screen.dart';
import 'edit_alimentos_screen.dart';

class AdmAlimentosScreen extends StatefulWidget {
  const AdmAlimentosScreen({Key? key}) : super(key: key);

  @override
  AdmAlimentosScreenState createState() => AdmAlimentosScreenState();
}

class AdmAlimentosScreenState extends State<AdmAlimentosScreen> {
  late Future<List<Map<String, dynamic>>> _alimentosFuture;
  final Set<String> _selectedAlimentosIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> alimentos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _alimentosFuture = AlimentosFirestoreService()
          .getAlimentos(Localizations.localeOf(context));
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCustomButton(
              context,
              'addAlimento',
              _navigateToAddAlimentosScreen,
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
              future: _alimentosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingAlimentos'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  alimentos = snapshot.data!;
                  return _buildAlimentosGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noAlimentosFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedAlimentosIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedAlimentos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteAlimento'),
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

  Widget _buildAlimentosGrid(List<Map<String, dynamic>> alimentos) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: alimentos.map((alimentos) {
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildAlimentosCard(alimentos),
            );
          }).toList(),
        ));
  }

  Widget _buildAlimentosCard(Map<String, dynamic> alimentos) {
    var theme = Theme.of(context);
    bool isSelected = _selectedAlimentosIds.contains(alimentos['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedAlimentosIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedAlimentosIds.remove(alimentos['id']);
            } else {
              _selectedAlimentosIds.add(alimentos['id']);
            }
          });
        } else {
          _navigateToEditScreen(alimentos['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedAlimentosIds.add(alimentos['id']);
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
                child: Image.network(alimentos['URL de la Imagen'],
                    fit: BoxFit.cover),
              ),
            ),
            Text(alimentos['Nombre'],
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

  void _navigateToAddAlimentosScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAlimentosScreen()),
    );
    if (result == true) {
      _reloadAlimentos();
    }
  }

  void _navigateToEditScreen(String alimentosId) async {
    var alimentosDetails =
        await AlimentosDetailsFunctions().getAlimentosDetails(alimentosId);
    if (alimentosDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditAlimentosScreen(
              alimentosId: alimentosId, alimentosData: alimentosDetails),
        ),
      );
      if (result == true) {
        _reloadAlimentos();
      }
    }
  }

  void _reloadAlimentos() {
    setState(() {
      _alimentosFuture = AlimentosFirestoreService()
          .getAlimentos(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedAlimentos() {
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
                for (String alimentosId in _selectedAlimentosIds) {
                  await AlimentosFirestoreService()
                      .deleteAlimentos(alimentosId);
                }
                setState(() {
                  _selectedAlimentosIds.clear();
                });
                _reloadAlimentos();
              },
            ),
          ],
        );
      },
    );
  }
}
