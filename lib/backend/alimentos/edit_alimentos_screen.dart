// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/alimentos/update_alimentos_functions.dart';

import '../../functions/role_checker.dart';
import '../../functions/upload_exercise_image.dart';

class EditAlimentosScreen extends StatefulWidget {
  final String alimentosId;
  final Map<String, dynamic> alimentosData;

  const EditAlimentosScreen(
      {Key? key, required this.alimentosId, required this.alimentosData})
      : super(key: key);

  @override
  EditAlimentosScreenState createState() => EditAlimentosScreenState();
}

class EditAlimentosScreenState extends State<EditAlimentosScreen> {
  final TextEditingController _nameControllerEsp = TextEditingController();
  final TextEditingController _nameControllerEng = TextEditingController();
  final TextEditingController _contenidoControllerEsp = TextEditingController();
  final TextEditingController _contenidoControllerEng = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _caloriasController = TextEditingController();
  final TextEditingController _proteinaController = TextEditingController();
  final TextEditingController _porcionController = TextEditingController();
  final TextEditingController _gSaturadasController = TextEditingController();
  final TextEditingController _gMonoinsaturadasController =
      TextEditingController();
  final TextEditingController _gPoliinsaturadasController =
      TextEditingController();
  final TextEditingController _gHidrogenadasController =
      TextEditingController();
  final TextEditingController _grasaController = TextEditingController();
  final TextEditingController _carbohidratoController = TextEditingController();
  final TextEditingController _vitaminaController = TextEditingController();
  final TextEditingController _fibraController = TextEditingController();
  final TextEditingController _azucarController = TextEditingController();
  final TextEditingController _sodioController = TextEditingController();

  String _categoryEsp = 'Vegetal';
  String _categoryEng = 'Vegetable';

  String _membershipEsp = 'Gratis';
  String _membershipEng = 'Free';

  String _tipoEsp = 'Simple';
  String _tipoEng = 'Simple';

  String _tipoGrasaEsp = 'Saturadas';
  String _tipoGrasaEng = 'Saturated';

  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeFields();
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

  Future<void> _initializeFields() async {
    _nameControllerEsp.text = widget.alimentosData['NombreEsp'] ?? '';
    _nameControllerEng.text = widget.alimentosData['NombreEng'] ?? '';
    _contenidoControllerEsp.text = widget.alimentosData['ContenidoEsp'] ?? '';
    _contenidoControllerEng.text = widget.alimentosData['ContenidoEng'] ?? '';
    _imageUrl = widget.alimentosData['URL de la Imagen'] ?? '';
    _videoController.text = widget.alimentosData['Video'] ?? '';
    _caloriasController.text = widget.alimentosData['Calorias'] ?? '';
    _proteinaController.text = widget.alimentosData['Proteina'] ?? '';
    _porcionController.text = widget.alimentosData['Porcion'] ?? '';
    _gSaturadasController.text = widget.alimentosData['GrasaSaturadas'] ?? '';
    _gMonoinsaturadasController.text =
        widget.alimentosData['GrasaMonoinsaturadas'] ?? '';
    _gPoliinsaturadasController.text =
        widget.alimentosData['GrasaPoliinsaturadas'] ?? '';
    _gHidrogenadasController.text =
        widget.alimentosData['GrasaHidrogenadas'] ?? '';
    _grasaController.text = widget.alimentosData['Grasa'] ?? '';
    _carbohidratoController.text = widget.alimentosData['Carbohidrato'] ?? '';
    _vitaminaController.text = widget.alimentosData['Vitamina'] ?? '';
    _fibraController.text = widget.alimentosData['Fibra'] ?? '';
    _azucarController.text = widget.alimentosData['Azucar'] ?? '';
    _sodioController.text = widget.alimentosData['Sodio'] ?? '';
    _categoryEsp = widget.alimentosData['CategoryEsp'] ?? 'Vegetal';
    _categoryEng = widget.alimentosData['CategoryEng'] ?? 'Vegetable';
    _membershipEsp = widget.alimentosData['MembershipEsp'] ?? 'Gratis';
    _membershipEng = widget.alimentosData['MembershipEng'] ?? 'Free';
    _tipoEsp = widget.alimentosData['TipoEsp'] ?? 'Simple';
    _tipoEng = widget.alimentosData['TipoEng'] ?? 'Simple';
    _tipoGrasaEsp = widget.alimentosData['TipoGrasaEsp'] ?? 'Saturadas';
    _tipoGrasaEng = widget.alimentosData['TipoGrasaEng'] ?? 'Saturated';
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('categories'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildCategorySelector(),
      ],
    );
  }

  Widget _buildCategorySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Vegetal', 'Animal', 'Ninguno'];
    List<String> optionsEng = ['Vegetable', 'Animals', 'Ninguno'];

    Map<String, String> categoryMapEspToEng = {
      'Vegetal': 'Vegetable',
      'Animal': 'Animals',
      'Ninguno': 'Ninguno',
    };

    Map<String, String> categoryMapEngToEsp = {
      'Vegetable': 'Vegetal',
      'Animals': 'Animal',
      'Ninguno': 'Ninguno',
    };

    String currentCategory = isEsp ? _categoryEsp : _categoryEng;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: isEsp
          ? optionsEsp.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: option == currentCategory,
                onSelected: (bool isSelected) {
                  setState(() {
                    _categoryEsp = option;
                    _categoryEng = categoryMapEspToEng[option]!;
                  });
                },
              );
            }).toList()
          : optionsEng.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: option == currentCategory,
                onSelected: (bool isSelected) {
                  setState(() {
                    _categoryEng = option;
                    _categoryEsp = categoryMapEngToEsp[option]!;
                  });
                },
              );
            }).toList(),
    );
  }

  Widget _buildMembershipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('Membership'),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: (isEsp ? optionsEsp : optionsEng).map((option) {
        bool selected =
            isEsp ? option == _membershipEsp : option == _membershipEng;

        return ChoiceChip(
          label: Text(option),
          selected: selected,
          onSelected: (bool isSelected) {
            setState(() {
              if (isEsp) {
                _membershipEsp = option;
                _membershipEng =
                    membershipMapEspToEng[option] ?? _membershipEng;
              } else {
                _membershipEng = option;
                _membershipEsp =
                    membershipMapEngToEsp[option] ?? _membershipEsp;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTipoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('alimentosTipo'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildTipoSelector(),
      ],
    );
  }

  Widget _buildTipoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Simple', 'Complejo', 'Ninguno'];
    List<String> optionsEng = ['Simple', 'Complex', 'Ninguno'];

    Map<String, String> tipoMapEspToEng = {
      'Simple': 'Simple',
      'Complejo': 'Complex',
      'Ninguno': 'Ninguno',
    };

    Map<String, String> tipoMapEngToEsp = {
      'Simple': 'Simple',
      'Complex': 'Complejo',
      'Ninguno': 'Ninguno',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        bool selected;
        if (isEsp) {
          selected = _tipoEsp == option;
        } else {
          String? equivalentInEng = tipoMapEspToEng[_tipoEsp];
          selected = equivalentInEng == option;
        }
        return ChoiceChip(
          label: Text(option),
          selected: selected,
          onSelected: (bool isSelected) {
            setState(() {
              if (isEsp) {
                _tipoEsp = option;
                _tipoEng = tipoMapEspToEng[option]!;
              } else {
                _tipoEng = option;
                _tipoEsp = tipoMapEngToEsp[option]!;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTipoGrasaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('alimentosTipoGrasa'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _buildTipoGrasaSelector(),
      ],
    );
  }

  Widget _buildTipoGrasaSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Saturadas',
      'Insaturadas',
      'Hidrogenadas',
      'Ninguno'
    ];
    List<String> optionsEng = [
      'Saturated',
      'Unsatured',
      'Hydrogenated',
      'Ninguno'
    ];

    Map<String, String> tipoGrasaMapEspToEng = {
      'Saturadas': 'Saturated',
      'Insaturadas': 'Unsatured',
      'Hidrogenadas': 'Hydrogenated',
      'Ninguno': 'Ninguno',
    };

    Map<String, String> tipoGrasaMapEngToEsp = {
      'Saturated': 'Saturadas',
      'Unsatured': 'Insaturadas',
      'Hydrogenated': 'Hidrogenadas',
      'Ninguno': 'Ninguno',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options.map((option) {
          bool selected;
          if (isEsp) {
            selected = _tipoGrasaEsp == option;
          } else {
            String? equivalentInEng = tipoGrasaMapEspToEng[_tipoEsp];
            selected = equivalentInEng == option;
          }
          return ChoiceChip(
            label: Text(option),
            selected: selected,
            onSelected: (bool isSelected) {
              setState(() {
                if (isEsp) {
                  _tipoGrasaEsp = option;
                  _tipoGrasaEng = tipoGrasaMapEspToEng[option]!;
                } else {
                  _tipoGrasaEng = option;
                  _tipoGrasaEsp = tipoGrasaMapEngToEsp[option]!;
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(text: AppLocalizations.of(context)!.translate('español')),
      Tab(text: AppLocalizations.of(context)!.translate('english')),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(AppLocalizations.of(context)!.translate('EditAlimento')),
          bottom: TabBar(
            tabs: tabs,
            labelStyle:
                Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 26),
            unselectedLabelColor:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Colors.white70,
            labelColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            indicatorColor: AppColors.lightBlueAccentColor,
            indicatorWeight: 3,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: TabBarView(
          children: [
            _buildAlimentosForm('Esp'),
            _buildAlimentosForm('Eng'),
          ],
        ),
      ),
    );
  }

  Widget _buildAlimentosForm(String langKey) {
    TextEditingController nameController =
        langKey == 'Esp' ? _nameControllerEsp : _nameControllerEng;
    TextEditingController contenidoController =
        langKey == 'Esp' ? _contenidoControllerEsp : _contenidoControllerEng;

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
                AppLocalizations.of(context)!.translate('food'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('food')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterFoodName'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
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
                    AppLocalizations.of(context)!.translate('startTyping'),
                border: borderStyle,
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                      color: AppColors.lightBlueAccentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade300,
              ),
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
              controller: _videoController,
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
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.translate('calories'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _caloriasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('calories')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterCaloriesName'),
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
                AppLocalizations.of(context)!.translate('protein'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _proteinaController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('protein')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterProteinName'),
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
                AppLocalizations.of(context)!.translate('porcionName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _porcionController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('porcionName')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterPorcionName'),
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
                AppLocalizations.of(context)!.translate('saturatedfats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _gSaturadasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('saturatedfats')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterGrasaName'),
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
                AppLocalizations.of(context)!.translate('MonoinsaturadasFats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _gMonoinsaturadasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('MonoinsaturadasFats')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterGrasaName'),
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
                AppLocalizations.of(context)!.translate('PoliinsaturadasFats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _gPoliinsaturadasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('PoliinsaturadasFats')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterGrasaName'),
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
                AppLocalizations.of(context)!.translate('Hydrofats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _gHidrogenadasController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('Hydrofats')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterGrasaName'),
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
                AppLocalizations.of(context)!.translate('totalFats'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _grasaController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('totalFats')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterGrasaName'),
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
                AppLocalizations.of(context)!.translate('carbohidratoName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _carbohidratoController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('carbohidratoName')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterCarbohidratoName'),
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
                AppLocalizations.of(context)!.translate('vitaminaName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _vitaminaController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('vitaminaName')} ($langKey)',
                hintText: AppLocalizations.of(context)!
                    .translate('enterVitaminaName'),
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
                AppLocalizations.of(context)!.translate('fibraName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _fibraController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('fibraName')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterFibraName'),
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
                AppLocalizations.of(context)!.translate('azucarName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _azucarController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('azucarName')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterAzucarName'),
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
                AppLocalizations.of(context)!.translate('sodioName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: _sodioController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('sodioName')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterAzucarName'),
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
            const SizedBox(height: 15),
            _buildMembershipSection(),
            const SizedBox(height: 15),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildTipoSection(),
            const SizedBox(height: 20),
            _buildTipoGrasaSection(),
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
      'uploadImage',
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
      'update',
      () async {
        String contenidoEsp = _contenidoControllerEsp.text;
        String contenidoEng = _contenidoControllerEng.text;

        if (_nameControllerEsp.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _videoController.text.isNotEmpty &&
            _caloriasController.text.isNotEmpty &&
            _proteinaController.text.isNotEmpty &&
            _porcionController.text.isNotEmpty &&
            _gSaturadasController.text.isNotEmpty &&
            _gMonoinsaturadasController.text.isNotEmpty &&
            _gPoliinsaturadasController.text.isNotEmpty &&
            _gHidrogenadasController.text.isNotEmpty &&
            _grasaController.text.isNotEmpty &&
            _carbohidratoController.text.isNotEmpty &&
            _vitaminaController.text.isNotEmpty &&
            _fibraController.text.isNotEmpty &&
            _azucarController.text.isNotEmpty &&
            _sodioController.text.isNotEmpty &&
            _imageUrl.isNotEmpty &&
            _categoryEsp.isNotEmpty &&
            _categoryEng.isNotEmpty &&
            _tipoEsp.isNotEmpty &&
            _tipoEng.isNotEmpty &&
            _membershipEsp.isNotEmpty &&
            _membershipEng.isNotEmpty &&
            _tipoGrasaEsp.isNotEmpty &&
            _tipoGrasaEng.isNotEmpty) {
          await UpdateAlimentosFunctions().updateAlimentos(
            id: widget.alimentosId,
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            contenidoEsp: contenidoEsp,
            contenidoEng: contenidoEng,
            video: _videoController.text,
            calorias: _caloriasController.text,
            proteina: _proteinaController.text,
            porcion: _porcionController.text,
            gsaturadas: _gSaturadasController.text,
            gMonoinsaturadas: _gMonoinsaturadasController.text,
            gPoliinsaturadas: _gPoliinsaturadasController.text,
            gHidrogenadas: _gHidrogenadasController.text,
            grasa: _grasaController.text,
            carbohidrato: _carbohidratoController.text,
            vitamina: _vitaminaController.text,
            fibra: _fibraController.text,
            azucar: _azucarController.text,
            sodio: _sodioController.text,
            categoryEsp: _categoryEsp,
            categoryEng: _categoryEng,
            tipoEsp: _tipoEsp,
            tipoEng: _tipoEng,
            tipoGrasaEsp: _tipoGrasaEsp,
            tipoGrasaEng: _tipoGrasaEng,
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
      msg: AppLocalizations.of(context)!.translate('alimentoUpdated'),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 24.0,
    );
  }

  void _showErrorSnackbar(BuildContext context) {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.translate('updateErrorMessage'),
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
    _videoController.clear();
    _caloriasController.clear();
    _proteinaController.clear();
    _porcionController.clear();
    _gSaturadasController.clear();
    _gMonoinsaturadasController.clear();
    _gPoliinsaturadasController.clear();
    _gHidrogenadasController.clear();
    _grasaController.clear();
    _carbohidratoController.clear();
    _vitaminaController.clear();
    _fibraController.clear();
    _azucarController.clear();
    _sodioController.clear();
    _categoryEng = 'Low';
    _categoryEsp = 'Baja';
    _membershipEsp = 'Gratis';
    _membershipEng = 'Free';
    _contenidoControllerEsp.clear();
    _contenidoControllerEng.clear();
    _tipoEsp = 'Simple';
    _tipoEng = 'Simple';
    _tipoGrasaEsp = 'Saturada';
    _tipoGrasaEng = 'Saturated';
    _imageUrl = '';
  }
}
