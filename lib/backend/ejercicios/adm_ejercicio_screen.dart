// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/ejercicios/ejercicios_details_functions.dart';
import '../../functions/ejercicios/ejercicios_firestore_service.dart';
import '../../functions/role_checker.dart';
import 'add_ejercicio_screen.dart';
import 'edit_ejercicio_screen.dart';

class AdmEjerciciosScreen extends StatefulWidget {
  const AdmEjerciciosScreen({Key? key}) : super(key: key);

  @override
  AdmEjerciciosScreenState createState() => AdmEjerciciosScreenState();
}

class AdmEjerciciosScreenState extends State<AdmEjerciciosScreen> {
  late Future<List<Map<String, dynamic>>> _ejerciciosFuture;
  final Set<String> _selectedEjerciciosIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> ejercicios = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _ejerciciosFuture = EjercicioFirestoreService()
          .getEjercicios(Localizations.localeOf(context));
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
              'addEjercicio',
              _navigateToAddEjercicioScreen,
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
              future: _ejerciciosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingEjercicios'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  ejercicios = snapshot.data!;
                  return _buildEjerciciosGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noEjerciciosFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedEjerciciosIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedEjercicios,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteEjercicio'),
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

  Widget _buildEjerciciosGrid(List<Map<String, dynamic>> ejercicios) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: ejercicios.map((ejercicio) {
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildEjercicioCard(ejercicio),
            );
          }).toList(),
        ));
  }

  Widget _buildEjercicioCard(Map<String, dynamic> ejercicio) {
    var theme = Theme.of(context);
    bool isSelected = _selectedEjerciciosIds.contains(ejercicio['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedEjerciciosIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedEjerciciosIds.remove(ejercicio['id']);
            } else {
              _selectedEjerciciosIds.add(ejercicio['id']);
            }
          });
        } else {
          _navigateToEditScreen(ejercicio['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedEjerciciosIds.add(ejercicio['id']);
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
                child: Image.network(ejercicio['URL de la Imagen'],
                    fit: BoxFit.cover),
              ),
            ),
            Text(ejercicio['Nombre'],
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

  void _navigateToAddEjercicioScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEjercicioScreen()),
    );
    if (result == true) {
      _reloadEjercicios();
    }
  }

  void _navigateToEditScreen(String ejercicioId) async {
    var ejercicioDetails =
        await EjercicioDetailsFunctions().getEjercicioDetails(ejercicioId);
    if (ejercicioDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditEjercicioScreen(
              ejercicioId: ejercicioId, ejercicioData: ejercicioDetails),
        ),
      );
      if (result == true) {
        _reloadEjercicios();
      }
    }
  }

  void _reloadEjercicios() {
    setState(() {
      _ejerciciosFuture = EjercicioFirestoreService()
          .getEjercicios(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedEjercicios() {
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
                for (String ejercicioId in _selectedEjerciciosIds) {
                  await EjercicioFirestoreService()
                      .deleteEjercicio(ejercicioId);
                }
                setState(() {
                  _selectedEjerciciosIds.clear();
                });
                _reloadEjercicios();
              },
            ),
          ],
        );
      },
    );
  }
}
