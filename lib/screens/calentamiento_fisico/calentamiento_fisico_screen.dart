import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../widgets/grid_view/mansory_calentamiento_fisico.dart';

class CalentamientoFisicoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('calentamientoFisico')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Expanded(child: MasonryCalentamientoFisico()),
          ],
        ),
      ),
    );
  }
}
