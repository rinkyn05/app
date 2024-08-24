// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/category/category_details_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';
import '../../../functions/category/show_category_functions.dart';

class AdmCategoriesScreen extends StatefulWidget {
  const AdmCategoriesScreen({Key? key}) : super(key: key);

  @override
  AdmCategoriesScreenState createState() => AdmCategoriesScreenState();
}

class AdmCategoriesScreenState extends State<AdmCategoriesScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  final Set<int> _selectedCategories = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> categories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _categoriesFuture = CategoryFirestoreService()
          .getCategories(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('categories')),
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
              'addCategory',
              _navigateToAddCategoryScreen,
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
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingCategories'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  categories = snapshot.data!;
                  return _buildCategoriesGrid(categories);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noCategoriesFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteCategory'),
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

  Widget _buildCategoriesGrid(List<Map<String, dynamic>> categories) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: categories.map((category) {
            int index = categories.indexOf(category);
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildCategoryCard(index, category),
            );
          }).toList(),
        ));
  }

  Widget _buildCategoryCard(int index, Map<String, dynamic> category) {
    var theme = Theme.of(context);
    bool isSelected = _selectedCategories.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedCategories.isNotEmpty) {
          _selectCategory(index);
        } else {
          _navigateToEditScreen(index);
        }
      },
      onLongPress: () => _selectCategory(index),
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
                child: Image.network(category['URL de la Imagen'],
                    fit: BoxFit.cover),
              ),
            ),
            Text(category['Nombre'],
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium),
            Text(category['Descripcion'],
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
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

  void _navigateToEditScreen(int index) async {
    if (_selectedCategories.isEmpty) {
      String categoryId = categories[index]['id'].toString();
      var categoryDetails =
          await CategoryDetailsFunctions().getCategoryDetails(categoryId);
      if (categoryDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditCategoryScreen(category: categoryDetails),
          ),
        );
        if (result == true) {
          _reloadCategories();
        }
      } else {}
    } else {
      _selectCategory(index);
    }
  }

  void _selectCategory(int index) {
    setState(() {
      if (_selectedCategories.contains(index)) {
        _selectedCategories.remove(index);
      } else {
        _selectedCategories.add(index);
      }
    });
  }

  void _navigateToAddCategoryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCategoryScreen()),
    );
    if (result == true) {
      _reloadCategories();
    }
  }

  void _reloadCategories() {
    setState(() {
      _categoriesFuture = CategoryFirestoreService()
          .getCategories(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedCategories() {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('yes')),
              onPressed: () async {
                Navigator.of(context).pop();
                for (int index in _selectedCategories) {
                  String categoryId = categories[index]['id'].toString();
                  await CategoryFirestoreService().deleteCategory(categoryId);
                }
                setState(() {
                  _selectedCategories.clear();
                });
                _reloadCategories();
              },
            ),
          ],
        );
      },
    );
  }
}
