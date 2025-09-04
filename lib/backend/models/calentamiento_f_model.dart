class Calentamiento {
  final String nombreEsp;
  final String nombreEng;
  final String video;

  Calentamiento({
    required this.nombreEsp,
    required this.nombreEng,
    required this.video,
  });

  factory Calentamiento.fromMap(Map<String, dynamic> map) {
    return Calentamiento(
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
