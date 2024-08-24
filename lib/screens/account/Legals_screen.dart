import 'package:app/screens/account/privacy.dart';
import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../config/utils/appcolors.dart';
import 'delete_account_policy_screen.dart';
import 'terms_conditions.dart';

class LegalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate('legals')}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('legalsParagraph'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PrivacyPolicyScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColors.gdarkblue2,
                          width: 4.0,
                        ),
                      ),
                      elevation: 3,
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gdarkblue2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('privacy'),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => TermsConditionsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColors.gdarkblue2,
                          width: 4.0,
                        ),
                      ),
                      elevation: 3,
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gdarkblue2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('terms'),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DeleteAccountPolicyScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColors.gdarkblue2,
                          width: 4.0,
                        ),
                      ),
                      elevation: 3,
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gdarkblue2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('deleteAccount'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
