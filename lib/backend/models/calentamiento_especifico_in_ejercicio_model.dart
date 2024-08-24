class SelectedCalentamientoEspecifico {
  final String id;
  final String CalentamientoEspecificoEsp;
  final String CalentamientoEspecificoEng;

  SelectedCalentamientoEspecifico({
    required this.id,
    required this.CalentamientoEspecificoEsp,
    required this.CalentamientoEspecificoEng,
  });

  get calentamientoEspecificoEng => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'CalentamientoEspecificoEsp': CalentamientoEspecificoEsp,
      'CalentamientoEspecificoEng': CalentamientoEspecificoEng,
    };
  }
}
