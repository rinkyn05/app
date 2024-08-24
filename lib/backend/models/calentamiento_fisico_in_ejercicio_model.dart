class SelectedCalentamientoFisico {
  final String id;
  final String calentamientoFisicoEsp;
  final String calentamientoFisicoEng;

  SelectedCalentamientoFisico({
    required this.id,
    required this.calentamientoFisicoEsp,
    required this.calentamientoFisicoEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calentamientoFisicoEsp': calentamientoFisicoEsp,
      'calentamientoFisicoEng': calentamientoFisicoEng,
    };
  }
}
