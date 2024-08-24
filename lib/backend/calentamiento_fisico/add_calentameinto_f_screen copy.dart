import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/ejercicios/sports_in_ejercicio_functions.dart';
import '../models/sports_in_ejercicio_model.dart';

class AddCalentamientoFisicoScreen extends StatefulWidget {
  const AddCalentamientoFisicoScreen({Key? key}) : super(key: key);

  @override
  AddCalentamientoFisicoScreenState createState() =>
      AddCalentamientoFisicoScreenState();
}

class AddCalentamientoFisicoScreenState extends State<AddCalentamientoFisicoScreen> {
  final List<SelectedSports> _selectedSports = [];
  Map<String, Map<String, String>> sportsNames = {};

  @override
  void initState() {
    super.initState();
    _loadSportsNames();
  }

  void _loadSportsNames() async {
    var snapshot = await FirebaseFirestore.instance.collection('sports').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      sportsNames = tempMap;
    });
  }

  void _addSports(String sportsId) {
    if (!_selectedSports.any((selected) => selected.id == sportsId)) {
      String sportsEsp =
          sportsNames[sportsId]?['Esp'] ?? 'Nombre no disponible';
      String sportsEng =
          sportsNames[sportsId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedSports.add(SelectedSports(
          id: sportsId,
          sportsEsp: sportsEsp,
          sportsEng: sportsEng,
        ));
      });
    }
  }

  void _removeSports(String sportsId) {
    setState(() {
      _selectedSports.removeWhere((sports) => sports.id == sportsId);
    });
  }

  Widget _buildSelectedSports(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('sport'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedSports.map((sports) {
            String sportsName =
                langKey == 'Esp' ? sports.sportsEsp : sports.sportsEng;
            return Chip(
              label: Text(sportsName),
              onDeleted: () => _removeSports(sports.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(text: AppLocalizations.of(context)!.translate('español')),
      Tab(text: AppLocalizations.of(context)!.translate('english')),
    ];

    final tabLabelStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 26);
    final tabUnselectedLabelColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.grey
            : Colors.white70;
    final tabSelectedLabelColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(AppLocalizations.of(context)!
              .translate('addCalentamientoFisico')),
          bottom: TabBar(
            tabs: tabs,
            labelStyle: tabLabelStyle,
            unselectedLabelColor: tabUnselectedLabelColor,
            labelColor: tabSelectedLabelColor,
            indicatorColor: AppColors.lightBlueAccentColor,
            indicatorWeight: 3,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: TabBarView(
          children: [
            _buildCalentamientoFisicotsForm('Esp'),
            _buildCalentamientoFisicotsForm('Eng'),
          ],
        ),
      ),
    );
  }

  Widget _buildCalentamientoFisicotsForm(String langKey) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            _buildSelectedSports(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: SportsInEjercicioFunctions().getSimplifiedSports(langKey),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.lightBlueAccentColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('selectSports'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(AppLocalizations.of(context)!
                              .translate('selectSports')),
                          onChanged: (String? newValue) {
                            _addSports(newValue!);
                          },
                          items: snapshot.data,
                          value: snapshot.data!.isNotEmpty
                              ? snapshot.data?.first.value
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
