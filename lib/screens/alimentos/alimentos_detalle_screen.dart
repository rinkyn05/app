import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/alimentos_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/language_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../widgets/custom_appbar_new.dart';

class AlimentosDetalleScreen extends StatelessWidget {
  final Alimentos alimentos;

  const AlimentosDetalleScreen({Key? key, required this.alimentos})
      : super(key: key);

  String _translate(BuildContext context, String esp, String eng) {
    String languageCode = Provider.of<LanguageNotifier>(context, listen: false)
        .currentLocale
        .languageCode;
    return languageCode == 'es' ? esp : eng;
  }

  Widget _getCategoryWidget(String category, BuildContext context) {
    String translatedCategory =
        _translate(context, alimentos.categoryEsp, alimentos.categoryEng);
    IconData iconData;
    String textLabel;

    switch (translatedCategory.toLowerCase()) {
      case 'vegetal':
      case 'vegetable':
        iconData = Icons.person;
        textLabel = AppLocalizations.of(context)!.translate('vegetal');
        break;
      case 'animal':
      case 'animals':
        iconData = Icons.pets;
        textLabel = AppLocalizations.of(context)!.translate('animal');
        break;
      default:
        iconData = Icons.help_outline;
        textLabel = AppLocalizations.of(context)!.translate('Unknown');
    }

    return Column(
      children: [
        Icon(iconData, size: 50, color: Theme.of(context).iconTheme.color),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.translate('alimentosCategory'),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center),
        Text(textLabel,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> details = [
      {
        'valueWidget': _getCategoryWidget(alimentos.estancia, context),
      },
      {
        'key': AppLocalizations.of(context)!.translate('calories'),
        'value': alimentos.calorias,
        'icon': Icons.local_fire_department,
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBarNew(
              onBackButtonPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 8),
            Text(
              '${alimentos.nombre}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(alimentos.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 16,
                  height: 300),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: details.map((detail) {
                return Card(
                  elevation: 4.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 16,
                    padding: const EdgeInsets.all(8.0),
                    child: detail.containsKey('valueWidget')
                        ? Column(children: [detail['valueWidget']])
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(detail['icon'],
                                  size: 50,
                                  color: Theme.of(context).iconTheme.color),
                              const SizedBox(height: 8),
                              Text(detail['key'],
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(detail['value'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.translate('nutritionalTable'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Table(
              border: TableBorder.all(color: AppColors.adaptableColor(context)),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate('portion'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.porcion}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate('calories'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.calorias}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate('protein'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.proteina}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate('fats'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.grasa}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('carbohydrates'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.carbohidrato}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('vitamins/Minerals'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${alimentos.vitamina}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
