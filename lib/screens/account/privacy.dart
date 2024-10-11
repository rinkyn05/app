import 'package:flutter/material.dart'; // Importa Flutter Material para la interfaz de usuario.
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para la traducción de textos.

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key})
      : super(
            key: key); // Constructor de la pantalla de política de privacidad.

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
        Theme.of(context); // Obtiene el tema actual de la aplicación.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
              'privacyPolicy'), // Traduce y muestra el título de la política de privacidad.
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
        child: SingleChildScrollView(
          // Permite el desplazamiento si el contenido es más grande que la pantalla.
          padding: const EdgeInsets.all(
              16.0), // Aplica un padding de 16 píxeles alrededor del contenido.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Alinea el contenido al inicio (izquierda).
            children: [
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'welcomeToGabrielCoach'), // Traduce y muestra el título de bienvenida.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'privacyPolicyDescription'), // Traduce y muestra la descripción de la política de privacidad.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'informationWeCollect'), // Traduce y muestra el título sobre la información que se recopila.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'informationWeCollectDescription'), // Traduce y muestra la descripción sobre la información que se recopila.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'useOfInformation'), // Traduce y muestra el título sobre el uso de la información.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'useOfInformationDescription'), // Traduce y muestra la descripción sobre el uso de la información.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'permissionsRequired'), // Traduce y muestra el título sobre los permisos requeridos.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'permissionsRequiredDescription'), // Traduce y muestra la descripción de los permisos requeridos.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'changesToThisPolicy'), // Traduce y muestra el título sobre los cambios en esta política.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'changesToThisPolicyDescription'), // Traduce y muestra la descripción sobre los cambios en esta política.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'contactUs'), // Traduce y muestra el título de contacto.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'contactUsDescription'), // Traduce y muestra la descripción de contacto.
                theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear un título de sección.
  Widget _sectionTitle(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Aplica un padding vertical de 8 píxeles.
      child: Text(
        text,
        style: theme.textTheme.titleLarge!.copyWith(
            fontWeight:
                FontWeight.bold), // Establece el estilo del texto en negrita.
      ),
    );
  }

  // Método para crear un texto de sección.
  Widget _sectionText(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 16.0), // Aplica un padding inferior de 16 píxeles.
      child: Text(
        text,
        style: theme
            .textTheme.bodyMedium, // Aplica el estilo del cuerpo del texto.
      ),
    );
  }
}
