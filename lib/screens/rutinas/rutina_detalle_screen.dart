import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../backend/models/ejercicio_rutina_model.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/custom_appbar_new.dart';
import 'rutina_ejecucion_screen.dart';

class RutinaDetalleScreen extends StatelessWidget {
  final Rutina rutina;

  const RutinaDetalleScreen({Key? key, required this.rutina}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  rutina.ejercicios.first.imagen,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoCard(
                    title: AppLocalizations.of(context)!
                        .translate('totalDuration'),
                    value: rutina.duracionTotal,
                    icon: Icons.timer,
                  ),
                  _InfoCard(
                    title: AppLocalizations.of(context)!
                        .translate('totalCalories'),
                    value: '${rutina.caloriasTotal} kcal',
                    icon: Icons.local_fire_department,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: rutina.ejercicios.map((ejercicio) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      leading: Image.network(ejercicio.imagen,
                          width: 70, height: 70, fit: BoxFit.cover),
                      title: Text(ejercicio.nombre,
                          style: theme.textTheme.titleMedium),
                      subtitle: Text(
                          '${ejercicio.duracion} - ${ejercicio.calorias} kcal',
                          style: theme.textTheme.bodyMedium),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => _mostrarDialogoInicio(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 2, 11, 59)
              : Colors.white,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[300]
              : const Color.fromARGB(255, 2, 11, 59),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          padding: const EdgeInsets.all(15.0),
        ),
        icon: const Icon(Icons.play_arrow, size: 56),
        label: Text(
          AppLocalizations.of(context)!.translate('startt'),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  void _mostrarDialogoInicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('areYouReady')),
          content: Text(
              AppLocalizations.of(context)!.translate('readyToStartRoutine')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('notReady')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('letsStart')),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RutinaEjecucionScreen(
                    ejercicios: rutina.ejercicios,
                    intervalo: rutina.intervalo,
                    nombreRutina: rutina.nombreRutina,
                    auth: FirebaseAuth.instance,
                    firestore: FirebaseFirestore.instance,
                  ),
                ));
              },
            ),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
