import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../config/validators/validator.dart';
import '../../widgets/circularprogress_widget.dart';
import '../../widgets/reg_input_decoration_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    final String email = emailController.text.trim();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog(email);
    } catch (error) {
      print('Error sending password reset email: $error');
      _showErrorDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.adaptableGreyColor(context),
        title: Text(
          AppLocalizations.of(context)!.translate('recoverPassword'),
          style: const TextStyle(
            fontFamily: "MB",
            color: AppColors.orangeColor,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!
              .translate('emailSent', params: {'email': email}),
          style: const TextStyle(
            fontFamily: "MM",
            color: AppColors.darkBlueColor,
          ),
        ),
        actions: [
          MaterialButton(
            color: AppColors.orangeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.translate('accept'),
              style: const TextStyle(
                fontFamily: "MB",
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.adaptableGreyColor(context),
        title: Text(
          AppLocalizations.of(context)!.translate('error'),
          style: TextStyle(
            fontFamily: "MB",
            color: AppColors.errorColor,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.translate('errorSendingEmail'),
          style: const TextStyle(
            fontFamily: "MM",
            color: AppColors.text,
          ),
        ),
        actions: [
          MaterialButton(
            color: AppColors.errorColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.translate('accept'),
              style: const TextStyle(
                fontFamily: "MB",
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate('recoverPassword'),
          style: theme.textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                RegistrationInputDecorationWidget(
                  controller: emailController,
                  labelText:
                      AppLocalizations.of(context)!.translate('enterYourEmail'),
                  hintext: "@gmail.com",
                  suffixIcon: const Icon(Icons.email_rounded),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressWidget(
                        text: AppLocalizations.of(context)!
                            .translate('simulatingSend'),
                        colors: theme.primaryColor,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 40),
                        ),
                        onPressed: () => _resetPassword(),
                        child: Text(
                          AppLocalizations.of(context)!.translate('recover'),
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
