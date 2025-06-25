import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/notifiers/selection_notifier.dart';
import '../anatomic_adapt.dart';
import 'anatomic_adapt2.dart';
import 'anatomic_adapt3.dart';
import 'anatomic_adapt4.dart';
import 'anatomic_adapt5.dart';
import 'anatomic_adapt6.dart';
import 'anatomic_adapt7.dart';
import 'anatomic_adapt8.dart';
// Asegúrate de importar los archivos necesarios

class CantidadEjerciciosRedirect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el notifier
    final notifier = Provider.of<SelectionNotifier>(context);
    int cantidadDeEjercicios = int.tryParse(
          notifier.cantidadDeEjerciciosEsp.replaceAll(RegExp(r'[^0-9]'), '')) ??
      0;

    Widget redirectWidget;

    switch (cantidadDeEjercicios) {
      case 2:
        redirectWidget = AnatomicAdaptVideo2();
        break;
      case 3:
        redirectWidget = AnatomicAdaptVideo3();
        break;
      case 4:
        redirectWidget = AnatomicAdaptVideo4();
        break;
      case 5:
        redirectWidget = AnatomicAdaptVideo5();
        break;
      case 6:
        redirectWidget = AnatomicAdaptVideo6();
        break;
      case 7:
        redirectWidget = AnatomicAdaptVideo7();
        break;
      case 8:
        redirectWidget = AnatomicAdaptVideo8();
        break;
      default:
        redirectWidget = AnatomicAdaptVideo();
    }

    // Navegar a la pantalla correspondiente y evitar volver atrás
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => redirectWidget),
      );
    });

    // Retornar un contenedor vacío mientras se realiza la redirección
    return Container();
  }
}