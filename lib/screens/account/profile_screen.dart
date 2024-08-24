import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:app/config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';
import '../../functions/latest_frase.dart';
import '../../functions/sign_out.dart';
import '../../widgets/custom_appbar_new.dart';
import 'delete_account_screen.dart';
import 'forgot_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _nombre = '';
  String _email = '';
  DateTime? _fechaCreacion;
  int? _paymentM;
  String _password = '';
  String _phone = '';
  String _country = '';
  String _membership = 'Free';
  String _heightUnit = '';
  String _level = 'Basic';
  String _latestFrase = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfoAndImage();
    _loadLatestFrase();
  }

  void _loadUserInfoAndImage() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _nombre = userData.data()?['Nombre'] ?? 'Usuario';
          _email = userData.data()?['Correo Electrónico'] ?? '';
          _fechaCreacion =
              (userData.data()?['DateTime'] as Timestamp?)?.toDate();
          _paymentM = userData.data()?['Payment Method'];
          _password = userData.data()?['Password'] ?? '';
          _phone = userData.data()?['Telefono'] ?? '';
          _country = userData.data()?['Pais'] ?? '';
          _membership = userData.data()?['Membership'] ?? 'Free';
          _level = userData.data()?['Nivel'] ?? 'Basic';
        });
      }
    }
  }

  void _loadLatestFrase() async {
    var fraseData = await fetchLatestFrase();
    if (fraseData != null) {
      String currentLang = Localizations.localeOf(context).languageCode;

      setState(() {
        _latestFrase = (currentLang == 'es')
            ? fraseData['Frase Esp'] ?? ""
            : fraseData['Frase Eng'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: ListView(
          children: [
            CustomAppBarNew(
              onBackButtonPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "${AppLocalizations.of(context)!.translate('personalInfo')}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 2),
            _buildUserHeader(),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.primaryColor,
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    _latestFrase.isNotEmpty
                        ? _latestFrase
                        : AppLocalizations.of(context)!
                            .translate('inspirationalQuote'),
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            _buildEmailInfoTile(
              context,
              AppLocalizations.of(context)!.translate('email'),
              _email,
              Icons.email,
            ),
            const Divider(
              color: AppColors.orangeColor,
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            _buildUserInfoTile(
              context,
              AppLocalizations.of(context)!.translate('paymentMethod'),
              _paymentM != null
                  ? _paymentM.toString()
                  : AppLocalizations.of(context)!.translate('notSpecified'),
              Icons.payment,
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditAgeScreen(
                //       email: _email,
                //     ),
                //   ),
                // );
              },
            ),
            _buildUserInfoTile(
              context,
              AppLocalizations.of(context)!.translate('password'),
              _password,
              Icons.password,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordScreen(),
                  ),
                );
              },
            ),
            _buildUserInfoTile(
              context,
              AppLocalizations.of(context)!.translate('phone'),
              _phone,
              Icons.phone,
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditWeightScreen(
                //       email: _email,
                //     ),
                //   ),
                // );
              },
            ),
            _buildUserInfoTile(
              context,
              AppLocalizations.of(context)!.translate('country'),
              '$_country $_heightUnit',
              Icons.map,
              () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditHeightScreen(
                //       email: _email,
                //     ),
                //   ),
                // );
              },
            ),
            _buildUserInfoTile(
              context,
              AppLocalizations.of(context)!.translate('creationDate'),
              _fechaCreacion != null
                  ? DateFormat('dd/MM/yyyy').format(_fechaCreacion!)
                  : AppLocalizations.of(context)!.translate('notSpecified'),
              Icons.date_range,
              null,
            ),
            const SizedBox(height: 10),
            _buildDeleteAccountTile(),
            const SizedBox(height: 10),
            const Divider(
              color: AppColors.orangeColor,
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            _buildLogoutTile(),
            const SizedBox(height: 10),
            const Divider(
              color: AppColors.orangeColor,
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                '${AppLocalizations.of(context)!.translate('helloUser')} $_nombre',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                '${AppLocalizations.of(context)!.translate('yourMembership: ')} $_membership',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                '${AppLocalizations.of(context)!.translate('yourLevel: ')} $_level',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTile(BuildContext context, String title, String value,
      IconData icon, Function()? onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(Icons.edit, color: Theme.of(context).iconTheme.color),
            ),
        ],
      ),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _buildEmailInfoTile(
      BuildContext context, String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodySmall),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout, size: 30),
      title: Text(AppLocalizations.of(context)!.translate('logOut'),
          style: Theme.of(context).textTheme.bodyLarge),
      onTap: () => signOut(context),
    );
  }

  Widget _buildDeleteAccountTile() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Divider(
          color: AppColors.orangeColor,
          height: 2,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          leading: const Icon(Icons.delete, size: 30),
          title: Text(
            AppLocalizations.of(context)!.translate('deleteAccount'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeleteAccountScreen(userEmail: _email),
              ),
            );
          },
        ),
      ],
    );
  }
}
