// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/catejercicio/cat_ejercicio_details_functions.dart';
import '../../../functions/contents/catejercicio/show_cat_ejercicio_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_category_ejercicio.dart';
import 'edit_category_ejercicio.dart';

class AdmCatEjercicioScreen extends StatefulWidget {
  const AdmCatEjercicioScreen({Key? key}) : super(key: key);

  @override
  AdmCatEjercicioScreenState createState() => AdmCatEjercicioScreenState();
}

class AdmCatEjercicioScreenState extends State<AdmCatEjercicioScreen> {
  late Future<List<Map<String, dynamic>>> _catejercicioFuture;
  final Set<int> _selectedCatEjercicio = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> catejercicio = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _catejercicioFuture = CatEjercicioFirestoreService()
          .getCatEjercicio(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('catEjercicio')),
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
              'addCatEjercicio',
              _navigateToAddCatEjercicioScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate('searchCatEjercicio'),
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
              future: _catejercicioFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingCatEjercicio'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  catejercicio = snapshot.data!;
                  return _buildCatEjercicioGrid(catejercicio);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noCatEjercicioFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedCatEjercicio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedCatEjercicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteCatEjercicio'),
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

  Widget _buildCatEjercicioGrid(List<Map<String, dynamic>> catejercicio) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: catejercicio.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> catejercicioItem = entry.value;
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildCatEjercicioCard(index, catejercicioItem),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCatEjercicioCard(int index, Map<String, dynamic> catejercicio) {
    var theme = Theme.of(context);
    bool isSelected = _selectedCatEjercicio.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedCatEjercicio.isNotEmpty) {
          _selectCatEjercicio(index);
        } else {
          _navigateToEditCatEjercicioScreen(index);
        }
      },
      onLongPress: () => _selectCatEjercicio(index),
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
                  catejercicio['URL de la Imagen'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                catejercicio['Nombre'],
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

  void _navigateToEditCatEjercicioScreen(int index) async {
    if (_selectedCatEjercicio.isEmpty) {
      String catejercicioId = catejercicio[index]['id'].toString();
      var catejercicioDetails = await CatEjercicioDetailsFunctions()
          .getCatEjercicioDetails(catejercicioId);
      if (catejercicioDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditCatEjercicioScreen(catejercicio: catejercicioDetails)),
        );
        if (result == true) {
          _reloadCatEjercicio();
        }
      } else {}
    } else {
      _selectCatEjercicio(index);
    }
  }

  void _selectCatEjercicio(int index) {
    setState(() {
      if (_selectedCatEjercicio.contains(index)) {
        _selectedCatEjercicio.remove(index);
      } else {
        _selectedCatEjercicio.add(index);
      }
    });
  }

  void _navigateToAddCatEjercicioScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCatEjercicioScreen()),
    );
    if (result == true) {
      _reloadCatEjercicio();
    }
  }

  void _reloadCatEjercicio() {
    setState(() {
      _catejercicioFuture = CatEjercicioFirestoreService()
          .getCatEjercicio(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedCatEjercicio() {
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
                for (int index in _selectedCatEjercicio) {
                  String catejercicioId = catejercicio[index]['id'].toString();
                  await CatEjercicioFirestoreService()
                      .deleteCatEjercicio(catejercicioId);
                }
                setState(() {
                  _selectedCatEjercicio.clear();
                });
                _reloadCatEjercicio();
              },
            ),
          ],
        );
      },
    );
  }
}
