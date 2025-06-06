import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/selected_notifier.dart';
import '../../config/notifiers/selection_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/dialogs/dialogs.dart';
import '../../functions/ejercicios/calentamiento_fisico_in_ejercicio_functions.dart';
import '../../functions/ejercicios/estiramiento_fisico_in_ejercicio_functions.dart';
import '../../widgets/custom_appbar_new.dart';
import 'anatomic_adapt.dart';

class AnatAadaptPlanCreator extends StatefulWidget {
  const AnatAadaptPlanCreator({Key? key}) : super(key: key);

  @override
  State<AnatAadaptPlanCreator> createState() => _AnatAadaptPlanCreatorState();
}

class _AnatAadaptPlanCreatorState extends State<AnatAadaptPlanCreator> {
  String _intensityEsp = 'Seleccionar';
  String _intensityEng = 'Select';

  String _calentamientoFisicoEsp = 'Seleccionar';
  String _calentamientoFisicoEng = 'Select';

  String _descansoEntreEjerciciosEsp = 'Seleccionar';
  String _descansoEntreEjerciciosEng = 'Select';

  String _descansoEntreCircuitoEsp = 'Seleccionar';
  String _descansoEntreCircuitoEng = 'Select';

  String _estiramientoEstaticoEsp = 'Seleccionar';
  String _estiramientoEstaticoEng = 'Select';

  String _diasALaSemanaEsp = 'Seleccionar';
  String _diasALaSemanaEng = 'Select';

  String _calentamientoArticularEsp = '5 Minutos';
  String _calentamientoArticularEng = '5 Minutes';

  String _cantidadDeEjerciciosEsp = 'Seleccionar';
  String _cantidadDeEjerciciosEng = 'Select';

  String _repeticionesPorEjerciciosEsp = 'Seleccionar';
  String _repeticionesPorEjerciciosEng = 'Select';

  String _cantidadDeCircuitosEsp = 'Seleccionar';
  String _cantidadDeCircuitosEng = 'Select';

  String _porcentajeDeRMEsp = 'Seleccionar';
  String _porcentajeDeRMEng = 'Select';

  String _nombreRutinaEsp = '';
  String _nombreRutinaEng = '';

  String?
      _selectedCalentamientoFisicoId; // Cambiado a String para almacenar un solo ID
  String? _selectedCalentamientoFisicoNameEsp;
  String? _selectedCalentamientoFisicoNameEng;
  Map<String, Map<String, String>> calentamientoFisicoNames = {};

  String?
      _selectedEstiramientoFisicoId; // Cambiado a String para almacenar un solo ID
  String? _selectedEstiramientoFisicoNameEsp;
  String? _selectedEstiramientoFisicoNameEng;
  Map<String, Map<String, String>> estiramientoFisicoNames = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  
  Future<void> _storeSelectedValues() async {
    // Imprimir los valores antes de la verificación
    print('Verificando las selecciones...');
    print('intensityEsp: $_intensityEsp');
    print('intensityEng: $_intensityEng');
    print('calentamientoFisicoEsp: $_calentamientoFisicoEsp');
    print('calentamientoFisicoEng: $_calentamientoFisicoEng');
    print('descansoEntreEjerciciosEsp: $_descansoEntreEjerciciosEsp');
    print('descansoEntreEjerciciosEng: $_descansoEntreEjerciciosEng');
    print('descansoEntreCircuitoEsp: $_descansoEntreCircuitoEsp');
    print('descansoEntreCircuitoEng: $_descansoEntreCircuitoEng');
    print('estiramientoEstaticoEsp: $_estiramientoEstaticoEsp');
    print('estiramientoEstaticoEng: $_estiramientoEstaticoEng');
    print('diasALaSemanaEsp: $_diasALaSemanaEsp');
    print('diasALaSemanaEng: $_diasALaSemanaEng');
    print('calentamientoArticularEsp: $_calentamientoArticularEsp');
    print('calentamientoArticularEng: $_calentamientoArticularEng');
    print('cantidadDeEjerciciosEsp: $_cantidadDeEjerciciosEsp');
    print('cantidadDeEjerciciosEng: $_cantidadDeEjerciciosEng');
    print('repeticionesPorEjerciciosEsp: $_repeticionesPorEjerciciosEsp');
    print('repeticionesPorEjerciciosEng: $_repeticionesPorEjerciciosEng');
    print('cantidadDeCircuitosEsp: $_cantidadDeCircuitosEsp');
    print('cantidadDeCircuitosEng: $_cantidadDeCircuitosEng');
    print('porcentajeDeRMEsp: $_porcentajeDeRMEsp');
    print('porcentajeDeRMEng: $_porcentajeDeRMEng');
    print('nombreRutinaEsp: $_nombreRutinaEsp');
    print('nombreRutinaEng: $_nombreRutinaEng');

    print('calentamientoFisicoNames: $calentamientoFisicoNames');
    print('selectedCalentamientoFisicoId: $_selectedCalentamientoFisicoId');
    print(
        'selectedCalentamientoFisicoNameEsp: $_selectedCalentamientoFisicoNameEsp');
    print(
        'selectedCalentamientoFisicoNameEng: $_selectedCalentamientoFisicoNameEng');

    print('estiramientoFisicoNames: $estiramientoFisicoNames');
    print('selectedEstiramientoFisicoId: $_selectedEstiramientoFisicoId');
    print(
        'selectedEstiramientoFisicoNameEsp: $_selectedEstiramientoFisicoNameEsp');
    print(
        'selectedEstiramientoFisicoNameEng: $_selectedEstiramientoFisicoNameEng');

    // Verificar si todas las variables han sido seleccionadas
    if (_intensityEsp != 'Seleccionar' &&
        _intensityEng != 'Select' &&
        _calentamientoFisicoEsp != 'Seleccionar' &&
        _calentamientoFisicoEng != 'Select' &&
        _descansoEntreEjerciciosEsp != 'Seleccionar' &&
        _descansoEntreEjerciciosEng != 'Select' &&
        _descansoEntreCircuitoEsp != 'Seleccionar' &&
        _descansoEntreCircuitoEng != 'Select' &&
        _estiramientoEstaticoEsp != 'Seleccionar' &&
        _estiramientoEstaticoEng != 'Select' &&
        _diasALaSemanaEsp != 'Seleccionar' &&
        _diasALaSemanaEng != 'Select' &&
        _calentamientoArticularEsp != 'Seleccionar' &&
        _calentamientoArticularEng != 'Select' &&
        _cantidadDeEjerciciosEsp != 'Seleccionar' &&
        _cantidadDeEjerciciosEng != 'Select' &&
        _repeticionesPorEjerciciosEsp != 'Seleccionar' &&
        _repeticionesPorEjerciciosEng != 'Select' &&
        _cantidadDeCircuitosEsp != 'Seleccionar' &&
        _cantidadDeCircuitosEng != 'Select' &&
        _porcentajeDeRMEsp != 'Seleccionar' &&
        _porcentajeDeRMEng != 'Select' &&
        _nombreRutinaEsp.isNotEmpty &&
        _nombreRutinaEng.isNotEmpty &&
        _selectedCalentamientoFisicoId != null &&
        _selectedCalentamientoFisicoNameEsp != null &&
        _selectedCalentamientoFisicoNameEng != null &&
        _selectedEstiramientoFisicoId != null &&
        _selectedEstiramientoFisicoNameEsp != null &&
        _selectedEstiramientoFisicoNameEng != null) {
      // Usar el notifier para almacenar las selecciones
      print('Almacenando las selecciones en el notifier...');
      Provider.of<SelectionNotifier>(context, listen: false).updateSelection(
        intensityEsp: _intensityEsp,
        intensityEng: _intensityEng,
        calentamientoFisicoEsp: _calentamientoFisicoEsp,
        calentamientoFisicoEng: _calentamientoFisicoEng,
        descansoEntreEjerciciosEsp: _descansoEntreEjerciciosEsp,
        descansoEntreEjerciciosEng: _descansoEntreEjerciciosEng,
        descansoEntreCircuitoEsp: _descansoEntreCircuitoEsp,
        descansoEntreCircuitoEng: _descansoEntreCircuitoEng,
        estiramientoEstaticoEsp: _estiramientoEstaticoEsp,
        estiramientoEstaticoEng: _estiramientoEstaticoEng,
        diasALaSemanaEsp: _diasALaSemanaEsp,
        diasALaSemanaEng: _diasALaSemanaEng,
        calentamientoArticularEsp: _calentamientoArticularEsp,
        calentamientoArticularEng: _calentamientoArticularEng,
        cantidadDeEjerciciosEsp: _cantidadDeEjerciciosEsp,
        cantidadDeEjerciciosEng: _cantidadDeEjerciciosEng,
        repeticionesPorEjerciciosEsp: _repeticionesPorEjerciciosEsp,
        repeticionesPorEjerciciosEng: _repeticionesPorEjerciciosEng,
        cantidadDeCircuitosEsp: _cantidadDeCircuitosEsp,
        cantidadDeCircuitosEng: _cantidadDeCircuitosEng,
        porcentajeDeRMEsp: _porcentajeDeRMEsp,
        porcentajeDeRMEng: _porcentajeDeRMEng,
        nombreRutinaEsp: _nombreRutinaEsp,
        nombreRutinaEng: _nombreRutinaEng,
        calentamientoFisicoNames: calentamientoFisicoNames,
        selectedCalentamientoFisicoId: _selectedCalentamientoFisicoId,
        selectedCalentamientoFisicoNameEsp: _selectedCalentamientoFisicoNameEsp,
        selectedCalentamientoFisicoNameEng: _selectedCalentamientoFisicoNameEng,
        estiramientoFisicoNames: estiramientoFisicoNames,
        selectedEstiramientoFisicoId: _selectedEstiramientoFisicoId,
        selectedEstiramientoFisicoNameEsp: _selectedEstiramientoFisicoNameEsp,
        selectedEstiramientoFisicoNameEng: _selectedEstiramientoFisicoNameEng,
      );

      // Guardar en SharedPreferences
      print('Almacenando las selecciones en SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('intensityEsp', _intensityEsp);
      await prefs.setString('intensityEng', _intensityEng);
      await prefs.setString('calentamientoFisicoEsp', _calentamientoFisicoEsp);
      await prefs.setString('calentamientoFisicoEng', _calentamientoFisicoEng);
      await prefs.setString(
          'estiramientoEstaticoEsp', _estiramientoEstaticoEsp);
      await prefs.setString(
          'estiramientoEstaticoEng', _estiramientoEstaticoEng);
      await prefs.setString(
          'cantidadDeEjerciciosEsp', _cantidadDeEjerciciosEsp);
      await prefs.setString(
          'cantidadDeEjerciciosEng', _cantidadDeEjerciciosEng);

      // Guardar listas de calentamientos y estiramientos físicos
      await prefs.setString(
          'selectedCalentamientoFisicoId', _selectedCalentamientoFisicoId!);
      await prefs.setString('selectedCalentamientoFisicoNameEsp',
          _selectedCalentamientoFisicoNameEsp!);
      await prefs.setString('selectedCalentamientoFisicoNameEng',
          _selectedCalentamientoFisicoNameEng!);

      await prefs.setString(
          'selectedEstiramientoFisicoId', _selectedEstiramientoFisicoId!);
      await prefs.setString('selectedEstiramientoFisicoNameEsp',
          _selectedEstiramientoFisicoNameEsp!);
      await prefs.setString('selectedEstiramientoFisicoNameEng',
          _selectedEstiramientoFisicoNameEng!);

      // Mostrar Snackbar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciones almacenadas con éxito.'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Selecciones almacenadas con éxito.');

      // Navegar a la pantalla de AnatomicAdapt y pasar los valores
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnatomicAdaptVideo(),
          ),
        );
      });
    } else {
      // Mostrar Snackbar de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe seleccionar una opción en todos los campos.'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Debe seleccionar una opción en todos los campos.');
    }
  }

  Widget _buildcompleteButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _storeSelectedValues, // Asignar la nueva función al botón
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.gdarkblue2,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            textStyle: Theme.of(context).textTheme.labelMedium,
          ),
          child: const Text('Completar'),
        ),
      ],
    );
  }

  Widget _buildIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('actividadFisica'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildIntensitySelector(),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      'Fácil',
      'Intermedio',
      'Avanzado'
    ];
    List<String> optionsEng = ['Select', 'Easy', 'Medium', 'Advanced'];

    Map<String, String> intensityMapEspToEng = {
      'Seleccionar': 'Select',
      'Fácil': 'Easy',
      'Intermedio': 'Medium',
      'Avanzado': 'Advanced',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Select': 'Seleccionar',
      'Easy': 'Fácil',
      'Medium': 'Intermedio',
      'Advanced': 'Avanzado',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentIntensity = isEsp ? _intensityEsp : _intensityEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectDifficulty')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _intensityEsp = newValue!;
                        _intensityEng = intensityMapEspToEng[newValue]!;
                        if (newValue == 'Seleccionar') {
                          _diasALaSemanaEsp = 'Seleccionar';
                          _diasALaSemanaEng = 'Select';
                          _repeticionesPorEjerciciosEsp = 'Seleccionar';
                          _repeticionesPorEjerciciosEng = 'Select';
                          _cantidadDeCircuitosEsp = 'Seleccionar';
                          _cantidadDeCircuitosEng = 'Select';
                          _porcentajeDeRMEsp = 'Seleccionar';
                          _porcentajeDeRMEng = 'Select';
                        } else if (newValue == 'Fácil') {
                          _diasALaSemanaEsp = '2 Dias';
                          _diasALaSemanaEng = '2 Days';
                          _cantidadDeEjerciciosEsp = '2 Ejercicios';
                          _cantidadDeEjerciciosEng = '2 Exercises';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _cantidadDeCircuitosEsp = '2 Circuitos';
                          _cantidadDeCircuitosEng = '2 Circuits';
                          _porcentajeDeRMEsp = '30%';
                          _porcentajeDeRMEng = '30%';
                        } else if (newValue == 'Intermedio') {
                          _diasALaSemanaEsp = '3 Dias';
                          _diasALaSemanaEng = '3 Days';
                          _cantidadDeEjerciciosEsp = '4 Ejercicios';
                          _cantidadDeEjerciciosEng = '4 Exercises';
                          _repeticionesPorEjerciciosEsp = '8 Repeticiones';
                          _repeticionesPorEjerciciosEng = '8 Repetitions';
                          _cantidadDeCircuitosEsp = '2 Circuitos';
                          _cantidadDeCircuitosEng = '2 Circuits';
                          _porcentajeDeRMEsp = '40%';
                          _porcentajeDeRMEng = '40%';
                        } else if (newValue == 'Avanzado') {
                          _diasALaSemanaEsp = '3 Dias';
                          _diasALaSemanaEng = '3 Days';
                          _cantidadDeEjerciciosEsp = '5 Ejercicios';
                          _cantidadDeEjerciciosEng = '5 Exercises';
                          _repeticionesPorEjerciciosEsp = '10 Repeticiones';
                          _repeticionesPorEjerciciosEng = '10 Repetitions';
                          _cantidadDeCircuitosEsp = '3 Circuitos';
                          _cantidadDeCircuitosEng = '3 Circuits';
                          _porcentajeDeRMEsp = '50%';
                          _porcentajeDeRMEng = '50%';
                        }
                      } else {
                        _intensityEng = newValue!;
                        _intensityEsp = intensityMapEngToEsp[newValue]!;

                        if (newValue == 'Select') {
                          _diasALaSemanaEng = 'Select';
                          _diasALaSemanaEsp = 'Seleccionar';
                          _repeticionesPorEjerciciosEng = 'Select';
                          _repeticionesPorEjerciciosEsp = 'Seleccionar';
                          _cantidadDeCircuitosEng = 'Select';
                          _cantidadDeCircuitosEsp = 'Seleccionar';
                          _porcentajeDeRMEng = 'Select';
                          _porcentajeDeRMEsp = 'Seleccionar';
                        } else if (newValue == 'Easy') {
                          _diasALaSemanaEng = '2 Days';
                          _diasALaSemanaEsp = '2 Dias';
                          _cantidadDeEjerciciosEng = '2 Exercises';
                          _cantidadDeEjerciciosEsp = '2 Ejercicios';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _cantidadDeCircuitosEng = '2 Circuits';
                          _cantidadDeCircuitosEsp = '2 Circuitos';
                          _porcentajeDeRMEng = '30%';
                          _porcentajeDeRMEsp = '30%';
                        } else if (newValue == 'Medium') {
                          _diasALaSemanaEng = '3 Days';
                          _diasALaSemanaEsp = '3 Dias';
                          _cantidadDeEjerciciosEng = '4 Exercises';
                          _cantidadDeEjerciciosEsp = '4 Ejercicios';
                          _repeticionesPorEjerciciosEng = '8 Repetitions';
                          _repeticionesPorEjerciciosEsp = '8 Repeticiones';
                          _cantidadDeCircuitosEng = '2 Circuits';
                          _cantidadDeCircuitosEsp = '2 Circuitos';
                          _porcentajeDeRMEng = '40%';
                          _porcentajeDeRMEsp = '40%';
                        } else if (newValue == 'Advanced') {
                          _diasALaSemanaEng = '3 Days';
                          _diasALaSemanaEsp = '3 Dias';
                          _cantidadDeEjerciciosEng = '5 Exercises';
                          _cantidadDeEjerciciosEsp = '5 Ejercicios';
                          _repeticionesPorEjerciciosEng = '10 Repetitions';
                          _repeticionesPorEjerciciosEsp = '10 Repeticiones';
                          _cantidadDeCircuitosEng = '3 Circuits';
                          _cantidadDeCircuitosEsp = '3 Circuitos';
                          _porcentajeDeRMEng = '50%';
                          _porcentajeDeRMEsp = '50%';
                        }
                      }
                    });
                  },
                  value: currentIntensity == 'Seleccionar' ||
                          currentIntensity == 'Select'
                      ? null
                      : currentIntensity,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentIntensity == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoActividadFisicaDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSelector(
    String currentValueEsp,
    String currentValueEng,
    List<String> optionsEsp,
    List<String> optionsEng,
    void Function(String?) onChangedEsp,
    void Function(String?) onChangedEng,
    String hintTextEsp,
    String hintTextEng,
    BuildContext context,
    VoidCallback onInfoPressed,
  ) {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentValue = isEsp ? currentValueEsp : currentValueEng;
    String hintText = isEsp ? hintTextEsp : hintTextEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(hintText),
                  onChanged: isEsp ? onChangedEsp : onChangedEng,
                  value:
                      currentValue == 'Seleccionar' || currentValue == 'Select'
                          ? null
                          : currentValue,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentValue == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: onInfoPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildCalentamientoFisicoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('tiempoCalentamientoFisico'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildCalentamientoFisicoSelector(),
      ],
    );
  }

  Widget _buildCalentamientoFisicoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      '5 Minutos',
      '10 Minutos',
      '15 Minutos'
    ];
    List<String> optionsEng = [
      'Select',
      '5 Minutes',
      '10 Minutes',
      '15 Minutes'
    ];

    Map<String, String> calentamientoFisicoMapEspToEng = {
      'Seleccionar': 'Select',
      '5 Minutos': '5 Minutes',
      '10 Minutos': '10 Minutes',
      '15 Minutos': '15 Minutes',
    };

    Map<String, String> calentamientoFisicoMapEngToEsp = {
      'Select': 'Seleccionar',
      '5 Minutes': '5 Minutos',
      '10 Minutes': '10 Minutos',
      '15 Minutes': '15 Minutos',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentCalentamientoFisico =
        isEsp ? _calentamientoFisicoEsp : _calentamientoFisicoEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectCalentamientoTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _calentamientoFisicoEsp = newValue!;
                        _calentamientoFisicoEng =
                            calentamientoFisicoMapEspToEng[newValue]!;
                      } else {
                        _calentamientoFisicoEng = newValue!;
                        _calentamientoFisicoEsp =
                            calentamientoFisicoMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  value: currentCalentamientoFisico == 'Seleccionar' ||
                          currentCalentamientoFisico == 'Select'
                      ? null
                      : currentCalentamientoFisico,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentCalentamientoFisico == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoCalentamientoFisicoDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDescansoEntreEjerciciosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('descansoEntreEjercicios'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildDescansoEntreEjerciciosSelector(),
      ],
    );
  }

  Widget _buildDescansoEntreEjerciciosSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      '5 Segundos',
      '10 Segundos',
      '15 Segundos'
    ];
    List<String> optionsEng = [
      'Select',
      '5 Seconds',
      '10 Seconds',
      '15 Seconds'
    ];

    Map<String, String> descansoEntreEjerciciosMapEspToEng = {
      'Seleccionar': 'Select',
      '5 Segundos': '5 Seconds',
      '10 Segundos': '10 Seconds',
      '15 Segundos': '15 Seconds',
    };

    Map<String, String> descansoEntreEjerciciosMapEngToEsp = {
      'Select': 'Seleccionar',
      '5 Seconds': '5 Segundos',
      '10 Seconds': '10 Segundos',
      '15 Seconds': '15 Segundos',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentDescansoEntreEjercicios =
        isEsp ? _descansoEntreEjerciciosEsp : _descansoEntreEjerciciosEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectDescansoEntreEjerciciosTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _descansoEntreEjerciciosEsp = newValue!;
                        _descansoEntreEjerciciosEng =
                            descansoEntreEjerciciosMapEspToEng[newValue]!;
                      } else {
                        _descansoEntreEjerciciosEng = newValue!;
                        _descansoEntreEjerciciosEsp =
                            descansoEntreEjerciciosMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  value: currentDescansoEntreEjercicios == 'Seleccionar' ||
                          currentDescansoEntreEjercicios == 'Select'
                      ? null
                      : currentDescansoEntreEjercicios,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentDescansoEntreEjercicios == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoDescansoEntreEjerciciosDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDescansoEntreCircuitoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('descansoEntreCircuito'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildDescansoEntreCircuitoSelector(),
      ],
    );
  }

  Widget _buildDescansoEntreCircuitoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      '5 Minutos',
      '10 Minutos',
      '15 Minutos'
    ];
    List<String> optionsEng = [
      'Select',
      '5 Minutes',
      '10 Minutes',
      '15 Minutes'
    ];

    Map<String, String> descansoEntreCircuitoMapEspToEng = {
      'Seleccionar': 'Select',
      '5 Minutos': '5 Minutes',
      '10 Minutos': '10 Minutes',
      '15 Minutos': '15 Minutes',
    };

    Map<String, String> descansoEntreCircuitoMapEngToEsp = {
      'Select': 'Seleccionar',
      '5 Minutes': '5 Minutos',
      '10 Minutes': '10 Minutos',
      '15 Minutes': '15 Minutos',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentDescansoEntreCircuito =
        isEsp ? _descansoEntreCircuitoEsp : _descansoEntreCircuitoEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectDescansoEntreCircuitoTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _descansoEntreCircuitoEsp = newValue!;
                        _descansoEntreCircuitoEng =
                            descansoEntreCircuitoMapEspToEng[newValue]!;
                      } else {
                        _descansoEntreCircuitoEng = newValue!;
                        _descansoEntreCircuitoEsp =
                            descansoEntreCircuitoMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  value: currentDescansoEntreCircuito == 'Seleccionar' ||
                          currentDescansoEntreCircuito == 'Select'
                      ? null
                      : currentDescansoEntreCircuito,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentDescansoEntreCircuito == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoDescansoEntreCircuitoDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEstiramientoEstaticoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('estiramientoEstatico'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildEstiramientoEstaticoSelector(),
      ],
    );
  }

  Widget _buildEstiramientoEstaticoSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      '5 Minutos',
      '10 Minutos',
      '15 Minutos'
    ];
    List<String> optionsEng = [
      'Select',
      '5 Minutes',
      '10 Minutes',
      '15 Minutes'
    ];

    Map<String, String> estiramientoEstaticoMapEspToEng = {
      'Seleccionar': 'Select',
      '5 Minutos': '5 Minutes',
      '10 Minutos': '10 Minutes',
      '15 Minutos': '15 Minutes',
    };

    Map<String, String> estiramientoEstaticoMapEngToEsp = {
      'Select': 'Seleccionar',
      '5 Minutes': '5 Minutos',
      '10 Minutes': '10 Minutos',
      '15 Minutes': '15 Minutos',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentEstiramientoEstatico =
        isEsp ? _estiramientoEstaticoEsp : _estiramientoEstaticoEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectEstiramientoEstaticoTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _estiramientoEstaticoEsp = newValue!;
                        _estiramientoEstaticoEng =
                            estiramientoEstaticoMapEspToEng[newValue]!;
                      } else {
                        _estiramientoEstaticoEng = newValue!;
                        _estiramientoEstaticoEsp =
                            estiramientoEstaticoMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  value: currentEstiramientoEstatico == 'Seleccionar' ||
                          currentEstiramientoEstatico == 'Select'
                      ? null
                      : currentEstiramientoEstatico,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentEstiramientoEstatico == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoEstiramientoEstaticoDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDiasALaSemanaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('diasALaSemana'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildDiasALaSemanaSelector(),
      ],
    );
  }

  Widget _buildDiasALaSemanaSelector() {
    List<String> diasOptionsEsp;
    List<String> diasOptionsEng;

    // Determinar las opciones de acuerdo a la intensidad seleccionada
    if (_intensityEsp == 'Fácil' || _intensityEng == 'Easy') {
      diasOptionsEsp = ['2 Dias', '3 Dias'];
      diasOptionsEng = ['2 Days', '3 Days'];
    } else if (_intensityEsp == 'Intermedio' || _intensityEng == 'Medium') {
      diasOptionsEsp = ['3 Dias', '4 Dias'];
      diasOptionsEng = ['3 Days', '4 Days'];
    } else if (_intensityEsp == 'Avanzado' || _intensityEng == 'Advanced') {
      diasOptionsEsp = ['3 Dias', '4 Dias', '5 Dias'];
      diasOptionsEng = ['3 Days', '4 Days', '5 Days'];
    } else {
      diasOptionsEsp = ['Seleccionar'];
      diasOptionsEng = ['Select'];
    }

    return _buildSelector(
      _diasALaSemanaEsp,
      _diasALaSemanaEng,
      diasOptionsEsp,
      diasOptionsEng,
      (newValue) {
        setState(() {
          _diasALaSemanaEsp = newValue!;
          _diasALaSemanaEng = diasOptionsEsp.contains(newValue)
              ? diasOptionsEng[diasOptionsEsp.indexOf(newValue)]
              : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _diasALaSemanaEng = newValue!;
          _diasALaSemanaEsp = diasOptionsEng.contains(newValue)
              ? diasOptionsEsp[diasOptionsEng.indexOf(newValue)]
              : 'Seleccionar';
        });
      },
      AppLocalizations.of(context)!.translate('selectDiasALaSemanaTime'),
      AppLocalizations.of(context)!.translate('selectDiasALaSemanaTimeEng'),
      context,
      () => showInfoDiasALaSemanaDialog(context),
    );
  }

  Widget _buildCalentamientoArticularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('calentamientoArticular'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildCalentamientoArticularSelector(),
      ],
    );
  }

  Widget _buildCalentamientoArticularSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    String defaultOption =
        isEsp ? _calentamientoArticularEsp : _calentamientoArticularEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                defaultOption,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoCalentamientoArticularDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCantidadDeEjerciciosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('cantidadDeEjercicios'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildCantidadDeEjerciciosSelector(),
      ],
    );
  }

  Widget _buildCantidadDeEjerciciosSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    // Define las opciones de ejercicios según la intensidad seleccionada.
    List<String> ejerciciosOptionsEsp;
    List<String> ejerciciosOptionsEng;

    if (_intensityEsp == 'Fácil') {
      ejerciciosOptionsEsp = [
        '2 Ejercicios',
        '3 Ejercicios',
        '4 Ejercicios',
        '5 Ejercicios'
      ];
      ejerciciosOptionsEng = [
        '2 Exercises',
        '3 Exercises',
        '4 Exercises',
        '5 Exercises'
      ];
    } else if (_intensityEsp == 'Intermedio') {
      ejerciciosOptionsEsp = ['4 Ejercicios', '5 Ejercicios', '6 Ejercicios'];
      ejerciciosOptionsEng = ['4 Exercises', '5 Exercises', '6 Exercises'];
    } else if (_intensityEsp == 'Avanzado') {
      ejerciciosOptionsEsp = [
        '5 Ejercicios',
        '6 Ejercicios',
        '7 Ejercicios',
        '8 Ejercicios'
      ];
      ejerciciosOptionsEng = [
        '5 Exercises',
        '6 Exercises',
        '7 Exercises',
        '8 Exercises'
      ];
    } else {
      // Opciones por defecto en caso de que la intensidad no esté seleccionada.
      ejerciciosOptionsEsp = ['Seleccionar'];
      ejerciciosOptionsEng = ['Select'];
    }

    // Construye el selector con las opciones dinámicas basadas en la intensidad.
    return _buildSelector(
      isEsp ? _cantidadDeEjerciciosEsp : _cantidadDeEjerciciosEng,
      isEsp ? _cantidadDeEjerciciosEng : _cantidadDeEjerciciosEsp,
      ejerciciosOptionsEsp,
      ejerciciosOptionsEng,
      (newValue) {
        setState(() {
          if (isEsp) {
            _cantidadDeEjerciciosEsp = newValue!;
            _cantidadDeEjerciciosEng = ejerciciosOptionsEsp.contains(newValue)
                ? ejerciciosOptionsEng[ejerciciosOptionsEsp.indexOf(newValue)]
                : 'Select';
          } else {
            _cantidadDeEjerciciosEng = newValue!;
            _cantidadDeEjerciciosEsp = ejerciciosOptionsEng.contains(newValue)
                ? ejerciciosOptionsEsp[ejerciciosOptionsEng.indexOf(newValue)]
                : 'Seleccionar';
          }
        });
      },
      (newValue) {
        setState(() {
          if (!isEsp) {
            _cantidadDeEjerciciosEng = newValue!;
            _cantidadDeEjerciciosEsp = ejerciciosOptionsEng.contains(newValue)
                ? ejerciciosOptionsEsp[ejerciciosOptionsEng.indexOf(newValue)]
                : 'Seleccionar';
          } else {
            _cantidadDeEjerciciosEsp = newValue!;
            _cantidadDeEjerciciosEng = ejerciciosOptionsEsp.contains(newValue)
                ? ejerciciosOptionsEng[ejerciciosOptionsEsp.indexOf(newValue)]
                : 'Select';
          }
        });
      },
      AppLocalizations.of(context)!.translate('selectCantidadDeEjerciciosTime'),
      AppLocalizations.of(context)!
          .translate('selectCantidadDeEjerciciosTimeEng'),
      context,
      () => showInfoCantidadDeEjerciciosDialog(context),
    );
  }

  Widget _buildRepeticionesPorEjerciciosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('repeticionesPorEjercicios'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildRepeticionesPorEjerciciosSelector(),
      ],
    );
  }

  Widget _buildRepeticionesPorEjerciciosSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> repeticionesOptionsEsp;
    List<String> repeticionesOptionsEng;

    // Ajusta las opciones de repeticiones según la intensidad seleccionada.
    if ((isEsp && _intensityEsp == 'Fácil') ||
        (!isEsp && _intensityEng == 'Easy')) {
      repeticionesOptionsEsp = [
        '5 Repeticiones',
        '6 Repeticiones',
        '7 Repeticiones',
        '8 Repeticiones',
        '9 Repeticiones',
        '10 Repeticiones',
        '11 Repeticiones',
        '12 Repeticiones',
        '13 Repeticiones',
        '14 Repeticiones',
        '15 Repeticiones',
        '16 Repeticiones'
      ];
      repeticionesOptionsEng = [
        '5 Repetitions',
        '6 Repetitions',
        '7 Repetitions',
        '8 Repetitions',
        '9 Repetitions',
        '10 Repetitions',
        '11 Repetitions',
        '12 Repetitions',
        '13 Repetitions',
        '14 Repetitions',
        '15 Repetitions',
        '16 Repetitions'
      ];
    } else if ((isEsp && _intensityEsp == 'Intermedio') ||
        (!isEsp && _intensityEng == 'Medium')) {
      repeticionesOptionsEsp = [
        '8 Repeticiones',
        '9 Repeticiones',
        '10 Repeticiones',
        '11 Repeticiones',
        '12 Repeticiones',
        '13 Repeticiones',
        '14 Repeticiones',
        '15 Repeticiones',
        '16 Repeticiones'
      ];
      repeticionesOptionsEng = [
        '8 Repetitions',
        '9 Repetitions',
        '10 Repetitions',
        '11 Repetitions',
        '12 Repetitions',
        '13 Repetitions',
        '14 Repetitions',
        '15 Repetitions',
        '16 Repetitions'
      ];
    } else if ((isEsp && _intensityEsp == 'Avanzado') ||
        (!isEsp && _intensityEng == 'Advanced')) {
      repeticionesOptionsEsp = [
        '10 Repeticiones',
        '11 Repeticiones',
        '12 Repeticiones',
        '13 Repeticiones',
        '14 Repeticiones',
        '15 Repeticiones',
        '16 Repeticiones'
      ];
      repeticionesOptionsEng = [
        '10 Repetitions',
        '11 Repetitions',
        '12 Repetitions',
        '13 Repetitions',
        '14 Repetitions',
        '15 Repetitions',
        '16 Repetitions'
      ];
    } else {
      // Opciones por defecto si la intensidad no está seleccionada.
      repeticionesOptionsEsp = ['Seleccionar'];
      repeticionesOptionsEng = ['Select'];
    }

    // Usa la función _buildSelector para crear el selector dinámico basado en el idioma.
    return _buildSelector(
      _repeticionesPorEjerciciosEsp,
      _repeticionesPorEjerciciosEng,
      repeticionesOptionsEsp,
      repeticionesOptionsEng,
      (newValue) {
        setState(() {
          _repeticionesPorEjerciciosEsp = newValue!;
          _repeticionesPorEjerciciosEng = repeticionesOptionsEsp
                  .contains(newValue)
              ? repeticionesOptionsEng[repeticionesOptionsEsp.indexOf(newValue)]
              : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _repeticionesPorEjerciciosEng = newValue!;
          _repeticionesPorEjerciciosEsp = repeticionesOptionsEng
                  .contains(newValue)
              ? repeticionesOptionsEsp[repeticionesOptionsEng.indexOf(newValue)]
              : 'Seleccionar';
        });
      },
      AppLocalizations.of(context)!
          .translate('selectRepeticionesPorEjerciciosTime'),
      AppLocalizations.of(context)!
          .translate('selectRepeticionesPorEjerciciosTimeEng'),
      context,
      () => showInfoRepeticionesPorEjerciciosDialog(context),
    );
  }

  Widget _buildCantidadDeCircuitosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('cantidadDeCircuitos'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildCantidadDeCircuitosSelector(),
      ],
    );
  }

  Widget _buildCantidadDeCircuitosSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> cantidadDeCircuitosOptionsEsp;
    List<String> cantidadDeCircuitosOptionsEng;

    // Ajusta las opciones de Circuitos según la intensidad seleccionada.
    if ((isEsp && _intensityEsp == 'Fácil') ||
        (!isEsp && _intensityEng == 'Easy')) {
      cantidadDeCircuitosOptionsEsp = ['2 Circuitos', '3 Circuitos'];
      cantidadDeCircuitosOptionsEng = ['2 Circuits', '3 Circuits'];
    } else if ((isEsp && _intensityEsp == 'Intermedio') ||
        (!isEsp && _intensityEng == 'Medium')) {
      cantidadDeCircuitosOptionsEsp = [
        '2 Circuitos',
        '3 Circuitos',
        '4 Circuitos'
      ];
      cantidadDeCircuitosOptionsEng = [
        '2 Circuits',
        '3 Circuits',
        '4 Circuits'
      ];
    } else if ((isEsp && _intensityEsp == 'Avanzado') ||
        (!isEsp && _intensityEng == 'Advanced')) {
      cantidadDeCircuitosOptionsEsp = ['3 Circuitos', '4 Circuitos'];
      cantidadDeCircuitosOptionsEng = ['3 Circuits', '4 Circuits'];
    } else {
      // Opciones por defecto si la Circuitos no está seleccionada.
      cantidadDeCircuitosOptionsEsp = ['Seleccionar'];
      cantidadDeCircuitosOptionsEng = ['Select'];
    }

    // Usa la función _buildSelector para crear el selector dinámico basado en el idioma.
    return _buildSelector(
      _cantidadDeCircuitosEsp,
      _cantidadDeCircuitosEng,
      cantidadDeCircuitosOptionsEsp,
      cantidadDeCircuitosOptionsEng,
      (newValue) {
        setState(() {
          _cantidadDeCircuitosEsp = newValue!;
          _cantidadDeCircuitosEng =
              cantidadDeCircuitosOptionsEsp.contains(newValue)
                  ? cantidadDeCircuitosOptionsEng[
                      cantidadDeCircuitosOptionsEsp.indexOf(newValue)]
                  : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _cantidadDeCircuitosEng = newValue!;
          _cantidadDeCircuitosEsp =
              cantidadDeCircuitosOptionsEng.contains(newValue)
                  ? cantidadDeCircuitosOptionsEsp[
                      cantidadDeCircuitosOptionsEng.indexOf(newValue)]
                  : 'Seleccionar';
        });
      },
      AppLocalizations.of(context)!.translate('selectCircuitsTime'),
      AppLocalizations.of(context)!.translate('selectCircuitsTimeEng'),
      context,
      () => showInfoRepeticionesPorEjerciciosDialog(context),
    );
  }

  Widget _buildPorcentajeDeRMSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('porcentajeDeRM'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildPorcentajeDeRMSelector(),
      ],
    );
  }

  Widget _buildPorcentajeDeRMSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    // Opciones según la intensidad seleccionada
    List<String> optionsEsp;
    List<String> optionsEng;

    if (_intensityEsp == 'Fácil' || _intensityEng == 'Easy') {
      optionsEsp = ['Seleccionar', '30%', '35%', '40%', '45%', '50%'];
      optionsEng = ['Select', '30%', '35%', '40%', '45%', '50%'];
    } else if (_intensityEsp == 'Intermedio' || _intensityEng == 'Medium') {
      optionsEsp = ['Seleccionar', '40%', '45%', '50%', '55%', '60%'];
      optionsEng = ['Select', '40%', '45%', '50%', '55%', '60%'];
    } else if (_intensityEsp == 'Avanzado' || _intensityEng == 'Advanced') {
      optionsEsp = ['Seleccionar', '50%', '55%', '60%'];
      optionsEng = ['Select', '50%', '55%', '60%'];
    } else {
      // Opciones por defecto
      optionsEsp = ['Seleccionar'];
      optionsEng = ['Select'];
    }

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentPorcentajeDeRM =
        isEsp ? _porcentajeDeRMEsp : _porcentajeDeRMEng;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(AppLocalizations.of(context)!
                      .translate('selectPorcentajeDeRMTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _porcentajeDeRMEsp = newValue!;
                        _porcentajeDeRMEng = optionsEsp.contains(newValue)
                            ? optionsEng[optionsEsp.indexOf(newValue)]
                            : 'Select';
                      } else {
                        _porcentajeDeRMEng = newValue!;
                        _porcentajeDeRMEsp = optionsEng.contains(newValue)
                            ? optionsEsp[optionsEng.indexOf(newValue)]
                            : 'Seleccionar';
                      }
                    });
                  },
                  value: currentPorcentajeDeRM == 'Seleccionar' ||
                          currentPorcentajeDeRM == 'Select'
                      ? null
                      : currentPorcentajeDeRM,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentPorcentajeDeRM == value)
                            const Icon(Icons.check, color: Colors.green),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoPorcentajeDeRMDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNombreRutinaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('nombreRutina'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildNombreRutinaTextField(),
      ],
    );
  }

  Widget _buildNombreRutinaTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBlueAccentColor,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _nombreRutinaEsp = value;
                  _nombreRutinaEng =
                      value; // Asumiendo que el nombre es el mismo en ambos idiomas
                });
              },
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)!.translate('nombreRutinaHint'),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoNombreRutinaDialog(context),
          ),
        ],
      ),
    );
  }

  void showInfoNombreRutinaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.translate('nombreRutinaInfoTitle')),
          content: Text(AppLocalizations.of(context)!
              .translate('nombreRutinaInfoContent')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('close')),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCalentamientoFisicoNames();
    _loadEstiramientoFisicoNames();
  }

  void _loadCalentamientoFisicoNames() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('calentamientoFisico')
        .get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      calentamientoFisicoNames = tempMap;
    });
  }

  void _loadEstiramientoFisicoNames() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('estiramientoFisico').get();
    Map<String, Map<String, String>> tempMap = {};
    for (var doc in snapshot.docs) {
      tempMap[doc.id] = {
        'Esp': doc['NombreEsp'] ?? 'Nombre no disponible',
        'Eng': doc['NombreEng'] ?? 'Nombre no disponible',
      };
    }
    setState(() {
      estiramientoFisicoNames = tempMap;
    });
  }

  void _addCalentamientoFisico(String calentamientoFisicoId) {
    setState(() {
      _selectedCalentamientoFisicoId = calentamientoFisicoId;
      _selectedCalentamientoFisicoNameEsp =
          calentamientoFisicoNames[calentamientoFisicoId]?['Esp'] ??
              'Nombre no disponible';
      _selectedCalentamientoFisicoNameEng =
          calentamientoFisicoNames[calentamientoFisicoId]?['Eng'] ??
              'Nombre no disponible';
    });

    Provider.of<SelectedItemsNotifier>(context, listen: false)
        .addSelection(calentamientoFisicoId);
  }

  void _addEstiramientoFisico(String estiramientoFisicoId) {
    setState(() {
      _selectedEstiramientoFisicoId = estiramientoFisicoId;
      _selectedEstiramientoFisicoNameEsp =
          estiramientoFisicoNames[estiramientoFisicoId]?['Esp'] ??
              'Nombre no disponible';
      _selectedEstiramientoFisicoNameEng =
          estiramientoFisicoNames[estiramientoFisicoId]?['Eng'] ??
              'Nombre no disponible';
    });

    Provider.of<SelectedItemsNotifier>(context, listen: false)
        .addSelection(estiramientoFisicoId);
  }

  void _removeCalentamientoFisico(String calentamientoFisicoId) {
    setState(() {
      _selectedCalentamientoFisicoId = null;
      _selectedCalentamientoFisicoNameEsp = null;
      _selectedCalentamientoFisicoNameEng = null;
    });

    Provider.of<SelectedItemsNotifier>(context, listen: false)
        .removeSelection(calentamientoFisicoId);
  }

  void _removeEstiramientoFisico(String estiramientoFisicoId) {
    setState(() {
      _selectedEstiramientoFisicoId = null;
      _selectedEstiramientoFisicoNameEsp = null;
      _selectedEstiramientoFisicoNameEng = null;
    });

    Provider.of<SelectedItemsNotifier>(context, listen: false)
        .removeSelection(estiramientoFisicoId);
  }

  Widget _buildSelectedCalentamientoFisico(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.translate('calentamientoFisico'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedCalentamientoFisicoId != null
              ? [
                  Chip(
                    label: Text(_selectedCalentamientoFisicoNameEsp ??
                        'Nombre no disponible'),
                    onDeleted: () => _removeCalentamientoFisico(
                        _selectedCalentamientoFisicoId!),
                  )
                ]
              : [],
        ),
      ],
    );
  }

  Widget _buildSelectedEstiramientoFisico(String langKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.translate('estiramientoFisico'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: _selectedEstiramientoFisicoId != null
              ? [
                  Chip(
                    label: Text(_selectedEstiramientoFisicoNameEsp ??
                        'Nombre no disponible'),
                    onDeleted: () => _removeEstiramientoFisico(
                        _selectedEstiramientoFisicoId!),
                  )
                ]
              : [],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    String langKey = Localizations.localeOf(context).languageCode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          // En lugar de enviar un mapa de selecciones, solo se hace pop del Navigator
          // y se confía en que la pantalla anterior observe los cambios a través del Notifier.
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'Plan de Entrenamiento',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 6.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  debugPrint("Video is ready.");
                },
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    _buildIntensitySection(),
                    const SizedBox(height: 8),
                    _buildDiasALaSemanaSection(),
                    const SizedBox(height: 8),
                    _buildSelectedCalentamientoFisico(langKey),
                    FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: CalentamientoFisicoInEjercicioFunctions()
                          .getSimplifiedCalentamientoFisico(
                              langKey == 'es' ? 'NombreEsp' : 'NombreEng'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text(
                              'No se encontraron calentamientos físicos');
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.lightBlueAccentColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(AppLocalizations.of(context)!
                                        .translate(
                                            'selectCalentamientoFisico')),
                                    onChanged: (String? newValue) {
                                      _addCalentamientoFisico(newValue!);
                                    },
                                    items: snapshot.data,
                                    value: _selectedCalentamientoFisicoId,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildCalentamientoFisicoSection(),
                    const SizedBox(height: 8),
                    _buildCalentamientoArticularSection(),
                    const SizedBox(height: 8),
                    _buildCantidadDeEjerciciosSection(),
                    const SizedBox(height: 8),
                    _buildRepeticionesPorEjerciciosSection(),
                    const SizedBox(height: 8),
                    _buildCantidadDeCircuitosSection(),
                    const SizedBox(height: 8),
                    _buildPorcentajeDeRMSection(),
                    const SizedBox(height: 8),
                    _buildDescansoEntreEjerciciosSection(),
                    const SizedBox(height: 8),
                    _buildDescansoEntreCircuitoSection(),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    _buildSelectedEstiramientoFisico(langKey),
                    FutureBuilder<List<DropdownMenuItem<String>>>(
                      future: EstiramientoFisicoInEjercicioFunctions()
                          .getSimplifiedEstiramientoFisico(
                              langKey == 'es' ? 'NombreEsp' : 'NombreEng'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text(
                              'No se encontraron Estiramientos físicos');
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.lightBlueAccentColor,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(AppLocalizations.of(context)!
                                        .translate('selectEstiramientoFisico')),
                                    onChanged: (String? newValue) {
                                      _addEstiramientoFisico(newValue!);
                                    },
                                    items: snapshot.data,
                                    value: _selectedEstiramientoFisicoId,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildEstiramientoEstaticoSection(),
                    const SizedBox(height: 8),
                    _buildNombreRutinaSection(),
                    const SizedBox(height: 8),
                    _buildcompleteButton(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showInfoPartesDelCuerpoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('informaciónDePartesDelCuerpo')),
          content: Text(AppLocalizations.of(context)!.translate('informaciónDePartesDelCuerpoDesc')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('cerrar')),
            ),
          ],
        );
      },
    );
  }
}
class ErrorPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Ruta de navegación no encontrada para la selección.'),
        ),
      );
    }
  }