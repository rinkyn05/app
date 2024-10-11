import 'package:flutter/material.dart';

import '../config/lang/app_localization.dart'; // Importa la configuración de localización de la aplicación.

class DropdownWidget extends StatefulWidget {
  final List<String> options; // Lista de opciones para el menú desplegable.
  final String? selectedValue; // Valor actualmente seleccionado.
  final String labelText; // Texto de la etiqueta del menú desplegable.
  final void Function(String?)?
      onChanged; // Función que se llama cuando cambia la selección.

  const DropdownWidget({
    super.key,
    required this.options, // Lista de opciones obligatoria.
    this.selectedValue, // Valor seleccionado opcional.
    required this.labelText, // Etiqueta obligatoria.
    required this.onChanged, // Función de cambio obligatoria.
  });

  @override
  DropdownWidgetState createState() =>
      DropdownWidgetState(); // Crea el estado asociado al widget.
}

class DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtiene el tema actual.

    return DropdownButtonFormField(
      iconEnabledColor: theme.iconTheme.color, // Color del ícono habilitado.
      selectedItemBuilder: (BuildContext context) {
        // Construye la lista de elementos seleccionados.
        return widget.options.map<Widget>((String item) {
          return Text(
            item,
            style: TextStyle(
              fontFamily:
                  "MB", // Fuente utilizada para los elementos seleccionados.
              color: theme.textTheme.titleLarge!.color, // Color del texto.
            ),
          );
        }).toList(); // Convierte la lista en un widget.
      },
      decoration: InputDecoration(
        labelText: widget.labelText, // Texto de la etiqueta.
        labelStyle: theme.textTheme.titleLarge, // Estilo de la etiqueta.
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10), // Radio del borde del contenedor.
          borderSide: BorderSide(
            color: theme.primaryColor, // Color del borde.
            width: 2, // Grosor del borde.
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10), // Radio del borde cuando está habilitado.
          borderSide: BorderSide(
            color: theme.primaryColor, // Color del borde habilitado.
            width: 8, // Grosor del borde habilitado.
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10), // Radio del borde cuando está enfocado.
          borderSide: BorderSide(
            color: theme.primaryColor, // Color del borde enfocado.
            width: 6, // Grosor del borde enfocado.
          ),
        ),
      ),
      items: widget.options.map((option) {
        // Mapea las opciones en elementos del menú desplegable.
        return DropdownMenuItem(
          value: option, // Valor del elemento del menú.
          child: Text(
            option,
            style: TextStyle(
              fontFamily: "MB", // Fuente utilizada para las opciones.
              color: theme.textTheme.titleLarge!.color, // Color del texto.
            ),
          ),
        );
      }).toList(), // Convierte la lista de opciones en widgets.
      value: widget.selectedValue, // Valor actualmente seleccionado.
      onChanged:
          widget.onChanged, // Función que se llama al cambiar la selección.
      validator: (value) {
        // Validador para asegurar que se seleccione una opción.
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.translate(
              'selectOptionValidation'); // Mensaje de error si no hay selección.
        }
        return null; // Retorna null si la validación es exitosa.
      },
    );
  }
}
