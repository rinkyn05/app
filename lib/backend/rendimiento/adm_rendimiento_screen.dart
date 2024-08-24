import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/rendimiento_fisico/rendimiento_fisico_details_functions.dart';
import '../../functions/rendimiento_fisico/rendimiento_fisico_firestore_service.dart';
import '../../functions/role_checker.dart';
import '../admin/admin_start_screen.dart';
import 'add_rendimiento_screen.dart';
import 'edit_rendimiento_screen.dart';

class AdmRendimientoFisicoScreen extends StatefulWidget {
  const AdmRendimientoFisicoScreen({Key? key}) : super(key: key);

  @override
  AdmRendimientoFisicoScreenState createState() =>
      AdmRendimientoFisicoScreenState();
}

class AdmRendimientoFisicoScreenState
    extends State<AdmRendimientoFisicoScreen> {
  late Future<List<Map<String, dynamic>>> _rendimientoFisicoFuture;
  final Set<String> _selectedRendimientoFisicoIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> rendimientoFisico = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _rendimientoFisicoFuture = RendimientoFisicoFirestoreService()
          .getRendimientoFisico(Localizations.localeOf(context));
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
            AppLocalizations.of(context)!.translate('rendimientoFisico')),
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
              'addRendimientoFisico',
              _navigateToAddRendimientoFisicoScreen,
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
              future: _rendimientoFisicoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingRendimientoFisico'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  rendimientoFisico = snapshot.data!;
                  return _buildRendimientoFisicoGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('noRendimientoFisicoFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedRendimientoFisicoIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedRendimientoFisico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('deleteRendimientoFisico'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRendimientoFisicoGrid(
      List<Map<String, dynamic>> rendimientoFisico) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: rendimientoFisico.map((rendimientoFisico) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildRendimientoFisicoCard(rendimientoFisico),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRendimientoFisicoCard(
      Map<String, dynamic> rendimientoFisico) {
    var theme = Theme.of(context);
    bool isSelected =
        _selectedRendimientoFisicoIds.contains(rendimientoFisico['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedRendimientoFisicoIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedRendimientoFisicoIds.remove(rendimientoFisico['id']);
            } else {
              _selectedRendimientoFisicoIds.add(rendimientoFisico['id']);
            }
          });
        } else {
          _navigateToEditScreen(rendimientoFisico['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedRendimientoFisicoIds.add(rendimientoFisico['id']);
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
                child: rendimientoFisico['URL de la Imagen'] != null &&
                        rendimientoFisico['URL de la Imagen'].isNotEmpty
                    ? Image.network(
                        rendimientoFisico['URL de la Imagen'],
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: Text(
                          'Imagen no disponible',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            Text(rendimientoFisico['Nombre'],
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

  void _navigateToAddRendimientoFisicoScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AddRendimientoFisicoScreen()),
    );
    if (result == true) {
      _reloadRendimientoFisico();
    }
  }

  void _navigateToEditScreen(String rendimientoFisicoId) async {
    var rendimientoFisicoDetails = await RendimientoFisicoDetailsFunctions()
        .getRendimientoFisicoDetails(rendimientoFisicoId);
    if (rendimientoFisicoDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditRendimientoFisicoScreen(
              rendimientoFisicoId: rendimientoFisicoId,
              rendimientoFisicoData: rendimientoFisicoDetails),
        ),
      );
      if (result == true) {
        _reloadRendimientoFisico();
      }
    }
  }

  void _reloadRendimientoFisico() {
    setState(() {
      _rendimientoFisicoFuture = RendimientoFisicoFirestoreService()
          .getRendimientoFisico(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedRendimientoFisico() {
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
                for (String rendimientoFisicoId
                    in _selectedRendimientoFisicoIds) {
                  await RendimientoFisicoFirestoreService()
                      .deleteRendimientoFisico(rendimientoFisicoId);
                }
                setState(() {
                  _selectedRendimientoFisicoIds.clear();
                });
                _reloadRendimientoFisico();
              },
            ),
          ],
        );
      },
    );
  }
}
