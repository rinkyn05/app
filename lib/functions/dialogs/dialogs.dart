import 'package:flutter/material.dart';

void showInfoDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Text(content),
      );
    },
  );
}

void showInfoActividadFisicaDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Actividad Física',
    content: 'Este es un párrafo de Actividad Física.',
  );
}

void showInfoCalentamientoFisicoDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Calentamiento Físico',
    content: 'Este es un párrafo de Calentamiento Físico.',
  );
}

void showInfoDescansoEntreEjerciciosDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Descanso Entre Ejercicios',
    content: 'Este es un párrafo de Descanso Entre Ejercicios.',
  );
}

void showInfoDescansoEntreCircuitoDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Descanso Entre Circuito',
    content: 'Este es un párrafo de Descanso Entre Circuito.',
  );
}

void showInfoDescansoEntreSeriesDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Descanso Entre Series',
    content: 'Este es un párrafo de Descanso Entre Series.',
  );
}

void showInfoEstiramientoEstaticoDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Estiramiento Estático',
    content: 'Este es un párrafo de Estiramiento Estático.',
  );
}

void showInfoDiasALaSemanaDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Días a la Semana',
    content: 'Este es un párrafo de Días a la Semana.',
  );
}

void showInfoCalentamientoArticularDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Calentamiento Articular',
    content: 'Este es un párrafo de Calentamiento Articular.',
  );
}

void showInfoCantidadDeEjerciciosDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Cantidad de Ejercicios',
    content: 'Este es un párrafo de Cantidad de Ejercicios.',
  );
}

void showInfoRepeticionesPorEjerciciosDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Repeticiones por Ejercicios',
    content: 'Este es un párrafo de Repeticiones por Ejercicios.',
  );
}

void showInfoCantidadDeCircuitosDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Cantidad de Circuitos',
    content: 'Este es un párrafo de Cantidad de Circuitos.',
  );
}

void showInfoCantidadDeSeriesDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Cantidad de Series',
    content: 'Este es un párrafo de Cantidad de Series.',
  );
}

void showInfoPorcentajeDeRMDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Porcentaje de RM',
    content: 'Este es un párrafo de Porcentaje de RM.',
  );
}
