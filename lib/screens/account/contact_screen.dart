import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('contactTitle'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('contactHeader'),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                AppLocalizations.of(context)!.translate('contactDescription'),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('subject'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('email'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('message'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.gdarkblue2,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('sendButton'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
