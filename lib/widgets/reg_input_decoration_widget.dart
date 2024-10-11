import 'package:flutter/material.dart';

// Widget que crea un campo de entrada de texto con decoración personalizada para el registro.
class RegistrationInputDecorationWidget extends StatelessWidget {
  final String labelText; // Texto de la etiqueta del campo de entrada.
  final String hintext; // Texto de sugerencia (hint) del campo de entrada.
  final IconData? icon; // Icono opcional que se muestra al lado del campo de entrada.
  final IconData? prefixIcon; // Icono que se muestra al principio del campo de entrada.
  final Widget? suffixIcon; // Icono que se muestra al final del campo de entrada.
  final TextEditingController? controller; // Controlador para obtener y establecer el texto en el campo de entrada.
  final String? Function(String?)? validator; // Función para validar el texto ingresado en el campo.
  final bool? obscureText; // Si es verdadero, oculta el texto ingresado (utilizado para contraseñas).
  final Function(String)? onChanged; // Callback que se llama cuando el texto cambia.
  final TextInputType? keyboardType; // Tipo de teclado que se mostrará (por ejemplo, texto, número).
  final int? maxLines; // Número máximo de líneas que se permitirán en el campo.
  final String? initialValue; // Valor inicial del campo de entrada.

  // Constructor del widget que requiere algunos parámetros y permite opcionalmente otros.
  const RegistrationInputDecorationWidget({
    super.key,
    required this.labelText,
    required this.hintext,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.obscureText,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Obtiene el tema actual del contexto.

    // Define los colores utilizados en el borde y el texto según el brillo del tema.
    final Color borderColor = theme.brightness == Brightness.light
        ? Colors.grey[300]! // Color del borde en modo claro.
        : theme.colorScheme.secondary; // Color del borde en modo oscuro.
    final Color textColor = theme.textTheme.bodyLarge!.color!; // Color del texto.
    final Color hintColor = textColor.withOpacity(0.3); // Color del texto de sugerencia.
    final Color iconColor = theme.iconTheme.color!; // Color de los iconos.
    final Color errorColor = theme.colorScheme.error; // Color para los mensajes de error.

    // Retorna un campo de texto con decoración personalizada.
    return TextFormField(
      controller: controller, // Controlador del campo de texto.
      style: theme.textTheme.bodyLarge, // Estilo del texto del campo.
      obscureText: obscureText ?? false, // Si se debe ocultar el texto.
      readOnly: false, // Indica que el campo no es de solo lectura.
      autocorrect: true, // Permite la corrección automática del texto.
      onTap: onChanged != null ? () => onChanged!(controller!.text) : null, // Llama a onChanged al tocar el campo.
      keyboardType: keyboardType, // Tipo de teclado que se mostrará.
      maxLines: maxLines ?? 1, // Número máximo de líneas permitidas.
      initialValue: initialValue, // Valor inicial del campo.
      validator: validator, // Función de validación.
      onChanged: onChanged, // Callback para cambios en el texto.
      decoration: InputDecoration(
        labelText: labelText, // Texto de la etiqueta del campo.
        hintText: hintext, // Texto de sugerencia del campo.
        errorStyle: TextStyle(
          color: errorColor, // Color del texto de error.
          fontFamily: theme.textTheme.bodyLarge!.fontFamily, // Fuente del texto de error.
        ),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: iconColor) : null, // Icono prefijo si existe.
        suffixIcon: suffixIcon, // Icono sufijo.
        icon: icon != null ? Icon(icon, color: iconColor) : null, // Icono general si existe.
        labelStyle: theme.textTheme.bodyLarge, // Estilo del texto de la etiqueta.
        hintStyle: TextStyle(
          color: hintColor, // Color del texto de sugerencia.
          fontFamily: theme.textTheme.bodyLarge!.fontFamily, // Fuente del texto de sugerencia.
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo.
          borderSide: BorderSide(color: borderColor, width: 2), // Estilo del borde.
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo de error.
          borderSide: BorderSide(color: errorColor, width: 2), // Estilo del borde de error.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo enfocado.
          borderSide: BorderSide(color: borderColor, width: 2), // Estilo del borde enfocado.
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo de error enfocado.
          borderSide: BorderSide(color: errorColor, width: 2), // Estilo del borde de error enfocado.
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo habilitado.
          borderSide: BorderSide(color: borderColor, width: 2), // Estilo del borde habilitado.
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Radio de los bordes del campo deshabilitado.
          borderSide: BorderSide(color: borderColor, width: 2), // Estilo del borde deshabilitado.
        ),
      ),
    );
  }
}
