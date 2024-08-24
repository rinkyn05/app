import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../backend/models/calentamiento_fisico_in_ejercicio_model.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/ejercicios/calentamiento_fisico_in_ejercicio_functions.dart';
import '../../widgets/custom_appbar_new.dart';
import '../calentamiento_fisico/calentamiento_fisico_screen.dart';
import '../estiramiento_fisico/estiramiento_fisico_screen.dart';

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

  void _showInfoActividadFisicaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Activida Fisica'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Activida Fisica.'),
        );
      },
    );
  }

  void _showInfoCalentamientoFisicoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Calentamiento Fisico'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Calentamiento Fisico.'),
        );
      },
    );
  }

  void _showInfoDescansoEntreEjerciciosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Descanso Entre Ejercicios'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content:
              const Text('Este es un párrafo de Descanso Entre Ejercicios.'),
        );
      },
    );
  }

  void _showInfoDescansoEntreCircuitoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Descanso Entre Circuito'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Descanso Entre Circuito.'),
        );
      },
    );
  }

  void _showInfoEstiramientoEstaticoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estiramiento Estático'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Estiramiento Estático.'),
        );
      },
    );
  }

  void _showInfoDiasALaSemanaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dias a la Semana'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Dias a la Semana.'),
        );
      },
    );
  }

  void _showInfoCalentamientoArticularDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Calentamiento Articular'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Calentamiento Articular.'),
        );
      },
    );
  }

  void _showInfoCantidadDeEjerciciosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cantidad de Ejercicios'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Cantidad de Ejercicios.'),
        );
      },
    );
  }

  void _showInfoRepeticionesPorEjerciciosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Repeticiones por Ejercicios'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content:
              const Text('Este es un párrafo de Repeticiones por Ejercicios.'),
        );
      },
    );
  }

  void _showInfoCantidadDeCircuitosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cantidad de Circuitos'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Cantidad de Circuitos.'),
        );
      },
    );
  }

  void _showInfoPorcentajeDeRMDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Porcentaje de RM'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: const Text('Este es un párrafo de Porcentaje de RM.'),
        );
      },
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
                          _diasALaSemanaEsp = '2 a 3';
                          _diasALaSemanaEng = '2 to 3';
                          _cantidadDeEjerciciosEsp = '2 a 5';
                          _cantidadDeEjerciciosEng = '2 to 5';
                          _repeticionesPorEjerciciosEsp = '5 a 16';
                          _repeticionesPorEjerciciosEng = '5 to 16';
                          _cantidadDeCircuitosEsp = '2 a 3';
                          _cantidadDeCircuitosEng = '2 to 3';
                          _porcentajeDeRMEsp = '30% a 50%';
                          _porcentajeDeRMEng = '30% to 50%';
                        } else if (newValue == 'Intermedio') {
                          _diasALaSemanaEsp = '3 a 4';
                          _diasALaSemanaEng = '3 to 4';
                          _cantidadDeEjerciciosEsp = '4 a 6';
                          _cantidadDeEjerciciosEng = '4 to 6';
                          _repeticionesPorEjerciciosEsp = '8 a 16';
                          _repeticionesPorEjerciciosEng = '8 to 16';
                          _cantidadDeCircuitosEsp = '2 a 4';
                          _cantidadDeCircuitosEng = '2 to 4';
                          _porcentajeDeRMEsp = '40% a 60%';
                          _porcentajeDeRMEng = '40% to 60%';
                        } else if (newValue == 'Avanzado') {
                          _diasALaSemanaEsp = '3 a 5';
                          _diasALaSemanaEng = '3 to 5';
                          _cantidadDeEjerciciosEsp = '5 a 8';
                          _cantidadDeEjerciciosEng = '5 to 8';
                          _repeticionesPorEjerciciosEsp = '10 a 16';
                          _repeticionesPorEjerciciosEng = '10 to 16';
                          _cantidadDeCircuitosEsp = '3 a 4';
                          _cantidadDeCircuitosEng = '3 to 4';
                          _porcentajeDeRMEsp = '50% a 60%';
                          _porcentajeDeRMEng = '50% to 60%';
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
                          _diasALaSemanaEng = '2 to 3';
                          _diasALaSemanaEsp = '2 a 3';
                          _cantidadDeEjerciciosEng = '2 to 5';
                          _cantidadDeEjerciciosEsp = '2 a 5';
                          _repeticionesPorEjerciciosEng = '5 to 16';
                          _repeticionesPorEjerciciosEsp = '5 a 16';
                          _cantidadDeCircuitosEng = '2 to 3';
                          _cantidadDeCircuitosEsp = '2 a 3';
                          _porcentajeDeRMEng = '30% to 50%';
                          _porcentajeDeRMEsp = '30% a 50%';
                        } else if (newValue == 'Medium') {
                          _diasALaSemanaEng = '3 to 4';
                          _diasALaSemanaEsp = '3 a 4';
                          _cantidadDeEjerciciosEng = '4 to 6';
                          _cantidadDeEjerciciosEsp = '4 a 6';
                          _repeticionesPorEjerciciosEng = '8 to 16';
                          _repeticionesPorEjerciciosEsp = '8 a 16';
                          _cantidadDeCircuitosEng = '2 to 4';
                          _cantidadDeCircuitosEsp = '2 a 4';
                          _porcentajeDeRMEng = '40% to 60%';
                          _porcentajeDeRMEsp = '40% a 60%';
                        } else if (newValue == 'Advanced') {
                          _diasALaSemanaEng = '3 to 5';
                          _diasALaSemanaEsp = '3 a 5';
                          _cantidadDeEjerciciosEng = '5 to 8';
                          _cantidadDeEjerciciosEsp = '5 a 8';
                          _repeticionesPorEjerciciosEng = '10 to 16';
                          _repeticionesPorEjerciciosEsp = '10 a 16';
                          _cantidadDeCircuitosEng = '3 to 4';
                          _cantidadDeCircuitosEsp = '3 a 4';
                          _porcentajeDeRMEng = '50% to 60%';
                          _porcentajeDeRMEsp = '50% a 60%';
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
            onPressed: _showInfoActividadFisicaDialog,
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
            onPressed: _showInfoCalentamientoFisicoDialog,
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
            onPressed: _showInfoDescansoEntreEjerciciosDialog,
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
            onPressed: _showInfoDescansoEntreCircuitoDialog,
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
            onPressed: _showInfoEstiramientoEstaticoDialog,
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
    Locale currentLocale = Localizations.localeOf(context);
    bool isEsp = currentLocale.languageCode == "es";

    List<String> optionsEsp = ['Seleccionar', '2 a 3', '3 a 4', '3 a 5'];
    List<String> optionsEng = ['Select', '2 to 3', '3 to 4', '3 to 5'];

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentDiasALaSemana = isEsp ? _diasALaSemanaEsp : _diasALaSemanaEng;

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
                      .translate('selectDiasALaSemanaTime')),
                  onChanged:
                      null,
                  value: currentDiasALaSemana == 'Seleccionar' ||
                          currentDiasALaSemana == 'Select'
                      ? null
                      : currentDiasALaSemana,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentDiasALaSemana == value)
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
            onPressed: _showInfoDiasALaSemanaDialog,
          ),
        ],
      ),
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
            onPressed: _showInfoCalentamientoArticularDialog,
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

    List<String> optionsEsp = ['Seleccionar', '2 a 5', '4 a 6', '5 a 8'];
    List<String> optionsEng = ['Select', '2 to 5', '4 to 6', '5 to 8'];

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentCantidadDeEjercicios =
        isEsp ? _cantidadDeEjerciciosEsp : _cantidadDeEjerciciosEng;

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
                      .translate('selectCantidadDeEjerciciosTime')),
                  onChanged:
                      null,
                  value: currentCantidadDeEjercicios == 'Seleccionar' ||
                          currentCantidadDeEjercicios == 'Select'
                      ? null
                      : currentCantidadDeEjercicios,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentCantidadDeEjercicios == value)
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
            onPressed: _showInfoCantidadDeEjerciciosDialog,
          ),
        ],
      ),
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

    List<String> optionsEsp = ['Seleccionar', '5 a 16', '8 a 16', '8 a 16'];
    List<String> optionsEng = ['Select', '5 to 16', '8 to 16', '8 to 16'];

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentRepeticionesPorEjercicios =
        isEsp ? _repeticionesPorEjerciciosEsp : _repeticionesPorEjerciciosEng;

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
                      .translate('selectRepeticionesPorEjerciciosTime')),
                  onChanged:
                      null,
                  value: currentRepeticionesPorEjercicios == 'Seleccionar' ||
                          currentRepeticionesPorEjercicios == 'Select'
                      ? null
                      : currentRepeticionesPorEjercicios,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentRepeticionesPorEjercicios == value)
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
            onPressed: _showInfoRepeticionesPorEjerciciosDialog,
          ),
        ],
      ),
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

    List<String> optionsEsp = ['Seleccionar', '2 a 3', '2 a 4', '3 a 4'];
    List<String> optionsEng = ['Select', '2 to 3', '2 to 4', '3 to 4'];

    List<String> options = isEsp ? optionsEsp : optionsEng;
    String currentCantidadDeCircuitos =
        isEsp ? _cantidadDeCircuitosEsp : _cantidadDeCircuitosEng;

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
                      .translate('selectCantidadDeCircuitosTime')),
                  onChanged:
                      null,
                  value: currentCantidadDeCircuitos == 'Seleccionar' ||
                          currentCantidadDeCircuitos == 'Select'
                      ? null
                      : currentCantidadDeCircuitos,
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value),
                          if (currentCantidadDeCircuitos == value)
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
            onPressed: _showInfoCantidadDeCircuitosDialog,
          ),
        ],
      ),
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

    List<String> optionsEsp = [
      'Seleccionar',
      '30% a 50%',
      '40% a 60%',
      '50% a 60%'
    ];
    List<String> optionsEng = [
      'Select',
      '30% to 50%',
      '40% to 60%',
      '50% to 60%'
    ];

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
                  onChanged:
                      null,
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
            onPressed: _showInfoPorcentajeDeRMDialog,
          ),
        ],
      ),
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
    }
  }

  void _removeCalentamientoFisico(String calentamientoFisicoId) {
    setState(() {
      _selectedCalentamientoFisico.removeWhere((calentamientoFisico) =>
          calentamientoFisico.id == calentamientoFisicoId);
    });
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
            String calentamientoFisicoName = langKey == 'Esp'
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
            const SizedBox(height: 8),
            _buildEstiramientoEstaticoButtons(),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9,
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
                          .getSimplifiedCalentamientoFisico(langKey),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
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
                              Text(
                                AppLocalizations.of(context)!
                                    .translate('selectCalentamientoFisico'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(AppLocalizations.of(context)!
                                      .translate('selectCalentamientoFisico')),
                                  onChanged: (String? newValue) {
                                    _addCalentamientoFisico(newValue!);
                                  },
                                  items: snapshot.data,
                                  value: snapshot.data!.isNotEmpty
                                      ? snapshot.data?.first.value
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
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
