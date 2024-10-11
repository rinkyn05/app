import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa la biblioteca de Firestore.
import 'package:fl_chart/fl_chart.dart'; // Importa la biblioteca de gráficos.
import '../config/lang/app_localization.dart'; // Importa la configuración de localización de la aplicación.
import '../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación.

class CustomPieChartCard extends StatelessWidget {
  final String
      userEmail; // Correo electrónico del usuario, utilizado para acceder a sus estadísticas.

  const CustomPieChartCard({
    Key? key,
    required this.userEmail, // Correo electrónico del usuario es un parámetro obligatorio.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      // Escucha cambios en el documento de Firestore.
      stream: FirebaseFirestore.instance
          .collection(
              'userstats') // Colección que contiene las estadísticas del usuario.
          .doc(userEmail) // Documento específico del usuario.
          .snapshots(),
      builder: (context, snapshot) {
        // Constructor del StreamBuilder.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget(); // Muestra un indicador de carga mientras espera datos.
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.data() == null) {
          return _buildNoDataWidget(
              context); // Muestra un mensaje de error o "sin datos".
        }

        var userData = snapshot.data!
            .data()!; // Datos del usuario recuperados de Firestore.
        var userStats = userData; // Estadísticas del usuario.

        return Card(
          elevation: 4, // Sombra de la tarjeta.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Esquinas redondeadas de la tarjeta.
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Espaciado interno.
            child: Column(
              children: [
                _buildPieChart(
                    context, userStats), // Construye el gráfico circular.
                const SizedBox(
                    height: 16), // Espaciado entre el gráfico y el texto.
                Text(
                  AppLocalizations.of(context)!
                      .translate('pieChartTitle'), // Título del gráfico.
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge, // Estilo del texto.
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    // Widget que muestra un indicador de carga.
    return const Center(
      child: CircularProgressIndicator(), // Indicador de progreso circular.
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    // Widget que muestra un mensaje cuando no hay datos disponibles.
    return Card(
      elevation: 4, // Sombra de la tarjeta.
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10), // Esquinas redondeadas de la tarjeta.
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado interno.
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.3, // Relación de aspecto del gráfico.
              child: PieChart(
                PieChartData(
                  sections:
                      _buildEmptySectionsData(), // Datos vacíos para el gráfico.
                ),
              ),
            ),
            const SizedBox(
                height: 16), // Espaciado entre el gráfico y el texto.
            Text(
              AppLocalizations.of(context)!
                  .translate('pieChartTitle'), // Título del gráfico.
              style:
                  Theme.of(context).textTheme.titleLarge, // Estilo del texto.
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildEmptySectionsData() {
    // Devuelve una lista de secciones vacías para el gráfico circular.
    return <PieChartSectionData>[
      PieChartSectionData(
        color: AppColors.contentColorBlue, // Color de la sección.
        value: 0, // Valor de la sección.
        title: '0%', // Título de la sección.
      ),
      PieChartSectionData(
        color: AppColors.contentColorYellow,
        value: 0,
        title: '0%',
      ),
      PieChartSectionData(
        color: AppColors.contentColorGreen,
        value: 0,
        title: '0%',
      ),
      PieChartSectionData(
        color: AppColors.contentColorRed,
        value: 0,
        title: '0%',
      ),
    ];
  }

  Widget _buildPieChart(BuildContext context, Map<String, dynamic> userStats) {
    // Construye el gráfico circular utilizando las estadísticas del usuario.
    var sectionsData = <PieChartSectionData>[
      if (userStats['caloriasQuemadas'] != null) // Verifica si el dato existe.
        PieChartSectionData(
          color: AppColors.contentColorBlue, // Color de la sección.
          value: double.parse(
              userStats['caloriasQuemadas'].toString()), // Valor de la sección.
          title: '${userStats['caloriasQuemadas']}%', // Título de la sección.
        ),
      if (userStats['tiempoDeEjercicios'] != null)
        PieChartSectionData(
          color: AppColors.contentColorYellow,
          value: double.parse(userStats['tiempoDeEjercicios'].toString()),
          title: '${userStats['tiempoDeEjercicios']}%',
        ),
      if (userStats['ejerciciosRealizados'] != null)
        PieChartSectionData(
          color: AppColors.contentColorGreen,
          value: double.parse(userStats['ejerciciosRealizados'].toString()),
          title: '${userStats['ejerciciosRealizados']}%',
        ),
      if (userStats['rutinascompletadas'] != null)
        PieChartSectionData(
          color: AppColors.contentColorRed,
          value: double.parse(userStats['rutinascompletadas'].toString()),
          title: '${userStats['rutinascompletadas']}%',
        ),
    ];

    return AspectRatio(
      aspectRatio: 1.3, // Relación de aspecto del gráfico.
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event,
                  pieTouchResponse) {}), // Manejo de eventos táctiles.
          borderData:
              FlBorderData(show: false), // Configuración del borde del gráfico.
          sectionsSpace: 0, // Espacio entre secciones.
          centerSpaceRadius: 0, // Radio del espacio central.
          sections: sectionsData, // Secciones del gráfico.
        ),
      ),
    );
  }
}
