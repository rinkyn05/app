import 'package:flutter/material.dart';
import 'package:app/widgets/custom_drawer.dart';
import '../config/utils/appcolors.dart';
import '../../../config/lang/app_localization.dart';
import '../functions/load_user_info.dart';
import '../functions/upload_home_image.dart';
import 'my_objectives/my_objectives.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Clave Global para el Scaffold, permite controlar el Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // URL de la imagen de silueta por defecto
  late String silhouetteImage = '';

  // Instancias de FirebaseAuth y FirebaseFirestore para autenticar y acceder a Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variable para almacenar el nombre del usuario
  String _nombre = '';

  @override
  void initState() {
    super.initState();

    // Inicializa la URL de la imagen de silueta por defecto
    silhouetteImage =
        'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';

    // Verifica la imagen del usuario y carga la información del usuario
    checkUserImage();
    loadUserInfo(_auth, _firestore, (userData) {
      // Actualiza el nombre del usuario basado en la información cargada
      setState(() {
        _nombre = userData['Nombre'] ?? 'Usuario';
      });
    });
  }

  // Método para verificar la imagen del usuario en Firestore
  Future<void> checkUserImage() async {
    try {
      // Obtiene el ID del usuario basado en su correo electrónico
      String userId = FirebaseAuth.instance.currentUser!.email!;
      final usersRef = FirebaseFirestore.instance.collection('users');

      // Busca la información del usuario en Firestore
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si se encuentra al usuario, obtiene su URL de imagen
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        final imageUrl = userData['image_home_url'];

        setState(() {
          // Actualiza la imagen de silueta si se encuentra una URL
          silhouetteImage = imageUrl ?? '';
        });
      } else {
        // Si no se encuentra al usuario, se establece la imagen por defecto
        setState(() {
          silhouetteImage =
              'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';
        });
      }
    } catch (e) {
      // Maneja errores durante la verificación de la imagen
      print('Error en la verificación de la imagen del usuario: $e');
      setState(() {
        silhouetteImage =
            'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asocia la clave global con el Scaffold
      drawer: const CustomDrawer(), // Agrega el menú lateral
      backgroundColor:
          AppColors.adaptableBlueColor(context), // Establece el color de fondo
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Espaciado superior
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Texto de bienvenida con el nombre del usuario
          Text(
            '${AppLocalizations.of(context)!.translate('welcome')} $_nombre !!',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Contenedor que muestra la imagen de silueta
                GestureDetector(
                  onTap:
                      _changeSilhouetteImage, // Detecta toques para cambiar la imagen
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Image.network(
                      silhouetteImage, // Muestra la imagen desde la URL
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // Muestra la imagen por defecto si ocurre un error
                        return Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                // Botón para cambiar la imagen de silueta
                Positioned.fill(
                  bottom: 0,
                  left: 70,
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap:
                          _changeSilhouetteImage, // Cambia la imagen al tocar
                      child: ElevatedButton.icon(
                        onPressed:
                            _changeSilhouetteImage, // Cambia la imagen al presionar
                        icon: Icon(
                          Icons.add, // Ícono de agregar
                          size: 40,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .gdarkblue2, // Establece el color de fondo
                          padding: EdgeInsets.all(16.0), // Espaciado interno
                          shape: CircleBorder(), // Forma circular
                        ),
                        label: Text(''), // Etiqueta vacía
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Botón para ir a la pantalla de objetivos
          _buildObjectivesButton(context),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // Método para construir el botón de objetivos
  Widget _buildObjectivesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navega a la pantalla de objetivos al presionar el botón
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyObjectives()),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Esquinas redondeadas
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.gdarkblue2, // Color de fondo
        padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 4.0), // Espaciado interno
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Text(
        AppLocalizations.of(context)!
            .translate("myOcjetives"), // Texto del botón
      ),
    );
  }

  // Método para cambiar la imagen de silueta
  void _changeSilhouetteImage() async {
    await uploadHomeImage(updateSilhouetteImage,
        context); // Llama a la función para subir la imagen
  }

  // Actualiza la imagen de silueta con la nueva URL
  void updateSilhouetteImage(String? newImage) {
    if (newImage != null && newImage.isNotEmpty) {
      setState(() {
        silhouetteImage =
            newImage; // Actualiza la imagen si se proporciona una nueva
      });
    } else {
      setState(() {
        // Establece la imagen por defecto si no hay nueva URL
        silhouetteImage =
            'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';
      });
    }
  }
}
