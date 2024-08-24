import 'package:flutter/material.dart';
import '../../../config/lang/app_localization.dart';
import '../../../screens/account/profile_screen.dart';
import 'admin_custom_drawer.dart';

class AdminMainScreenLayout extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String appBarTitle;
  final String nombre;
  final String rol;

  const AdminMainScreenLayout({
    Key? key,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.appBarTitle,
    required this.nombre,
    required this.rol,
  }) : super(key: key);

  @override
  AdminMainScreenLayoutState createState() => AdminMainScreenLayoutState();
}

class AdminMainScreenLayoutState extends State<AdminMainScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarTheme = Theme.of(context).bottomNavigationBarTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              iconSize: 30,
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ));
            },
            iconSize: 30,
          ),
        ],
      ),
      drawer: const AdminCustomDrawer(),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center),
            label: AppLocalizations.of(context)!.translate('exercises'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: AppLocalizations.of(context)!.translate('recipes'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fastfood),
            label: AppLocalizations.of(context)!.translate('food'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.translate('profile'),
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor:
            bottomNavigationBarTheme.selectedItemColor ?? Colors.blue,
        unselectedItemColor:
            bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
        showUnselectedLabels:
            bottomNavigationBarTheme.showUnselectedLabels ?? true,
        backgroundColor:
            bottomNavigationBarTheme.backgroundColor ?? Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 5.0,
        iconSize: 30.0,
        selectedFontSize:
            bottomNavigationBarTheme.selectedLabelStyle?.fontSize ?? 14.0,
        unselectedFontSize:
            bottomNavigationBarTheme.unselectedLabelStyle?.fontSize ?? 12.0,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
