class SelectedObjetivos {
  final String id;
  final String objetivosEsp;
  final String objetivosEng;

  SelectedObjetivos({
    required this.id,
    required this.objetivosEsp,
    required this.objetivosEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'objetivosEsp': objetivosEsp,
      'objetivosEng': objetivosEng,
    };
  }
}
