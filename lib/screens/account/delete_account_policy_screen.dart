import 'package:flutter/material.dart'; // Importa Flutter Material para construir la interfaz de usuario.
import 'package:app/config/lang/app_localization.dart'; // Importa el sistema de localización para traducir textos.
import '../../config/utils/appcolors.dart'; // Importa los colores personalizados definidos en la configuración.

class DeleteAccountPolicyScreen extends StatelessWidget {
  const DeleteAccountPolicyScreen({Key? key})
      : super(
            key:
                key); // Constructor para la pantalla de política de eliminación de cuenta.

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
        Theme.of(context); // Obtiene el tema actual de la aplicación.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
              'deleteAccountPolicy'), // Traduce y muestra el título de la política de eliminación de cuenta.
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono de retroceso.
          onPressed: () {
            Navigator.pop(context); // Navega de regreso a la pantalla anterior.
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: theme
                .scaffoldBackgroundColor), // Establece el color de fondo del contenedor.
        child: ListView(
          // Utiliza ListView para permitir el desplazamiento de una lista de widgets.
          padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical:
                  10), // Aplica un padding horizontal y vertical al ListView.
          children: [
            const SizedBox(height: 20), // Espaciado superior.
            Text(
              AppLocalizations.of(context)!.translate(
                  'deleteAccountPolicy'), // Traduce y muestra el título de la política de eliminación de cuenta.
              style: theme.textTheme
                  .titleLarge, // Aplica el estilo de texto grande definido en el tema.
            ),
            const SizedBox(
                height: 20), // Espaciado entre el título y la descripción.
            Text(
              AppLocalizations.of(context)!.translate(
                  'deleteAccountPolicyDescription'), // Traduce y muestra la descripción de la política de eliminación de cuenta.
              style: theme.textTheme
                  .bodyLarge, // Aplica el estilo del cuerpo del texto grande.
            ),
            const SizedBox(
                height: 20), // Espaciado entre la descripción y la nota.
            Text(
              AppLocalizations.of(context)!.translate(
                  'deleteAccountPolicyNote'), // Traduce y muestra una nota relacionada con la política.
              style: const TextStyle(
                color: AppColors
                    .orangeColor, // Establece el color de texto como naranja.
                fontWeight: FontWeight.bold, // Establece el texto en negrita.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
