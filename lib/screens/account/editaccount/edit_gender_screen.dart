import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../role_first_page.dart';

class EditGenderScreen extends StatefulWidget {
  final String email;

  const EditGenderScreen({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  _EditGenderScreenState createState() => _EditGenderScreenState();
}

class _EditGenderScreenState extends State<EditGenderScreen> {
  int currentStep = 2;
  final _formKey = GlobalKey<FormState>();
  String _gender = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitMedidasGenerales() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = _auth.currentUser;

        if (user != null) {
          await _firestore.collection('usersmedical').doc(widget.email).update({
            'Medidas Generales.Género': _gender,
          });

          await _firestore.collection('users').doc(user.uid).update({
            'Género': _gender,
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
        title: Text(AppLocalizations.of(context)!.translate('editGender')),
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
              _buildStepThree(),
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
}
