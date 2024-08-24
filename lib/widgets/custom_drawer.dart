import 'package:app/screens/account/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/lang/app_localization.dart';
import '../config/notifiers/language_notifier.dart';
import '../config/notifiers/theme_notifier.dart';
import '../functions/load_user_image.dart';
import '../functions/sign_out.dart';
import '../main.dart';
import '../screens/account/Legals_screen.dart';
import '../screens/account/contact_screen.dart';
import '../screens/start_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _nombre = '';
  String _membership = '';
  String _nivel = '';
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    loadUserImage(_auth, (imageUrl) {
      setState(() {
        _userImageUrl = imageUrl ??
            'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3';
      });
    });
  }

  Future<void> _loadUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          String? imageUrl = userData['image_url'];
          if (imageUrl != null) {
            setState(() {
              _userImageUrl = imageUrl;
            });
          } else {
            setState(() {
              _userImageUrl =
                  'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3';
            });
          }

          setState(() {
            _nombre = userData['Nombre'] ?? 'Usuario';
            _membership = userData['Membership'] ?? 'Sin Membership';
            _nivel = userData['Nivel'] ?? 'Sin Nivel';
          });
        }
      } catch (e) {
        // Manejar otros errores aquí
      }
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.translate('language')),
          children: <Widget>[
            _buildLanguageOption(
                context, 'es', 'Español', 'assets/images/mexico_flag.png'),
            _buildLanguageOption(
                context, 'en', 'English', 'assets/images/usa_flag.png'),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String languageCode,
      String languageName, String flagImagePath) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        _changeLanguage(context, languageCode);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(flagImagePath, width: 30, height: 20),
          const SizedBox(width: 10),
          Text(languageName),
        ],
      ),
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    Provider.of<LanguageNotifier>(context, listen: false)
        .changeLanguage(Locale(languageCode));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .translate('changeLanguageDialogTitle')),
          content: Text(
            AppLocalizations.of(context)!
                .translate('changeLanguageDialogContent'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartApp(context);
              },
              child: Text(AppLocalizations.of(context)!
                  .translate('changeLanguageDialogRestartButton')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!
                  .translate('changeLanguageDialogMaybeLaterButton')),
            ),
          ],
        );
      },
    );
  }

  void _restartApp(BuildContext context) {
    final languageNotifier =
        Provider.of<LanguageNotifier>(context, listen: false);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MyApp(languageNotifier: languageNotifier),
    ));
  }

  String _getFlagImagePath(Locale currentLocale) {
    switch (currentLocale.languageCode) {
      case 'es':
        return 'assets/images/mexico_flag.png';
      case 'en':
        return 'assets/images/usa_flag.png';
      default:
        return 'assets/images/mexico_flag.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String flagImagePath = _getFlagImagePath(languageNotifier.currentLocale);

    Color dividerColor = currentTheme.brightness == Brightness.light
        ? const Color.fromARGB(255, 2, 11, 59)
        : Colors.white;

    return Drawer(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: _userImageUrl != null
                    ? NetworkImage(_userImageUrl!)
                    : const AssetImage("assets/images/gym.png")
                        as ImageProvider,
                radius: 70.0,
              ),
              const SizedBox(height: 10),
              Text(
                _nombre,
                style: currentTheme.textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                _membership,
                style: currentTheme.textTheme.labelLarge,
              ),
              const SizedBox(height: 5),
              Text(
                _nivel,
                style: currentTheme.textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              Divider(
                color: dividerColor,
                thickness: 2,
                height: 2,
                endIndent: 20,
                indent: 20,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.home,
                title: AppLocalizations.of(context)!.translate('home'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => StartScreen(
                            nombre: _nombre,
                            rol: _membership,
                            currentUserEmail: '',
                          )));
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.settings,
                title: AppLocalizations.of(context)!.translate('settings'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettingsScreen()));
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.contact_mail,
                title: AppLocalizations.of(context)!.translate('contact'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ContactScreen()));
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.policy,
                title: AppLocalizations.of(context)!.translate('legals'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LegalsScreen()));
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.brightness_6,
                title: AppLocalizations.of(context)!.translate('changeTheme'),
                onTap: () {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .toggleTheme();
                },
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('language'),
                    style: currentTheme.textTheme.labelSmall,
                  ),
                  trailing: Image.asset(
                    flagImagePath,
                    width: 30,
                    height: 20,
                  ),
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: AppLocalizations.of(context)!.translate('logOut'),
                onTap: () {
                  signOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    final ThemeData currentTheme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        selectedColor: currentTheme.primaryColor,
        iconColor: currentTheme.iconTheme.color,
        textColor: currentTheme.textTheme.labelSmall?.color ?? Colors.white,
        leading: Text(
          title,
          style: currentTheme.textTheme.labelSmall,
        ),
        title: const SizedBox.shrink(),
        trailing: Icon(icon),
        onTap: onTap,
      ),
    );
  }
}
