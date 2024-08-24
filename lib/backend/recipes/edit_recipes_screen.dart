// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../functions/recipes/update_recipes_functions.dart';

import '../../functions/role_checker.dart';
import '../../functions/upload_exercise_image.dart';

class EditRecipesScreen extends StatefulWidget {
  final String recipesId;
  final Map<String, dynamic> recipesData;

  const EditRecipesScreen(
      {Key? key, required this.recipesId, required this.recipesData})
      : super(key: key);

  @override
  EditRecipesScreenState createState() => EditRecipesScreenState();
}

class EditRecipesScreenState extends State<EditRecipesScreen> {
  final TextEditingController _nameControllerEsp = TextEditingController();
  final TextEditingController _nameControllerEng = TextEditingController();
  final TextEditingController _contenidoControllerEsp = TextEditingController();
  final TextEditingController _contenidoControllerEng = TextEditingController();
  final TextEditingController _videoController = TextEditingController();
  final TextEditingController _caloriasController = TextEditingController();

  String _categoryEsp = 'Vegetal';
  String _categoryEng = 'Vegetable';

  String _membershipEsp = 'Gratis';
  String _membershipEng = 'Free';

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
    _nameControllerEsp.text = widget.recipesData['NombreEsp'] ?? '';
    _nameControllerEng.text = widget.recipesData['NombreEng'] ?? '';
    _contenidoControllerEsp.text = widget.recipesData['ContenidoEsp'] ?? '';
    _contenidoControllerEng.text = widget.recipesData['ContenidoEng'] ?? '';
    _imageUrl = widget.recipesData['URL de la Imagen'] ?? '';
    _videoController.text = widget.recipesData['Video'] ?? '';
    _caloriasController.text = widget.recipesData['Calorias'] ?? '';
    _categoryEsp = widget.recipesData['CategoryEsp'] ?? 'Vegetal';
    _categoryEng = widget.recipesData['CategoryEng'] ?? 'Vegetable';
    _membershipEsp = widget.recipesData['MembershipEsp'] ?? 'Gratis';
    _membershipEng = widget.recipesData['MembershipEng'] ?? 'Free';
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

    List<String> optionsEsp = ['Vegetal', 'Animal'];
    List<String> optionsEng = ['Vegetable', 'Animals'];

    Map<String, String> categoryMapEspToEng = {
      'Vegetal': 'Vegetable',
      'Animal': 'Animals',
    };

    Map<String, String> categoryMapEngToEsp = {
      'Vegetable': 'Vegetal',
      'Animals': 'Animal',
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
            _buildRecipesForm('Esp'),
            _buildRecipesForm('Eng'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesForm(String langKey) {
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
                AppLocalizations.of(context)!.translate('recipe'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    '${AppLocalizations.of(context)!.translate('recipe')} ($langKey)',
                hintText:
                    AppLocalizations.of(context)!.translate('enterRecipeName'),
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
            const SizedBox(height: 15),
            _buildMembershipSection(),
            const SizedBox(height: 15),
            _buildCategorySection(),
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
            _imageUrl.isNotEmpty &&
            _categoryEsp.isNotEmpty &&
            _categoryEng.isNotEmpty &&
            _membershipEsp.isNotEmpty &&
            _membershipEng.isNotEmpty) {
          await UpdateRecipesFunctions().updateRecipes(
            id: widget.recipesId,
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            contenidoEsp: contenidoEsp,
            contenidoEng: contenidoEng,
            video: _videoController.text,
            calorias: _caloriasController.text,
            categoryEsp: _categoryEsp,
            categoryEng: _categoryEng,
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
    _categoryEng = 'Low';
    _categoryEsp = 'Baja';
    _membershipEsp = 'Gratis';
    _membershipEng = 'Free';
    _contenidoControllerEsp.clear();
    _contenidoControllerEng.clear();
    _imageUrl = '';
  }
}
