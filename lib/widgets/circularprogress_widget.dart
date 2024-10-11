import 'package:flutter/material.dart';

// Widget para mostrar un indicador de progreso circular con un texto.
class CircularProgressWidget extends StatefulWidget {
  final String text; // Texto que se mostrará junto al indicador de progreso.
  final Color colors; // Color del indicador y del texto.

  const CircularProgressWidget({
    super.key,
    required this.text, // Requiere un texto como parámetro.
    required this.colors, // Requiere un color como parámetro.
  });

  @override
  State<CircularProgressWidget> createState() =>
      _CircularProgressWidgetState(); // Crea el estado del widget.
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  void initState() {
    super.initState();
    // Espera 2 segundos antes de actualizar el estado del widget.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted)
        setState(
            () {}); // Asegura que el widget esté montado antes de llamar a setState.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra los elementos en la fila.
        children: [
          CircularProgressIndicator(
              color: widget
                  .colors), // Indicador de progreso circular con el color especificado.
          const SizedBox(
              width: 15), // Espacio horizontal entre el indicador y el texto.
          Text(
            widget.text, // Muestra el texto proporcionado.
            style: TextStyle(
                color: widget.colors,
                fontFamily: "MB"), // Estilo del texto con color y fuente.
          ),
        ],
      ),
    );
  }
}
