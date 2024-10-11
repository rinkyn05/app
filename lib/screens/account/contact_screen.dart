import 'package:flutter/material.dart'; // Importa Flutter Material para construir la interfaz de usuario.
import '../../config/lang/app_localization.dart'; // Importa el sistema de localización para traducir textos.
import '../../config/utils/appcolors.dart'; // Importa los colores personalizados definidos en la configuración.

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
              'contactTitle'), // Traduce y muestra el título de la pantalla de contacto.
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Permite el desplazamiento si el contenido excede la pantalla.
          padding: EdgeInsets.all(
              16.0), // Aplica un padding de 16 píxeles a todo el contenido.
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Centra los hijos verticalmente en el espacio disponible.
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Estira los hijos para ocupar el ancho máximo.
            children: [
              Text(
                AppLocalizations.of(context)!.translate(
                    'contactHeader'), // Traduce y muestra el encabezado de contacto.
                style: Theme.of(context)
                    .textTheme
                    .titleLarge, // Aplica el estilo de texto grande definido en el tema.
                textAlign: TextAlign.center, // Centra el texto.
              ),
              SizedBox(
                  height:
                      16.0), // Espacio entre el encabezado y la descripción.
              Text(
                AppLocalizations.of(context)!.translate(
                    'contactDescription'), // Traduce y muestra la descripción de contacto.
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge, // Aplica el estilo del cuerpo del texto grande.
                textAlign: TextAlign.center, // Centra el texto.
              ),
              SizedBox(
                  height:
                      32.0), // Espacio entre la descripción y el primer campo de texto.
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(
                      'subject'), // Traduce y establece el texto de la etiqueta para el campo del asunto.
                  border:
                      OutlineInputBorder(), // Establece un borde alrededor del campo de texto.
                ),
              ),
              SizedBox(height: 16.0), // Espacio entre los campos de texto.
              TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(
                      'email'), // Traduce y establece el texto de la etiqueta para el campo del email.
                  border:
                      OutlineInputBorder(), // Establece un borde alrededor del campo de texto.
                ),
              ),
              SizedBox(height: 16.0), // Espacio entre los campos de texto.
              TextFormField(
                maxLines:
                    null, // Permite múltiples líneas en el campo de mensaje.
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(
                      'message'), // Traduce y establece el texto de la etiqueta para el campo del mensaje.
                  border:
                      OutlineInputBorder(), // Establece un borde alrededor del campo de texto.
                ),
              ),
              SizedBox(height: 32.0), // Espacio antes del botón de envío.
              ElevatedButton(
                onPressed:
                    () {}, // Acción a realizar al presionar el botón (actualmente vacío).
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Colors.white, // Establece el color del texto del botón.
                  backgroundColor: AppColors
                      .gdarkblue2, // Establece el color de fondo del botón.
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical:
                          0.0), // Aplica padding horizontal y vertical al botón.
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleMedium, // Aplica el estilo de texto medio definido en el tema.
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate(
                      'sendButton'), // Traduce y establece el texto del botón de envío.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
