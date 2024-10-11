import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces de usuario.
import 'package:firebase_auth/firebase_auth.dart'; // Importa FirebaseAuth para manejar la autenticación de usuarios.
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar la base de datos de Firebase.

import '../config/lang/app_localization.dart'; // Importa el archivo para la localización y traducción de la aplicación.
import 'gymder_screen.dart'; // Importa la pantalla principal de la comunidad.

class JoinCommunityScreen extends StatefulWidget {
  // Este widget permite al usuario unirse a la comunidad.
  const JoinCommunityScreen({Key? key}) : super(key: key);

  @override
  _JoinCommunityScreenState createState() =>
      _JoinCommunityScreenState(); // Crea el estado de la pantalla.
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final FirebaseAuth _auth = FirebaseAuth
      .instance; // Instancia para manejar la autenticación de Firebase.
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // Instancia para acceder a la base de datos de Firestore.

  String?
      _userEmail; // Variable para almacenar el correo electrónico del usuario.

  @override
  void initState() {
    // Función que se ejecuta al iniciar el widget.
    super.initState();
    _getUserInfo(); // Llama a la función para obtener la información del usuario.
  }

  // Función que obtiene el correo electrónico del usuario autenticado.
  Future<void> _getUserInfo() async {
    final User? user =
        _auth.currentUser; // Obtiene el usuario actual autenticado.
    if (user != null) {
      setState(() {
        _userEmail = user.email; // Almacena el correo electrónico del usuario.

        // Imprime el correo electrónico del usuario en la consola.
        print('Correo electrónico del usuario: $_userEmail');
      });
    }
  }

  // Función que permite al usuario unirse a la comunidad.
  Future<void> _joinCommunity() async {
    if (_userEmail != null) {
      // Verifica que el correo electrónico no sea nulo.
      try {
        print(
            'Correo electrónico del usuario para buscar en Firestore: $_userEmail');

        // Intenta obtener el documento del usuario en la colección 'gymfriends' de Firestore.
        final gymFriendDoc =
            await _firestore.collection('gymfriends').doc(_userEmail).get();

        if (gymFriendDoc.exists) {
          // Si el documento ya existe, significa que el usuario ya está en la comunidad.
          print('El usuario ya existe en la comunidad.');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GymDerScreen()), // Redirige a la pantalla de la comunidad.
          );
        } else {
          // Si el documento no existe, el usuario no está en la comunidad.
          print(
              'El usuario no existe en la comunidad. Procediendo con el registro...');

          // Busca el documento del usuario en la colección 'users' usando el correo electrónico.
          final userSnapshot = await _firestore
              .collection('users')
              .where('Correo Electrónico', isEqualTo: _userEmail)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            // Si se encuentra el documento del usuario...
            final userData = userSnapshot.docs.first
                .data(); // Obtiene los datos del primer documento.

            // Almacena la información del usuario.
            final userName = userData['Nombre'];
            final membership = userData['Membership'];
            final nivel = userData['Nivel'];
            final edad = userData['Edad'];
            final genero = userData['Género'];
            final image_url = userData['image_url'];

            // Imprime la información del usuario en la consola.
            print('Información del usuario obtenida de Firestore:');
            print('Nombre: $userName');
            print('Membership: $membership');
            print('Nivel: $nivel');
            print('Edad: $edad');
            print('Género: $genero');
            print('image_url: $image_url');

            // Crea un nuevo documento en la colección 'gymfriendsemails' para almacenar datos del usuario.
            await _firestore
                .collection('gymfriendsemails')
                .doc(_userEmail)
                .set({
              'like': [], // Inicializa la lista de 'like'.
              'likedyou': [], // Inicializa la lista de 'likedyou'.
              'dislike': [], // Inicializa la lista de 'dislike'.
              'dislikedyou': [], // Inicializa la lista de 'dislikedyou'.
              'follow': [], // Inicializa la lista de 'follow'.
              'followers': [], // Inicializa la lista de 'followers'.
            });

            // Crea un nuevo documento en la colección 'gymfriends' con la información del usuario.
            await _firestore.collection('gymfriends').doc(_userEmail).set({
              'Nombre': userName,
              'Correo Electrónico': _userEmail,
              'Membership': membership,
              'Nivel': nivel,
              'Edad': edad,
              'Género': genero,
              'image_url': image_url,
              'Like': 0, // Inicializa el contador de 'Like'.
              'Dislike': 0, // Inicializa el contador de 'Dislike'.
              'Followers': 0, // Inicializa el contador de 'Followers'.
            });

            print('Te has unido exitosamente a la comunidad.');

            // Redirige al usuario a la pantalla de la comunidad.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GymDerScreen()),
            );
          } else {
            // Si no se encontró información del usuario en Firestore.
            print('No se encontró la información del usuario en Firestore.');
          }
        }
      } catch (error) {
        // Maneja cualquier error que ocurra al intentar unirse a la comunidad.
        print('Error al unirse a la comunidad: $error');
      }
    } else {
      // Si el correo electrónico es nulo, muestra un mensaje de error.
      print(
          'No se pudo unir a la comunidad debido a falta de correo electrónico.');
    }
  }

  // Función que construye un botón personalizado con estilo.
  Widget _buildCustomStyledButton(
    String text,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed:
          onPressed, // Asigna la función que se ejecutará al presionar el botón.
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(
                255, 2, 11, 59) // Color del texto en modo oscuro.
            : Colors.white, // Color del texto en modo claro.
        backgroundColor: Colors.blue, // Color de fondo del botón.
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0), // Espaciado interno del botón.
        textStyle: Theme.of(context)
            .textTheme
            .titleLarge, // Estilo de texto del botón.
      ),
      child: Text(text), // Texto que se mostrará en el botón.
    );
  }

  @override
  Widget build(BuildContext context) {
    // Función que construye la interfaz de usuario.
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Añade padding alrededor del contenido.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Centra los elementos en la columna.
              children: [
                Text(
                  AppLocalizations.of(context)!.translate(
                      'joinCommunityHeading'), // Muestra el encabezado de unirse a la comunidad.
                  style: TextStyle(
                    fontSize: 24, // Tamaño de la fuente del encabezado.
                    fontWeight:
                        FontWeight.bold, // Peso de la fuente del encabezado.
                  ),
                ),
                SizedBox(
                    height: 20), // Espacio entre el encabezado y la imagen.
                Image.asset(
                  'assets/images/onboarding3.png', // Imagen que se mostrará en la pantalla.
                  fit: BoxFit
                      .cover, // Ajusta la imagen para cubrir el espacio disponible.
                ),
                SizedBox(
                    height: 20), // Espacio entre la imagen y la descripción.
                Text(
                  AppLocalizations.of(context)!.translate(
                      'joinCommunityDescription'), // Muestra la descripción de unirse a la comunidad.
                  textAlign:
                      TextAlign.center, // Centra el texto de la descripción.
                  style: TextStyle(
                    fontSize: 22, // Tamaño de la fuente de la descripción.
                  ),
                ),
                SizedBox(
                    height: 20), // Espacio entre la descripción y el botón.
                _buildCustomStyledButton(
                  AppLocalizations.of(context)!.translate(
                      'joinCommunityButton'), // Muestra el texto del botón.
                  _joinCommunity, // Asigna la función para unirse a la comunidad al presionar el botón.
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
