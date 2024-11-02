// info_card_widget.dart
import 'package:flutter/material.dart';
import '../../config/utils/appcolors.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final Function onClose;
  final Function onNavigateToExercise;

  InfoCardWidget({
    required this.title,
    required this.onClose,
    required this.onNavigateToExercise,
  });

  String getContent(String title) {
    switch (title) {
      case 'Deltoide':
        return 'Músculo en la parte superior del brazo y el hombro.';
      case 'Pectoral':
        return 'Músculo del pecho.';
      case 'Bíceps':
        return 'Músculo en la parte frontal del brazo.';
      case 'Abdomen':
        return 'Parte del cuerpo entre el pecho y la pelvis.';
      case 'Antebrazo':
        return 'Parte del brazo entre el codo y la muñeca.\nParte del cuerpo entre el pecho y la pelvis.';
      case 'Cuádriceps':
        return 'Músculos en la parte frontal del muslo.';
      case 'Tibial anterior':
        return 'Músculo en la parte frontal de la espinilla.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => onClose(),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              getContent(title),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onNavigateToExercise(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.gdarkblue2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
              child: Center(
                child: Text('Ver Ejercicios de $title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
