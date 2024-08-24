// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/calentamiento_especifico/calentamiento_especifico_details_functions.dart';
import '../../../functions/contents/calentamiento_especifico/show_calentamiento_especifico_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_calentamiento_especifico.dart';
import 'edit_calentamiento_especifico.dart';

class AdmCalentamientoEspecificoScreen extends StatefulWidget {
  const AdmCalentamientoEspecificoScreen({Key? key}) : super(key: key);

  @override
  AdmCalentamientoEspecificoScreenState createState() =>
      AdmCalentamientoEspecificoScreenState();
}

class AdmCalentamientoEspecificoScreenState
    extends State<AdmCalentamientoEspecificoScreen> {
  late Future<List<Map<String, dynamic>>> _calentamientoEspecificosFuture;
  final Set<int> _selectedCalentamientoEspecificos = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> calentamientoEspecificos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _calentamientoEspecificosFuture =
          CalentamientoEspecificoFirestoreService()
              .getCalentamientoEspecificos(Localizations.localeOf(context));
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
            AppLocalizations.of(context)!.translate('calentamientoEspecifico')),
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
              'addCalentamientoEspecifico',
              _navigateToAddCalentamientoEspecificoScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate('searchCalentamientoEspecifico'),
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
              future: _calentamientoEspecificosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingCalentamientoEspecifico'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  calentamientoEspecificos = snapshot.data!;
                  return _buildCalentamientoEspecificosGrid(
                      calentamientoEspecificos);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noCalentamientoEspecificoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedCalentamientoEspecificos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedCalentamientoEspecificos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteCalentamientoEspecifico'),
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

  Widget _buildCalentamientoEspecificosGrid(
      List<Map<String, dynamic>> calentamientoEspecificos) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: calentamientoEspecificos.map((calentamientoEspecifico) {
            int index =
                calentamientoEspecificos.indexOf(calentamientoEspecifico);
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildCalentamientoEspecificoCard(
                  index, calentamientoEspecifico),
            );
          }).toList(),
        ));
  }

  Widget _buildCalentamientoEspecificoCard(
      int index, Map<String, dynamic> calentamientoEspecifico) {
    var theme = Theme.of(context);
    bool isSelected = _selectedCalentamientoEspecificos.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedCalentamientoEspecificos.isNotEmpty) {
          _selectCalentamientoEspecifico(index);
        } else {
          _navigateToEditCalentamientoEspecificoScreen(index);
        }
      },
      onLongPress: () => _selectCalentamientoEspecifico(index),
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
                child: calentamientoEspecifico['URL de la Imagen'] != null &&
                        calentamientoEspecifico['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        calentamientoEspecifico['URL de la Imagen'],
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
                calentamientoEspecifico['Nombre'] != null &&
                        calentamientoEspecifico['Nombre'].isNotEmpty
                    ? calentamientoEspecifico['Nombre']
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

  void _navigateToEditCalentamientoEspecificoScreen(int index) async {
    if (_selectedCalentamientoEspecificos.isEmpty) {
      String calentamientoEspecificoId =
          calentamientoEspecificos[index]['id'].toString();
      var calentamientoEspecificoDetails =
          await CalentamientoEspecificoDetailsFunctions()
              .getCalentamientoEspecificoDetails(calentamientoEspecificoId);
      if (calentamientoEspecificoDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditCalentamientoEspecificoScreen(
                  calentamientoEspecifico: calentamientoEspecificoDetails)),
        );
        if (result == true) {
          _reloadCalentamientoEspecificos();
        }
      } else {}
    } else {
      _selectCalentamientoEspecifico(index);
    }
  }

  void _selectCalentamientoEspecifico(int index) {
    setState(() {
      if (_selectedCalentamientoEspecificos.contains(index)) {
        _selectedCalentamientoEspecificos.remove(index);
      } else {
        _selectedCalentamientoEspecificos.add(index);
      }
    });
  }

  void _navigateToAddCalentamientoEspecificoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddCalentamientoEspecificoScreen()),
    );
    if (result == true) {
      _reloadCalentamientoEspecificos();
    }
  }

  void _reloadCalentamientoEspecificos() {
    setState(() {
      _calentamientoEspecificosFuture =
          CalentamientoEspecificoFirestoreService()
              .getCalentamientoEspecificos(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedCalentamientoEspecificos() {
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
                for (int index in _selectedCalentamientoEspecificos) {
                  String calentamientoEspecificoId =
                      calentamientoEspecificos[index]['id'].toString();
                  await CalentamientoEspecificoFirestoreService()
                      .deleteCalentamientoEspecifico(calentamientoEspecificoId);
                }
                setState(() {
                  _selectedCalentamientoEspecificos.clear();
                });
                _reloadCalentamientoEspecificos();
              },
            ),
          ],
        );
      },
    );
  }
}
