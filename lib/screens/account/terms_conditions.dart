import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish
              ? AppLocalizations.of(context)!.translate('termsAndConditions')
              : AppLocalizations.of(context)!.translate('termsAndConditions'),
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
                AppLocalizations.of(context)!.translate('termsIntroduction'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('termsIntroductionDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate('termsCopyrightNotice'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('termsCopyrightNoticeDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!
                    .translate('termsUserResponsibilities'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('termsUserResponsibilitiesDescription'),
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!
                    .translate('termsDisputeResolution'),
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!
                    .translate('termsDisputeResolutionDescription'),
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
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
