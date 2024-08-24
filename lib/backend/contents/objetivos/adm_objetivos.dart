// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:app/backend/contents/objetivos/edit_objetivos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/objetivo/objetivos_details_functions.dart';
import '../../../functions/contents/objetivo/show_objetivos_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_objetivos.dart';

class AdmObjetivosScreen extends StatefulWidget {
  const AdmObjetivosScreen({Key? key}) : super(key: key);

  @override
  AdmObjetivosScreenState createState() => AdmObjetivosScreenState();
}

class AdmObjetivosScreenState extends State<AdmObjetivosScreen> {
  late Future<List<Map<String, dynamic>>> _objetivosFuture;
  final Set<int> _selectedObjetivos = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> objetivos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _objetivosFuture = ObjetivosFirestoreService()
          .getObjetivos(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('applicableTo')),
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
              'addApplicableTo',
              _navigateToAddObjetivosScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('searchApplicableTo'),
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
              future: _objetivosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingApplicableTo'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  objetivos = snapshot.data!;
                  return _buildObjetivosGrid(objetivos);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noApplicableToFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedObjetivos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedObjetivos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteApplicableTo'),
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

  Widget _buildObjetivosGrid(List<Map<String, dynamic>> objetivos) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: objetivos.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> objetivo = entry.value;
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildObjetivosCard(index, objetivo),
            );
          }).toList(),
        ));
  }

  Widget _buildObjetivosCard(int index, Map<String, dynamic> objetivos) {
    var theme = Theme.of(context);
    bool isSelected = _selectedObjetivos.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedObjetivos.isNotEmpty) {
          _selectObjetivos(index);
        } else {
          _navigateToEditObjetivosScreen(index);
        }
      },
      onLongPress: () => _selectObjetivos(index),
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
                child: Image.network(
                  objetivos['URL de la Imagen'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                objetivos['Nombre'],
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

  void _navigateToEditObjetivosScreen(int index) async {
    if (_selectedObjetivos.isEmpty) {
      String objetivosId = objetivos[index]['id'].toString();
      var objetivosDetails =
          await ObjetivosDetailsFunctions().getObjetivosDetails(objetivosId);
      if (objetivosDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditObjetivosScreen(objetivos: objetivosDetails)),
        );
        if (result == true) {
          _reloadObjetivos();
        }
      } else {}
    } else {
      _selectObjetivos(index);
    }
  }

  void _selectObjetivos(int index) {
    setState(() {
      if (_selectedObjetivos.contains(index)) {
        _selectedObjetivos.remove(index);
      } else {
        _selectedObjetivos.add(index);
      }
    });
  }

  void _navigateToAddObjetivosScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddObjetivoScreen()),
    );
    if (result == true) {
      _reloadObjetivos();
    }
  }

  void _reloadObjetivos() {
    setState(() {
      _objetivosFuture = ObjetivosFirestoreService()
          .getObjetivos(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedObjetivos() {
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
                for (int index in _selectedObjetivos) {
                  String objetivosId = objetivos[index]['id'].toString();
                  await ObjetivosFirestoreService()
                      .deleteObjetivos(objetivosId);
                }
                setState(() {
                  _selectedObjetivos.clear();
                });
                _reloadObjetivos();
              },
            ),
          ],
        );
      },
    );
  }
}
