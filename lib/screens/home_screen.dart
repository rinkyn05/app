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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String silhouetteImage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _nombre = '';

  @override
  void initState() {
    super.initState();
    silhouetteImage =
        'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';

    checkUserImage();
    loadUserInfo(_auth, _firestore, (userData) {
      setState(() {
        _nombre = userData['Nombre'] ?? 'Usuario';
      });
    });
  }

  Future<void> checkUserImage() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.email!;
      final usersRef = FirebaseFirestore.instance.collection('users');
      final querySnapshot =
          await usersRef.where('Correo Electrónico', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        final imageUrl = userData['image_home_url'];
        setState(() {
          silhouetteImage = imageUrl ?? '';
        });
      } else {
        setState(() {
          silhouetteImage =
              'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';
        });
      }
    } catch (e) {
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
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.adaptableBlueColor(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            '${AppLocalizations.of(context)!.translate('welcome')} $_nombre !!',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _changeSilhouetteImage,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1.0,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Image.network(
                      silhouetteImage,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  left: 70,
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _changeSilhouetteImage,
                      child: ElevatedButton.icon(
                        onPressed: _changeSilhouetteImage,
                        icon: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gdarkblue2,
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                        ),
                        label: Text(''),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          _buildObjectivesButton(context),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildObjectivesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyObjectives()),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.gdarkblue2,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      child: Text(
        AppLocalizations.of(context)!.translate("myOcjetives"),
      ),
    );
  }

  void _changeSilhouetteImage() async {
    await uploadHomeImage(updateSilhouetteImage, context);
  }

  void updateSilhouetteImage(String? newImage) {
    if (newImage != null && newImage.isNotEmpty) {
      setState(() {
        silhouetteImage = newImage;
      });
    } else {
      setState(() {
        silhouetteImage =
            'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/silueta.png?alt=media&token=de8c6c22-f947-4ddc-9050-8aefdd2abca6';
      });
    }
  }
}
