// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/unequipment/show_unequipment_functions.dart';
import '../../../functions/contents/unequipment/unequipment_details_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_unequipment.dart';
import 'edit_unequipment.dart';

class AdmUnequipmentScreen extends StatefulWidget {
  const AdmUnequipmentScreen({Key? key}) : super(key: key);

  @override
  AdmUnequipmentScreenState createState() => AdmUnequipmentScreenState();
}

class AdmUnequipmentScreenState extends State<AdmUnequipmentScreen> {
  late Future<List<Map<String, dynamic>>> _unequipmentFuture;
  final Set<int> _selectedUnequipment = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> unequipment = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _unequipmentFuture = UnequipmentFirestoreService()
          .getUnequipment(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('unequipment')),
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
              'addUnequipment',
              _navigateToAddUnequipmentScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translate('searchUnequipment'),
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
              future: _unequipmentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingUnequipment'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  unequipment = snapshot.data!;
                  return _buildUnequipmentGrid(unequipment);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noUnequipmentFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedUnequipment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedUnequipment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteUnequipment'),
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

  Widget _buildUnequipmentGrid(List<Map<String, dynamic>> unequipment) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: unequipment.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> unequipmentItem = entry.value;
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildUnequipmentCard(index, unequipmentItem),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUnequipmentCard(int index, Map<String, dynamic> unequipment) {
    var theme = Theme.of(context);
    bool isSelected = _selectedUnequipment.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedUnequipment.isNotEmpty) {
          _selectUnequipment(index);
        } else {
          _navigateToEditUnequipmentScreen(index);
        }
      },
      onLongPress: () => _selectUnequipment(index),
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
                  unequipment['URL de la Imagen'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                unequipment['Nombre'],
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

  void _navigateToEditUnequipmentScreen(int index) async {
    if (_selectedUnequipment.isEmpty) {
      String unequipmentId = unequipment[index]['id'].toString();
      var unequipmentDetails = await UnequipmentDetailsFunctions()
          .getUnequipmentDetails(unequipmentId);
      if (unequipmentDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditUnequipmentScreen(unequipment: unequipmentDetails)),
        );
        if (result == true) {
          _reloadUnequipment();
        }
      } else {}
    } else {
      _selectUnequipment(index);
    }
  }

  void _selectUnequipment(int index) {
    setState(() {
      if (_selectedUnequipment.contains(index)) {
        _selectedUnequipment.remove(index);
      } else {
        _selectedUnequipment.add(index);
      }
    });
  }

  void _navigateToAddUnequipmentScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddUnequipmentScreen()),
    );
    if (result == true) {
      _reloadUnequipment();
    }
  }

  void _reloadUnequipment() {
    setState(() {
      _unequipmentFuture = UnequipmentFirestoreService()
          .getUnequipment(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedUnequipment() {
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
                for (int index in _selectedUnequipment) {
                  String unequipmentId = unequipment[index]['id'].toString();
                  await UnequipmentFirestoreService()
                      .deleteUnequipment(unequipmentId);
                }
                setState(() {
                  _selectedUnequipment.clear();
                });
                _reloadUnequipment();
              },
            ),
          ],
        );
      },
    );
  }
}
