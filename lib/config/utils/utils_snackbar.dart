import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar los widgets.
import 'appcolors.dart'; // Importa el archivo de colores personalizados.

class NotificationService {
  // Clave global para el ScaffoldMessenger, permite mostrar SnackBars en toda la aplicación.
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Método estático para mostrar un SnackBar.
  static void showSnackbar(BuildContext context, String message) {
    // Utiliza el ScaffoldMessenger para mostrar el SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Duración del SnackBar.
        duration: const Duration(seconds: 3),
        // Color de fondo del SnackBar, definido en AppColors.
        backgroundColor: AppColors.darkBlueColor,
        content: Text(
          // Mensaje del SnackBar.
          message,
          style: const TextStyle(
            // Estilo del texto del SnackBar.
            color: AppColors.text, // Color del texto, definido en AppColors.
            fontFamily: "MB", // Fuente personalizada.
          ),
        ),
      ),
    );
  }
}
