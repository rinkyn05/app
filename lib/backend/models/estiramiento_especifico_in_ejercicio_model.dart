class SelectedEstiramientoEspecifico {
  final String id;
  final String EstiramientoEspecificoEsp;
  final String EstiramientoEspecificoEng;

  SelectedEstiramientoEspecifico({
    required this.id,
    required this.EstiramientoEspecificoEsp,
    required this.EstiramientoEspecificoEng,
  });

  get estiramientoEspecificoEng => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'EstiramientoEspecificoEsp': EstiramientoEspecificoEsp,
      'EstiramientoEspecificoEng': EstiramientoEspecificoEng,
    };
  }
}
