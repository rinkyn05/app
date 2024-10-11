import 'package:flutter/material.dart'; // Importa Flutter Material para la interfaz de usuario.
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para la traducción de textos.

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key})
      : super(
            key: key); // Constructor de la pantalla de términos y condiciones.

  @override
  Widget build(BuildContext context) {
    ThemeData theme =
        Theme.of(context); // Obtiene el tema actual de la aplicación.
    bool isEnglish = Localizations.localeOf(context).languageCode ==
        'en'; // Verifica si el idioma actual es inglés.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish
              ? AppLocalizations.of(context)!.translate(
                  'termsAndConditions') // Traduce 'termsAndConditions' si es inglés.
              : AppLocalizations.of(context)!.translate(
                  'termsAndConditions'), // Traduce 'termsAndConditions' si no es inglés.
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
                    'termsIntroduction'), // Traduce y muestra el título de la introducción.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'termsIntroductionDescription'), // Traduce y muestra la descripción de la introducción.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'termsCopyrightNotice'), // Traduce y muestra el título del aviso de copyright.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'termsCopyrightNoticeDescription'), // Traduce y muestra la descripción del aviso de copyright.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'termsUserResponsibilities'), // Traduce y muestra el título de las responsabilidades del usuario.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'termsUserResponsibilitiesDescription'), // Traduce y muestra la descripción de las responsabilidades del usuario.
                theme,
              ),
              _sectionTitle(
                AppLocalizations.of(context)!.translate(
                    'termsDisputeResolution'), // Traduce y muestra el título de la resolución de disputas.
                theme,
              ),
              _sectionText(
                AppLocalizations.of(context)!.translate(
                    'termsDisputeResolutionDescription'), // Traduce y muestra la descripción de la resolución de disputas.
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
        style:
            theme.textTheme.bodyLarge, // Aplica el estilo del cuerpo del texto.
      ),
    );
  }
}
