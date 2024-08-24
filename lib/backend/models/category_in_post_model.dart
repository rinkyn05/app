class SelectedCategory {
  final String id;
  final String categoryEsp;
  final String categoryEng;

  SelectedCategory({
    required this.id,
    required this.categoryEsp,
    required this.categoryEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryEsp': categoryEsp,
      'categoryEng': categoryEng,
    };
  }
}
