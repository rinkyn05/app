// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../functions/contents/catejercicio/edit_cat_ejercicio_functions.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/role_checker.dart';
import '../../../functions/upload_exercise_image.dart';

class EditCatEjercicioScreen extends StatefulWidget {
  final Map<String, dynamic> catejercicio;

  const EditCatEjercicioScreen({Key? key, required this.catejercicio})
      : super(key: key);

  @override
  EditCatEjercicioScreenState createState() => EditCatEjercicioScreenState();
}

class EditCatEjercicioScreenState extends State<EditCatEjercicioScreen> {
  late TextEditingController _nameControllerEsp;
  late TextEditingController _descriptionControllerEsp;
  late TextEditingController _nameControllerEng;
  late TextEditingController _descriptionControllerEng;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameControllerEsp =
        TextEditingController(text: widget.catejercicio['NombreEsp']);
    _descriptionControllerEsp =
        TextEditingController(text: widget.catejercicio['DescripcionEsp']);
    _nameControllerEng =
        TextEditingController(text: widget.catejercicio['NombreEng']);
    _descriptionControllerEng =
        TextEditingController(text: widget.catejercicio['DescripcionEng']);
    _imageUrl = widget.catejercicio['URL de la Imagen'];
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
    final theme = Theme.of(context);
    final tabLabelStyle = theme.textTheme.labelLarge?.copyWith(fontSize: 26);
    final tabUnselectedLabelColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.grey
            : Colors.white70;
    final tabSelectedLabelColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white;

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
          title:
              Text(AppLocalizations.of(context)!.translate('editCatEjercicio')),
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
            _buildCatEjercicioForm(
                _nameControllerEsp, _descriptionControllerEsp, 'Español'),
            _buildCatEjercicioForm(
                _nameControllerEng, _descriptionControllerEng, 'English'),
          ],
        ),
      ),
    );
  }

  Widget _buildCatEjercicioForm(TextEditingController nameController,
      TextEditingController descriptionController, String langKey) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBlueColor
        : Colors.black;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('catEjercicioName'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.translate('catEjercicioName')} ($langKey)',
                  hintText: AppLocalizations.of(context)!
                      .translate('enterCatEjercicioName'),
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
                  AppLocalizations.of(context)!
                      .translate('catEjercicioDescription'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.translate('catEjercicioDescription')} ($langKey)',
                  hintText: AppLocalizations.of(context)!
                      .translate('enterCatEjercicioDescription'),
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
              const SizedBox(height: 20),
              _buildUpdateButton(),
            ],
          ),
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
      child: _imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(_imageUrl!, height: 200, fit: BoxFit.cover),
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

  Widget _buildUpdateButton() {
    return _buildCustomButton(
      context,
      'update',
      () async {
        if (_nameControllerEsp.text.isNotEmpty &&
            _descriptionControllerEsp.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _descriptionControllerEng.text.isNotEmpty &&
            _imageUrl != null) {
          String catejercicioId = widget.catejercicio['id'].toString();
          await UpdateCatEjercicioFunctions().updateCatEjercicio(
            id: catejercicioId,
            nombreEsp: _nameControllerEsp.text,
            descripcionEsp: _descriptionControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            descripcionEng: _descriptionControllerEng.text,
            imageUrl: _imageUrl!,
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
      msg: AppLocalizations.of(context)!.translate('catEjercicioUpdated'),
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
    _descriptionControllerEsp.clear();
    _nameControllerEng.clear();
    _descriptionControllerEng.clear();
    setState(() {
      _imageUrl = '';
    });
  }
}
