import 'package:app/backend/admin/admin_start_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/lang/app_localization.dart';
import '../../../config/notifiers/language_notifier.dart';
import '../../../config/notifiers/theme_notifier.dart';
import '../../../functions/role_checker.dart';
import '../../../main.dart';
import '../../blog/categorias/adm_categories_screen.dart';
import '../../blog/entradas/adm_posts_screen.dart';
import '../../blog/paginas/adm_page_screen.dart';
import '../../calentamiento_fisico/adm_calentamiento_f_screen.dart';
import '../../contents/bodyparts/adm_body_parts.dart';
import '../../contents/calentamiento_especifico/adm_calentamiento_especifico.dart';
import '../../contents/category_ejercicio/adm_cat_ejercicio.dart';
import '../../contents/equipment/adm_equipment.dart';
import '../../contents/estiramiento_especifico/adm_estiramiento_especifico.dart';
import '../../contents/objetivos/adm_objetivos.dart';
import '../../contents/unequipment/adm_unequipment.dart';
import '../../estiramiento_fisico/adm_estiramiento_f_screen.dart';
import '../../rendimiento/adm_rendimiento_screen.dart';
import '../../screens/add_frases_screen.dart';
import '../../screens/adm_users_screen.dart';
import '../../tecnica_tactica/adm_tecnica_tactica_screen.dart';
import '../../mej_prev_lesiones/adm_mej_prev_les_screen.dart';

class AdminCustomDrawer extends StatefulWidget {
  const AdminCustomDrawer({super.key});

  @override
  AdminCustomDrawerState createState() => AdminCustomDrawerState();
}

class AdminCustomDrawerState extends State<AdminCustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _nombre = '';
  String _rol = '';
  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    bool hasAccess = await checkUserRole();
    if (!hasAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showAccessDeniedDialog(context);
        }
      });
    }
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.translate('accessDeniedTitle')),
          content: Text(
              AppLocalizations.of(context)!.translate('accessDeniedMessage')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.translate('okButton')),
            ),
          ],
        );
      },
    );
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
          try {
            String imagePath = 'user_images/${user.uid}';
            Reference imageRef =
                FirebaseStorage.instance.ref().child(imagePath);
            String imageUrl = await imageRef.getDownloadURL();
            setState(() {
              _userImageUrl = imageUrl;
            });
          } catch (e) {
            setState(() {
              _userImageUrl =
                  'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3';
            });
          }

          setState(() {
            _nombre = userData['Nombre'] ?? 'Usuario';
            _rol = userData['Rol'] ?? 'Sin Rol';
          });
        }
      } catch (e) {
        // Manejar otros errores
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _userImageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_userImageUrl!),
                    radius: 70.0,
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/avatar2.png"),
                    radius: 70.0,
                  ),
            const SizedBox(height: 10),
            Text(
              _nombre,
              style: currentTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              _rol,
              style: currentTheme.textTheme.labelLarge,
              textAlign: TextAlign.center,
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
                    builder: (_) =>
                        AdminStartScreen(nombre: _nombre, rol: _rol)));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.group,
              title: AppLocalizations.of(context)!.translate('users'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdmUsersScreen()));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: AppLocalizations.of(context)!.translate('quotes'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddFrasesScreen()));
              },
            ),
            ExpansionTile(
              leading: const Icon(Icons.feed),
              title: Text(AppLocalizations.of(context)!.translate('blog')),
              children: <Widget>[
                _buildSubMenuOption(
                  context,
                  title: AppLocalizations.of(context)!.translate('entries'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmPostsScreen()));
                  },
                ),
                _buildSubMenuOption(
                  context,
                  title: AppLocalizations.of(context)!.translate('categories'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmCategoriesScreen()));
                  },
                ),
                _buildSubMenuOption(
                  context,
                  title: AppLocalizations.of(context)!.translate('pages'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmPageScreen()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.feed),
              title: Text(AppLocalizations.of(context)!.translate('exercises')),
              children: <Widget>[
                _buildSubMenuOption2(
                  context,
                  title:
                      AppLocalizations.of(context)!.translate('catEjercicio'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmCatEjercicioScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title: AppLocalizations.of(context)!
                      .translate('MusculoObjetivo'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmBodyPartsScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title:
                      AppLocalizations.of(context)!.translate('applicableTo'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmObjetivosScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title:
                      AppLocalizations.of(context)!.translate('equipmentNew'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmEquipmentScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title: AppLocalizations.of(context)!.translate('unequipment'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AdmUnequipmentScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title: AppLocalizations.of(context)!
                      .translate('calentamientoEspecifico'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            const AdmCalentamientoEspecificoScreen()));
                  },
                ),
                _buildSubMenuOption2(
                  context,
                  title: AppLocalizations.of(context)!
                      .translate('estiramientoEspecifico'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            const AdmEstiramientoEspecificoScreen()));
                  },
                ),
              ],
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: AppLocalizations.of(context)!
                  .translate('calentamientoFisico'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdmCalentamientoFisicoScreen()));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title:
                  AppLocalizations.of(context)!.translate('estiramientoFisico'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdmEstiramientoFisicoScreen()));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: AppLocalizations.of(context)!.translate('rendimiento'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdmRendimientoFisicoScreen()));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: AppLocalizations.of(context)!.translate('tecnica/tactica'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdmTenicaTacticaScreen()));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              title: AppLocalizations.of(context)!.translate('mejPreLesiones'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdmMejPreLesionesScreen()));
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
                leading: Image.asset(flagImagePath, width: 30, height: 20),
                title: Text(
                  AppLocalizations.of(context)!.translate('language'),
                  style: currentTheme.textTheme.bodyMedium,
                ),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      textColor: currentTheme.textTheme.bodyMedium?.color ?? Colors.white,
      leading: Icon(icon),
      title: Text(title, style: currentTheme.textTheme.bodyMedium),
      onTap: onTap,
    ),
  );
}

Widget _buildSubMenuOption(BuildContext context,
    {required String title, required VoidCallback onTap}) {
  final ThemeData currentTheme = Theme.of(context);

  return ListTile(
    contentPadding: const EdgeInsets.only(left: 40),
    title: Text(title, style: currentTheme.textTheme.bodyMedium),
    onTap: onTap,
  );
}

Widget _buildSubMenuOption2(BuildContext context,
    {required String title, required VoidCallback onTap}) {
  final ThemeData currentTheme = Theme.of(context);

  return ListTile(
    contentPadding: const EdgeInsets.only(left: 40),
    title: Text(title, style: currentTheme.textTheme.bodyMedium),
    onTap: onTap,
  );
}
