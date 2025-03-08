class Ejercicio {
  final String id;
  final String nombre;
  final String descripcion;
  final String imageUrl;
  final String image3dUrl;
  final String intensidad;
  final String calorias;
  final String duracion;
  final String estancia;
  final String contenidoEsp;
  final String contenidoEng;
  final String video;
  final String videoPTrain;
  final String videoPObese;
  final String videoPFlaca;
  final String agonistMuscle;
  final String antagonistMuscle;
  final String sinergistnistMuscle;
  final String estabiliMuscle;
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
    required this.image3dUrl,
    required this.intensidad,
    required this.calorias,
    required this.duracion,
    required this.estancia,
    required this.contenidoEsp,
    required this.contenidoEng,
    required this.video,
    required this.videoPTrain,
    required this.videoPObese,
    required this.videoPFlaca,
    required this.agonistMuscle,
    required this.antagonistMuscle,
    required this.sinergistnistMuscle,
    required this.estabiliMuscle,
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
      image3dUrl: data['URL de la Imagen'] ?? '',
      intensidad: data['Intensity$langCodeSuffix'] ?? '',
      calorias: data['Calorias'] ?? '',
      duracion: data['Duracion'] ?? '',
      estancia: data['Stance$langCodeSuffix'] ?? '',
      contenidoEsp: data['ContenidoEsp'] ?? '',
      contenidoEng: data['ContenidoEng'] ?? '',
      agonistMuscle: data['agonistMuscle'] ?? '',
      antagonistMuscle: data['antagonistMuscle'] ?? '',
      sinergistnistMuscle: data['sinergistnistMuscle'] ?? '',
      estabiliMuscle: data['estabiliMuscle'] ?? '',
      video: data['Video'] ?? '',
      videoPTrain: data['videoPTrain'] ?? '',
      videoPObese: data['videoPObese'] ?? '',
      videoPFlaca: data['videoPFlaca'] ?? '',
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
