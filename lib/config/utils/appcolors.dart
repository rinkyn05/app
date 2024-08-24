import 'package:flutter/material.dart';

class AppColors {
  static const yellowColor = Color(0xFFFEC050);
  static const orangeColor = Color(0xFFFB632B);
  static const oscureColor = Color(0xFF151619);
  static const headerColor = Color(0xFFF1F3F5);
  static const text = Color.fromARGB(255, 255, 255, 255);
  static const darkBlueColor = Color.fromARGB(255, 2, 11, 59);
  static const lightBlueColor = Color.fromARGB(255, 47, 78, 252);
  static const gblue = Color(0xFF0170AF);
  static const gdarkblue = Color(0xFF010B14);
  static const gdarkblue2 = Color.fromARGB(255, 0, 60, 128);
  static const oscureColor1 = Color(0xFF151619);
  static const greyAcentColor1 = Color(0xFF3E4653);
  static const Color contentColorGreen = Color(0xFF00FF00);
  static const Color contentColorRed = Color(0xFFFF0000);
  static const Color contentColorBlue = Color(0xFF0000FF);
  static const Color contentColorYellow = Color(0xFFFFFF00);
  static const Color contentColorPurple = Color(0xFF800080);
  static const deepPurpleColor = Colors.deepPurple;
  static const lightBlueAccentColor = Colors.lightBlueAccent;
  static const gradientColor = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFB632B), Color(0xFFFEC050)],
  );

  static const Color errorColor = Color(0xFFFF0000);

  static Color adaptableGreyColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF151619)
        : Colors.white;
  }

  static Color adaptableColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF151619);
  }

  static Color adaptableColor2Inverse(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF151619)
        : Colors.white;
  }

  static Color? adaptableBlueColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF010B14)
        : Colors.blueGrey[50];
  }

  static Color? adaptableBlueColorWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF010B14)
        : Colors.white;
  }

  static const Color cyan900 = Color.fromARGB(255, 0, 32, 33);
  static const Color cyanAccent700 = Color.fromARGB(255, 0, 25, 29);
  static const Color lightBlue900 = Color.fromARGB(255, 0, 53, 93);
  static const Color blueAccent700 = Color(0xFF2962FF);
  static const Color indigo900 = Color(0xFF1A237E);
}
