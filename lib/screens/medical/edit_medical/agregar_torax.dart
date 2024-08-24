import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../role_first_page.dart';

class AgregarTorax extends StatefulWidget {
  final String email;

  const AgregarTorax({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _AgregarToraxState createState() =>
      _AgregarToraxState();
}

class _AgregarToraxState
    extends State<AgregarTorax> {
  int currentStep = 2;
  final _formKey = GlobalKey<FormState>();
  int? _torax;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitCircunferencias() async {
  if (_formKey.currentState!.validate()) {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        await _firestore
            .collection('usersmedical')
            .doc(widget.email)
            .update({
          'Circunferencias.Torax': _torax,
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
            Text(AppLocalizations.of(context)!.translate('torax')),
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

  Widget _buildStepTwo() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Torax',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Torax';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _torax = int.tryParse(value);
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
