import 'dart:math'; // Importa la biblioteca de matemáticas para realizar operaciones matemáticas

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces de usuario
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para acceder a la base de datos en la nube de Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para la autenticación de usuarios
import '../functions/gym_friends_functions.dart'; // Importa funciones personalizadas para manejar amigos de gimnasio
import '../widgets/custom_appbar_gynder.dart'; // Importa un widget personalizado para la barra de aplicaciones
import 'role_first_page.dart'; // Importa la página del rol inicial
import '../../config/lang/app_localization.dart'; // Importa la configuración de localización para la aplicación

// Clase principal que representa la pantalla del gimnasio
class GymDerScreen extends StatefulWidget {
  const GymDerScreen({Key? key}) : super(key: key);

  @override
  _GymDerScreenState createState() =>
      _GymDerScreenState(); // Crea el estado de la pantalla
}

// Clase que maneja el estado de GymDerScreen
class _GymDerScreenState extends State<GymDerScreen> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instancia de Firebase Auth para autenticación
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // Instancia de Firestore para acceder a la base de datos
  final GymFriendsFunctions _gymFriendsFunctions =
      GymFriendsFunctions(); // Instancia de funciones personalizadas

  late Future<List<DocumentSnapshot>>
      _futureGymFriends; // Variable para almacenar el futuro de amigos de gimnasio
  late Future<List<String>>
      _futureUserInteractions; // Variable para almacenar el futuro de interacciones del usuario
  late Stream<DocumentSnapshot>
      _interactionsStream; // Flujo de datos para las interacciones del usuario

  @override
  void initState() {
    super.initState(); // Inicializa el estado
    _futureGymFriends =
        _getGymFriends(); // Llama a la función para obtener amigos de gimnasio
    _futureUserInteractions =
        _getUserInteractions(); // Llama a la función para obtener interacciones del usuario
    _checkCurrentUserEmail(); // Verifica el correo electrónico del usuario actual
    _setupInteractionsStream(); // Configura el flujo de interacciones del usuario
  }

  // Función para verificar el correo electrónico del usuario actual
  Future<void> _checkCurrentUserEmail() async {
    final User? user = _auth.currentUser; // Obtiene el usuario actual
    if (user != null) {
      // Si el usuario no es nulo
      final userEmail =
          user.email; // Almacena el correo electrónico del usuario
      print(
          'Current User Email: $userEmail'); // Imprime el correo electrónico del usuario
    } else {
      print(
          'Current User Email is null'); // Imprime un mensaje si el usuario es nulo
    }
  }

  // Función para obtener amigos de gimnasio
  Future<List<DocumentSnapshot>> _getGymFriends() async {
    final User? user = _auth.currentUser; // Obtiene el usuario actual
    if (user != null) {
      // Si el usuario no es nulo
      final userEmail =
          user.email; // Almacena el correo electrónico del usuario
      final gymFriendSnapshot = await _firestore
          .collection('gymfriends')
          .get(); // Obtiene la colección de amigos de gimnasio
      // Filtra los amigos de gimnasio que no son el usuario actual
      final gymFriends =
          gymFriendSnapshot.docs.where((doc) => doc.id != userEmail).toList();
      for (var friend in gymFriends) {
        // Itera sobre cada amigo de gimnasio
        final friendEmail = friend.data()['Correo Electrónico']
            as String?; // Obtiene el correo electrónico del amigo
        if (friendEmail != null) {
          // Si el correo electrónico no es nulo
          print(
              'Friend Email: $friendEmail'); // Imprime el correo electrónico del amigo
        } else {
          print(
              'Friend Email is null'); // Imprime un mensaje si el correo electrónico del amigo es nulo
        }
      }
      return gymFriends; // Retorna la lista de amigos de gimnasio
    } else {
      return []; // Retorna una lista vacía si el usuario es nulo
    }
  }

  // Función para obtener las interacciones del usuario
  Future<List<String>> _getUserInteractions() async {
    final User? user = _auth.currentUser; // Obtiene el usuario actual
    if (user != null) {
      // Si el usuario no es nulo
      final userEmail =
          user.email; // Almacena el correo electrónico del usuario
      // Obtiene las interacciones del usuario desde Firestore
      final userInteractionsSnapshot =
          await _firestore.collection('gymfriendsemails').doc(userEmail).get();
      final userInteractionsData = userInteractionsSnapshot
          .data(); // Obtiene los datos de las interacciones del usuario
      final List<String> userInteractions =
          []; // Lista para almacenar las interacciones del usuario

      // Verifica si hay datos de interacciones y las agrega a la lista
      if (userInteractionsData != null) {
        if (userInteractionsData['liked'] != null) {
          userInteractionsData['liked'].forEach((email) {
            userInteractions
                .add('liked:$email'); // Agrega las interacciones de "gustar"
          });
        }

        if (userInteractionsData['youDisliked'] != null) {
          userInteractionsData['youDisliked'].forEach((email) {
            userInteractions.add(
                'youDisliked:$email'); // Agrega las interacciones de "no gustar"
          });
        }

        if (userInteractionsData['follow'] != null) {
          userInteractionsData['follow'].forEach((email) {
            userInteractions
                .add('follow:$email'); // Agrega las interacciones de "seguir"
          });
        }
      }

      return userInteractions; // Retorna la lista de interacciones del usuario
    } else {
      return []; // Retorna una lista vacía si el usuario es nulo
    }
  }

  // Función para configurar el flujo de interacciones
  void _setupInteractionsStream() {
    final User? user =
        FirebaseAuth.instance.currentUser; // Obtiene el usuario actual
    if (user != null) {
      // Si el usuario no es nulo
      final userEmail =
          user.email; // Almacena el correo electrónico del usuario
      // Configura el flujo de datos para las interacciones del usuario
      _interactionsStream =
          _firestore.collection('gymfriendsemails').doc(userEmail).snapshots();
    }
  }

  // Función para mostrar el cuadro de diálogo de filtros
  void _showFilterDialog(BuildContext context) {
    bool isManSelected = false; // Estado para saber si se seleccionó hombre
    bool isWomanSelected = false; // Estado para saber si se seleccionó mujer
    RangeValues ageRange = RangeValues(18, 30); // Rango de edad inicial

    showDialog(
      // Muestra el cuadro de diálogo
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Permite reconstruir el estado del cuadro de diálogo
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Espaciado entre elementos del título
                children: [
                  Text(AppLocalizations.of(context)!
                      .translate('show')), // Título traducido
                  IconButton(
                    icon: Icon(Icons.close), // Botón para cerrar el diálogo
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min, // Tamaño mínimo de la columna
                children: [
                  // Casilla de verificación para seleccionar hombre
                  CheckboxListTile(
                    title: Text(AppLocalizations.of(context)!
                        .translate('man')), // Texto traducido
                    value: isManSelected, // Valor de la casilla de verificación
                    onChanged: (bool? value) {
                      setState(() {
                        isManSelected = value!; // Actualiza el estado
                      });
                    },
                  ),
                  // Casilla de verificación para seleccionar mujer
                  CheckboxListTile(
                    title: Text(AppLocalizations.of(context)!
                        .translate('woman')), // Texto traducido
                    value:
                        isWomanSelected, // Valor de la casilla de verificación
                    onChanged: (bool? value) {
                      setState(() {
                        isWomanSelected = value!; // Actualiza el estado
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Espaciado vertical
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                          'age_range'), // Título para el rango de edad
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium, // Estilo del texto
                    ),
                  ),
                  // Control deslizante para seleccionar el rango de edad
                  RangeSlider(
                    values: ageRange, // Rango de valores actual
                    min: 18, // Valor mínimo
                    max: 80, // Valor máximo
                    divisions: 50, // Número de divisiones
                    labels: RangeLabels(
                      '${ageRange.start.round()}', // Etiqueta del valor inicial
                      '${ageRange.end.round()}', // Etiqueta del valor final
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        ageRange = values; // Actualiza el rango de edad
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                // Botón para aceptar los filtros
                Center(
                  child: ElevatedButton(
                    child: Text(AppLocalizations.of(context)!
                        .translate('accept')), // Texto traducido
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarGynder(
        // Barra de aplicaciones personalizada
        onBackButtonPressed: () {
          Navigator.of(context).push(
            // Navega a la página anterior
            MaterialPageRoute(
              builder: (context) =>
                  RoleFirstPage(), // Página a la que se navega
            ),
          );
        },
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _futureGymFriends, // Espera el futuro de amigos de gimnasio
        builder: (context, snapshot) {
          // Comprueba el estado de la conexión
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Muestra un indicador de carga mientras espera
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Muestra un mensaje de error si ocurre uno
          } else {
            final gymFriends =
                snapshot.data!; // Obtiene la lista de amigos de gimnasio
            return StreamBuilder<DocumentSnapshot>(
              stream:
                  _interactionsStream, // Escucha el flujo de interacciones del usuario
              builder: (context, interactionsSnapshot) {
                // Comprueba el estado del flujo de interacciones
                if (interactionsSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    interactionsSnapshot.data == null) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Muestra un indicador de carga mientras espera
                } else if (interactionsSnapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${interactionsSnapshot.error}')); // Muestra un mensaje de error si ocurre uno
                } else {
                  final userInteractionsData = interactionsSnapshot.data!.data()
                      as Map<String,
                          dynamic>; // Obtiene los datos de las interacciones
                  final userInteractions =
                      []; // Lista para almacenar las interacciones del usuario
                  // Itera sobre los datos de interacciones y las agrega a la lista
                  userInteractionsData.forEach((key, value) {
                    if (key == 'liked' ||
                        key == 'youDisliked' ||
                        key == 'follow') {
                      (value as List).forEach((email) {
                        userInteractions.add(
                            '$key:$email'); // Agrega la interacción a la lista
                      });
                    }
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Alinea el contenido al centro
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                            0.0), // Espaciado alrededor del contenido
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment
                                    .center, // Alinea el texto al centro
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('community')}", // Texto traducido para "comunidad"
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge, // Estilo del texto
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_list), // Icono de filtro
                              iconSize: 40.0, // Tamaño del icono
                              onPressed: () {
                                _showFilterDialog(
                                    context); // Muestra el cuadro de diálogo de filtros
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          // Constructor de vista de páginas para mostrar amigos de gimnasio
                          itemCount:
                              gymFriends.length, // Número de amigos de gimnasio
                          itemBuilder: (context, index) {
                            final userData = gymFriends[index].data() as Map<
                                String,
                                dynamic>; // Obtiene los datos del amigo de gimnasio
                            final imageUrl = userData[
                                    'image_url'] ?? // URL de la imagen
                                'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3'; // Imagen predeterminada
                            final name =
                                userData['Nombre'] ?? 'N/A'; // Nombre del amigo
                            final membership = userData['Membership'] ??
                                'N/A'; // Membresía del amigo
                            final nivel =
                                userData['Nivel'] ?? 'N/A'; // Nivel del amigo
                            var followers = userData['Followers'] ??
                                0; // Seguidores del amigo
                            var likes =
                                userData['Like'] ?? 0; // Likes del amigo
                            var dislikes =
                                userData['Dislike'] ?? 0; // Dislikes del amigo
                            final userEmail = _auth.currentUser!
                                .email; // Correo electrónico del usuario actual

                            final interactionKey =
                                '${userData['Correo Electrónico']}'; // Clave para las interacciones
                            Color likeColor = Colors
                                .grey; // Color inicial para el botón de "like"
                            Color dislikeColor = Colors
                                .grey; // Color inicial para el botón de "dislike"
                            Color followColor = Colors
                                .grey; // Color inicial para el botón de "follow"

                            // Comprueba las interacciones del usuario y actualiza los colores de los botones
                            if (userInteractions
                                .contains('liked:$interactionKey')) {
                              likeColor = Colors
                                  .green; // Cambia a verde si ha dado like
                              dislikeColor = Colors.grey;
                              followColor = Colors
                                  .lightBlueAccent; // Cambia a azul si sigue al amigo
                            } else if (userInteractions
                                .contains('youDisliked:$interactionKey')) {
                              dislikeColor = Colors
                                  .red; // Cambia a rojo si ha dado dislike
                              likeColor = Colors.grey;
                              followColor = Colors.grey;
                            } else if (userInteractions
                                .contains('follow:$interactionKey')) {
                              followColor = Colors
                                  .lightBlueAccent; // Cambia a azul si sigue al amigo
                              likeColor = Colors
                                  .green; // Cambia a verde si ha dado like
                              dislikeColor = Colors.grey;
                            }

                            return DraggableCard(
                              // Widget personalizado para mostrar la tarjeta del amigo
                              imageUrl: imageUrl, // URL de la imagen
                              name: name, // Nombre del amigo
                              membership: membership, // Membresía del amigo
                              nivel: nivel, // Nivel del amigo
                              followers: followers, // Seguidores del amigo
                              likes: likes, // Likes del amigo
                              dislikes: dislikes, // Dislikes del amigo
                              likeColor: likeColor, // Color del botón de like
                              dislikeColor:
                                  dislikeColor, // Color del botón de dislike
                              followColor:
                                  followColor, // Color del botón de follow
                              onLikePressed: () {
                                // Acción cuando se presiona el botón de like
                                print(
                                    'Like button pressed'); // Imprime un mensaje en la consola
                                final email = userData['Correo Electrónico']
                                    as String?; // Obtiene el correo del amigo
                                if (email != null) {
                                  // Si el correo no es nulo
                                  _gymFriendsFunctions
                                      .likeUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Has dado like')), // Muestra un mensaje de éxito
                                    );
                                    setState(() {
                                      likes++; // Aumenta el contador de likes
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(error
                                              .toString())), // Muestra un mensaje de error
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Email is null')), // Muestra un mensaje si el correo es nulo
                                  );
                                }
                              },
                              onDislikePressed: () {
                                // Acción cuando se presiona el botón de dislike
                                print(
                                    'Dislike button pressed'); // Imprime un mensaje en la consola
                                final email = userData['Correo Electrónico']
                                    as String?; // Obtiene el correo del amigo
                                if (email != null) {
                                  // Si el correo no es nulo
                                  _gymFriendsFunctions
                                      .dislikeUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Has dado dislike')), // Muestra un mensaje de éxito
                                    );
                                    setState(() {
                                      dislikes++; // Aumenta el contador de dislikes
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(error
                                              .toString())), // Muestra un mensaje de error
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Email is null')), // Muestra un mensaje si el correo es nulo
                                  );
                                }
                              },
                              onFollowPressed: () {
                                // Acción cuando se presiona el botón de follow
                                print(
                                    'Follow button pressed'); // Imprime un mensaje en la consola
                                final email = userData['Correo Electrónico']
                                    as String?; // Obtiene el correo del amigo
                                if (email != null) {
                                  // Si el correo no es nulo
                                  _gymFriendsFunctions
                                      .followUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Has dado follow')), // Muestra un mensaje de éxito
                                    );
                                    setState(() {
                                      followers++; // Aumenta el contador de seguidores
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(error
                                              .toString())), // Muestra un mensaje de error
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Email is null')), // Muestra un mensaje si el correo es nulo
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  // Propiedades que define la tarjeta draggable
  final String imageUrl; // URL de la imagen del usuario
  final String name; // Nombre del usuario
  final String membership; // Tipo de membresía del usuario
  final String nivel; // Nivel del usuario
  final int followers; // Cantidad de seguidores del usuario
  final int likes; // Cantidad de likes que tiene el usuario
  final int dislikes; // Cantidad de dislikes que tiene el usuario
  final Color likeColor; // Color del botón de like
  final Color dislikeColor; // Color del botón de dislike
  final Color followColor; // Color del botón de follow
  final VoidCallback? onLikePressed; // Callback para el evento de like
  final VoidCallback? onDislikePressed; // Callback para el evento de dislike
  final VoidCallback? onFollowPressed; // Callback para el evento de follow

  // Constructor de la clase, que recibe todas las propiedades como parámetros
  DraggableCard({
    required this.imageUrl,
    required this.name,
    required this.membership,
    required this.nivel,
    required this.followers,
    required this.likes,
    required this.dislikes,
    required this.likeColor,
    required this.dislikeColor,
    required this.followColor,
    this.onLikePressed,
    this.onDislikePressed,
    this.onFollowPressed,
  });

  // Lista de combinaciones de colores para los fondos de las tarjetas
  final List<List<Color>> colorCombinations = [
    [
      Color.fromARGB(255, 0, 54, 99).withOpacity(0.1), // Color superior
      Color.fromARGB(255, 0, 34, 61).withOpacity(0.8), // Color inferior
    ],
    [
      Color.fromARGB(255, 0, 113, 106).withOpacity(0.1),
      Color.fromARGB(255, 0, 61, 51).withOpacity(0.8),
    ],
    [
      Color.fromARGB(255, 250, 124, 104).withOpacity(0.1),
      Color.fromARGB(255, 54, 0, 0).withOpacity(0.8),
    ],
    [
      Color.fromARGB(255, 0, 201, 177).withOpacity(0.1),
      Color.fromARGB(255, 0, 54, 50).withOpacity(0.8),
    ],
  ];

  // Función que selecciona aleatoriamente una combinación de colores
  List<Color> getRandomColors() {
    final random = Random(); // Crea una instancia de Random
    return colorCombinations[random
        .nextInt(colorCombinations.length)]; // Selecciona un color aleatorio
  }

  @override
  Widget build(BuildContext context) {
    final randomColors =
        getRandomColors(); // Obtiene una combinación de colores aleatoria
    return Card(
      margin: EdgeInsets.all(20), // Margen alrededor de la tarjeta
      elevation: 15, // Elevación de la tarjeta para darle sombra
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // Bordes redondeados
      shadowColor: Colors.white.withOpacity(0.3), // Color de la sombra
      child: Container(
        height:
            MediaQuery.of(context).size.height * 0.5, // Altura de la tarjeta
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20), // Bordes redondeados para el contenido
          child: Stack(
            fit: StackFit.expand, // Expande el stack para llenar el contenedor
            children: [
              Image.network(imageUrl,
                  fit: BoxFit.contain), // Carga la imagen del usuario
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // Gradiente de fondo
                    colors:
                        randomColors, // Colores seleccionados aleatoriamente
                    begin: Alignment.topCenter, // Comienza en la parte superior
                    end: Alignment.bottomCenter, // Termina en la parte inferior
                    stops: const [0.7, 1], // Posiciones del gradiente
                  ),
                ),
                padding:
                    const EdgeInsets.all(16), // Padding interno del contenedor
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineación a la izquierda
                  children: [
                    const Spacer(), // Espacio flexible para empujar el contenido hacia arriba
                    Text(
                      name, // Muestra el nombre del usuario
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white), // Estilo del texto
                    ),
                    const SizedBox(
                        height: 8), // Espaciado entre el nombre y la membresía
                    Text(
                      membership, // Muestra la membresía del usuario
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white), // Estilo del texto
                    ),
                    Text(
                      nivel, // Muestra el nivel del usuario
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white), // Estilo del texto
                    ),
                    const SizedBox(
                        height: 16), // Espaciado entre los datos y los botones
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Espacia los botones uniformemente
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite,
                              color: likeColor, size: 46), // Botón de like
                          onPressed:
                              onLikePressed, // Acción cuando se presiona el botón de like
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down,
                              color: dislikeColor,
                              size: 46), // Botón de dislike
                          onPressed:
                              onDislikePressed, // Acción cuando se presiona el botón de dislike
                        ),
                        IconButton(
                          icon: Icon(Icons.people,
                              color: followColor, size: 46), // Botón de follow
                          onPressed:
                              onFollowPressed, // Acción cuando se presiona el botón de follow
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
