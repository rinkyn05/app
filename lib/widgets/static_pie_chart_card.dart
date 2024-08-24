import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/lang/app_localization.dart';
import '../config/utils/appcolors.dart';
import '../functions/harris_benedict_calculator.dart';
import '../screens/alimentos/front_alimentos_screen.dart';
import '../screens/nutrition/carbohydrates_screen.dart';
import '../screens/nutrition/fats_screen.dart';
import '../screens/nutrition/protein_screen.dart';
import '../screens/nutrition/recipes_screen.dart';

class StaticPieChartCard extends StatelessWidget {
  final double totalCalories;

  const StaticPieChartCard({Key? key, required this.totalCalories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: Column(
        children: [
          _buildHarrisBenedictResult2(totalCalories),
          SizedBox(height: 10),
          _buildCardsRow(context),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('lower'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.translate('maintain'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.translate('gain'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          _buildHarrisBenedictResult(totalCalories),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipesScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: AppColors.gdarkblue2, width: 4.0),
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
                  AppLocalizations.of(context)!.translate('recipes'),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FrontAlimentosScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: AppColors.gdarkblue2, width: 4.0),
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
                  AppLocalizations.of(context)!.translate('food'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('nutritionParagraph'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHarrisBenedictResult(double totalCalories) {
    return FutureBuilder<double>(
      future: HarrisBenedictCalculator().calculateHarrisBenedict(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('');
        } else {
          double result = snapshot.data ?? 0.0;

          return _buildPieCharts(context, result);
        }
      },
    );
  }

  Widget _buildHarrisBenedictResult2(double totalCalories) {
    return FutureBuilder<double>(
      future: HarrisBenedictCalculator().calculateHarrisBenedict(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
              AppLocalizations.of(context)!.translate('completeUProfile'));
        } else {
          double result = snapshot.data ?? 0.0;

          return Center(
            child: Column(
              children: [
                Text(
                  '${AppLocalizations.of(context)!.translate('approxCalories')} ${result.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildCardsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard(
          context,
          const Color.fromARGB(255, 252, 67, 0),
          AppLocalizations.of(context)!.translate('fats'),
          fontSize: 13,
          destinationScreen: FatsScreen(),
        ),
        _buildCard(
          context,
          Color.fromARGB(255, 0, 27, 85),
          AppLocalizations.of(context)!.translate('protein'),
          fontSize: 13,
          destinationScreen: ProteinScreen(),
        ),
        _buildCard(
          context,
          const Color.fromARGB(255, 1, 81, 1),
          AppLocalizations.of(context)!.translate('carbohydrate'),
          fontSize: 13,
          destinationScreen: CarbohydratesScreen(),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Color color, String text,
      {double fontSize = 16, required Widget destinationScreen}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPieCharts(BuildContext context, double totalCalories) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildPieChart(
        context,
        AppLocalizations.of(context)!.translate('lower'),
        Color.fromARGB(255, 252, 67, 0),
        totalCalories * 0.35,
        totalCalories * 0.20,
        totalCalories * 0.45,
        3.2,
        Colors.white,
        14,
      ),
      _buildPieChart(
        context,
        AppLocalizations.of(context)!.translate('maintain'),
        Color.fromARGB(255, 0, 27, 85),
        totalCalories * 0.30,
        totalCalories * 0.20,
        totalCalories * 0.50,
        3.2,
        Colors.white,
        14,
      ),
      _buildPieChart(
        context,
        AppLocalizations.of(context)!.translate('gain'),
        Color.fromARGB(255, 1, 81, 1),
        totalCalories * 0.40,
        totalCalories * 0.20,
        totalCalories * 0.40,
        3.2,
        Colors.white,
        14,
      ),
    ],
  );
}

Widget _buildPieChart(
  BuildContext context,
  String title,
  Color centerColor,
  double proteinCalories,
  double fatCalories,
  double carbCalories,
  double sizeFactor,
  Color percentageTextColor,
  double percentageTextSize,
) {
  var sectionsData = <PieChartSectionData>[
    PieChartSectionData(
      color: Color.fromARGB(255, 252, 67, 0),
      value: fatCalories,
      title: '${fatCalories.toStringAsFixed(0)}\n kcal',
      titleStyle: TextStyle(
        color: percentageTextColor,
        fontSize: percentageTextSize,
        fontWeight: FontWeight.normal,
      ),
    ),
    PieChartSectionData(
      color: Color.fromARGB(255, 0, 27, 85),
      value: proteinCalories,
      title: '${proteinCalories.toStringAsFixed(0)}\n kcal',
      titleStyle: TextStyle(
        color: percentageTextColor,
        fontSize: percentageTextSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    PieChartSectionData(
      color: Color.fromARGB(255, 1, 81, 1),
      value: carbCalories,
      title: '${carbCalories.toStringAsFixed(0)}\n kcal',
      titleStyle: TextStyle(
        color: percentageTextColor,
        fontSize: percentageTextSize,
        fontWeight: FontWeight.bold,
      ),
    ),
  ];

  return Expanded(
    child: AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    ),
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 2,
                    sections: sectionsData,
                    centerSpaceRadius: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
