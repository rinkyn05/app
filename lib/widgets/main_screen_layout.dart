import 'package:flutter/material.dart';
import '../screens/account/settings_screen.dart';
import '../screens/temporizador/temporizador.dart';
import 'custom_drawer.dart';
import '../config/utils/appcolors.dart';

class MainScreenLayout extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String appBarTitle;
  final String nombre;
  final String rol;

  const MainScreenLayout({
    Key? key,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.appBarTitle,
    required this.nombre,
    required this.rol,
  }) : super(key: key);

  @override
  MainScreenLayoutState createState() => MainScreenLayoutState();
}

class MainScreenLayoutState extends State<MainScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarTheme = Theme.of(context).bottomNavigationBarTheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    Color? bottomNavBarColor =
        isDarkTheme ? AppColors.gdarkblue : Colors.blueGrey[50];
    String cgImage = isDarkTheme ? 'assets/images/cg_w.png' : 'assets/images/cg.png';

    return Container(
      margin: EdgeInsets.only(top: 0.0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 70,
          title: StopwatchWidget(),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                iconSize: 50,
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
              iconSize: 50,
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: widget.body,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: bottomNavBarColor,
          ),
          child: Container(
            height: 70,
            child: Stack(
              children: [
                BottomNavigationBar(
                  selectedItemColor:
                      bottomNavigationBarTheme.selectedItemColor ?? Colors.blue,
                  currentIndex: widget.selectedIndex,
                  onTap: widget.onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 40),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.fitness_center, size: 40),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.apple, size: 40),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(cgImage, width: 50, height: 50),
                      label: '',
                    ),
                  ],
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.0 +
                      (MediaQuery.of(context).size.width * 0.4 / 4) +
                      (MediaQuery.of(context).size.width *
                          0.9 /
                          4 *
                          widget.selectedIndex),
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3 / 2,
                    height: 6,
                    color: AppColors.gblue,
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
