import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/lang/app_localization.dart';
import '../config/utils/appcolors.dart';

class CustomIconsCard extends StatelessWidget {
  final String currentUserEmail;

  const CustomIconsCard({Key? key, required this.currentUserEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('userstats')
          .doc(currentUserEmail)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text('Error al cargar las estadísticas'),
          );
        }

        var userStats = snapshot.data!.data() as Map<String, dynamic>;

        return Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  _iconWithText(context, Icons.local_fire_department,
                      'caloriasQuemadas', userStats),
                  _iconWithText(
                      context, Icons.timer, 'tiempoDeEjercicios', userStats),
                  _iconWithText(context, Icons.favorite, 'ejerciciosRealizados',
                      userStats),
                  _iconWithText(context, Icons.check_circle,
                      'rutinasCompletadas', userStats),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _iconWithText(BuildContext context, IconData icon,
      String translationKey, Map<String, dynamic> userStats) {
    ThemeData theme = Theme.of(context);
    Color iconColor = theme.brightness == Brightness.dark
        ? Colors.white
        : AppColors.darkBlueColor;

    if (userStats.containsKey(translationKey)) {
      dynamic fieldValue = userStats[translationKey];

      String title = '';
      switch (translationKey) {
        case 'caloriasQuemadas':
          title = AppLocalizations.of(context)!.translate('calories');
          break;
        case 'tiempoDeEjercicios':
          title = AppLocalizations.of(context)!.translate('time');
          break;
        case 'ejerciciosRealizados':
          title = AppLocalizations.of(context)!.translate('exercises');
          break;
        case 'rutinasCompletadas':
          title = AppLocalizations.of(context)!.translate('routines');
          break;
        default:
          title = '';
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(height: 8),
          Text(
            '$title\n$fieldValue',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!.copyWith(fontSize: 26),
          ),
        ],
      );
    } else {
      String title = '';
      switch (translationKey) {
        case 'caloriasQuemadas':
          title = AppLocalizations.of(context)!.translate('calories');
          break;
        case 'tiempoDeEjercicios':
          title = AppLocalizations.of(context)!.translate('time');
          break;
        case 'ejerciciosRealizados':
          title = AppLocalizations.of(context)!.translate('exercises');
          break;
        case 'rutinasCompletadas':
          title = AppLocalizations.of(context)!.translate('routines');
          break;
        default:
          title = '';
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(height: 8),
          Text(
            '$title\n0',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!.copyWith(fontSize: 26),
          ),
        ],
      );
    }
  }
}
