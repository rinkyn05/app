class SelectedEstiramientoFisico {
  final String id;
  final String estiramientoFisicoEsp;
  final String estiramientoFisicoEng;

  SelectedEstiramientoFisico({
    required this.id,
    required this.estiramientoFisicoEsp,
    required this.estiramientoFisicoEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estiramientoFisicoEsp': estiramientoFisicoEsp,
      'estiramientoFisicoEng': estiramientoFisicoEsp,
    };
  }
}
