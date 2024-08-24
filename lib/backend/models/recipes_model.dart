class Recipes {
  final String id;
  final String nombre;
  final String imageUrl;
  final String intensidad;
  final String calorias;
  final String estancia;
  final String contenidoEsp;
  final String contenidoEng;
  final String video;
  final String membershipEsp;
  final String membershipEng;
  final String categoryEsp;
  final String categoryEng;

  Recipes({
    required this.id,
    required this.nombre,
    required this.imageUrl,
    required this.intensidad,
    required this.calorias,
    required this.estancia,
    required this.contenidoEsp,
    required this.contenidoEng,
    required this.video,
    required this.membershipEsp,
    required this.membershipEng,
    required this.categoryEsp,
    required this.categoryEng,
  });

  bool get isPremium =>
      membershipEsp == "Premium" || membershipEng == "Premium";

  factory Recipes.fromMap(
      Map<String, dynamic> data, String documentId, String languageCode) {
    final langCodeSuffix = languageCode == 'es' ? 'Esp' : 'Eng';

    return Recipes(
      id: documentId,
      nombre: data['Nombre$langCodeSuffix'] ?? '',
      imageUrl: data['URL de la Imagen'] ?? '',
      intensidad: data['Intensity$langCodeSuffix'] ?? '',
      calorias: data['Calorias'] ?? '',
      estancia: data['Stance$langCodeSuffix'] ?? '',
      contenidoEsp: data['ContenidoEsp'] ?? '',
      contenidoEng: data['ContenidoEng'] ?? '',
      video: data['Video'] ?? '',
      membershipEsp: data['MembershipEsp'] ?? '',
      membershipEng: data['MembershipEng'] ?? '',
      categoryEsp: data['CategoryEsp'] ?? '',
      categoryEng: data['CategoryEng'] ?? '',
    );
  }
}
