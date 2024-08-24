// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/contents/equipment/equipment_details_functions.dart';
import '../../../functions/contents/equipment/show_equipment_functions.dart';
import '../../../functions/role_checker.dart';
import '../../admin/admin_start_screen.dart';
import 'add_equiment.dart';
import 'edit_equipment.dart';

class AdmEquipmentScreen extends StatefulWidget {
  const AdmEquipmentScreen({Key? key}) : super(key: key);

  @override
  AdmEquipmentScreenState createState() => AdmEquipmentScreenState();
}

class AdmEquipmentScreenState extends State<AdmEquipmentScreen> {
  late Future<List<Map<String, dynamic>>> _equipmentFuture;
  final Set<int> _selectedEquipment = <int>{};
  bool _isInit = true;
  List<Map<String, dynamic>> equipment = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _equipmentFuture = EquipmentFirestoreService()
          .getEquipment(Localizations.localeOf(context));
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
        title: Text(AppLocalizations.of(context)!.translate('equipment')),
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
              'addEquipment',
              _navigateToAddEquipmentScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('searchEquipment'),
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
              future: _equipmentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingEquipment'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  equipment = snapshot.data!;
                  return _buildEquipmentGrid(equipment);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noEquipmentFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedEquipment.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedEquipment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteEquipment'),
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

  Widget _buildEquipmentGrid(List<Map<String, dynamic>> equipment) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: equipment.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> equipmentItem = entry.value;
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildEquipmentCard(index, equipmentItem),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEquipmentCard(int index, Map<String, dynamic> equipment) {
    var theme = Theme.of(context);
    bool isSelected = _selectedEquipment.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedEquipment.isNotEmpty) {
          _selectEquipment(index);
        } else {
          _navigateToEditEquipmentScreen(index);
        }
      },
      onLongPress: () => _selectEquipment(index),
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
                  equipment['URL de la Imagen'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                equipment['Nombre'],
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

  void _navigateToEditEquipmentScreen(int index) async {
    if (_selectedEquipment.isEmpty) {
      String equipmentId = equipment[index]['id'].toString();
      var equipmentDetails =
          await EquipmentDetailsFunctions().getEquipmentDetails(equipmentId);
      if (equipmentDetails != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditEquipmentScreen(equipment: equipmentDetails)),
        );
        if (result == true) {
          _reloadEquipment();
        }
      } else {}
    } else {
      _selectEquipment(index);
    }
  }

  void _selectEquipment(int index) {
    setState(() {
      if (_selectedEquipment.contains(index)) {
        _selectedEquipment.remove(index);
      } else {
        _selectedEquipment.add(index);
      }
    });
  }

  void _navigateToAddEquipmentScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEquipmentScreen()),
    );
    if (result == true) {
      _reloadEquipment();
    }
  }

  void _reloadEquipment() {
    setState(() {
      _equipmentFuture = EquipmentFirestoreService()
          .getEquipment(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedEquipment() {
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
                for (int index in _selectedEquipment) {
                  String equipmentId = equipment[index]['id'].toString();
                  await EquipmentFirestoreService()
                      .deleteEquipment(equipmentId);
                }
                setState(() {
                  _selectedEquipment.clear();
                });
                _reloadEquipment();
              },
            ),
          ],
        );
      },
    );
  }
}
