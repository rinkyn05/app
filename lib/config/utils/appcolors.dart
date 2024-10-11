import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar los widgets y temas.

class AppColors {
  // Definición de colores constantes utilizados en la aplicación.
  static const yellowColor = Color(0xFFFEC050); // Color amarillo.
  static const orangeColor = Color(0xFFFB632B); // Color naranja.
  static const oscureColor = Color(0xFF151619); // Color oscuro.
  static const headerColor = Color(0xFFF1F3F5); // Color para encabezados.
  static const text =
      Color.fromARGB(255, 255, 255, 255); // Color de texto blanco.
  static const darkBlueColor =
      Color.fromARGB(255, 2, 11, 59); // Color azul oscuro.
  static const lightBlueColor =
      Color.fromARGB(255, 47, 78, 252); // Color azul claro.
  static const gblue = Color(0xFF0170AF); // Otro tono de azul.
  static const gdarkblue = Color(0xFF010B14); // Azul oscuro.
  static const gdarkblue2 =
      Color.fromARGB(255, 0, 60, 128); // Otro tono de azul oscuro.
  static const oscureColor1 = Color(0xFF151619); // Color oscuro repetido.
  static const greyAcentColor1 = Color(0xFF3E4653); // Color gris de acento.

  // Colores de contenido específicos.
  static const Color contentColorGreen = Color(0xFF00FF00); // Color verde.
  static const Color contentColorRed = Color(0xFFFF0000); // Color rojo.
  static const Color contentColorBlue = Color(0xFF0000FF); // Color azul.
  static const Color contentColorYellow = Color(0xFFFFFF00); // Color amarillo.
  static const Color contentColorPurple = Color(0xFF800080); // Color púrpura.

  // Colores estándar de Flutter.
  static const deepPurpleColor = Colors.deepPurple; // Color púrpura profundo.
  static const lightBlueAccentColor =
      Colors.lightBlueAccent; // Color azul claro de acento.

  // Gradiente de color utilizado en la aplicación.
  static const gradientColor = LinearGradient(
    begin: Alignment.topCenter, // Comienza en la parte superior.
    end: Alignment.bottomCenter, // Termina en la parte inferior.
    colors: [Color(0xFFFB632B), Color(0xFFFEC050)], // Colores del gradiente.
  );

  // Color para errores.
  static const Color errorColor = Color(0xFFFF0000); // Color rojo para errores.

  // Métodos para devolver colores adaptables según el tema actual.
  static Color adaptableGreyColor(BuildContext context) {
    // Devuelve un color gris o blanco según el modo oscuro o claro.
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF151619) // Gris oscuro en modo oscuro.
        : Colors.white; // Blanco en modo claro.
  }

  static Color adaptableColor(BuildContext context) {
    // Devuelve un color según el tema actual.
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Blanco en modo oscuro.
        : const Color(0xFF151619); // Gris oscuro en modo claro.
  }

  static Color adaptableColor2Inverse(BuildContext context) {
    // Similar al anterior, pero retorna un color diferente.
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF151619) // Gris oscuro en modo oscuro.
        : Colors.white; // Blanco en modo claro.
  }

  static Color? adaptableBlueColor(BuildContext context) {
    // Devuelve un color azul según el tema actual.
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF010B14) // Azul oscuro en modo oscuro.
        : Colors.blueGrey[50]; // Azul grisáceo claro en modo claro.
  }

  static Color? adaptableBlueColorWhite(BuildContext context) {
    // Devuelve un azul oscuro o blanco según el tema actual.
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF010B14) // Azul oscuro en modo oscuro.
        : Colors.white; // Blanco en modo claro.
  }

  // Colores adicionales definidos con ARGB.
  static const Color cyan900 = Color.fromARGB(255, 0, 32, 33);
  static const Color cyanAccent700 = Color.fromARGB(255, 0, 25, 29);
  static const Color lightBlue900 = Color.fromARGB(255, 0, 53, 93);
  static const Color blueAccent700 = Color(0xFF2962FF);
  static const Color indigo900 = Color(0xFF1A237E);
}
