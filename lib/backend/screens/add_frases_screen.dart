// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:app/config/lang/app_localization.dart';
import '../../functions/publish_frase.dart';
import '../../functions/role_checker.dart';

class AddFrasesScreen extends StatefulWidget {
  const AddFrasesScreen({super.key});

  @override
  AddFrasesScreenState createState() => AddFrasesScreenState();
}

class AddFrasesScreenState extends State<AddFrasesScreen> {
  final TextEditingController _fraseController = TextEditingController();
  final TextEditingController _fraseEngController = TextEditingController();

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

  void _handlePublish() async {
    String fraseEsp = _fraseController.text;
    String fraseEng = _fraseEngController.text;

    if (!mounted) return;
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await publishFrase(fraseEsp, fraseEng);
      _fraseController.clear();
      _fraseEngController.clear();

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.translate('publishSuccess')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.translate('publishError')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('writeInspiringPhrase'),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fraseController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.translate('phraseHint'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fraseEngController,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)!.translate('phraseHintEng'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handlePublish,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 2, 11, 59)
                    : Colors.white,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : const Color.fromARGB(255, 2, 11, 59),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: Text(AppLocalizations.of(context)!.translate('publish')),
            ),
          ],
        ),
      ),
    );
  }
}
