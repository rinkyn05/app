class Alimentos {
  final String id;
  final String nombre;
  final String imageUrl;
  final String intensidad;
  final String calorias;
  final String porcion;
  final String proteina;
  final String gsaturadas;
  final String gMonoinsaturadas;
  final String gPoliinsaturadas;
  final String gHidrogenadas;
  final String grasa;
  final String carbohidrato;
  final String vitamina;
  final String fibra;
  final String azucar;
  final String sodio;
  final String estancia;
  final String contenidoEsp;
  final String contenidoEng;
  final String video;
  final String membershipEsp;
  final String membershipEng;
  final String categoryEsp;
  final String categoryEng;
  final String tipoEsp;
  final String tipoEng;
  final String tipoGrasaEsp;
  final String tipoGrasaEng;

  Alimentos({
    required this.id,
    required this.nombre,
    required this.imageUrl,
    required this.intensidad,
    required this.calorias,
    required this.gsaturadas,
    required this.gMonoinsaturadas,
    required this.gPoliinsaturadas,
    required this.gHidrogenadas,
    required this.grasa,
    required this.porcion,
    required this.proteina,
    required this.carbohidrato,
    required this.vitamina,
    required this.fibra,
    required this.azucar,
    required this.sodio,
    required this.estancia,
    required this.contenidoEsp,
    required this.contenidoEng,
    required this.video,
    required this.membershipEsp,
    required this.membershipEng,
    required this.categoryEsp,
    required this.categoryEng,
    required this.tipoEsp,
    required this.tipoEng,
    required this.tipoGrasaEsp,
    required this.tipoGrasaEng,
  });

  bool get isPremium =>
      membershipEsp == "Premium" || membershipEng == "Premium";

  factory Alimentos.fromMap(
      Map<String, dynamic> data, String documentId, String languageCode) {
    final langCodeSuffix = languageCode == 'es' ? 'Esp' : 'Eng';

    return Alimentos(
      id: documentId,
      nombre: data['Nombre$langCodeSuffix'] ?? '',
      imageUrl: data['URL de la Imagen'] ?? '',
      intensidad: data['Intensity$langCodeSuffix'] ?? '',
      calorias: data['Calorias'] ?? '',
      gsaturadas: data['GrasaSaturadas'] ?? '',
      gMonoinsaturadas: data['GrasaMonoinsaturadas'] ?? '',
      gPoliinsaturadas: data['GrasaPoliinsaturadas'] ?? '',
      gHidrogenadas: data['GrasaHidrogenadas'] ?? '',
      grasa: data['Grasa'] ?? '',
      porcion: data['Porcion'] ?? '',
      proteina: data['Proteina'] ?? '',
      carbohidrato: data['Carbohidrato'] ?? '',
      vitamina: data['Vitamina'] ?? '',
      estancia: data['Stance$langCodeSuffix'] ?? '',
      fibra: data['Fibra'] ?? '',
      azucar: data['Azucar'] ?? '',
      sodio: data['Sodio'] ?? '',
      contenidoEsp: data['ContenidoEsp'] ?? '',
      contenidoEng: data['ContenidoEng'] ?? '',
      video: data['Video'] ?? '',
      membershipEsp: data['MembershipEsp'] ?? '',
      membershipEng: data['MembershipEng'] ?? '',
      categoryEsp: data['CategoryEsp'] ?? '',
      categoryEng: data['CategoryEng'] ?? '',
      tipoEsp: data['TipoEsp'] ?? '',
      tipoEng: data['TipoEng'] ?? '',
      tipoGrasaEsp: data['TipoGrasaEsp'] ?? '',
      tipoGrasaEng: data['TipoGrasaEng'] ?? '',
    );
  }
}
