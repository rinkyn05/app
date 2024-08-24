import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentEjercicio {
  final int id;
  final String nombreEsp;
  final String descripcionEsp;
  final String nombreEng;
  final String descripcionEng;
  final String imageUrl;
  final DateTime fecha;

  EquipmentEjercicio({
    required this.id,
    required this.nombreEsp,
    required this.descripcionEsp,
    required this.nombreEng,
    required this.descripcionEng,
    required this.imageUrl,
    required this.fecha,
  });

  factory EquipmentEjercicio.fromMap(
      Map<String, dynamic> data, String documentId) {
    return EquipmentEjercicio(
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
