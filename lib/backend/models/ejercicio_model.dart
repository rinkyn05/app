class Ejercicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String imageUrl;
  final String intensidad;
  final String calorias;
  final String duracion;
  final String estancia;
  final String contenidoEsp;
  final String contenidoEng;
  final String video;
  final String repeticiones;
  final String membershipEsp;
  final String membershipEng;
  final String intensityEsp;
  final String intensityEng;
  final String stanceEsp;
  final String stanceEng;
  final List<Map<String, dynamic>> bodyParts;
  final List<Map<String, dynamic>> objetivos;
  final List<Map<String, dynamic>> equipment;
  final List<Map<String, dynamic>> unequipment;
  final List<Map<String, dynamic>> catEjercicio;

  Ejercicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imageUrl,
    required this.intensidad,
    required this.calorias,
    required this.duracion,
    required this.estancia,
    required this.contenidoEsp,
    required this.contenidoEng,
    required this.video,
    required this.repeticiones,
    required this.membershipEsp,
    required this.membershipEng,
    required this.intensityEsp,
    required this.intensityEng,
    required this.stanceEsp,
    required this.stanceEng,
    required this.bodyParts,
    required this.objetivos,
    required this.equipment,
    required this.unequipment,
    required this.catEjercicio,
  });

  bool get isPremium =>
      membershipEsp == "Premium" || membershipEng == "Premium";

  factory Ejercicio.fromMap(
      Map<String, dynamic> data, String documentId, String languageCode) {
    final langCodeSuffix = languageCode == 'es' ? 'Esp' : 'Eng';

    List<Map<String, dynamic>> parseList(String key) =>
        List<Map<String, dynamic>>.from((data[key] as List? ?? []).map((e) {
          return {
            'id': e['id'] ?? '',
            'NombreEsp': e['NombreEsp'] ?? '',
            'NombreEng': e['NombreEng'] ?? '',
          };
        }));

    return Ejercicio(
      id: documentId,
      nombre: data['Nombre$langCodeSuffix'] ?? '',
      descripcion: data['Descripcion$langCodeSuffix'] ?? '',
      imageUrl: data['URL de la Imagen'] ?? '',
      intensidad: data['Intensity$langCodeSuffix'] ?? '',
      calorias: data['Calorias'] ?? '',
      duracion: data['Duracion'] ?? '',
      estancia: data['Stance$langCodeSuffix'] ?? '',
      contenidoEsp: data['ContenidoEsp'] ?? '',
      contenidoEng: data['ContenidoEng'] ?? '',
      video: data['Video'] ?? '',
      repeticiones: data['Repeticiones'] ?? '',
      membershipEsp: data['MembershipEsp'] ?? '',
      membershipEng: data['MembershipEng'] ?? '',
      intensityEsp: data['IntensityEsp'] ?? '',
      intensityEng: data['IntensityEng'] ?? '',
      stanceEsp: data['StanceEsp'] ?? '',
      stanceEng: data['StanceEng'] ?? '',
      bodyParts: parseList('BodyPart'),
      objetivos: parseList('Objetivos'),
      equipment: parseList('Equipment'),
      unequipment: parseList('Unequipment'),
      catEjercicio: parseList('CatEjercicio'),
    );
  }
}
