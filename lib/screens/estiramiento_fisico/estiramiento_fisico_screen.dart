import 'package:flutter/material.dart';
import '../../widgets/custom_appbar_new.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/grid_view/mansory_estiramiento_fisico.dart';

class EstiramientoFisicoScreen extends StatelessWidget {
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
              "${AppLocalizations.of(context)!.translate('estiramientoFisico')}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Expanded(child: MasonryEstiramientoFisico()),
          ],
        ),
      ),
    );
  }
}
