import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../functions/users/users_firebase_register_functions.dart';
import '../../../widgets/reg_input_decoration_widget.dart';
import '../../account/privacy.dart';
import '../../account/terms_conditions.dart';
import '../../role_first_page.dart';
import '../login/login_screen.dart';
import 'complete_registration_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _password = '';
  bool _privacyPolicyChecked = false;
  bool _termsChecked = false;
  DateTime currentDate = DateTime.now();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('completeProfileTitle'),
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('completeProfileContent'),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteRegistrationScreen(
                      email: _email,
                      password: _password,
                    ),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.translate('yesOption'),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoleFirstPage(),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.translate('maybeLaterOption'),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (!_privacyPolicyChecked || !_termsChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .translate('acceptTermsAndPrivacyMessage'),
              textAlign: TextAlign.center,
            ),
          ),
        );
        return;
      }

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        if (!mounted) return;

        DateTime currentDate = DateTime.now();

        Map<String, dynamic> userData = {
          'Nombre': _name,
          'Correo Electrónico': _email,
          'DateTime': currentDate,
          'Rol': 'Usuario',
          'Membership': 'Free',
          'Nivel': 'Basico',
          'Edad': '0',
          'Género': 'No especificado',
          'Peso': '0',
          'Estatura': '0',
          'image_url':
              'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3',
        };

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);

        Map<String, dynamic> generalMeasurements = {
          'Edad': '0',
          'Género': 'No especificado',
          'Peso': '0',
          'Estatura': '0',
          'Estatura Sentado': '0',
          'Envergadura': '0',
        };

        Map<String, dynamic> userDataMedical = {
          'Medidas Generales': generalMeasurements,
          'Circunferencias': {},
        };

        await _firestore
            .collection('usersmedical')
            .doc(_email)
            .set(userDataMedical);

        FirebaseFunctions().updateUserStats(_email);
        FirebaseFunctions().updateReferrals(_email);
        FirebaseFunctions().updateTotalUsers();

        if (!mounted) return;

        _showCompletionDialog();
      } catch (e) {
        if (!mounted) return;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('register'),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStepOne(),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: AppColors.gdarkblue2, width: 4.0),
                    ),
                    elevation: 3,
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.gdarkblue2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    textStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('registerrr'),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('alreadyHaveAnAccountLogin'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color.fromARGB(255, 2, 11, 59),
                          decoration: TextDecoration.underline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    final ThemeData theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(cgImage, width: 500, height: 150),
              Image.asset(coachGImage, width: 500, height: 100),
              Text(
                AppLocalizations.of(context)!.translate('improveYourLife'),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 10.0),
                child: RegistrationInputDecorationWidget(
                  labelText: AppLocalizations.of(context)!.translate('named'),
                  hintext: AppLocalizations.of(context)!.translate('enterName'),
                  icon: Icons.person,
                  controller: _nameController,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)!.translate('enterName')
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _name = value.isNotEmpty
                          ? value[0].toUpperCase() + value.substring(1)
                          : '';
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 10.0),
                child: RegistrationInputDecorationWidget(
                  labelText: AppLocalizations.of(context)!.translate('email'),
                  hintext:
                      AppLocalizations.of(context)!.translate('enterEmail'),
                  icon: Icons.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)!.translate('enterEmail')
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 10.0),
                child: RegistrationInputDecorationWidget(
                  labelText:
                      AppLocalizations.of(context)!.translate('password'),
                  hintext:
                      AppLocalizations.of(context)!.translate('enterPassword'),
                  icon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)!.translate('enterPassword')
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _privacyPolicyChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _privacyPolicyChecked = newValue!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('viewPrivacyPolicy'),
                      style: const TextStyle(
                        fontSize: 24,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _termsChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _termsChecked = newValue!;
                      });
                    },
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('viewTermsAndConditions'),
                        style: const TextStyle(
                          fontSize: 24,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
