import 'package:flutter/material.dart';
import '../screens/account/settings_screen.dart'; // Importa la pantalla de configuración de la cuenta.
import '../screens/temporizador/temporizador.dart'; // Importa la pantalla del temporizador.
import 'custom_drawer.dart'; // Importa el drawer personalizado.
import '../config/utils/appcolors.dart'; // Importa la configuración de colores de la aplicación.

class MainScreenLayout extends StatefulWidget {
  final Widget body; // Contenido principal del layout.
  final int
      selectedIndex; // Índice del elemento seleccionado en el BottomNavigationBar.
  final Function(int)
      onItemTapped; // Función que se llama al tocar un elemento del BottomNavigationBar.
  final String appBarTitle; // Título del AppBar.
  final String nombre; // Nombre del usuario.
  final String rol; // Rol del usuario.

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
  MainScreenLayoutState createState() =>
      MainScreenLayoutState(); // Crea el estado asociado al widget.
}

class MainScreenLayoutState extends State<MainScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final bottomNavigationBarTheme = Theme.of(context)
        .bottomNavigationBarTheme; // Obtiene el tema del BottomNavigationBar.
    final isDarkTheme = Theme.of(context).brightness ==
        Brightness.dark; // Verifica si el tema es oscuro.
    Color? bottomNavBarColor = isDarkTheme
        ? AppColors.gdarkblue
        : Colors.blueGrey[50]; // Establece el color del BottomNavigationBar.
    String cgImage = isDarkTheme
        ? 'assets/images/cg_w.png'
        : 'assets/images/cg.png'; // Establece la imagen según el tema.

    return Container(
      margin: EdgeInsets.only(top: 0.0), // Margen superior del contenedor.
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // Evita mostrar el botón de retroceso por defecto.
          centerTitle: true, // Centra el título en el AppBar.
          toolbarHeight: 70, // Altura del toolbar del AppBar.
          title:
              StopwatchWidget(), // Widget que se muestra como título en el AppBar.
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 12), // Separación del borde izquierdo
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      iconSize: 30,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              );
            },
          ),

          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 12),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.transparent, // Fondo transparente
                border:
                    Border.all(color: Colors.blueGrey), // Borde gris azulado
                borderRadius: BorderRadius.circular(12), // Bordes redondeados
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ));
                  },
                  iconSize: 40,
                  color: Colors.blueGrey, // Color del icono
                ),
              ),
            ),
          ],
        ),
        drawer: const CustomDrawer(), // Drawer personalizado.
        body: widget.body, // Cuerpo del layout que se pasa como argumento.
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                bottomNavBarColor, // Color de fondo del BottomNavigationBar.
          ),
          child: Container(
            height: 70, // Altura del contenedor del BottomNavigationBar.
            child: Stack(
              children: [
                BottomNavigationBar(
                  selectedItemColor:
                      bottomNavigationBarTheme.selectedItemColor ??
                          Colors.blue, // Color del ítem seleccionado.
                  currentIndex:
                      widget.selectedIndex, // Índice del ítem seleccionado.
                  onTap: widget
                      .onItemTapped, // Función que se llama al tocar un ítem.
                  items: [
                    BottomNavigationBarItem(
                      icon:
                          Icon(Icons.home, size: 38), // Ícono del primer ítem.
                      label: '', // Etiqueta del primer ítem.
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.fitness_center,
                          size: 38), // Ícono del segundo ítem.
                      label: '', // Etiqueta del segundo ítem.
                    ),
                    BottomNavigationBarItem(
                      icon:
                          Icon(Icons.apple, size: 38), // Ícono del tercer ítem.
                      label: '', // Etiqueta del tercer ítem.
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(cgImage,
                          width: 48,
                          height: 48), // Ícono del cuarto ítem (imagen).
                      label: '', // Etiqueta del cuarto ítem.
                    ),
                  ],
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.0 +
                      (MediaQuery.of(context).size.width * 0.4 / 4) +
                      (MediaQuery.of(context).size.width *
                          0.9 /
                          4 *
                          widget
                              .selectedIndex), // Posiciona el indicador de selección en el BottomNavigationBar.
                  top: 0, // Posición superior del indicador.
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.3 /
                        2, // Ancho del indicador.
                    height: 6, // Altura del indicador.
                    color: AppColors.gblue, // Color del indicador.
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
