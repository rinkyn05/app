// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/recipes/recipes_details_functions.dart';
import '../../functions/recipes/recipes_firestore_service.dart';
import '../../functions/role_checker.dart';
import 'add_recipes_screen.dart';
import 'edit_recipes_screen.dart';

class AdmRecipesScreen extends StatefulWidget {
  const AdmRecipesScreen({Key? key}) : super(key: key);

  @override
  AdmRecipesScreenState createState() => AdmRecipesScreenState();
}

class AdmRecipesScreenState extends State<AdmRecipesScreen> {
  late Future<List<Map<String, dynamic>>> _recipesFuture;
  final Set<String> _selectedRecipesIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> recipes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _recipesFuture = RecipesFirestoreService()
          .getRecipes(Localizations.localeOf(context));
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
              'addRecipe',
              _navigateToAddRecipesScreen,
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
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingRecipes'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  recipes = snapshot.data!;
                  return _buildRecipesGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noRecipesFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedRecipesIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedRecipes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteRecipe'),
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

  Widget _buildRecipesGrid(List<Map<String, dynamic>> recipes) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: recipes.map((recipes) {
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildRecipesCard(recipes),
            );
          }).toList(),
        ));
  }

  Widget _buildRecipesCard(Map<String, dynamic> recipes) {
    var theme = Theme.of(context);
    bool isSelected = _selectedRecipesIds.contains(recipes['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedRecipesIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedRecipesIds.remove(recipes['id']);
            } else {
              _selectedRecipesIds.add(recipes['id']);
            }
          });
        } else {
          _navigateToEditScreen(recipes['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedRecipesIds.add(recipes['id']);
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
                child: Image.network(recipes['URL de la Imagen'],
                    fit: BoxFit.cover),
              ),
            ),
            Text(recipes['Nombre'],
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

  void _navigateToAddRecipesScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipesScreen()),
    );
    if (result == true) {
      _reloadRecipes();
    }
  }

  void _navigateToEditScreen(String recipesId) async {
    var recipesDetails =
        await RecipesDetailsFunctions().getRecipesDetails(recipesId);
    if (recipesDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRecipesScreen(
              recipesId: recipesId, recipesData: recipesDetails),
        ),
      );
      if (result == true) {
        _reloadRecipes();
      }
    }
  }

  void _reloadRecipes() {
    setState(() {
      _recipesFuture = RecipesFirestoreService()
          .getRecipes(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedRecipes() {
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
                for (String recipesId in _selectedRecipesIds) {
                  await RecipesFirestoreService()
                      .deleteRecipes(recipesId);
                }
                setState(() {
                  _selectedRecipesIds.clear();
                });
                _reloadRecipes();
              },
            ),
          ],
        );
      },
    );
  }
}
