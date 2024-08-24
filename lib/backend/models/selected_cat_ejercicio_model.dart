class SelectedCatEjercicio {
  final int id;
  final String nombreEsp;
  final String nombreEng;

  SelectedCatEjercicio({
    required this.id,
    required this.nombreEsp,
    required this.nombreEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
    };
  }
}
