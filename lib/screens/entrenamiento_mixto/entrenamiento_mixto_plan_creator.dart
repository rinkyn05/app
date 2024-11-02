import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/calentamiento_fisico_in_ejercicio_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/notifiers/selected_notifier.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/dialogs/dialogs.dart';
import '../../functions/ejercicios/calentamiento_fisico_in_ejercicio_functions.dart';
import '../../widgets/custom_appbar_new.dart';
import '../calentamiento_fisico/calentamiento_fisico_screen.dart';
import '../estiramiento_fisico/estiramiento_fisico_screen.dart';

class EntrenamientoMixtoPlanCreator extends StatefulWidget {
  const EntrenamientoMixtoPlanCreator({Key? key}) : super(key: key);

  @override
  State<EntrenamientoMixtoPlanCreator> createState() =>
      _EntrenamientoMixtoPlanCreatorState();
}

class _EntrenamientoMixtoPlanCreatorState
    extends State<EntrenamientoMixtoPlanCreator> {
  String _intensityEsp = 'Seleccionar';
  String _intensityEng = 'Select';

  String _calentamientoFisicoEsp = 'Seleccionar';
  String _calentamientoFisicoEng = 'Select';

  String _descansoEntreEjerciciosEsp = 'Seleccionar';
  String _descansoEntreEjerciciosEng = 'Select';

  String _descansoEntreSeriesEsp = 'Seleccionar';
  String _descansoEntreSeriesEng = 'Select';

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

  String _cantidadDeSeriesEsp = 'Seleccionar';
  String _cantidadDeSeriesEng = 'Select';

  String _porcentajeDeRMEsp = 'Seleccionar';
  String _porcentajeDeRMEng = 'Select';

  final List<SelectedCalentamientoFisico> _selectedCalentamientoFisico = [];
  Map<String, Map<String, String>> calentamientoFisicoNames = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'cTcTIBOgM9E',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Widget _buildEstiramientoEstaticoButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CalentamientoFisicoScreen()),
            );
          },
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
          child: const Text('Calentamiento Fisico'),
        ),
        const SizedBox(height: 6),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EstiramientoFisicoScreen()),
            );
          },
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
          child: const Text('Estiramiento Fisico'),
        ),
      ],
    );
  }

  Widget _buildIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('metodoEntrenamiento'),
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

    List<String> optionsEsp = ['Seleccionar', 'Torzo-Pierna', 'Weider'];
    List<String> optionsEng = ['Select', 'Torso-Legs', 'Weider'];

    Map<String, String> intensityMapEspToEng = {
      'Seleccionar': 'Select',
      'Torzo-Pierna': 'Torso-Legs',
      'Weider': 'Weider',
    };

    Map<String, String> intensityMapEngToEsp = {
      'Select': 'Seleccionar',
      'Torso-Legs': 'Torzo-Pierna',
      'Weider': 'Weider',
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
                          _cantidadDeSeriesEsp = 'Seleccionar';
                          _cantidadDeSeriesEng = 'Select';
                          _porcentajeDeRMEsp = 'Seleccionar';
                          _porcentajeDeRMEng = 'Select';
                        } else if (newValue == 'Torzo-Pierna') {
                          _diasALaSemanaEsp = '4 Dias';
                          _diasALaSemanaEng = '4 Days';
                          _cantidadDeEjerciciosEsp = '4 Ejercicios';
                          _cantidadDeEjerciciosEng = '4 Exercises';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _cantidadDeSeriesEsp = '3 Series';
                          _cantidadDeSeriesEng = '3 Seasons';
                          _porcentajeDeRMEsp = '70%';
                          _porcentajeDeRMEng = '70%';
                        } else if (newValue == 'Weider') {
                          _diasALaSemanaEsp = '5 Dias';
                          _diasALaSemanaEng = '5 Days';
                          _cantidadDeEjerciciosEsp = '5 Ejercicios';
                          _cantidadDeEjerciciosEng = '5 Exercises';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _cantidadDeSeriesEsp = '3 Series';
                          _cantidadDeSeriesEng = '3 Seasons';
                          _porcentajeDeRMEsp = '70%';
                          _porcentajeDeRMEng = '70%';
                        }
                      } else {
                        _intensityEng = newValue!;
                        _intensityEsp = intensityMapEngToEsp[newValue]!;

                        if (newValue == 'Select') {
                          _diasALaSemanaEng = 'Select';
                          _diasALaSemanaEsp = 'Seleccionar';
                          _repeticionesPorEjerciciosEng = 'Select';
                          _repeticionesPorEjerciciosEsp = 'Seleccionar';
                          _cantidadDeSeriesEng = 'Select';
                          _cantidadDeSeriesEsp = 'Seleccionar';
                          _porcentajeDeRMEng = 'Select';
                          _porcentajeDeRMEsp = 'Seleccionar';
                        } else if (newValue == 'Torso-Legs') {
                          _diasALaSemanaEng = '4 Days';
                          _diasALaSemanaEsp = '4 Dias';
                          _cantidadDeEjerciciosEng = '4 Exercises';
                          _cantidadDeEjerciciosEsp = '4 Ejercicios';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _cantidadDeSeriesEng = '3 Seasons';
                          _cantidadDeSeriesEsp = '3 Series';
                          _porcentajeDeRMEng = '70%';
                          _porcentajeDeRMEsp = '70%';
                        } else if (newValue == 'Weider') {
                          _diasALaSemanaEng = '5 Days';
                          _diasALaSemanaEsp = '5 Dias';
                          _cantidadDeEjerciciosEng = '5 Exercises';
                          _cantidadDeEjerciciosEsp = '5 Ejercicios';
                          _repeticionesPorEjerciciosEng = '5 Repetitions';
                          _repeticionesPorEjerciciosEsp = '5 Repeticiones';
                          _cantidadDeSeriesEng = '3 Seasons';
                          _cantidadDeSeriesEsp = '3 Series';
                          _porcentajeDeRMEng = '70%';
                          _porcentajeDeRMEsp = '70%';
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
      '2 Minutos',
      '3 Minutos',
      '4 Minutos'
    ];
    List<String> optionsEng = ['Select', '2 Minutes', '3 Minutes', '4 Minutes'];

    Map<String, String> descansoEntreEjerciciosMapEspToEng = {
      'Seleccionar': 'Select',
      '2 Minutos': '2 Minutes',
      '3 Minutos': '3 Minutes',
      '4 Minutos': '4 Minutes',
    };

    Map<String, String> descansoEntreEjerciciosMapEngToEsp = {
      'Select': 'Seleccionar',
      '2 Minutes': '2 Minutos',
      '3 Minutes': '3 Minutos',
      '4 Minutes': '4 Minutos',
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

  Widget _buildDescansoEntreSeriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('descansoEntreSeries'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildDescansoEntreSeriesSelector(),
      ],
    );
  }

  Widget _buildDescansoEntreSeriesSelector() {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = [
      'Seleccionar',
      '2 Minutos',
      '3 Minutos',
      '4 Minutos'
    ];
    List<String> optionsEng = ['Select', '2 Minutes', '3 Minutes', '4 Minutos'];

    Map<String, String> descansoEntreSeriesMapEspToEng = {
      'Seleccionar': 'Select',
      '2 Minutos': '2 Minutes',
      '3 Minutos': '3 Minutes',
      '4 Minutos': '4 Minutes',
    };

    Map<String, String> descansoEntreSeriesMapEngToEsp = {
      'Select': 'Seleccionar',
      '2 Minutes': '2 Minutos',
      '3 Minutes': '3 Minutos',
      '4 Minutes': '4 Minutos',
    };

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentDescansoEntreSeries =
        isEsp ? _descansoEntreSeriesEsp : _descansoEntreSeriesEng;

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
                      .translate('selectDescansoEntreSeriesTime')),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (isEsp) {
                        _descansoEntreSeriesEsp = newValue!;
                        _descansoEntreSeriesEng =
                            descansoEntreSeriesMapEspToEng[newValue]!;
                      } else {
                        _descansoEntreSeriesEng = newValue!;
                        _descansoEntreSeriesEsp =
                            descansoEntreSeriesMapEngToEsp[newValue]!;
                      }
                    });
                  },
                  value: currentDescansoEntreSeries == 'Seleccionar' ||
                          currentDescansoEntreSeries == 'Select'
                      ? null
                      : currentDescansoEntreSeries,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentDescansoEntreSeries == value)
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
            onPressed: () => showInfoDescansoEntreSeriesDialog(context),
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

    if (_intensityEsp == 'Torzo-Pierna') {
      diasOptionsEsp = ['4 Dias', '5 Dias'];
      diasOptionsEng = ['4 Days', '5 Days'];
    } else if (_intensityEsp == 'Weider') {
      diasOptionsEsp = ['5 Dias'];
      diasOptionsEng = ['5 Days'];
    } else {
      diasOptionsEsp = ['2 Dias', '3 Dias'];
      diasOptionsEng = ['2 Days', '3 Days'];
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
    List<String> ejerciciosOptionsEsp;
    List<String> ejerciciosOptionsEng;

    if (_intensityEsp == 'Torzo-Pierna') {
      ejerciciosOptionsEsp = ['4 Ejercicios', '5 Ejercicios', '6 Ejercicios'];
      ejerciciosOptionsEng = ['4 Exercises', '5 Exercises', '6 Exercises'];
    } else if (_intensityEsp == 'Weider') {
      ejerciciosOptionsEsp = ['5 Ejercicios', '6 Ejercicios'];
      ejerciciosOptionsEng = ['5 Exercises', '6 Exercises'];
    } else {
      ejerciciosOptionsEsp = ['5 Ejercicios', '6 Ejercicios'];
      ejerciciosOptionsEng = ['5 Exercises', '6 Exercises'];
    }

    return _buildSelector(
      _cantidadDeEjerciciosEsp,
      _cantidadDeEjerciciosEng,
      ejerciciosOptionsEsp,
      ejerciciosOptionsEng,
      (newValue) {
        setState(() {
          _cantidadDeEjerciciosEsp = newValue!;
          _cantidadDeEjerciciosEng = ejerciciosOptionsEsp.contains(newValue)
              ? ejerciciosOptionsEng[ejerciciosOptionsEsp.indexOf(newValue)]
              : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _cantidadDeEjerciciosEng = newValue!;
          _cantidadDeEjerciciosEsp = ejerciciosOptionsEng.contains(newValue)
              ? ejerciciosOptionsEsp[ejerciciosOptionsEng.indexOf(newValue)]
              : 'Seleccionar';
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
    List<String> repeticionesOptionsEsp;
    List<String> repeticionesOptionsEng;

    if (_intensityEsp == 'Torzo-Pierna' || _intensityEsp == 'Weider') {
      repeticionesOptionsEsp = [
        '5 Repeticiones',
        '6 Repeticiones',
        '7 Repeticiones',
        '8 Repeticiones'
      ];
      repeticionesOptionsEng = [
        '5 Repetitions',
        '6 Repetitions',
        '7 Repetitions',
        '8 Repetitions'
      ];
    } else {
      repeticionesOptionsEsp = [
        '5 Repeticiones',
        '6 Repeticiones',
        '7 Repeticiones',
        '8 Repeticiones'
      ];
      repeticionesOptionsEng = [
        '5 Repetitions',
        '6 Repetitions',
        '7 Repetitions',
        '8 Repetitions'
      ];
    }

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

  Widget _buildCantidadDeSeriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.translate('cantidadDeSeries'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        _buildCantidadDeSeriesSelector(),
      ],
    );
  }

  Widget _buildCantidadDeSeriesSelector() {
    List<String> seriesOptionsEsp;
    List<String> seriesOptionsEng;

    if (_intensityEsp == 'Torzo-Pierna' || _intensityEsp == 'Weider') {
      seriesOptionsEsp = ['3 Series', '4 Series', '5 Series'];
      seriesOptionsEng = ['3 Seasons', '4 Seasons', '5 Seasons'];
    } else {
      seriesOptionsEsp = ['3 Series', '4 Series'];
      seriesOptionsEng = ['3 Seasons', '4 Seasons'];
    }

    return _buildSelector(
      _cantidadDeSeriesEsp,
      _cantidadDeSeriesEng,
      seriesOptionsEsp,
      seriesOptionsEng,
      (newValue) {
        setState(() {
          _cantidadDeSeriesEsp = newValue!;
          _cantidadDeSeriesEng = seriesOptionsEsp.contains(newValue)
              ? seriesOptionsEng[seriesOptionsEsp.indexOf(newValue)]
              : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _cantidadDeSeriesEng = newValue!;
          _cantidadDeSeriesEsp = seriesOptionsEng.contains(newValue)
              ? seriesOptionsEsp[seriesOptionsEng.indexOf(newValue)]
              : 'Seleccionar';
        });
      },
      AppLocalizations.of(context)!.translate('selectCantidadDeSeriesTime'),
      AppLocalizations.of(context)!.translate('selectCantidadDeSeriesTimeEng'),
      context,
      () => showInfoCantidadDeSeriesDialog(context),
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
    List<String> porcentajeOptionsEsp;
    List<String> porcentajeOptionsEng;

    if (_intensityEsp == 'Torzo-Pierna' || _intensityEsp == 'Weider') {
      porcentajeOptionsEsp = ['70%', '75%', '80%', '85%'];
      porcentajeOptionsEng = ['70%', '75%', '80%', '85%'];
    } else {
      porcentajeOptionsEsp = ['70%', '75%', '80%', '85%'];
      porcentajeOptionsEng = ['70%', '75%', '80%', '85%'];
    }

    return _buildSelector(
      _porcentajeDeRMEsp,
      _porcentajeDeRMEng,
      porcentajeOptionsEsp,
      porcentajeOptionsEng,
      (newValue) {
        setState(() {
          _porcentajeDeRMEsp = newValue!;
          _porcentajeDeRMEng = porcentajeOptionsEsp.contains(newValue)
              ? porcentajeOptionsEng[porcentajeOptionsEsp.indexOf(newValue)]
              : 'Select';
        });
      },
      (newValue) {
        setState(() {
          _porcentajeDeRMEng = newValue!;
          _porcentajeDeRMEsp = porcentajeOptionsEng.contains(newValue)
              ? porcentajeOptionsEsp[porcentajeOptionsEng.indexOf(newValue)]
              : 'Seleccionar';
        });
      },
      AppLocalizations.of(context)!.translate('selectPorcentajeDeRMTime'),
      AppLocalizations.of(context)!.translate('selectPorcentajeDeRMTimeEng'),
      context,
      () => showInfoPorcentajeDeRMDialog(context),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCalentamientoFisicoNames();
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

  void _addCalentamientoFisico(String calentamientoFisicoId) {
    if (!_selectedCalentamientoFisico
        .any((selected) => selected.id == calentamientoFisicoId)) {
      String calentamientoFisicoEsp =
          calentamientoFisicoNames[calentamientoFisicoId]?['Esp'] ??
              'Nombre no disponible';
      String calentamientoFisicoEng =
          calentamientoFisicoNames[calentamientoFisicoId]?['Eng'] ??
              'Nombre no disponible';
      setState(() {
        _selectedCalentamientoFisico.add(SelectedCalentamientoFisico(
          id: calentamientoFisicoId,
          calentamientoFisicoEsp: calentamientoFisicoEsp,
          calentamientoFisicoEng: calentamientoFisicoEng,
        ));
      });

      Provider.of<SelectedItemsNotifier>(context, listen: false)
          .addSelection(calentamientoFisicoEsp);
      Provider.of<SelectedItemsNotifier>(context, listen: false)
          .addSelection(calentamientoFisicoEng);
    }
  }

  void _removeCalentamientoFisico(String calentamientoFisicoId) {
    String? calentamientoFisicoEsp;
    String? calentamientoFisicoEng;
    _selectedCalentamientoFisico.removeWhere((calentamientoFisico) {
      if (calentamientoFisico.id == calentamientoFisicoId) {
        calentamientoFisicoEsp = calentamientoFisico.calentamientoFisicoEsp;
        calentamientoFisicoEng = calentamientoFisico.calentamientoFisicoEng;
      }
      return calentamientoFisico.id == calentamientoFisicoId;
    });

    setState(() {});

    if (calentamientoFisicoEsp != null) {
      Provider.of<SelectedItemsNotifier>(context, listen: false)
          .removeSelection(calentamientoFisicoEsp!);
      Provider.of<SelectedItemsNotifier>(context, listen: false)
          .removeSelection(calentamientoFisicoEng!);
    }
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
          children: _selectedCalentamientoFisico.map((calentamientoFisico) {
            String calentamientoFisicoName = langKey == 'es'
                ? calentamientoFisico.calentamientoFisicoEsp
                : calentamientoFisico.calentamientoFisicoEng;
            return Chip(
              label: Text(calentamientoFisicoName),
              onDeleted: () =>
                  _removeCalentamientoFisico(calentamientoFisico.id),
            );
          }).toList(),
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
                'Plan de Entrenamiento Entrenamiento Mixto',
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
            const SizedBox(height: 8),
            _buildEstiramientoEstaticoButtons(),
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
                                // Text(
                                //   AppLocalizations.of(context)!
                                //       .translate('selectCalentamientoFisico'),
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 18,
                                //     color: Colors.black,
                                //   ),
                                // ),
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
                                    value: _selectedCalentamientoFisico
                                            .isNotEmpty
                                        ? _selectedCalentamientoFisico.first.id
                                        : null,
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
                    _buildCantidadDeSeriesSection(),
                    const SizedBox(height: 8),
                    _buildPorcentajeDeRMSection(),
                    const SizedBox(height: 8),
                    _buildDescansoEntreSeriesSection(),
                    const SizedBox(height: 8),
                    _buildDescansoEntreEjerciciosSection(),
                    const SizedBox(height: 8),
                    _buildEstiramientoEstaticoSection(),
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
}
