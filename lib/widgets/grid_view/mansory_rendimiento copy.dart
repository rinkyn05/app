import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/notifiers/selected_notifier.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class MasonryRendimiento extends StatefulWidget {
  const MasonryRendimiento({Key? key}) : super(key: key);

  @override
  _MasonryRendimientoState createState() => _MasonryRendimientoState();
}

class _MasonryRendimientoState extends State<MasonryRendimiento> {
  late YoutubePlayerController _controller;
  bool _isIntensityToggled = false;
  String? _selectedIntensity;

  bool _isMembershipToggled = false;
  String? _selectedMembership;

  bool _isStanceToggled = false;
  String? _selectedStance;

  bool _isNivelDeImpactoToggled = false;
  String? _selectedNivelDeImpacto;

  bool _isDificultyToggled = false;
  String? _selectedDificulty;

  final Map<String, List<String>> intensityLabels = {
    'es': [
      'Ascendente',
      'Descendente',
      'Baja',
      'Muy Baja',
      'Moderada',
      'Alta',
      'Muy Alta',
    ],
    'en': [
      'Ascending',
      'Descending',
      'Low',
      'Very Low',
      'Moderate',
      'High',
      'Very High',
    ],
  };

  final Map<String, List<String>> membershipLabels = {
    'es': ['Gratis', 'Premium'],
    'en': ['Free', 'Premium'],
  };

  final Map<String, List<String>> stanceLabels = {
    'es': [
      'Parado',
      'Sentado',
      'Inclinado',
      'Declinado',
      'De Pie Horizontal',
      'Maquina Gimnasion'
    ],
    'en': [
      'Standing',
      'Sitting',
      'Inclined',
      'Declined',
      'Horizontal',
      'Gym Machine'
    ],
  };

  final Map<String, List<String>> nivelDeImpactoLabels = {
    'es': ['Bajo', 'Regular', 'Medio', 'Bueno', 'Alto'],
    'en': ['Low', 'Regular', 'Medium', 'Good', 'High'],
  };

  final Map<String, List<String>> dificultyLabels = {
    'es': ['Fácil', 'Medio', 'Avanzado', 'Difícil'],
    'en': ['Easy', 'Medium', 'Advanced', 'Difficult'],
  };

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final locale = AppLocalizations.of(context)!.locale.languageCode;
            final intensityLabelsLocal =
                intensityLabels[locale] ?? intensityLabels['en']!;
            final membershipLabelsLocal =
                membershipLabels[locale] ?? membershipLabels['en']!;
            final stanceLabelsLocal =
                stanceLabels[locale] ?? stanceLabels['en']!;
            final nivelDeImpactoLabelsLocal =
                nivelDeImpactoLabels[locale] ?? nivelDeImpactoLabels['en']!;
            final dificultyLabelsLocal =
                dificultyLabels[locale] ?? dificultyLabels['en']!;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Test Dialog',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Intensidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Intensidad',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isIntensityToggled,
                          onChanged: (value) {
                            setState(() {
                              _isIntensityToggled = value;
                              if (!value) {
                                _selectedIntensity = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isIntensityToggled)
                      Wrap(
                        spacing: 4.0,
                        children: _selectedIntensity == null
                            ? intensityLabelsLocal.map((label) {
                                return ChoiceChip(
                                  label: Text(label,
                                      style: TextStyle(fontSize: 12)),
                                  selected: _selectedIntensity == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedIntensity =
                                          selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedIntensity',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIntensity = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
                      ),
                    const SizedBox(height: 20),

                    // Membresía
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Membresía',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isMembershipToggled,
                          onChanged: (value) {
                            setState(() {
                              _isMembershipToggled = value;
                              if (!value) {
                                _selectedMembership = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isMembershipToggled)
                      Wrap(
                        spacing: 4.0,
                        children: _selectedMembership == null
                            ? membershipLabelsLocal.map((label) {
                                return ChoiceChip(
                                  label: Text(label,
                                      style: TextStyle(fontSize: 12)),
                                  selected: _selectedMembership == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedMembership =
                                          selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedMembership',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedMembership = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
                      ),
                    const SizedBox(height: 20),

                    // Stance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Postura',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isStanceToggled,
                          onChanged: (value) {
                            setState(() {
                              _isStanceToggled = value;
                              if (!value) {
                                _selectedStance = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isStanceToggled)
                      Wrap(
                        spacing: 4.0,
                        children: _selectedStance == null
                            ? stanceLabelsLocal.map((label) {
                                return ChoiceChip(
                                  label: Text(label,
                                      style: TextStyle(fontSize: 12)),
                                  selected: _selectedStance == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedStance = selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedStance',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedStance = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
                      ),
                    const SizedBox(height: 20),
                    // Nivel de Impacto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nivel de Impacto',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isNivelDeImpactoToggled,
                          onChanged: (value) {
                            setState(() {
                              _isNivelDeImpactoToggled = value;
                              if (!value) {
                                _selectedNivelDeImpacto = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isNivelDeImpactoToggled)
                      Wrap(
                        spacing: 4.0,
                        children: _selectedNivelDeImpacto == null
                            ? nivelDeImpactoLabelsLocal.map((label) {
                                return ChoiceChip(
                                  label: Text(
                                    label,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  selected: _selectedNivelDeImpacto == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedNivelDeImpacto =
                                          selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedNivelDeImpacto',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedNivelDeImpacto = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
                      ),
                    const SizedBox(height: 20),
                    // Dificultad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nivel de Dificultad',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: _isDificultyToggled,
                          onChanged: (value) {
                            setState(() {
                              _isDificultyToggled = value;
                              if (!value) {
                                _selectedDificulty = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isDificultyToggled)
                      Wrap(
                        spacing: 4.0,
                        children: _selectedDificulty == null
                            ? dificultyLabelsLocal.map((label) {
                                return ChoiceChip(
                                  label: Text(
                                    label,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  selected: _selectedDificulty == label,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedDificulty =
                                          selected ? label : null;
                                    });
                                  },
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.grey.shade200,
                                );
                              }).toList()
                            : [
                                Text(
                                  'Seleccionado: $_selectedDificulty',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDificulty = null;
                                    });
                                  },
                                  child: Text('Limpiar'),
                                ),
                              ],
                      ),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Lógica de filtrado a implementar
                          },
                          child: Text('Filtrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItemsNotifier = Provider.of<SelectedItemsNotifier>(context);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 6.0,
                    color: AppColors.adaptableColor(context),
                  ),
                ),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          color: AppColors.adaptableColor(context),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .translate('search'),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 10.0,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showFilterDialog,
                    icon: Icon(
                      Icons.filter_list,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('rendimientoFisico')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final estiramientosFisicos = snapshot.data!.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          (estiramientosFisicos.length / 3).ceil(),
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              3,
                              (i) => i + index * 3 < estiramientosFisicos.length
                                  ? _buildIconItem(
                                      context,
                                      estiramientosFisicos[i + index * 3],
                                      selectedItemsNotifier,
                                    )
                                  : SizedBox(width: 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context,
      DocumentSnapshot rendimientoFisico, SelectedItemsNotifier notifier) {
    String? imageUrl = rendimientoFisico['URL de la Imagen'];
    String nombre = rendimientoFisico['NombreEsp'] ?? 'Nombre no encontrado';
    bool isPremium = rendimientoFisico['MembershipEng'] == 'Premium';

    bool isSelected = notifier.selectedItems.contains(nombre);

    return GestureDetector(
      onTap: () {
        notifier.toggleSelection(nombre);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        )
                      : Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    nombre,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned.fill(
                child: Container(
                  color: Colors.blue.withOpacity(0.5),
                ),
              ),
            if (isPremium)
              Positioned.fill(
                child: Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
