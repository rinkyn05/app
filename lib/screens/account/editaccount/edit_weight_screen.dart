import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../role_first_page.dart';

class EditWeightScreen extends StatefulWidget {
  final String email;

  const EditWeightScreen({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _EditWeightScreenState createState() => _EditWeightScreenState();
}

class _EditWeightScreenState extends State<EditWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  String _weightUnit = 'Kg';
  double _weight = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitMedidasGenerales() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = _auth.currentUser;

        if (user != null) {
          String formattedWeight = '$_weight$_weightUnit';

          await _firestore.collection('usersmedical').doc(widget.email).update({
            'Medidas Generales.Peso': formattedWeight,
          });

          await _firestore.collection('users').doc(user.uid).update({
            'Peso': formattedWeight,
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
        title: Text(AppLocalizations.of(context)!.translate('editWeight')),
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
              _buildWeightInput(),
              ElevatedButton(
                onPressed: _submitMedidasGenerales,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 3,
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.gdarkblue2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 12.0,
                  ),
                  textStyle: Theme.of(context).textTheme.labelMedium,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('completeInfo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
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
                                borderRadius: BorderRadius.circular(20.0))),
                        items: <String>['Kg', 'Lbs', 'P']
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
            ],
          ),
        ),
      ),
    );
  }
}