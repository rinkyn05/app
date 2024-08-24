import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../widgets/reg_input_decoration_widget.dart';
import '../../account/forgot_screen.dart';
import '../../role_first_page.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final ThemeData theme = Theme.of(context);

    String cgImage =
        isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';
    String coachGImage =
        isDarkTheme ? 'assets/images/coachG_w.png' : 'assets/images/coachG.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('login'),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(cgImage, width: 500, height: 150),
                        Image.asset(coachGImage, width: 500, height: 100),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('improveYourLife'),
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 10.0),
                          child: RegistrationInputDecorationWidget(
                            labelText: AppLocalizations.of(context)!
                                .translate('email'),
                            hintext: 'Ingrese su correo electrónico',
                            icon: Icons.email,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value!.isEmpty
                                ? 'Ingrese su correo electrónico'
                                : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 10.0),
                          child: RegistrationInputDecorationWidget(
                            labelText: AppLocalizations.of(context)!
                                .translate('password'),
                            hintext: 'Ingrese su contraseña',
                            icon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            validator: (value) =>
                                value!.isEmpty ? 'Ingrese su contraseña' : null,
                          ),
                        ),
                        _buildLoginButton(context),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('forgotYourPassword'),
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: isDarkTheme
                                  ? Colors.white
                                  : const Color.fromARGB(255, 2, 11, 59),
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('dontHaveAnAccount'),
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: isDarkTheme
                                  ? Colors.white
                                  : const Color.fromARGB(255, 2, 11, 59),
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleFirstPage()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) {
          return;
        }

        String errorMessage = "Error de inicio de sesión";
        if (e.code == 'user-not-found') {
          errorMessage = 'Usuario no encontrado';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Contraseña incorrecta';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _submitLogin,
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
        AppLocalizations.of(context)!.translate('login'),
        textAlign: TextAlign.center,
      ),
    );
  }
}
