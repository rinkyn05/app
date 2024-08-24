// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/bodypart/bodypart_details_functions.dart';
import '../../../functions/contents/bodypart/show_bodypart_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_body_part.dart';
import 'edit_body_part.dart';

class AdmBodyPartsScreen extends StatefulWidget {
  const AdmBodyPartsScreen({Key? key}) : super(key: key);

  @override
  AdmBodyPartsScreenState createState() => AdmBodyPartsScreenState();
}

class AdmBodyPartsScreenState extends State<AdmBodyPartsScreen> {
  late Future<List<Map<String, dynamic>>> _bodyPartsFuture;
  final Set<int> _selectedBodyParts = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> bodyParts = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _bodyPartsFuture = BodyPartFirestoreService()
          .getBodyParts(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('MusculoObjetivo')),
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
              'addMusculoObjetivo',
              _navigateToAddBodyPartScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('searchMusculoObjetivo'),
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
              future: _bodyPartsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingMusculoObjetivo'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  bodyParts = snapshot.data!;
                  return _buildBodyPartsGrid(bodyParts);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noMusculoObjetivoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedBodyParts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedBodyParts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteMusculoObjetivo'),
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

  Widget _buildBodyPartsGrid(List<Map<String, dynamic>> bodyParts) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: bodyParts.map((bodyPart) {
            int index = bodyParts.indexOf(bodyPart);
            return StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: _buildBodyPartCard(index, bodyPart),
            );
          }).toList(),
        ));
  }

  Widget _buildBodyPartCard(int index, Map<String, dynamic> bodyPart) {
    var theme = Theme.of(context);
    bool isSelected = _selectedBodyParts.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedBodyParts.isNotEmpty) {
          _selectBodyPart(index);
        } else {
          _navigateToEditBodyPartScreen(index);
        }
      },
      onLongPress: () => _selectBodyPart(index),
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
                  bodyPart['URL de la Imagen'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                bodyPart['Nombre'],
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

  void _navigateToEditBodyPartScreen(int index) async {
    if (_selectedBodyParts.isEmpty) {
      String bodyPartId = bodyParts[index]['id'].toString();
      var bodyPartDetails =
          await BodyPartDetailsFunctions().getBodyPartDetails(bodyPartId);
      if (bodyPartDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditBodyPartScreen(bodyPart: bodyPartDetails)),
        );
        if (result == true) {
          _reloadBodyParts();
        }
      } else {}
    } else {
      _selectBodyPart(index);
    }
  }

  void _selectBodyPart(int index) {
    setState(() {
      if (_selectedBodyParts.contains(index)) {
        _selectedBodyParts.remove(index);
      } else {
        _selectedBodyParts.add(index);
      }
    });
  }

  void _navigateToAddBodyPartScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBodyPartScreen()),
    );
    if (result == true) {
      _reloadBodyParts();
    }
  }

  void _reloadBodyParts() {
    setState(() {
      _bodyPartsFuture = BodyPartFirestoreService()
          .getBodyParts(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedBodyParts() {
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
                for (int index in _selectedBodyParts) {
                  String bodyPartId = bodyParts[index]['id'].toString();
                  await BodyPartFirestoreService().deleteBodyPart(bodyPartId);
                }
                setState(() {
                  _selectedBodyParts.clear();
                });
                _reloadBodyParts();
              },
            ),
          ],
        );
      },
    );
  }
}
