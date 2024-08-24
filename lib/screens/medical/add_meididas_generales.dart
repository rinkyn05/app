import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../role_first_page.dart';

class AgregarMedidasGeneralesScreen extends StatefulWidget {
  final String email;

  const AgregarMedidasGeneralesScreen({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _AgregarMedidasGeneralesScreenState createState() =>
      _AgregarMedidasGeneralesScreenState();
}

class _AgregarMedidasGeneralesScreenState
    extends State<AgregarMedidasGeneralesScreen> {
  int currentStep = 2;
  final _formKey = GlobalKey<FormState>();
  String _gender = '';
  String _weightUnit = 'Kg';
  String _heightUnit = 'Cm';
  String _wingspanUnit = 'Cm';
  String _seatedHeightUnit = 'Cm';
  double _weight = 0, _height = 0;
  double _seatedHeight = 0, _wingspan = 0;
  int? _age;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitMedidasGenerales() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = _auth.currentUser;

        if (user != null) {
          String formattedWeight = '$_weight $_weightUnit';
          String formattedHeight = '$_height $_heightUnit';
          String formattedSeatedHeight = '$_seatedHeight $_seatedHeightUnit';
          String formattedWingspan = '$_wingspan $_wingspanUnit';

          Map<String, dynamic> generalMeasurements = {
            'Edad': _age,
            'Género': _gender,
            'Peso': formattedWeight,
            'Estatura': formattedHeight,
            'Estatura Sentado': formattedSeatedHeight,
            'Envergadura': formattedWingspan,
          };

          Map<String, dynamic> userData = {
            'Medidas Generales': generalMeasurements,
            'Circunferencias': {},
          };

          await _firestore
              .collection('usersmedical')
              .doc(widget.email)
              .set(userData);

          await _firestore.collection('users').doc(user.uid).update({
            'Edad': _age,
            'Género': _gender,
            'Peso': formattedWeight,
            'Estatura': formattedHeight,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RoleFirstPage()),
          );
        }
      } catch (e) {
        // Manejar errores
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.translate('addGeneralMeasures')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (currentStep == 2) _buildStepTwo(),
              if (currentStep == 3) _buildStepThree(),
              if (currentStep == 4) _buildStepFour(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (currentStep > 2 || currentStep < 4) ...[
                  ElevatedButton(
                    onPressed: _previousStep,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColors.gdarkblue2,
                          width: 4.0,
                        ),
                      ),
                      elevation: 3,
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gdarkblue2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('previous'),
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed:
                        currentStep < 4 ? _nextStep : _submitMedidasGenerales,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: AppColors.gdarkblue2,
                          width: 4.0,
                        ),
                      ),
                      elevation: 3,
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gdarkblue2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      textStyle: Theme.of(context).textTheme.labelMedium,
                    ),
                    child: Text(
                      currentStep < 4
                          ? AppLocalizations.of(context)!.translate('next')
                          : AppLocalizations.of(context)!
                              .translate('completeInfo'),
                    ),
                  ),
                ],
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      currentStep--;
    });
  }

  Widget _buildStepTwo() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    final ThemeData theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cgImage, width: 500, height: 150),
              Image.asset(coachGImage, width: 500, height: 100),
              Text(
                AppLocalizations.of(context)!.translate('improveYourLife'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.translate('age'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('enterYourAge');
                    }
                    if (int.tryParse(value) == null) {
                      return AppLocalizations.of(context)!
                          .translate('enterValidAge');
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _age = int.tryParse(value);
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepThree() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _genderTile(
                    AppLocalizations.of(context)!.translate('male'),
                    'assets/images/avatar3.png',
                  ),
                  _genderTile(
                    AppLocalizations.of(context)!.translate('female'),
                    'assets/images/avatar2.png',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _genderTile(
                    AppLocalizations.of(context)!.translate('preferNotToSay'),
                    'assets/images/gym.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderTile(String genderKey, String imagePath) {
    return GestureDetector(
      onTap: () => _selectGender(genderKey),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: _genderOption(
            imagePath,
            AppLocalizations.of(context)!.translate(genderKey),
            _gender == genderKey),
      ),
    );
  }

  Widget _genderOption(String imagePath, String gender, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(gender),
          ),
        ],
      ),
    );
  }

  void _selectGender(String gender) {
    setState(() {
      _gender = gender;
    });
  }

  Widget _buildStepFour() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    final ThemeData theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cgImage, width: 500, height: 150),
              Image.asset(coachGImage, width: 500, height: 100),
              Text(
                AppLocalizations.of(context)!.translate('improveYourLife'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.translate('weight'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translate('enterYourWeight');
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .translate('enterValidWeight');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _weight = double.tryParse(value) ?? 0.0;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _weightUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        items: <String>['Kg', 'Lbs']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _weightUnit = newValue!;
                          });
                        },
                        isDense: false,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.translate('height'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translate('enterYourHeight');
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .translate('enterValidHeight');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _height = double.tryParse(value) ?? 0.0;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _heightUnit,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        items: <String>['Cm', 'M', 'P']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _heightUnit = newValue!;
                          });
                        },
                        isDense: false,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .translate('seatedHeight'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translate('enterSeatedHeight');
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .translate('enterValidHeight');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _seatedHeight = double.tryParse(value) ?? 0.0;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _seatedHeightUnit,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        items: <String>['Cm', 'M', 'P']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _seatedHeightUnit = newValue!;
                          });
                        },
                        isDense: false,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .translate('wingspan'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translate('enterWingspan');
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!
                                .translate('enterValidHeight');
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _wingspan = double.tryParse(value) ?? 0.0;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _wingspanUnit,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        items: <String>['Cm', 'M', 'P']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _wingspanUnit = newValue!;
                          });
                        },
                        isDense: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
