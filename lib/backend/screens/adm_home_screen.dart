import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../config/lang/app_localization.dart';
import '../../functions/role_checker.dart';

class AdmHomeScreen extends StatefulWidget {
  const AdmHomeScreen({Key? key}) : super(key: key);

  @override
  AdmHomeScreenState createState() => AdmHomeScreenState();
}

class AdmHomeScreenState extends State<AdmHomeScreen> {
  late Future<List<double>> userData;
  late Future<List<double>> exerciseData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
    exerciseData = fetchExerciseData();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    bool hasAccess = await checkUserRole();
    if (!hasAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showAccessDeniedDialog(context);
        }
      });
    }
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.translate('accessDeniedTitle')),
          content: Text(
              AppLocalizations.of(context)!.translate('accessDeniedMessage')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.translate('okButton')),
            ),
          ],
        );
      },
    );
  }

  Future<List<double>> fetchUserData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs
        .map((doc) => doc.data().toString().length.toDouble())
        .toList();
  }

  Future<List<double>> fetchExerciseData() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('ejercicios').get();
    return snapshot.docs
        .map((doc) => doc.data().toString().length.toDouble())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            chartSection("User Registrations Over Time", userData,
                isBarChart: false),
            const SizedBox(height: 20),
            chartSection("Exercises Published Over Time", exerciseData,
                isBarChart: true),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget chartSection(String title, Future<List<double>> data,
      {bool isBarChart = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 250,
          child: FutureBuilder<List<double>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error fetching data');
              } else {
                return isBarChart
                    ? BarChart(mainBarData(snapshot.data!))
                    : LineChart(mainLineData(snapshot.data!));
              }
            },
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  LineChartData mainLineData(List<double> dataPoints) {
    List<FlSpot> spots = dataPoints
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: true),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 70,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text('Día 1');
                case 1:
                  return const Text('Día 2');
                default:
                  return const Text('');
              }
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: (dataPoints.length - 1).toDouble(),
      minY: 0,
      maxY: dataPoints.reduce(math.max),
    );
  }

  BarChartData mainBarData(List<double> dataPoints) {
    List<BarChartGroupData> barGroups = dataPoints.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(toY: entry.value, color: Colors.blue),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
    return BarChartData(
      barGroups: barGroups,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 70,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text('Ej. 1');
                case 1:
                  return const Text('Ej. 2');
                default:
                  return const Text('');
              }
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: true),
      borderData: FlBorderData(show: false),
      maxY: dataPoints.reduce(math.max),
    );
  }
}
