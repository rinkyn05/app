import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa la biblioteca de Firestore.
import '../config/lang/app_localization.dart'; // Importa la configuración de localización de la aplicación.
import '../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación.

class CustomIconsCard extends StatelessWidget {
  final String currentUserEmail; // Correo electrónico del usuario actual.

  const CustomIconsCard({Key? key, required this.currentUserEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      // Construye un widget basado en el resultado de una operación asíncrona.
      future: FirebaseFirestore.instance
          .collection(
              'userstats') // Colección que contiene las estadísticas del usuario.
          .doc(currentUserEmail) // Documento específico del usuario actual.
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child:
                CircularProgressIndicator(), // Indicador de progreso mientras se espera la carga de datos.
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text(
                'Error al cargar las estadísticas'), // Mensaje de error en caso de fallo.
          );
        }

        var userStats = snapshot.data!.data() as Map<String,
            dynamic>; // Datos del usuario recuperados de Firestore.

        return Center(
          child: Card(
            elevation: 4, // Sombra de la tarjeta.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), // Esquinas redondeadas de la tarjeta.
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Espaciado interno.
              child: Wrap(
                alignment: WrapAlignment.center, // Alineación del contenido.
                spacing: 16.0, // Espacio entre los íconos.
                runSpacing: 16.0, // Espacio entre las filas de íconos.
                children: [
                  _iconWithText(
                      context,
                      Icons.local_fire_department,
                      'caloriasQuemadas',
                      userStats), // Ícono y texto para calorías quemadas.
                  _iconWithText(context, Icons.timer, 'tiempoDeEjercicios',
                      userStats), // Ícono y texto para tiempo de ejercicios.
                  _iconWithText(context, Icons.favorite, 'ejerciciosRealizados',
                      userStats), // Ícono y texto para ejercicios realizados.
                  _iconWithText(
                      context,
                      Icons.check_circle,
                      'rutinasCompletadas',
                      userStats), // Ícono y texto para rutinas completadas.
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
    // Widget que construye un ícono con texto.
    ThemeData theme =
        Theme.of(context); // Obtiene el tema actual de la aplicación.
    Color iconColor = theme.brightness == Brightness.dark
        ? Colors.white // Color del ícono en modo oscuro.
        : AppColors.darkBlueColor; // Color del ícono en modo claro.

    if (userStats.containsKey(translationKey)) {
      // Verifica si el dato existe en userStats.
      dynamic fieldValue =
          userStats[translationKey]; // Valor del campo correspondiente.

      String title = ''; // Título del ícono.
      switch (translationKey) {
        // Determina el título basado en la clave de traducción.
        case 'caloriasQuemadas':
          title = AppLocalizations.of(context)!
              .translate('calories'); // Título para calorías.
          break;
        case 'tiempoDeEjercicios':
          title = AppLocalizations.of(context)!
              .translate('time'); // Título para tiempo de ejercicios.
          break;
        case 'ejerciciosRealizados':
          title = AppLocalizations.of(context)!
              .translate('exercises'); // Título para ejercicios.
          break;
        case 'rutinasCompletadas':
          title = AppLocalizations.of(context)!
              .translate('routines'); // Título para rutinas.
          break;
        default:
          title = ''; // Título por defecto.
      }

      return Column(
        mainAxisSize:
            MainAxisSize.min, // Establece el tamaño mínimo de la columna.
        children: [
          Icon(icon, color: iconColor, size: 48), // Ícono.
          const SizedBox(height: 8), // Espaciado entre ícono y texto.
          Text(
            '$title\n$fieldValue', // Texto que muestra el título y el valor.
            textAlign: TextAlign.center, // Alineación del texto.
            style: theme.textTheme.titleLarge!
                .copyWith(fontSize: 26), // Estilo del texto.
          ),
        ],
      );
    } else {
      String title = ''; // Título por defecto cuando no hay datos.
      switch (translationKey) {
        // Determina el título basado en la clave de traducción.
        case 'caloriasQuemadas':
          title = AppLocalizations.of(context)!
              .translate('calories'); // Título para calorías.
          break;
        case 'tiempoDeEjercicios':
          title = AppLocalizations.of(context)!
              .translate('time'); // Título para tiempo de ejercicios.
          break;
        case 'ejerciciosRealizados':
          title = AppLocalizations.of(context)!
              .translate('exercises'); // Título para ejercicios.
          break;
        case 'rutinasCompletadas':
          title = AppLocalizations.of(context)!
              .translate('routines'); // Título para rutinas.
          break;
        default:
          title = ''; // Título por defecto.
      }

      return Column(
        mainAxisSize:
            MainAxisSize.min, // Establece el tamaño mínimo de la columna.
        children: [
          Icon(icon, color: iconColor, size: 48), // Ícono.
          const SizedBox(height: 8), // Espaciado entre ícono y texto.
          Text(
            '$title\n0', // Texto que muestra el título y 0 como valor predeterminado.
            textAlign: TextAlign.center, // Alineación del texto.
            style: theme.textTheme.titleLarge!
                .copyWith(fontSize: 26), // Estilo del texto.
          ),
        ],
      );
    }
  }
}
