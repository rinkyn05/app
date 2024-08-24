import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import 'delete_account_policy_screen.dart';
import 'delete_account_screen_last.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String userEmail;
  const DeleteAccountScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  DeleteAccountScreenState createState() => DeleteAccountScreenState();
}

class DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isConfirmed = false;
  bool _policyAccepted = false;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_checkInput);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.translate('deleteAccount')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLoc.translate('deleteAccountTitle'),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                appLoc.translate('deleteAccountConfirmation'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      appLoc.translate('deleteAccountPolicy'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyLarge!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DeleteAccountPolicyScreen(),
                        ),
                      );
                    },
                    child: Text(
                      appLoc.translate('see'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily:
                            Theme.of(context).textTheme.bodyLarge!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _confirmationDialogContent(),
              _deleteAccountStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmationDialogContent() {
    final appLoc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLoc.translate('confirmDeleteAccountQuestion'),
        ),
        Text(
          appLoc.translate('irreversibleActionWarning'),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _inputController,
          decoration: InputDecoration(
            hintText: (Localizations.localeOf(context).languageCode == 'es')
                ? 'BORRAR'
                : 'DELETE',
          ),
          textAlign: TextAlign.center,
          onChanged: (_) => _checkInput(),
        ),
      ],
    );
  }

  Widget _deleteAccountStep() {
    final appLoc = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 20),
        CheckboxListTile(
          title: Text(
            appLoc.translate('acceptPolicyConfirmation'),
          ),
          value: _policyAccepted,
          onChanged: (value) {
            setState(() {
              _policyAccepted = value ?? false;
            });
          },
        ),
        ElevatedButton(
          onPressed: _isConfirmed && _policyAccepted
              ? () => _deleteAccountRedirect(context)
              : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            backgroundColor: _isConfirmed ? Colors.red : Colors.grey[300],
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          child: Text(
            appLoc.translate('yesDeleteAccountOption'),
          ),
        ),
      ],
    );
  }

  void _checkInput() {
    String currentLanguageCode = Localizations.localeOf(context).languageCode;
    String expectedText = (currentLanguageCode == 'es') ? 'BORRAR' : 'DELETE';

    setState(() {
      _isConfirmed =
          _inputController.text.toUpperCase() == expectedText.toUpperCase();
    });
  }

  void _deleteAccountRedirect(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DeleteAccountScreenLast(userEmail: widget.userEmail),
      ),
    );
  }
}
