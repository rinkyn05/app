import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/lang/app_localization.dart';
import '../config/utils/appcolors.dart';

class CustomPieChartCard extends StatelessWidget {
  final String userEmail;

  const CustomPieChartCard({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('userstats')
          .doc(userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.data() == null) {
          return _buildNoDataWidget(context);
        }

        var userData = snapshot.data!.data()!;
        var userStats = userData;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPieChart(context, userStats),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.translate('pieChartTitle'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: _buildEmptySectionsData(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.translate('pieChartTitle'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildEmptySectionsData() {
    return <PieChartSectionData>[
      PieChartSectionData(
        color: AppColors.contentColorBlue,
        value: 0,
        title: '0%',
      ),
      PieChartSectionData(
        color: AppColors.contentColorYellow,
        value: 0,
        title: '0%',
      ),
      PieChartSectionData(
        color: AppColors.contentColorGreen,
        value: 0,
        title: '0%',
      ),
      PieChartSectionData(
        color: AppColors.contentColorRed,
        value: 0,
        title: '0%',
      ),
    ];
  }

  Widget _buildPieChart(BuildContext context, Map<String, dynamic> userStats) {
    var sectionsData = <PieChartSectionData>[
      if (userStats['caloriasQuemadas'] != null)
        PieChartSectionData(
          color: AppColors.contentColorBlue,
          value: double.parse(userStats['caloriasQuemadas'].toString()),
          title: '${userStats['caloriasQuemadas']}%',
        ),
      if (userStats['tiempoDeEjercicios'] != null)
        PieChartSectionData(
          color: AppColors.contentColorYellow,
          value: double.parse(userStats['tiempoDeEjercicios'].toString()),
          title: '${userStats['tiempoDeEjercicios']}%',
        ),
      if (userStats['ejerciciosRealizados'] != null)
        PieChartSectionData(
          color: AppColors.contentColorGreen,
          value: double.parse(userStats['ejerciciosRealizados'].toString()),
          title: '${userStats['ejerciciosRealizados']}%',
        ),
      if (userStats['rutinascompletadas'] != null)
        PieChartSectionData(
          color: AppColors.contentColorRed,
          value: double.parse(userStats['rutinascompletadas'].toString()),
          title: '${userStats['rutinascompletadas']}%',
        ),
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {}),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: sectionsData,
        ),
      ),
    );
  }
}
