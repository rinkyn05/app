// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../functions/ejercicios/add_ejercicios_functions.dart';
import '../../functions/ejercicios/body_part_in_ejercicio_functions.dart';
import '../../functions/ejercicios/equipment_in_ejercicio_functions.dart';
import '../../functions/ejercicios/objetivo_in_ejercicio_functions.dart';
import '../../functions/role_checker.dart';
import '../../functions/upload_exercise_3d_image.dart';
import '../../functions/upload_exercise_image.dart';
import '../models/bodypart_in_ejercicio_model.dart';
import '../models/equipment_in_ejercicio_model.dart';
import '../models/objetivos_in_ejercicio_model.dart';

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

  final TextEditingController _agonistMuscleController =
      TextEditingController();
  final TextEditingController _antagonistMuscleController =
      TextEditingController();

  final TextEditingController _sinergistnistMuscleController =
      TextEditingController();

  final TextEditingController _estabiliMuscleController =
      TextEditingController();

  final TextEditingController _videoController = TextEditingController();

  final TextEditingController _videoPersonalTController =
      TextEditingController();

  final TextEditingController _videoPObesaController = TextEditingController();

  final TextEditingController _videoPFlacaController = TextEditingController();

  String _imageUrl = '';

  String _image3dUrl = '';

  final List<SelectedObjetivos> _selectedObjetivos = [];
  Map<String, Map<String, String>> objetivosNames = {};

  final List<SelectedEquipment> _selectedEquipment = [];
  Map<String, Map<String, String>> equipmentNames = {};

  final List<SelectedBodyPart> _selectedBodyPart = [];
  Map<String, Map<String, String>> bodypartNames = {};

  String _intensityEsp = 'Fácil';
  String _intensityEng = 'Easy';

  String _nivelDeImpactoEsp = 'Bajo';
  String _nivelDeImpactoEng = 'Low';

  String _phaseEsp = 'Adaptación Anatómica';
  String _phaseEng = 'Anatomical Adaptation';

  String _stanceEsp = 'Parado';
  String _stanceEng = 'Standing';

  String _membershipEsp = 'Gratis';
  String _membershipEng = 'Free';

  List<String> _selectedPhasesEsp = [];
  List<String> _selectedPhasesEng = [];

  Map<String, List<String>> specificMuscleOptions = {
    'deltoide': ['Porción Frontal', 'Porción Media', 'Porción Posterior'],
    'pectoral': ['Porción Alta', 'Porción Media', 'Porción Baja'],
    'espalda': ['Dorsal Ancho', 'Redondo Mayor' 'Trapecio', 'Lumbar'],
    'bíceps': ['Porción Corta', 'Porción  Larga'], // Nuevas opciones para biceps
    'triceps': [
      'Porción Larga',
      'Porción Lateral',
      'Porción Medial'
    ], // Nuevas opciones para triceps
    'antebrazo': ['Flexor', 'Extensor'], // Nuevas opciones para antebrazo
    'abdomen': [
      'Porción Superior',
      'Porción Inferior',
      'Oblicuos'
    ], // Nuevas opciones para abdomen
    'glúteo': ['Porción Mayor', 'Porción Media', 'Porción Baja', 'Abductor'], // Nuevas opciones para glúteo
    'pierna': ['Abductor', 'Adductor'], // Nuevas opciones para pierna
    'cuádriceps': [
      'Vasto Interno',
      'Abductor',
      'Vasto Externo',
      'Recto Femoral'
    ], // Nuevas opciones para cuadriceps
    'pantorrillla': [
      'Gastrocnemio',
      'Soleo',
      'Tibial Anterior'
    ], // Nuevas opciones para pantorrilla
    'cuello': ['Esternocleidomastoideo'],
    'pantorilla': ['Gastrocnemio', 'soleo', 'Tibial Anterior'],
    'Isquiotibiales': ['Semitendinoso', 'Semimembranoso', 'bicep Femoral'],
  };

  final TextEditingController _specificMuscleController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBodyPartNames();
    _loadObjetivosNames();
    _loadEquipmentNames();
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

  void _removeBodyPart(String bodypartId) {
    setState(() {
      _selectedBodyPart.removeWhere((bodypart) => bodypart.id == bodypartId);
    });
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

  Widget _buildIntensitySection() {
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
        _buildIntensitySelector(),
        _buildSelectedIntensity(),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Fácil', 'Medio', 'Avanzado', 'Difícil'];
    List<String> optionsEng = ['Easy', 'Medium', 'Advanced', 'Difficult'];

    Map<String, String> intensityMapEspToEng = {
      'Fácil': 'Easy',
      'Medio': 'Medium',
      'Avanzado': 'Advanced',
      'Difícil': 'Difficult',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Easy': 'Fácil',
      'Medium': 'Medio',
      'Advanced': 'Avanzado',
      'Difficult': 'Difícil',
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
            _intensityEsp = 'Fácil';
            _intensityEng = 'Easy';
          });
        },
      ),
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

  final Map<String, String> phaseMapEspToEng = {
    'Adaptación Anatómica': 'Anatomical Adaptation',
    'Hipertrofia': 'Hypertrophy',
    'Entrenamiento de Fuerza': 'Strength Training',
    'Entrenamiento Mixto': 'Mixed Training',
    'Definición': 'Definition',
    'Transición': 'Transition',
  };

  final Map<String, String> phaseMapEngToEsp = {
    'Anatomical Adaptation': 'Adaptación Anatómica',
    'Hypertrophy': 'Hipertrofia',
    'Strength Training': 'Entrenamiento de Fuerza',
    'Mixed Training': 'Entrenamiento Mixto',
    'Definition': 'Definición',
    'Transition': 'Transición',
  };

  Widget _buildPhaseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate('exercisePhase'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildPhaseSelector(),
        _buildSelectedPhase(),
      ],
    );
  }

  Widget _buildPhaseSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Adaptación Anatómica',
      'Hipertrofia',
      'Entrenamiento de Fuerza',
      'Entrenamiento Mixto',
      'Definición',
      'Transición'
    ];
    List<String> optionsEng = [
      'Anatomical Adaptation',
      'Hypertrophy',
      'Strength Training',
      'Mixed Training',
      'Definition',
      'Transition'
    ];

    List<String> options = isEsp ? optionsEsp : optionsEng;

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
                AppLocalizations.of(context)!.translate('exercisePhase'),
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
                      .translate('selectExercisePhase')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        if (_selectedPhasesEsp.contains(newValue)) {
                          _selectedPhasesEsp.remove(newValue);
                          _selectedPhasesEng
                              .remove(phaseMapEspToEng[newValue]!);
                        } else {
                          _selectedPhasesEsp.add(newValue!);
                          _selectedPhasesEng.add(phaseMapEspToEng[newValue]!);
                        }
                      } else {
                        if (_selectedPhasesEng.contains(newValue)) {
                          _selectedPhasesEng.remove(newValue);
                          _selectedPhasesEsp
                              .remove(phaseMapEngToEsp[newValue]!);
                        } else {
                          _selectedPhasesEng.add(newValue!);
                          _selectedPhasesEsp.add(phaseMapEngToEsp[newValue]!);
                        }
                      }
                    });
                  },
                  items: snapshot.data,
                  value: null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedPhase() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";
    List<String> selectedPhases =
        isEsp ? _selectedPhasesEsp : _selectedPhasesEng;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: selectedPhases.map((phaseName) {
        return Chip(
          label: Text(phaseName),
          onDeleted: () {
            setState(() {
              if (isEsp) {
                _selectedPhasesEsp.remove(phaseName);
                _selectedPhasesEng.remove(phaseMapEspToEng[phaseName]!);
              } else {
                _selectedPhasesEng.remove(phaseName);
                _selectedPhasesEsp.remove(phaseMapEngToEsp[phaseName]!);
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
            AppLocalizations.of(context)!.translate('applicableTo'),
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

  Widget _buildSelectedBodyPart(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('MusculoObjetivo'),
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

  Widget _buildSelectedSpecificMuscle(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_specificMuscleController
            .text.isNotEmpty) // Solo se muestra si hay selección
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!
                  .translate('MuscEspecifico'), // Título para la tarjeta
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        if (_specificMuscleController.text.isNotEmpty)
          Wrap(
            spacing: 8.0,
            children: [
              Chip(
                label: Text(_specificMuscleController
                    .text), // Muestra el músculo específico seleccionado
                onDeleted: () {
                  setState(() {
                    _specificMuscleController.text =
                        ''; // Borra la selección al presionar el botón de eliminar
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  void _updateSpecificMuscleOptions(String selectedMuscle) {
    setState(() {
      _specificMuscleController.clear();
    });
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
                _agonistMuscleController,
                _antagonistMuscleController,
                _sinergistnistMuscleController,
                _estabiliMuscleController,
                _videoController,
                _videoPersonalTController,
                _videoPObesaController,
                _videoPFlacaController,
                _intensityEsp,
                _stanceEsp,
                _phaseEsp,
                _membershipEsp,
                'Esp'),
            _buildEjercicioForm(
                _nameControllerEng,
                _descriptionControllerEng,
                _contenidoControllerEng,
                _agonistMuscleController,
                _antagonistMuscleController,
                _sinergistnistMuscleController,
                _estabiliMuscleController,
                _videoController,
                _videoPersonalTController,
                _videoPObesaController,
                _videoPFlacaController,
                _intensityEng,
                _stanceEng,
                _phaseEng,
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
      TextEditingController agonistMuscleController,
      TextEditingController antagonistMuscleController,
      TextEditingController sinergistnistMuscleController,
      TextEditingController estabiliMuscleController,
      TextEditingController videoController,
      TextEditingController videoPersonalTController,
      TextEditingController videoPObesaController,
      TextEditingController videoPFlacaController,
      String intensity,
      String stance,
      String phase,
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
            const SizedBox(height: 10),
            _buildSelectedBodyPart(langKey),
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future:
                  BodyPartInEjercicioFunctions().getSimplifiedBodyPart(langKey),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Primer Dropdown para "Músculo Objetivo"
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('selectMusculoObjetivo'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          hint: Text(AppLocalizations.of(context)!.translate(
                              'selectMusculoObjetivo')), // Este es el hint que aparecerá
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _addBodyPart(newValue);
                              _updateSpecificMuscleOptions(newValue
                                  .toLowerCase()); // Actualiza el segundo dropdown
                            }
                          },
                          items: snapshot.data,
                          value: _selectedBodyPart.isEmpty
                              ? null // Si no hay selección, se muestra "Seleccionar músculo objetivo"
                              : _selectedBodyPart.last
                                  .id, // Si ya se ha seleccionado, muestra el valor correcto
                        ),
                      ),
                    ),
                    // Mostrar la tarjeta con la selección del músculo objetivo
                    // _buildSelectedBodyPart(
                    //     langKey), // Aquí insertamos la tarjeta para el músculo objetivo

                    // Segundo Dropdown para "Músculo Objetivo Específico"
                    if (_selectedBodyPart.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Músculo Específico',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
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
                                  hint: Text('Selecciona músculo específico'),
                                  value: _specificMuscleController.text.isEmpty
                                      ? null
                                      : _specificMuscleController.text,
                                  items: specificMuscleOptions[_selectedBodyPart
                                          .last.bodypartEsp
                                          .toLowerCase()]
                                      ?.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _specificMuscleController.text =
                                          newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Mostrar la tarjeta con la selección del músculo específico
                    _buildSelectedSpecificMuscle(
                        langKey), // Aquí insertamos la tarjeta para el músculo específico
                  ],
                );
              },
            ),
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
            _buildNivelDeImpactoSection(),
            const SizedBox(height: 10),
            _buildStanceSection(),
            const SizedBox(height: 10),
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
                            .translate('selectApplicableTo'),
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
                              .translate('selectOApplicableTo')),
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
            const SizedBox(height: 10),
            _buildPhaseSection(),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('agonistMuscle'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: agonistMuscleController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('agonistMuscle')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterAgonistMuscle'),
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
                AppLocalizations.of(context)!.translate('antagonistMuscle'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _antagonistMuscleController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('antagonistMuscle')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterAntagonistMuscle'),
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
                AppLocalizations.of(context)!.translate('synergistMuscle'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _sinergistnistMuscleController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('synergistMuscle')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterSynergistMuscle'),
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
                AppLocalizations.of(context)!.translate('stabilizerMuscle'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _estabiliMuscleController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('stabilizerMuscle')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterStabilizerMuscle'),
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
                AppLocalizations.of(context)!.translate('videoPTrainerLink'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: videoPersonalTController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('videoPTrainerLink')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterVideoPTrainerLink'),
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
                AppLocalizations.of(context)!.translate('videoPObesaLink'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: videoPObesaController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('videoPObesaLink')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterVideoPObesaLink'),
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
                AppLocalizations.of(context)!.translate('videoPFlacaLink'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: videoPFlacaController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('videoPFlacaLink')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterVideoPFlacaLink'),
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
                AppLocalizations.of(context)!.translate('image'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildImageUploadButton(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('3dImage'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _build3dImagePreview(),
            const SizedBox(height: 20),
            _build3dImageUploadButton(),
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

  Widget _build3dImagePreview() {
    return InkWell(
      onTap: () async {
        await uploadExercise3DImage(context, (String url) {
          setState(() {
            _image3dUrl = url;
          });
        });
      },
      child: _image3dUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(_image3dUrl, height: 200, fit: BoxFit.cover),
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

  Widget _build3dImageUploadButton() {
    return _buildCustomButton(
      context,
      'Subir Imagen',
      () async {
        await uploadExercise3DImage(context, (String url) {
          setState(() {
            _image3dUrl = url;
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
        if (_nameControllerEsp.text.isNotEmpty &&
            _descriptionControllerEsp.text.isNotEmpty &&
            _contenidoControllerEsp.text.isNotEmpty &&
            _videoController.text.isNotEmpty &&
            _videoPersonalTController.text.isNotEmpty &&
            _videoPObesaController.text.isNotEmpty &&
            _videoPFlacaController.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _descriptionControllerEng.text.isNotEmpty &&
            _contenidoControllerEng.text.isNotEmpty &&
            _agonistMuscleController.text.isNotEmpty &&
            _antagonistMuscleController.text.isNotEmpty &&
            _sinergistnistMuscleController.text.isNotEmpty &&
            _estabiliMuscleController.text.isNotEmpty &&
            _imageUrl.isNotEmpty &&
            _image3dUrl.isNotEmpty &&
            _selectedObjetivos.isNotEmpty &&
            _selectedEquipment.isNotEmpty &&
            _selectedBodyPart.isNotEmpty &&
            _membershipEsp.isNotEmpty &&
            _membershipEng.isNotEmpty &&
            _intensityEsp.isNotEmpty &&
            _intensityEng.isNotEmpty &&
            _phaseEsp.isNotEmpty &&
            _phaseEng.isNotEmpty &&
            _stanceEsp.isNotEmpty &&
            _stanceEng.isNotEmpty) {
          String? specificMuscle = _specificMuscleController.text.isNotEmpty
              ? _specificMuscleController.text
              : null;
          await AddEjercicioFunctions().addEjercicioWithAutoIncrementId(
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            descripcionEsp: _descriptionControllerEsp.text,
            descripcionEng: _descriptionControllerEng.text,
            contenidoEsp: _contenidoControllerEsp.text,
            agonistMuscle: _agonistMuscleController.text,
            antagonistMuscle: _antagonistMuscleController.text,
            sinergistnistMuscle: _sinergistnistMuscleController.text,
            estabiliMuscle: _estabiliMuscleController.text,
            contenidoEng: _contenidoControllerEng.text,
            video: _videoController.text,
            videoPTrain: _videoPersonalTController.text,
            videoPObese: _videoPObesaController.text,
            videoPFlaca: _videoPFlacaController.text,
            imageUrl: _imageUrl,
            image3dUrl: _image3dUrl,
            selectedObjetivos: _selectedObjetivos,
            selectedEquipment: _selectedEquipment,
            selectedBodyPart: _selectedBodyPart,
            membershipEsp: _membershipEsp,
            membershipEng: _membershipEng,
            intensityEsp: _intensityEsp,
            intensityEng: _intensityEng,
            phaseEsp: _phaseEsp,
            phaseEng: _phaseEng,
            stanceEsp: _stanceEsp,
            stanceEng: _stanceEng,
            specificMuscle: specificMuscle,
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
    _videoPersonalTController.clear();
    _videoPObesaController.clear();
    _videoPFlacaController.clear();
    _agonistMuscleController.clear();
    _antagonistMuscleController.clear();
    _sinergistnistMuscleController.clear();
    _estabiliMuscleController.clear();
    _phaseEsp = 'Adaptación Anatómica';
    _phaseEng = 'Anatomical Adaptation';
    _intensityEng = 'Fácil';
    _intensityEsp = 'Easy';
    _stanceEng = 'Parado';
    _stanceEng = 'Standing';
    _membershipEsp = 'Gratis';
    _membershipEng = 'Free';
    setState(() {
      _imageUrl = '';
      _image3dUrl = '';
      _selectedObjetivos.clear();
      _specificMuscleController.clear();
      _selectedEquipment.clear();
      _selectedBodyPart.clear();
    });
  }
}
