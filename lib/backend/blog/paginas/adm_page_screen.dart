// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:app/backend/admin/admin_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/pages/page_details_functions.dart';
import '../../../functions/pages/page_firestore_service.dart' as pfs;
import '../../../functions/role_checker.dart';
import 'add_page_screen.dart';
import 'edit_page_screen.dart';

class AdmPageScreen extends StatefulWidget {
  const AdmPageScreen({Key? key}) : super(key: key);

  @override
  AdmPageScreenState createState() => AdmPageScreenState();
}

class AdmPageScreenState extends State<AdmPageScreen> {
  late Future<List<Map<String, dynamic>>> _pagesFuture;
  final Set<String> _selectedpagesIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _pagesFuture =
          pfs.PageFirestoreService().getPages(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('pages')),
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
              'addPage',
              _navigateToAddPageScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('search'),
                labelStyle: Theme.of(context).textTheme.titleMedium,
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _pagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingPage'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  pages = snapshot.data!;
                  return _buildpagesGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noPageFound'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
          if (_selectedpagesIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedPages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deletePage'),
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

  Widget _buildpagesGrid(List<Map<String, dynamic>> pages) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: pages.map((page) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildPageCard(page),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPageCard(Map<String, dynamic> page) {
    var theme = Theme.of(context);
    bool isSelected = _selectedpagesIds.contains(page['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedpagesIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedpagesIds.remove(page['id']);
            } else {
              _selectedpagesIds.add(page['id']);
            }
          });
        } else {
          _navigateToEditScreen(page['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedpagesIds.add(page['id']);
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
                borderRadius: BorderRadius.circular(20),
                child:
                    Image.network(page['URL de la Imagen'], fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                page['Nombre'],
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

  void _navigateToAddPageScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPageScreen()),
    );
    if (result == true) {
      _reloadPages();
    }
  }

  void _reloadPages() {
    setState(() {
      _pagesFuture =
          pfs.PageFirestoreService().getPages(Localizations.localeOf(context));
    });
  }

  void _navigateToEditScreen(String pageId) async {
    var pageDetails = await PageDetailsFunctions().getPageDetails(pageId);
    if (pageDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditPageScreen(pageId: pageId, pageData: pageDetails),
        ),
      );
      if (result == true) {
        _reloadPages();
      }
    } else {}
  }

  void _deleteSelectedPages() {
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
                for (String pageId in _selectedpagesIds) {
                  await pfs.PageFirestoreService().deletePage(pageId);
                }
                setState(() {
                  _selectedpagesIds.clear();
                });
                _reloadPages();
              },
            ),
          ],
        );
      },
    );
  }
}
