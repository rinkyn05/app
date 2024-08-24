import 'package:flutter/material.dart';
import 'package:app/config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class DeleteAccountPolicyScreen extends StatelessWidget {
  const DeleteAccountPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('deleteAccountPolicy'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.translate('deleteAccountPolicy'),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!
                  .translate('deleteAccountPolicyDescription'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!
                  .translate('deleteAccountPolicyNote'),
              style: const TextStyle(
                color: AppColors.orangeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
