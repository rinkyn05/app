import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('privacyPolicy'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(
                AppLocalizations.of(context)!
                    .translate('welcomeToGabrielCoach'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('privacyPolicyDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('informationWeCollect'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('informationWeCollectDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('useOfInformation'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('useOfInformationDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('permissionsRequired'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('permissionsRequiredDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('changesToThisPolicy'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('changesToThisPolicyDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('contactUs'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate('contactUsDescription'),
                theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style:
            theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionText(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
