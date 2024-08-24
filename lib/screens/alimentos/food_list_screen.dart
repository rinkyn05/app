import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../config/lang/app_localization.dart';
import '../../../widgets/custom_appbar_new.dart';
import '../../config/utils/appcolors.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    Color adaptableColor = AppColors.adaptableColor(context);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('alimentos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.translate('errorLoadingData'),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 24.0,
            );
            return Center(child: Text('Error'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return Column(
            children: [
              CustomAppBarNew(
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('food'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      border: Border.all(color: adaptableColor, width: 2),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context)!.translate('name'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        tooltip:
                            AppLocalizations.of(context)!.translate('name'),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context)!.translate('prote'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        tooltip:
                            AppLocalizations.of(context)!.translate('prote'),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context)!.translate('fats'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        tooltip:
                            AppLocalizations.of(context)!.translate('fats'),
                      ),
                      DataColumn(
                        label: Text(
                          AppLocalizations.of(context)!.translate('carb'),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        tooltip:
                            AppLocalizations.of(context)!.translate('carb'),
                      ),
                    ],
                    rows: snapshot.data!.docs.map((food) {
                      return DataRow(cells: [
                        DataCell(Text(
                          AppLocalizations.of(context)!.translate(
                            locale.languageCode == 'en'
                                ? food['NombreEng'] ?? 'N/A'
                                : food['NombreEsp'] ?? 'N/A',
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                        DataCell(Text(
                          '${food['Proteina'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                        DataCell(Text(
                          '${food['Grasa'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                        DataCell(Text(
                          '${food['Carbohidrato'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
