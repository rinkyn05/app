import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaEjercicio {
  final int id;
  final String nombreEsp;
  final String descripcionEsp;
  final String nombreEng;
  final String descripcionEng;
  final String imageUrl;
  final DateTime fecha;

  CategoriaEjercicio({
    required this.id,
    required this.nombreEsp,
    required this.descripcionEsp,
    required this.nombreEng,
    required this.descripcionEng,
    required this.imageUrl,
    required this.fecha,
  });

  factory CategoriaEjercicio.fromMap(
      Map<String, dynamic> data, String documentId) {
    return CategoriaEjercicio(
      id: int.parse(documentId),
      nombreEsp: data['NombreEsp'] ?? '',
      descripcionEsp: data['DescripcionEsp'] ?? '',
      nombreEng: data['NombreEng'] ?? '',
      descripcionEng: data['DescripcionEng'] ?? '',
      imageUrl: data['URL de la Imagen'] ?? '',
      fecha: (data['Fecha'] as Timestamp).toDate(),
    );
  }
}
