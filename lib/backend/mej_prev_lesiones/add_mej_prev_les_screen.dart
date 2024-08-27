// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';

import '../../functions/ejercicios/equipment_in_ejercicio_functions.dart';
import '../../functions/ejercicios/sports_in_ejercicio_functions.dart';
import '../../functions/mej_prev_lesiones/add_mej_prev_les_functions.dart';
import '../../functions/role_checker.dart';
import '../../functions/upload_exercise_image.dart';
import '../models/equipment_in_ejercicio_model.dart';
import '../models/sports_in_ejercicio_model.dart';

class AddMejPreLesionesScreen extends StatefulWidget {
  const AddMejPreLesionesScreen({Key? key}) : super(key: key);

  @override
  AddMejPreLesionesScreenState createState() => AddMejPreLesionesScreenState();
}

class AddMejPreLesionesScreenState extends State<AddMejPreLesionesScreen> {
  final TextEditingController _nameControllerEsp = TextEditingController();
  final TextEditingController _nameControllerEng = TextEditingController();

  final TextEditingController _contenidoControllerEsp = TextEditingController();
  final TextEditingController _contenidoControllerEng = TextEditingController();

  final TextEditingController _videoController = TextEditingController();

  String _imageUrl = '';
  String _membershipEsp = 'Gratis';
  String _membershipEng = 'Free';

  final List<SelectedEquipment> _selectedEquipment = [];
  Map<String, Map<String, String>> equipmentNames = {};

  String _nivelDeImpactoEsp = 'Bajo';
  String _nivelDeImpactoEng = 'Low';

  String _stanceEsp = 'Parado';
  String _stanceEng = 'Standing';

  String _articulacionPrincipalEsp = 'Tobillo';
  String _articulacionPrincipalEng = 'ankle';

  String _zonaPrincipalInvolucradaEsp = 'Superior';
  String _zonaPrincipalInvolucradaEng = 'Upper Body';

  String _difficultyEsp = 'Fácil';
  String _difficultyEng = 'Easy';

  String _intensityEsp = 'Ascendente';
  String _intensityEng = 'Ascending';

  final List<SelectedSports> _selectedSports = [];
  Map<String, Map<String, String>> sportsNames = {};

  final TextEditingController _descriptionControllerEsp =
      TextEditingController();
  final TextEditingController _descriptionControllerEng =
      TextEditingController();

  List<String> _ejercicioParaEsp = ['Equilibrio'];
  List<String> _ejercicioParaEng = ['Balance'];

  final Map<String, String> ejercicioParaMapEspToEng = {
    'Equilibrio': 'Balance',
    'Propiocepción': 'Proprioception',
    'Lateralidad': 'Laterality',
    'Coordinación': 'Coordination',
    'Motricidad Gruesa': 'Gross Motor Skills',
    'Motricidad Fina': 'Fine Motor Skills',
  };

  final Map<String, String> ejercicioParaMapEngToEsp = {
    'Balance': 'Equilibrio',
    'Proprioception': 'Propiocepción',
    'Laterality': 'Lateralidad',
    'Coordination': 'Coordinación',
    'Gross Motor Skills': 'Motricidad Gruesa',
    'Fine Motor Skills': 'Motricidad Fina',
  };

  List<String> _faseDeTemporadaEsp = ['Pre Temporada'];
  List<String> _faseDeTemporadaEng = ['Pre-Season'];

  final Map<String, String> faseDeTemporadaMapEspToEng = {
    'Pre Temporada': 'Pre-Season',
    'Temporada': 'Season',
    'Post Temporada': 'Post-Season',
  };

  final Map<String, String> faseDeTemporadaMapEngToEsp = {
    'Pre-Season': 'Pre Temporada',
    'Season': 'Temporada',
    'Post-Season': 'Post Temporada',
  };

  List<String> _faseDeEjercicioEsp = ['Pre-Inicial'];
  List<String> _faseDeEjercicioEng = ['Pre-Initial'];

  final Map<String, String> faseDeEjercicioMapEspToEng = {
    'Pre-Inicial': 'Pre-Initial',
    'Iniciación': 'Initiation',
    'Preparatorio': 'Preparatory',
    'Específico': 'Specific',
    'Corrección': 'Correction',
  };

  final Map<String, String> faseDeEjercicioMapEngToEsp = {
    'Pre-Initial': 'Pre-Inicial',
    'Initiation': 'Iniciación',
    'Preparatory': 'Preparatorio',
    'Specific': 'Específico',
    'Correction': 'Corrección',
  };

  @override
  void initState() {
    super.initState();
    _loadEquipmentNames();
    _loadSportsNames();
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

  void _loadEquipmentNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('equipment').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      equipmentNames = tempMap;
    });
  }

  void _addEquipment(String equipmentId) {
    if (!_selectedEquipment.any((selected) => selected.id == equipmentId)) {
      String equipmentEsp =
          equipmentNames[equipmentId]?['Esp'] ?? 'Nombre no disponible';
      String equipmentEng =
          equipmentNames[equipmentId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedEquipment.add(SelectedEquipment(
          id: equipmentId,
          equipmentEsp: equipmentEsp,
          equipmentEng: equipmentEng,
        ));
      });
    }
  }

  void _removeEquipment(String equipmentId) {
    setState(() {
      _selectedEquipment
          .removeWhere((equipment) => equipment.id == equipmentId);
    });
  }

  Widget _buildSelectedEquipment(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('equipmentNew'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedEquipment.map((equipment) {
            String equipmentName = langKey == 'Esp'
                ? equipment.equipmentEsp
                : equipment.equipmentEng;
            return Chip(
              label: Text(equipmentName),
              onDeleted: () => _removeEquipment(equipment.id),
            );
          }).toList(),
        ),
      ],
    );
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

  Widget _buildNivelDeImpactoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseNivelDeImpacto'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildNivelDeImpactoSelector(),
        _buildSelectedNivelDeImpacto(),
      ],
    );
  }

  Widget _buildNivelDeImpactoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Bajo', 'Regular', 'Medio', 'Bueno', 'Alto'];
    List<String> optionsEng = ['Low', 'Regular', 'Medium', 'Good', 'High'];

    Map<String, String> nivelDeImpactoMapEspToEng = {
      'Bajo': 'Low',
      'Regular': 'Regular',
      'Medio': 'Medium',
      'Bueno': 'Good',
      'Alto': 'High',
    };

    Map<String, String> nivelDeImpactoMapEngToEsp = {
      'Low': 'Bajo',
      'Regular': 'Regular',
      'Medium': 'Medio',
      'Good': 'Bueno',
      'High': 'Alto',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentNivelDeImpacto =
        isEsp ? _nivelDeImpactoEsp : _nivelDeImpactoEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
            AppLocalizations.of(context)!.translate('selectNivelDeImpacto'),
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
                  .translate('selectNivelDeImpacto')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _nivelDeImpactoEsp = newValue!;
                    _nivelDeImpactoEng = nivelDeImpactoMapEspToEng[newValue]!;
                  } else {
                    _nivelDeImpactoEng = newValue!;
                    _nivelDeImpactoEsp = nivelDeImpactoMapEngToEsp[newValue]!;
                  }
                });
              },
              value: currentNivelDeImpacto,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedNivelDeImpacto() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String nivelDeImpactoName = isEsp ? _nivelDeImpactoEsp : _nivelDeImpactoEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(nivelDeImpactoName),
        onDeleted: () {
          setState(() {
            _nivelDeImpactoEsp = 'Bajo';
            _nivelDeImpactoEng = 'Low';
          });
        },
      ),
    );
  }

  Widget _buildEjercicioParaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseEjercicioPara'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildEjercicioParaDropdown(),
        _buildSelectedEjercicioPara(),
      ],
    );
  }

  Widget _buildEjercicioParaDropdown() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Equilibrio',
      'Propiocepción',
      'Lateralidad',
      'Coordinación',
      'Motricidad Gruesa',
      'Motricidad Fina'
    ];
    List<String> optionsEng = [
      'Balance',
      'Proprioception',
      'Laterality',
      'Coordination',
      'Gross Motor Skills',
      'Fine Motor Skills'
    ];

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
              AppLocalizations.of(context)!.translate('selectEjercicioPara')),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                if (isEsp && !_ejercicioParaEsp.contains(newValue)) {
                  _ejercicioParaEsp.add(newValue);
                  _ejercicioParaEng.add(ejercicioParaMapEspToEng[newValue]!);
                } else if (!isEsp && !_ejercicioParaEng.contains(newValue)) {
                  _ejercicioParaEng.add(newValue);
                  _ejercicioParaEsp.add(ejercicioParaMapEngToEsp[newValue]!);
                }
              }
            });
          },
          value: null,
        ),
      ),
    );
  }

  Widget _buildSelectedEjercicioPara() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    List<String> selectedEjercicioPara =
        isEsp ? _ejercicioParaEsp : _ejercicioParaEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: selectedEjercicioPara.map((String name) {
          return Chip(
            label: Text(name),
            onDeleted: () {
              setState(() {
                if (isEsp) {
                  _ejercicioParaEsp.remove(name);
                  _ejercicioParaEng.removeWhere(
                      (element) => ejercicioParaMapEspToEng[name] == element);
                } else {
                  _ejercicioParaEng.remove(name);
                  _ejercicioParaEsp.removeWhere(
                      (element) => ejercicioParaMapEngToEsp[name] == element);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaseDeTemporadaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('faseDeTemporada'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildFaseDeTemporadaDropdown(),
        _buildSelectedFaseDeTemporada(),
      ],
    );
  }

  Widget _buildFaseDeTemporadaDropdown() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Pre Temporada', 'Temporada', 'Post Temporada'];
    List<String> optionsEng = ['Pre-Season', 'Season', 'Post-Season'];

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
              AppLocalizations.of(context)!.translate('selectFaseDeTemporada')),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                if (isEsp && !_faseDeTemporadaEsp.contains(newValue)) {
                  _faseDeTemporadaEsp.add(newValue);
                  _faseDeTemporadaEng
                      .add(faseDeTemporadaMapEspToEng[newValue]!);
                } else if (!isEsp && !_faseDeTemporadaEng.contains(newValue)) {
                  _faseDeTemporadaEng.add(newValue);
                  _faseDeTemporadaEsp
                      .add(faseDeTemporadaMapEngToEsp[newValue]!);
                }
              }
            });
          },
          value: null,
        ),
      ),
    );
  }

  Widget _buildSelectedFaseDeTemporada() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    List<String> selectedFaseDeTemporada =
        isEsp ? _faseDeTemporadaEsp : _faseDeTemporadaEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: selectedFaseDeTemporada.map((String name) {
          return Chip(
            label: Text(name),
            onDeleted: () {
              setState(() {
                if (isEsp) {
                  _faseDeTemporadaEsp.remove(name);
                  _faseDeTemporadaEng.removeWhere(
                      (element) => faseDeTemporadaMapEspToEng[name] == element);
                } else {
                  _faseDeTemporadaEng.remove(name);
                  _faseDeTemporadaEsp.removeWhere(
                      (element) => faseDeTemporadaMapEngToEsp[name] == element);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaseDeEjercicioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('faseDeEjercicio'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildFaseDeEjercicioDropdown(),
        _buildSelectedFaseDeEjercicio(),
      ],
    );
  }

  Widget _buildFaseDeEjercicioDropdown() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Pre-Inicial',
      'Iniciación',
      'Preparatorio',
      'Específico',
      'Corrección'
    ];
    List<String> optionsEng = [
      'Pre-Initial',
      'Initiation',
      'Preparatory',
      'Specific',
      'Correction'
    ];

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
              AppLocalizations.of(context)!.translate('selectFaseDeEjercicio')),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                if (isEsp && !_faseDeEjercicioEsp.contains(newValue)) {
                  _faseDeEjercicioEsp.add(newValue);
                  _faseDeEjercicioEng
                      .add(faseDeEjercicioMapEspToEng[newValue]!);
                } else if (!isEsp && !_faseDeEjercicioEng.contains(newValue)) {
                  _faseDeEjercicioEng.add(newValue);
                  _faseDeEjercicioEsp
                      .add(faseDeEjercicioMapEngToEsp[newValue]!);
                }
              }
            });
          },
          value: null,
        ),
      ),
    );
  }

  Widget _buildSelectedFaseDeEjercicio() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    List<String> selectedFaseDeEjercicio =
        isEsp ? _faseDeEjercicioEsp : _faseDeEjercicioEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: selectedFaseDeEjercicio.map((String name) {
          return Chip(
            label: Text(name),
            onDeleted: () {
              setState(() {
                if (isEsp) {
                  _faseDeEjercicioEsp.remove(name);
                  _faseDeEjercicioEng.removeWhere(
                      (element) => faseDeEjercicioMapEspToEng[name] == element);
                } else {
                  _faseDeEjercicioEng.remove(name);
                  _faseDeEjercicioEsp.removeWhere(
                      (element) => faseDeEjercicioMapEngToEsp[name] == element);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseStance'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildStanceSelector(),
        _buildSelectedStance(),
      ],
    );
  }

  Widget _buildStanceSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Parado',
      'Sentado',
      'Inclinado',
      'Declinado',
      'De Pie Horizontal',
      'Maquina Gimnasion'
    ];
    List<String> optionsEng = [
      'Standing',
      'Sitting',
      'Inclined',
      'Declined',
      'Horizontal Standing',
      'Gym Machine'
    ];

    Map<String, String> stanceMapEspToEng = {
      'Parado': 'Standing',
      'Sentado': 'Sitting',
      'Inclinado': 'Inclined',
      'Declinado': 'Declined',
      'De Pie Horizontal': 'Horizontal Standing',
      'Maquina Gimnasion': 'Gym Machine',
    };

    Map<String, String> stanceMapEngToEsp = {
      'Standing': 'Parado',
      'Sitting': 'Sentado',
      'Inclined': 'Inclinado',
      'Declined': 'Declinado',
      'Horizontal Standing': 'De Pie Horizontal',
      'Gym Machine': 'Maquina Gimnasion',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue = isEsp ? _stanceEsp : _stanceEng;

    return FutureBuilder<List<DropdownMenuItem<String>>>(
      future: Future.value(
        options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                AppLocalizations.of(context)!.translate('exerciseStance'),
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
                      .translate('selectExerciseStance')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _stanceEsp = newValue!;
                        _stanceEng = stanceMapEspToEng[newValue]!;
                      } else {
                        _stanceEng = newValue!;
                        _stanceEsp = stanceMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  items: snapshot.data,
                  value: selectedValue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedStance() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String stanceName = isEsp ? _stanceEsp : _stanceEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Chip(
        label: Text(stanceName),
        onDeleted: () {
          setState(() {
            _stanceEsp = 'Parado';
            _stanceEng = 'Standing';
          });
        },
      ),
    );
  }

  Widget _buildArticulacionPrincipalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('exerciseArticulacionPrincipal'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildArticulacionPrincipalSelector(),
        _buildSelectedArticulacionPrincipal(),
      ],
    );
  }

  Widget _buildArticulacionPrincipalSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Tobillo',
      'Hombro',
      'Muñeca',
      'Brazo',
      'Pierna',
      'Cadera',
      'Muslo'
    ];
    List<String> optionsEng = [
      'ankle',
      'Shoulder',
      'Wrist',
      'Arm',
      'Leg',
      'Hip',
      'Thigh'
    ];

    Map<String, String> articulacionPrincipalMapEspToEng = {
      'Tobillo': 'ankle',
      'Hombro': 'Shoulder',
      'Muñeca': 'Wrist',
      'Brazo': 'Arm',
      'Pierna': 'Leg',
      'Cadera': 'Hip',
      'Muslo': 'Thigh',
    };

    Map<String, String> articulacionPrincipalMapEngToEsp = {
      'ankle': 'Tobillo',
      'Shoulder': 'Hombro',
      'Wrist': 'Muñeca',
      'Arm': 'Brazo',
      'Leg': 'Pierna',
      'Hip': 'Cadera',
      'Thigh': 'Muslo',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue =
        isEsp ? _articulacionPrincipalEsp : _articulacionPrincipalEng;

    return FutureBuilder<List<DropdownMenuItem<String>>>(
      future: Future.value(
        options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                AppLocalizations.of(context)!
                    .translate('exerciseArticulacionPrincipal'),
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
                      .translate('selectExerciseArticulacionPrincipal')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _articulacionPrincipalEsp = newValue!;
                        _articulacionPrincipalEng =
                            articulacionPrincipalMapEspToEng[newValue]!;
                      } else {
                        _articulacionPrincipalEng = newValue!;
                        _articulacionPrincipalEsp =
                            articulacionPrincipalMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  items: snapshot.data,
                  value: selectedValue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedArticulacionPrincipal() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String articulacionPrincipalName =
        isEsp ? _articulacionPrincipalEsp : _articulacionPrincipalEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Chip(
        label: Text(articulacionPrincipalName),
        onDeleted: () {
          setState(() {
            _articulacionPrincipalEsp = 'Tobillo';
            _articulacionPrincipalEng = 'ankle';
          });
        },
      ),
    );
  }

  Widget _buildZonaPrincipalInvolucradaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('exerciseZonaPrincipalInvolucrada'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildZonaPrincipalInvolucradaSelector(),
        _buildSelectedZonaPrincipalInvolucrada(),
      ],
    );
  }

  Widget _buildZonaPrincipalInvolucradaSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Superior', 'Inferior', 'Core', 'Fullbody'];
    List<String> optionsEng = ['Upper Body', 'Lower Body', 'Core', 'Fullbody'];

    Map<String, String> zonaPrincipalInvolucradaMapEspToEng = {
      'Superior': 'Upper Body',
      'Inferior': 'Lower Body',
      'Core': 'Core',
      'Fullbody': 'Fullbody',
    };

    Map<String, String> zonaPrincipalInvolucradaMapEngToEsp = {
      'Upper Body': 'Superior',
      'Lower Body': 'Inferior',
      'Core': 'Core',
      'Fullbody': 'Fullbody',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String? selectedValue =
        isEsp ? _zonaPrincipalInvolucradaEsp : _zonaPrincipalInvolucradaEng;

    return FutureBuilder<List<DropdownMenuItem<String>>>(
      future: Future.value(
        options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                AppLocalizations.of(context)!
                    .translate('exerciseZonaPrincipalInvolucrada'),
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
                      .translate('selectExerciseZonaPrincipalInvolucrada')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _zonaPrincipalInvolucradaEsp = newValue!;
                        _zonaPrincipalInvolucradaEng =
                            zonaPrincipalInvolucradaMapEspToEng[newValue]!;
                      } else {
                        _zonaPrincipalInvolucradaEng = newValue!;
                        _zonaPrincipalInvolucradaEsp =
                            zonaPrincipalInvolucradaMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  items: snapshot.data,
                  value: selectedValue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedZonaPrincipalInvolucrada() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String zonaPrincipalInvolucradaName =
        isEsp ? _zonaPrincipalInvolucradaEsp : _zonaPrincipalInvolucradaEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Chip(
        label: Text(zonaPrincipalInvolucradaName),
        onDeleted: () {
          setState(() {
            _zonaPrincipalInvolucradaEsp = 'Superior';
            _zonaPrincipalInvolucradaEng = 'Upper Body';
          });
        },
      ),
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('difficulty'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildDifficultySelector(),
        _buildSelectedDifficulty(),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Fácil', 'Medio', 'Avanzado', 'Difícil'];
    List<String> optionsEng = ['Easy', 'Medium', 'Advanced', 'Difficult'];

    Map<String, String> difficultyMapEspToEng = {
      'Fácil': 'Easy',
      'Medio': 'Medium',
      'Avanzado': 'Advanced',
      'Difícil': 'Difficult',
    };

    Map<String, String> difficultyMapEngToEsp = {
      'Easy': 'Fácil',
      'Medium': 'Medio',
      'Advanced': 'Avanzado',
      'Difficult': 'Difícil',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentDifficulty = isEsp ? _difficultyEsp : _difficultyEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
            AppLocalizations.of(context)!.translate('selectDifficulty'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                  AppLocalizations.of(context)!.translate('selectDifficulty')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _difficultyEsp = newValue!;
                    _difficultyEng = difficultyMapEspToEng[newValue]!;
                  } else {
                    _difficultyEng = newValue!;
                    _difficultyEsp = difficultyMapEngToEsp[newValue]!;
                  }
                });
              },
              value: currentDifficulty,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDifficulty() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String difficultyName = isEsp ? _difficultyEsp : _difficultyEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(difficultyName),
        onDeleted: () {
          setState(() {
            _difficultyEsp = 'Fácil';
            _difficultyEng = 'Easy';
          });
        },
      ),
    );
  }

  Widget _buildIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('intensity'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildIntensitySelector(),
        _buildSelectedIntensity(),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Ascendente',
      'Descendente',
      'Baja',
      'Muy Baja',
      'Moderada',
      'Alta',
      'Muy Alta'
    ];
    List<String> optionsEng = [
      'Ascending',
      'Descending',
      'Low',
      'Very Low',
      'Moderate',
      'High',
      'Very High'
    ];

    Map<String, String> intensityMapEspToEng = {
      'Ascendente': 'Ascending',
      'Descendente': 'Descending',
      'Baja': 'Low',
      'Muy Baja': 'Very Low',
      'Moderada': 'Moderate',
      'Alta': 'High',
      'Muy Alta': 'Very High',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Ascending': 'Ascendente',
      'Descending': 'Descendente',
      'Low': 'Baja',
      'Very Low': 'Muy Baja',
      'Moderate': 'Moderada',
      'High': 'Alta',
      'Very High': 'Muy Alta',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentIntensity = isEsp ? _intensityEsp : _intensityEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
            AppLocalizations.of(context)!.translate('selectIntensity'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                  AppLocalizations.of(context)!.translate('selectIntensity')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _intensityEsp = newValue!;
                    _intensityEng = intensityMapEspToEng[newValue]!;
                  } else {
                    _intensityEng = newValue!;
                    _intensityEsp = intensityMapEngToEsp[newValue]!;
                  }
                });
              },
              value: currentIntensity,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIntensity() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String intensityName = isEsp ? _intensityEsp : _intensityEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(intensityName),
        onDeleted: () {
          setState(() {
            _intensityEsp = 'Ascendente';
            _intensityEng = 'Ascending';
          });
        },
      ),
    );
  }

  Widget _buildMembershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseMembership'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildMembershipSelector(),
        _buildSelectedMembership(),
      ],
    );
  }

  Widget _buildMembershipSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Gratis', 'Premium'];
    List<String> optionsEng = ['Free', 'Premium'];

    Map<String, String> membershipMapEspToEng = {
      'Gratis': 'Free',
      'Premium': 'Premium',
    };

    Map<String, String> membershipMapEngToEsp = {
      'Free': 'Gratis',
      'Premium': 'Premium',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentMembership = isEsp ? _membershipEsp : _membershipEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
            AppLocalizations.of(context)!.translate('selectMembership'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                  AppLocalizations.of(context)!.translate('selectMembership')),
              onChanged: (String? newValue) {
                setState(() {
                  if (isEsp) {
                    _membershipEsp = newValue!;
                    _membershipEng = membershipMapEspToEng[newValue]!;
                  } else {
                    _membershipEng = newValue!;
                    _membershipEsp = membershipMapEngToEsp[newValue]!;
                  }
                });
              },
              value: currentMembership,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMembership() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    String membershipName = isEsp ? _membershipEsp : _membershipEng;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(membershipName),
        onDeleted: () {
          setState(() {
            _membershipEsp = 'Gratis';
            _membershipEng = 'Free';
          });
        },
      ),
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
          title: Text(
              AppLocalizations.of(context)!.translate('addMejPreLesiones')),
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
            _buildMejPreLesionestsForm(
                _nameControllerEsp,
                _contenidoControllerEsp,
                _nivelDeImpactoEsp,
                _ejercicioParaEsp.join(', '),
                _faseDeTemporadaEsp.join(', '),
                _faseDeEjercicioEsp.join(', '),
                _stanceEsp,
                _articulacionPrincipalEsp,
                _zonaPrincipalInvolucradaEsp,
                _difficultyEsp,
                _intensityEsp,
                _videoController,
                _descriptionControllerEsp,
                _membershipEsp,
                'Esp'),
            _buildMejPreLesionestsForm(
                _nameControllerEng,
                _contenidoControllerEng,
                _nivelDeImpactoEng,
                _ejercicioParaEng.join(', '),
                _faseDeTemporadaEng.join(', '),
                _faseDeEjercicioEng.join(', '),
                _stanceEng,
                _articulacionPrincipalEng,
                _zonaPrincipalInvolucradaEng,
                _difficultyEng,
                _intensityEng,
                _videoController,
                _descriptionControllerEng,
                _membershipEng,
                'Eng'),
          ],
        ),
      ),
    );
  }

  Widget _buildMejPreLesionestsForm(
      TextEditingController nameController,
      TextEditingController contenidoController,
      String nivelDeImpacto,
      String selectedEjercicioPara,
      String selectedFaseDeTemporada,
      String selectedFaseDeEjercicio,
      String stance,
      String articulacionPrincipal,
      String zonaPrincipalInvolucrada,
      String difficulty,
      String intensity,
      TextEditingController videoController,
      TextEditingController descriptionController,
      String membership,
      String langKey) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBlueColor
        : Colors.black;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('name'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('name')} ($langKey)',
                hintText: AppLocalizations.of(context)!.translate('enterName'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('synonyms'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: contenidoController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('synonyms')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterSynonyms'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            _buildSelectedSports(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: SportsInEjercicioFunctions().getSimplifiedSports(langKey),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            const SizedBox(height: 10),
            _buildEjercicioParaSection(),
            const SizedBox(height: 10),
            _buildArticulacionPrincipalSection(),
            const SizedBox(height: 10),
            _buildDifficultySection(),
            const SizedBox(height: 10),
            _buildNivelDeImpactoSection(),
            const SizedBox(height: 10),
            _buildStanceSection(),
            const SizedBox(height: 10),
            _buildFaseDeTemporadaSection(),
            const SizedBox(height: 10),
            _buildFaseDeEjercicioSection(),
            const SizedBox(height: 10),
            _buildZonaPrincipalInvolucradaSection(),
            const SizedBox(height: 10),
            _buildSelectedEquipment(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: EquipmentInEjercicioFunctions()
                  .getSimplifiedEquipment(langKey),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                        AppLocalizations.of(context)!
                            .translate('selectEquipmentNew'),
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
                              .translate('selectEquipmentNew')),
                          onChanged: (String? newValue) {
                            _addEquipment(newValue!);
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
            const SizedBox(height: 10),
            _buildIntensitySection(),
            const SizedBox(height: 10),
            _buildMembershipSection(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('videoLink'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: videoController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('videoLink')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterVideoLink'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('description'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('description')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterEjercicioDescription'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('image'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildImagePreview(),
            const SizedBox(height: 15),
            _buildPublishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return InkWell(
      onTap: () async {
        await uploadExerciseImage(context, (String url) {
          setState(() {
            _imageUrl = url;
          });
        });
      },
      child: _imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(_imageUrl, height: 200, fit: BoxFit.cover),
            )
          : Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Icon(Icons.photo, size: 50, color: Colors.grey.shade600),
            ),
    );
  }

  Widget _buildPublishButton() {
    return _buildCustomButton(
      context,
      'Publicar',
      () async {
        if (_nameControllerEsp.text.isNotEmpty &&
            _contenidoControllerEsp.text.isNotEmpty &&
            _videoController.text.isNotEmpty &&
            _descriptionControllerEsp.text.isNotEmpty &&
            _descriptionControllerEng.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _contenidoControllerEng.text.isNotEmpty &&
            _selectedEquipment.isNotEmpty &&
            _nivelDeImpactoEsp.isNotEmpty &&
            _nivelDeImpactoEng.isNotEmpty &&
            _ejercicioParaEsp.isNotEmpty &&
            _ejercicioParaEng.isNotEmpty &&
            _faseDeTemporadaEsp.isNotEmpty &&
            _faseDeTemporadaEng.isNotEmpty &&
            _faseDeEjercicioEsp.isNotEmpty &&
            _faseDeEjercicioEng.isNotEmpty &&
            _stanceEsp.isNotEmpty &&
            _stanceEng.isNotEmpty &&
            _articulacionPrincipalEsp.isNotEmpty &&
            _articulacionPrincipalEng.isNotEmpty &&
            _zonaPrincipalInvolucradaEsp.isNotEmpty &&
            _zonaPrincipalInvolucradaEng.isNotEmpty &&
            _difficultyEsp.isNotEmpty &&
            _difficultyEng.isNotEmpty &&
            _intensityEsp.isNotEmpty &&
            _intensityEng.isNotEmpty &&
            _membershipEsp.isNotEmpty &&
            _membershipEng.isNotEmpty) {
          await AddMejPreLesionesFunctions()
              .addMejPreLesionesWithAutoIncrementId(
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            contenidoEsp: _contenidoControllerEsp.text,
            contenidoEng: _contenidoControllerEng.text,
            selectedEquipment: _selectedEquipment,
            selectedSports: _selectedSports,
            nivelDeImpactoEsp: _nivelDeImpactoEsp,
            nivelDeImpactoEng: _nivelDeImpactoEng,
            ejercicioParaEsp: _ejercicioParaEsp,
            ejercicioParaEng: _ejercicioParaEng,
            faseDeTemporadaEsp: _faseDeTemporadaEsp,
            faseDeTemporadaEng: _faseDeTemporadaEng,
            faseDeEjercicioEsp: _faseDeEjercicioEsp,
            faseDeEjercicioEng: _faseDeEjercicioEng,
            stanceEsp: _stanceEsp,
            stanceEng: _stanceEng,
            articulacionPrincipalEsp: _articulacionPrincipalEsp,
            articulacionPrincipalEng: _articulacionPrincipalEng,
            zonaPrincipalInvolucradaEsp: _zonaPrincipalInvolucradaEsp,
            zonaPrincipalInvolucradaEng: _zonaPrincipalInvolucradaEng,
            difficultyEsp: _difficultyEsp,
            difficultyEng: _difficultyEng,
            intensityEsp: _intensityEsp,
            intensityEng: _intensityEng,
            video: _videoController.text,
            descripcionEsp: _descriptionControllerEsp.text,
            descripcionEng: _descriptionControllerEng.text,
            imageUrl: _imageUrl,
            membershipEsp: _membershipEsp,
            membershipEng: _membershipEng,
          );

          _showSuccessSnackbar(context);
          _clearFields();
          Navigator.pop(context, true);
        } else {
          _showErrorSnackbar(context);
        }
      },
    );
  }

  Widget _buildCustomButton(
      BuildContext context, String translationKey, VoidCallback onPressed) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;

    final Color backgroundColor = isDarkTheme
        ? AppColors.deepPurpleColor
        : AppColors.lightBlueAccentColor;
    const Color textColor = Colors.white;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        textStyle: theme.textTheme.titleLarge?.copyWith(color: textColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(color: backgroundColor),
        elevation: 5,
      ),
      child: Text(AppLocalizations.of(context)!.translate(translationKey)),
    );
  }

  void _showSuccessSnackbar(BuildContext context) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.translate('mejPreLesionesAdded'),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 24.0,
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.translate('publishErrorMessage'),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 24.0,
    );
  }

  void _clearFields() {
    _nameControllerEsp.clear();
    _nameControllerEng.clear();
    _contenidoControllerEsp.clear();
    _contenidoControllerEng.clear();
    _nivelDeImpactoEsp = 'Bajo';
    _nivelDeImpactoEng = 'Low';
    _stanceEng = 'Parado';
    _stanceEng = 'Standing';
    _articulacionPrincipalEsp = 'Tobillo';
    _articulacionPrincipalEng = 'ankle';
    _zonaPrincipalInvolucradaEsp = 'Superior';
    _zonaPrincipalInvolucradaEng = 'Upper Body';
    _difficultyEsp = 'Fácil';
    _difficultyEng = 'Easy';
    _intensityEng = 'Ascending';
    _intensityEsp = 'Ascendente';
    _videoController.clear();
    _descriptionControllerEsp.clear();
    _descriptionControllerEng.clear();
    setState(() {
      _imageUrl = '';
      _membershipEsp = 'Gratis';
      _membershipEng = 'Free';
      _selectedEquipment.clear();
      _selectedSports.clear();
      _ejercicioParaEsp = ['Técnica'];
      _ejercicioParaEng = ['Technique'];
      _faseDeTemporadaEsp = ['Pre Temporada'];
      _faseDeTemporadaEng = ['Pre-Season'];
      _faseDeEjercicioEsp = ['Pre-Inicial'];
      _faseDeEjercicioEng = ['Pre-Initial'];
    });
  }
}
