// card_widget.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String description;
  final Function(String) onCardTap;

  CardWidget({
    required this.title,
    required this.description,
    required this.onCardTap,
  });

  Future<String> _getSelectedExercise() async {
    final prefs = await SharedPreferences.getInstance();
    String? selectedExerciseName = prefs.getString(
        'selected_exercise_name_${title.toLowerCase().replaceAll(' ', '_')}');
    return selectedExerciseName ?? title;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getSelectedExercise(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () => onCardTap(title),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    snapshot.data ?? title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
