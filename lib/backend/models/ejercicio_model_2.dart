class Ejercicio2 {
  String nombre;
  String imageUrl;
  String video;
  String videoPTrain;
  String videoPObese;
  String videoPFlaca;
  String image3dUrl;

  Ejercicio2({
    required this.nombre,
    required this.imageUrl,
    required this.video,
    required this.videoPTrain,
    required this.videoPObese,
    required this.videoPFlaca,
    required this.image3dUrl,
  });

  factory Ejercicio2.fromMap(Map<String, dynamic> map) {
    return Ejercicio2(
      nombre: map['NombreEsp'] ?? '',
      imageUrl: map['URL de la Imagen'] ?? '',
      video: map['Video'] ?? '',
      videoPTrain: map['VideoPTrain'] ?? '',
      videoPObese: map['VideoPObese'] ?? '',
      videoPFlaca: map['VideoPFlaca'] ?? '',
      image3dUrl: map['URL de la Imagen 3D'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'NombreEsp': nombre,
      'URL de la Imagen': imageUrl,
      'Video': video,
      'VideoPTrain': videoPTrain,
      'VideoPObese': videoPObese,
      'VideoPFlaca': videoPFlaca,
      'URL de la Imagen 3D': image3dUrl,
    };
  }
}
