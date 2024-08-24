import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../role_first_page.dart';

class AgregarCadera extends StatefulWidget {
  final String email;

  const AgregarCadera({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _AgregarCaderaState createState() => _AgregarCaderaState();
}

class _AgregarCaderaState extends State<AgregarCadera> {
  int currentStep = 3;
  final _formKey = GlobalKey<FormState>();
  int? _cadera;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitCircunferencias() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = _auth.currentUser;

        if (user != null) {
          await _firestore.collection('usersmedical').doc(widget.email).update({
            'Circunferencias.Cadera': _cadera,
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
            Text(AppLocalizations.of(context)!.translate('addCircumferences')),
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
              if (currentStep == 3) _buildStepThree(),
              ElevatedButton(
                onPressed: _submitCircunferencias,
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
                  AppLocalizations.of(context)!.translate('completeInfo'),
                ),
              ),
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
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cadera',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Cadera';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _cadera = int.tryParse(value);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
