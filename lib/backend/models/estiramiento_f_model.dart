class Estiramiento {
  final String nombreEsp;
  final String nombreEng;
  final String video;

  Estiramiento({
    required this.nombreEsp,
    required this.nombreEng,
    required this.video,
  });

  factory Estiramiento.fromMap(Map<String, dynamic> map) {
    return Estiramiento(
      nombreEsp: map['NombreEsp'] ?? '',
      nombreEng: map['NombreEng'] ?? '',
      video: map['Video'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'Video': video,
    };
  }
}
