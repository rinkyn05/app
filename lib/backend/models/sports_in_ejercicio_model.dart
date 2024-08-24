class SelectedSports {
  final String id;
  final String sportsEsp;
  final String sportsEng;

  SelectedSports({
    required this.id,
    required this.sportsEsp,
    required this.sportsEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sportsEsp': sportsEsp,
      'sportsEng': sportsEng,
    };
  }
}
