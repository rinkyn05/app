import 'package:flutter/material.dart';
import '../../backend/models/ejercicio_rutina_model.dart';
import '../../config/lang/app_localization.dart';
import '../../functions/rutinas/show_rutinas_service.dart';
import '../../widgets/custom_appbar_new.dart';
import 'add_rutinas_screen.dart';
import 'rutina_detalle_screen.dart';

class RutinasScreen extends StatefulWidget {
  const RutinasScreen({Key? key}) : super(key: key);

  @override
  RutinasScreenState createState() => RutinasScreenState();
}

class RutinasScreenState extends State<RutinasScreen> {
  List<Rutina> rutinas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRutinas();
  }

  Future<void> _cargarRutinas() async {
    var rutinasObtenidas = await ShowRutinaService().obtenerRutinasUsuario();
    if (mounted) {
      setState(() {
        rutinas = rutinasObtenidas;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rutinas.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate('addRutinasPrompt'),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                )
              : _buildRutinasList(theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const AddRutinasScreen(ejerciciosSeleccionados: [],)))
              .then((_) => _cargarRutinas());
        },
        backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
        child: Icon(Icons.add, color: theme.iconTheme.color),
      ),
    );
  }

  Widget _buildRutinasList(ThemeData theme) {
    return ListView.builder(
      itemCount: rutinas.length,
      itemBuilder: (context, index) {
        final rutina = rutinas[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RutinaDetalleScreen(rutina: rutina),
              ));
            },
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  rutina.ejercicios.isNotEmpty
                      ? Image.network(
                          rutina.ejercicios.first.imagen,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(
                          height: 100,
                          child: Icon(Icons.fitness_center, size: 50),
                        ),
                  Text(
                    rutina.nombreRutina,
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.translate('calories')}: ${rutina.caloriasTotal}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow,
                            color: theme.iconTheme.color),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                RutinaDetalleScreen(rutina: rutina),
                          ));
                        },
                        iconSize: 40.0,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.translate('duration')}: ${rutina.duracionTotal}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.delete, color: theme.colorScheme.error),
                        onPressed: () {},
                        iconSize: 40.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
