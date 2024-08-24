import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String nombre;
  final String correoElectronico;
  final String rol;
  final String membership;
  final String imageUrl;

  UserModel({
    required this.nombre,
    required this.correoElectronico,
    required this.rol,
    required this.membership,
    this.imageUrl = '',
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      nombre: data['Nombre'] ?? '',
      correoElectronico: data['Correo Electrónico'] ?? '',
      rol: data['Rol'] ?? '',
      membership: data['Membership'] ?? '',
      imageUrl: data['ImageUrl'] ?? '',
    );
  }
}
