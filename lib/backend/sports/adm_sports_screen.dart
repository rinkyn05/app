import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/sports/sports_details_functions.dart';
import '../../functions/sports/sports_firestore_service.dart';
import '../../functions/role_checker.dart';
import 'add_sports_screen.dart';
import 'edit_sports_screen.dart';

class AdmSportsScreen extends StatefulWidget {
  const AdmSportsScreen({Key? key}) : super(key: key);

  @override
  AdmSportsScreenState createState() => AdmSportsScreenState();
}

class AdmSportsScreenState extends State<AdmSportsScreen> {
  late Future<List<Map<String, dynamic>>> _sportsFuture;
  final Set<String> _selectedSportsIds = <String>{};
  bool _isInit = true;
  List<Map<String, dynamic>> sports = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _sportsFuture =
          SportsFirestoreService().getSports(Localizations.localeOf(context));
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
              'addSports',
              _navigateToAddSportsScreen,
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
              future: _sportsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('errorLoadingSports'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  sports = snapshot.data!;
                  return _buildSportsGrid(snapshot.data!);
                }
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('noSportsFound'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
          if (_selectedSportsIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: _deleteSelectedSports,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('deleteSports'),
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

  Widget _buildSportsGrid(List<Map<String, dynamic>> sports) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: sports.map((sports) {
          return StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: _buildSportsCard(sports),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSportsCard(Map<String, dynamic> sports) {
    var theme = Theme.of(context);
    bool isSelected = _selectedSportsIds.contains(sports['id']);

    return GestureDetector(
      onTap: () {
        if (_selectedSportsIds.isNotEmpty) {
          setState(() {
            if (isSelected) {
              _selectedSportsIds.remove(sports['id']);
            } else {
              _selectedSportsIds.add(sports['id']);
            }
          });
        } else {
          _navigateToEditScreen(sports['id']);
        }
      },
      onLongPress: () {
        setState(() {
          _selectedSportsIds.add(sports['id']);
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
                child: Image.network(sports['URL de la Imagen'],
                    fit: BoxFit.cover),
              ),
            ),
            Text(sports['Nombre'],
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

  void _navigateToAddSportsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddSportsScreen()),
    );
    if (result == true) {
      _reloadSports();
    }
  }

  void _navigateToEditScreen(String sportsId) async {
    var sportsDetails =
        await SportsDetailsFunctions().getSportsDetails(sportsId);
    if (sportsDetails != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditSportsScreen(sportsId: sportsId, sportsData: sportsDetails),
        ),
      );
      if (result == true) {
        _reloadSports();
      }
    }
  }

  void _reloadSports() {
    setState(() {
      _sportsFuture =
          SportsFirestoreService().getSports(Localizations.localeOf(context));
    });
  }

  void _deleteSelectedSports() {
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
                for (String sportsId in _selectedSportsIds) {
                  await SportsFirestoreService().deleteSports(sportsId);
                }
                setState(() {
                  _selectedSportsIds.clear();
                });
                _reloadSports();
              },
            ),
          ],
        );
      },
    );
  }
}
