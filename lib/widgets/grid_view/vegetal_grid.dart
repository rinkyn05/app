import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../config/lang/app_localization.dart';
import '../../screens/nutrition/animal_details.dart';

class MasonryRecipess extends StatefulWidget {
  const MasonryRecipess({Key? key}) : super(key: key);

  @override
  _MasonryRecipessState createState() => _MasonryRecipessState();
}

class _MasonryRecipessState extends State<MasonryRecipess> {
  DocumentSnapshot? _selectedRecipe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('recipes')
              .where('CategoryEng', isEqualTo: 'Vegetable')
              .where('CategoryEsp', isEqualTo: 'Vegetal')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final recipes = snapshot.data!.docs;
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          (recipes.length / 3).ceil(),
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              3,
                              (i) => i + index * 3 < recipes.length
                                  ? _buildIconItem(
                                      context, recipes[i + index * 3])
                                  : SizedBox(width: 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedRecipe != null)
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: AnimatedPadding(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.only(
                          top: _selectedRecipe != null ? 0.0 : 300.0,
                        ),
                        child: _buildSelectedRecipeCard(context),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, DocumentSnapshot recipe) {
    String? imageUrl = recipe['URL de la Imagen'];
    String? nombre = recipe['NombreEsp'];
    bool isPremium = recipe['MembershipEng'] == 'Premium';

    return GestureDetector(
      onTap: () {
        if (!isPremium) {
          setState(() {
            _selectedRecipe = recipe;
          });
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        )
                      : Icon(Icons.error),
                  SizedBox(height: 8),
                  Text(
                    nombre ?? 'Nombre no encontrado',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isPremium)
              Positioned.fill(
                child: Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 70,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRecipeCard(BuildContext context) {
    String nombre = _selectedRecipe!['NombreEsp'] ?? 'Nombre no encontrado';
    double resistencia = double.parse(_selectedRecipe!['Resistencia'] ?? '0');
    double fisicoEstetico =
        double.parse(_selectedRecipe!['FisicoEstetico'] ?? '0');
    double potenciaAnaerobica =
        double.parse(_selectedRecipe!['PotenciaAnaerobica'] ?? '0');
    double saludBienestar =
        double.parse(_selectedRecipe!['SaludBienestar'] ?? '0');

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedRecipe = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nombre,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildCircularProgress(
                        context,
                        AppLocalizations.of(context)!.translate('resistance'),
                        resistencia),
                    _buildCircularProgress(
                        context,
                        AppLocalizations.of(context)!
                            .translate('aestheticPhysical'),
                        fisicoEstetico),
                    _buildCircularProgress(
                        context,
                        AppLocalizations.of(context)!
                            .translate('anaerobicPower'),
                        potenciaAnaerobica),
                    _buildCircularProgress(
                        context,
                        AppLocalizations.of(context)!
                            .translate('healthWellness'),
                        saludBienestar),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipesDetailsPage(recipe: _selectedRecipe!),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('start'),
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
      BuildContext context, String label, double value) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 4,
            percent: value / 100,
            center: Text(
              '${value.toInt()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            progressColor: Colors.blue,
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
