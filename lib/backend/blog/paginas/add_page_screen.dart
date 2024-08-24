// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rich_editor/rich_editor.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/pages/add_page_functions.dart';
import '../../../functions/role_checker.dart';
import '../../../functions/upload_exercise_image.dart';

class AddPageScreen extends StatefulWidget {
  const AddPageScreen({Key? key}) : super(key: key);

  @override
  AddPageScreenState createState() => AddPageScreenState();
}

class AddPageScreenState extends State<AddPageScreen> {
  final TextEditingController _nameControllerEsp = TextEditingController();
  final TextEditingController _nameControllerEng = TextEditingController();
  String _imageUrl = '';
  final GlobalKey<RichEditorState> _richEditorStateEsp =
      GlobalKey<RichEditorState>();
  final GlobalKey<RichEditorState> _richEditorStateEng =
      GlobalKey<RichEditorState>();

  @override
  void initState() {
    super.initState();
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
          title: Text(AppLocalizations.of(context)!.translate('addPage')),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Español'),
              Tab(text: 'English'),
            ],
            labelStyle: tabLabelStyle,
            unselectedLabelColor: tabUnselectedLabelColor,
            labelColor: tabSelectedLabelColor,
            indicatorColor: AppColors.lightBlueAccentColor,
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPageForm(_nameControllerEsp, 'Esp', _richEditorStateEsp),
            _buildPageForm(_nameControllerEng, 'Eng', _richEditorStateEng),
          ],
        ),
      ),
    );
  }

  Widget _buildPageForm(TextEditingController nameController, String langKey,
      GlobalKey<RichEditorState> editorKey) {
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
                AppLocalizations.of(context)!.translate('pageName'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextFormField(
              controller: nameController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText:
                    "${AppLocalizations.of(context)!.translate('pageName')} ($langKey)",
                hintText:
                    AppLocalizations.of(context)!.translate('enterPageName'),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SizedBox(
                height: 200,
                child: RichEditor(
                  key: editorKey,
                  value: '',
                  editorOptions: RichEditorOptions(
                    placeholder:
                        AppLocalizations.of(context)!.translate('startTyping'),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    baseFontFamily: 'sans-serif',
                    barPosition: BarPosition.TOP,
                  ),
                  getImageUrl: (image) {
                    String base64 = base64Encode(image.readAsBytesSync());
                    return 'data:image/png;base64,$base64';
                  },
                ),
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
      'Upload Image',
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
      'Publish',
      () async {
        String contenidoEsp =
            await _richEditorStateEsp.currentState?.getHtml() ?? '';
        String contenidoEng =
            await _richEditorStateEng.currentState?.getHtml() ?? '';

        if (_nameControllerEsp.text.isNotEmpty &&
            _nameControllerEng.text.isNotEmpty &&
            _imageUrl.isNotEmpty) {
          await AddPageFunctions().addPageWithAutoIncrementId(
            nombreEsp: _nameControllerEsp.text,
            nombreEng: _nameControllerEng.text,
            contenidoEsp: contenidoEsp,
            contenidoEng: contenidoEng,
            imageUrl: _imageUrl,
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
      msg: AppLocalizations.of(context)!.translate('pageAdded'),
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
    setState(() {
      _imageUrl = '';
      _richEditorStateEsp.currentState?.setHtml('');
      _richEditorStateEng.currentState?.setHtml('');
    });
  }
}
