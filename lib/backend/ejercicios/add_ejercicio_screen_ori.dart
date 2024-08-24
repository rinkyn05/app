// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../functions/ejercicios/add_ejercicios_functions copy.dart';
import '../../functions/ejercicios/body_part_in_ejercicio_functions.dart';
import '../../functions/ejercicios/cat_ejercicio_in_ejercicio_functions.dart';
import '../../functions/ejercicios/equipment_in_ejercicio_functions.dart';
import '../../functions/ejercicios/objetivo_in_ejercicio_functions.dart';
import '../../functions/ejercicios/unequipment_in_ejercicio_functions.dart';
import '../../functions/role_checker.dart';
import '../../functions/upload_exercise_image.dart';
import '../models/bodypart_in_ejercicio_model.dart';
import '../models/equipment_in_ejercicio_model.dart';
import '../models/objetivos_in_ejercicio_model.dart';
import '../models/selected_cat_ejercicio_model.dart';
import '../models/unequipment_in_ejercicio_model.dart';

class AddEjercicioScreen extends StatefulWidget {
  const AddEjercicioScreen({Key? key}) : super(key: key);

  @override
  AddEjercicioScreenState createState() => AddEjercicioScreenState();
}

class AddEjercicioScreenState extends State<AddEjercicioScreen> {
  final TextEditingController _nameControllerEsp = TextEditingController();
  final TextEditingController _nameControllerEng = TextEditingController();
  final TextEditingController _descriptionControllerEsp =
      TextEditingController();
  final TextEditingController _descriptionControllerEng =
      TextEditingController();
  final TextEditingController _contenidoControllerEsp = TextEditingController();
  final TextEditingController _contenidoControllerEng = TextEditingController();
  final TextEditingController _caloriasController = TextEditingController();
  final TextEditingController _repeticionesController = TextEditingController();
  final TextEditingController _videoController = TextEditingController();

  String _imageUrl = '';
  final List<SelectedObjetivos> _selectedObjetivos = [];
  Map<String, Map<String, String>> objetivosNames = {};

  final List<SelectedEquipment> _selectedEquipment = [];
  Map<String, Map<String, String>> equipmentNames = {};

  final List<SelectedUnequipment> _selectedUnequipment = [];
  Map<String, Map<String, String>> unequipmentNames = {};

  final List<SelectedBodyPart> _selectedBodyPart = [];
  Map<String, Map<String, String>> bodypartNames = {};

  final List<SelectedCatEjercicio> _selectedCatEjercicio = [];
  Map<int, Map<String, String>> catEjercicioNames = {};

  String _intensityEsp = 'Baja';
  String _intensityEng = 'Low';

  String _stanceEsp = 'Parado';
  String _stanceEng = 'Standing';

  String _membershipEsp = 'Gratis';
  String _membershipEng = 'Free';

  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadBodyPartNames();
    _loadCatEjercicioNames();
    _loadObjetivosNames();
    _loadEquipmentNames();
    _loadUnequipmentNames();
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

  void _loadObjetivosNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('objetivos').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      objetivosNames = tempMap;
    });
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

  void _loadUnequipmentNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('unequipment').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      unequipmentNames = tempMap;
    });
  }

  void _loadBodyPartNames() async {
    var snapshot = await FirebaseFirestore.instance.collection('bodyp').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      bodypartNames = tempMap;
    });
  }

  void _loadCatEjercicioNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('catEjercicio').get();
    Map<int, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      int id = int.tryParse(doc.id) ?? 0;
      tempMap[id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      catEjercicioNames = tempMap;
    });
  }

  void _addObjetivos(String objetivosId) {
    if (!_selectedObjetivos.any((selected) => selected.id == objetivosId)) {
      String objetivosEsp =
          objetivosNames[objetivosId]?['Esp'] ?? 'Nombre no disponible';
      String objetivosEng =
          objetivosNames[objetivosId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedObjetivos.add(SelectedObjetivos(
          id: objetivosId,
          objetivosEsp: objetivosEsp,
          objetivosEng: objetivosEng,
        ));
      });
    }
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

  void _addUnequipment(String unequipmentId) {
    if (!_selectedUnequipment.any((selected) => selected.id == unequipmentId)) {
      String unequipmentEsp =
          unequipmentNames[unequipmentId]?['Esp'] ?? 'Nombre no disponible';
      String unequipmentEng =
          unequipmentNames[unequipmentId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedUnequipment.add(SelectedUnequipment(
          id: unequipmentId,
          unequipmentEsp: unequipmentEsp,
          unequipmentEng: unequipmentEng,
        ));
      });
    }
  }

  void _addBodyPart(String bodypartId) {
    if (!_selectedBodyPart.any((selected) => selected.id == bodypartId)) {
      String bodypartEsp =
          bodypartNames[bodypartId]?['Esp'] ?? 'Nombre no disponible';
      String bodypartEng =
          bodypartNames[bodypartId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedBodyPart.add(SelectedBodyPart(
          id: bodypartId,
          bodypartEsp: bodypartEsp,
          bodypartEng: bodypartEng,
        ));
      });
    }
  }

  void _addCatEjercicio(int catEjercicioId) {
    if (!_selectedCatEjercicio
        .any((selected) => selected.id == catEjercicioId)) {
      String catEjercicioEsp =
          catEjercicioNames[catEjercicioId]?['Esp'] ?? 'Nombre no disponible';
      String catEjercicioEng =
          catEjercicioNames[catEjercicioId]?['Eng'] ?? 'Nombre no disponible';
      setState(() {
        _selectedCatEjercicio.add(SelectedCatEjercicio(
          id: catEjercicioId,
          nombreEsp: catEjercicioEsp,
          nombreEng: catEjercicioEng,
        ));
      });
    }
  }

  void _removeObjetivos(String objetivosId) {
    setState(() {
      _selectedObjetivos
          .removeWhere((objetivos) => objetivos.id == objetivosId);
    });
  }

  void _removeEquipment(String equipmentId) {
    setState(() {
      _selectedEquipment
          .removeWhere((equipment) => equipment.id == equipmentId);
    });
  }

  void _removeUnequipment(String unequipmentId) {
    setState(() {
      _selectedUnequipment
          .removeWhere((unequipment) => unequipment.id == unequipmentId);
    });
  }

  void _removeBodyPart(String bodypartId) {
    setState(() {
      _selectedBodyPart.removeWhere((bodypart) => bodypart.id == bodypartId);
    });
  }

  void _removeCatEjercicio(int catEjercicioId) {
    setState(() {
      _selectedCatEjercicio
          .removeWhere((catEjercicio) => catEjercicio.id == catEjercicioId);
    });
  }

  Widget _buildMembershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseMembership'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildMembershipSelector(),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        bool selected = isEsp
            ? option == currentMembership
            : membershipMapEspToEng[_membershipEsp] == option;

        return ChoiceChip(
          label: Text(option),
          selected: selected,
          onSelected: (bool isSelected) {
            setState(() {
              if (isEsp) {
                _membershipEsp = option;
                _membershipEng = membershipMapEspToEng[option]!;
              } else {
                _membershipEng = option;
                _membershipEsp = membershipMapEngToEsp[option]!;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseIntensity'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildIntensitySelector(),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Baja', 'Media', 'Alta'];
    List<String> optionsEng = ['Low', 'Medium', 'High'];

    Map<String, String> intensityMapEspToEng = {
      'Baja': 'Low',
      'Media': 'Medium',
      'Alta': 'High',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Low': 'Baja',
      'Medium': 'Media',
      'High': 'Alta',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        bool selected;
        if (isEsp) {
          selected = _intensityEsp == option;
        } else {
          String? equivalentInEng = intensityMapEspToEng[_intensityEsp];
          selected = equivalentInEng == option;
        }
        return ChoiceChip(
          label: Text(option),
          selected: selected,
          onSelected: (bool isSelected) {
            setState(() {
              if (isEsp) {
                _intensityEsp = option;
                _intensityEng = intensityMapEspToEng[option]!;
              } else {
                _intensityEng = option;
                _intensityEsp = intensityMapEngToEsp[option]!;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTimeSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('selectTime'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildTimeSelector(),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _selectedMinutes,
              items: List.generate(60, (index) => index)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Center(child: Text("$value min")),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedMinutes = newValue!;
                });
              },
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _selectedSeconds,
              items: List.generate(60, (index) => index)
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Center(
                      child: Text("${value.toString().padLeft(2, '0')} seg")),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSeconds = newValue!;
                });
              },
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exerciseStance'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildStanceSelector(),
      ],
    );
  }

  Widget _buildStanceSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Parado',
      'Sentado',
      'Acostado',
      'Saltando',
      'Corriendo'
    ];
    List<String> optionsEng = [
      'Standing',
      'Sitting',
      'Lying Down',
      'Jumping',
      'Running'
    ];

    Map<String, String> stanceMapEspToEng = {
      'Parado': 'Standing',
      'Sentado': 'Sitting',
      'Acostado': 'Lying Down',
      'Saltando': 'Jumping',
      'Corriendo': 'Running',
    };

    Map<String, String> stanceMapEngToEsp = {
      'Standing': 'Parado',
      'Sitting': 'Sentado',
      'Lying Down': 'Acostado',
      'Jumping': 'Saltando',
      'Running': 'Corriendo',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.spaceEvenly,
      children: options.map((option) {
        bool selected;
        if (isEsp) {
          selected = _stanceEsp == option;
        } else {
          String? equivalentInEng = stanceMapEspToEng[_stanceEsp];
          selected = equivalentInEng == option;
        }
        return ChoiceChip(
          label: Text(option),
          selected: selected,
          onSelected: (bool isSelected) {
            setState(() {
              if (isEsp) {
                _stanceEsp = option;
                _stanceEng = stanceMapEspToEng[option]!;
              } else {
                _stanceEng = option;
                _stanceEsp = stanceMapEngToEsp[option]!;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSelectedObjetivos(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('ocjetives'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedObjetivos.map((objetivos) {
            String objetivosName = langKey == 'Esp'
                ? objetivos.objetivosEsp
                : objetivos.objetivosEng;
            return Chip(
              label: Text(objetivosName),
              onDeleted: () => _removeObjetivos(objetivos.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedEquipment(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('equipments'),
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

  Widget _buildSelectedUnequipment(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('unequipments'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedUnequipment.map((unequipment) {
            String unequipmentName = langKey == 'Esp'
                ? unequipment.unequipmentEsp
                : unequipment.unequipmentEng;
            return Chip(
              label: Text(unequipmentName),
              onDeleted: () => _removeUnequipment(unequipment.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedBodyPart(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('bodyParts'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedBodyPart.map((bodypart) {
            String bodypartName =
                langKey == 'Esp' ? bodypart.bodypartEsp : bodypart.bodypartEng;
            return Chip(
              label: Text(bodypartName),
              onDeleted: () => _removeBodyPart(bodypart.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedCatEjercicio(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('catEjercicios'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedCatEjercicio.map((catEjercicio) {
            String catEjercicioName = langKey == 'Esp'
                ? catEjercicio.nombreEsp
                : catEjercicio.nombreEng;
            return Chip(
              label: Text(catEjercicioName),
              onDeleted: () => _removeCatEjercicio(catEjercicio.id),
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
          title: Text(AppLocalizations.of(context)!.translate('addEjercicio')),
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
            _buildEjercicioForm(
                _nameControllerEsp,
                _descriptionControllerEsp,
                _contenidoControllerEsp,
                _caloriasController,
                _repeticionesController,
                _videoController,
                _intensityEsp,
                _stanceEsp,
                _membershipEsp,
                'Esp'),
            _buildEjercicioForm(
                _nameControllerEng,
                _descriptionControllerEng,
                _contenidoControllerEng,
                _caloriasController,
                _repeticionesController,
                _videoController,
                _intensityEng,
                _stanceEng,
                _membershipEng,
                'Eng'),
          ],
        ),
      ),
    );
  }

  Widget _buildEjercicioForm(
      TextEditingController nameController,
      TextEditingController descriptionController,
      TextEditingController contenidoController,
      TextEditingController caloriasController,
      TextEditingController videoController,
      TextEditingController repeticionesController,
      String intensity,
      String stance,
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
                AppLocalizations.of(context)!.translate('ejercicioName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('ejercicioName')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterEjercicioName'),
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
                AppLocalizations.of(context)!.translate('ejercicioDescription'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('ejercicioDescription')} ($langKey)',
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('content'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: contenidoController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('content')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterContent'),
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
                AppLocalizations.of(context)!.translate('repeticionesName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: videoController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('repeticionesName')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterRepeticionesName'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('caloriasName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: caloriasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('caloriasName')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterCaloriasName'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('videoLink'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: repeticionesController,
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
            const SizedBox(height: 15),
            _buildMembershipSection(),
            const SizedBox(height: 15),
            _buildIntensitySection(),
            const SizedBox(height: 15),
            _buildStanceSection(),
            const SizedBox(height: 15),
            _buildTimeSelectionSection(),
            const SizedBox(height: 15),
            _buildSelectedBodyPart(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future:
                  BodyPartInEjercicioFunctions().getSimplifiedBodyPart(langKey),
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
                            .translate('selectBodyPart'),
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
                              .translate('selectBodyPart')),
                          onChanged: (String? newValue) {
                            _addBodyPart(newValue!);
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
            const SizedBox(height: 20),
            _buildSelectedCatEjercicio(langKey),
            FutureBuilder<List<DropdownMenuItem<int>>>(
              future: CatEjercicioInEjercicioFunctions()
                  .getSimplifiedCatEjercicio(langKey),
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
                            .translate('selectCatEjercicio'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text(AppLocalizations.of(context)!
                              .translate('selectCatEjercicio')),
                          onChanged: (int? newValue) {
                            _addCatEjercicio(newValue!);
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
            const SizedBox(height: 20),
            _buildSelectedObjetivos(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: ObjetivosInEjercicioFunctions()
                  .getSimplifiedObjetivos(langKey),
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
                            .translate('selectObjetivo'),
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
                              .translate('selectObjetivos')),
                          onChanged: (String? newValue) {
                            _addObjetivos(newValue!);
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
            const SizedBox(height: 20),
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
                            .translate('selectEquipment'),
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
                              .translate('selectEquipment')),
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
            const SizedBox(height: 20),
            _buildSelectedUnequipment(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: UnequipmentInEjercicioFunctions()
                  .getSimplifiedUnequipment(langKey),
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
                            .translate('selectUnequipment'),
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
                              .translate('selectUnequipment')),
                          onChanged: (String? newValue) {
                            _addUnequipment(newValue!);
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('image'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildImageUploadButton(),
            const SizedBox(height: 20),
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

  Widget _buildImageUploadButton() {
    return _buildCustomButton(
      context,
      'Subir Imagen',
      () async {
        await uploadExerciseImage(context, (String url) {
          setState(() {
            _imageUrl = url;
          });
        });
      },
    );
  }

  Widget _buildPublishButton() {
    return _buildCustomButton(
      context,
      'Publicar',
      () async {
        String formattedTime =
            '${_selectedMinutes.toString().padLeft(2, '0')}:${_selectedSeconds.toString().padLeft(2, '0')}';
        if (_nameControllerEsp.text.isNotEmpty &&
            _descriptionControllerEsp.text.isNotEmpty &&
            _contenidoControllerEsp.text.isNotEmpty &&
            _videoController.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _descriptionControllerEng.text.isNotEmpty &&
            _contenidoControllerEng.text.isNotEmpty &&
            _caloriasController.text.isNotEmpty &&
            _repeticionesController.text.isNotEmpty &&
            _imageUrl.isNotEmpty &&
            _selectedObjetivos.isNotEmpty &&
            _selectedEquipment.isNotEmpty &&
            _selectedUnequipment.isNotEmpty &&
            _selectedBodyPart.isNotEmpty &&
            _selectedCatEjercicio.isNotEmpty &&
            _membershipEsp.isNotEmpty &&
            _membershipEng.isNotEmpty &&
            _intensityEsp.isNotEmpty &&
            _intensityEng.isNotEmpty &&
            _stanceEsp.isNotEmpty &&
            _stanceEng.isNotEmpty) {
          await AddEjercicioFunctions().addEjercicioWithAutoIncrementId(
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            descripcionEsp: _descriptionControllerEsp.text,
            descripcionEng: _descriptionControllerEng.text,
            contenidoEsp: _contenidoControllerEsp.text,
            calorias: _caloriasController.text,
            repeticiones: _repeticionesController.text,
            contenidoEng: _contenidoControllerEng.text,
            video: _videoController.text,
            imageUrl: _imageUrl,
            selectedObjetivos: _selectedObjetivos,
            selectedEquipment: _selectedEquipment,
            selectedUnequipment: _selectedUnequipment,
            selectedBodyPart: _selectedBodyPart,
            selectedCatEjercicio: _selectedCatEjercicio,
            membershipEsp: _membershipEsp,
            membershipEng: _membershipEng,
            intensityEsp: _intensityEsp,
            intensityEng: _intensityEng,
            stanceEsp: _stanceEsp,
            stanceEng: _stanceEng,
            duracion: formattedTime,
          );
          _showSuccessSnackbar(context);
          _clearFields();
          _sendCountToTotalExercises();
          Navigator.pop(context, true);
        } else {
          _showErrorSnackbar(context);
        }
      },
    );
  }

  void _sendCountToTotalExercises() async {
    try {
      final totalExercisesRef = FirebaseFirestore.instance
          .collection('totalexercises')
          .doc('contador');
      await totalExercisesRef.set({
        'total': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (error) {
      //print('Error al enviar el conteo a totalexercises: $error');
    }
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
      msg: AppLocalizations.of(context)!.translate('ejercicioAdded'),
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
    _descriptionControllerEsp.clear();
    _descriptionControllerEng.clear();
    _contenidoControllerEsp.clear();
    _contenidoControllerEng.clear();
    _videoController.clear();
    _caloriasController.clear();
    _repeticionesController.clear();
    _intensityEng = 'Low';
    _intensityEsp = 'Baja';
    _stanceEng = 'Parado';
    _stanceEng = 'Standing';
    _membershipEsp = 'Gratis';
    _membershipEng = 'Free';
    setState(() {
      _imageUrl = '';
      _selectedObjetivos.clear();
      _selectedEquipment.clear();
      _selectedUnequipment.clear();
      _selectedBodyPart.clear();
      _selectedCatEjercicio.clear();
    });
  }
}
