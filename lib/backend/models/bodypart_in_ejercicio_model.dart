class SelectedBodyPart {
  final String id;
  final String bodypartEsp;
  final String bodypartEng;

  SelectedBodyPart({
    required this.id,
    required this.bodypartEsp,
    required this.bodypartEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bodypartEsp': bodypartEsp,
      'bodypartEng': bodypartEng,
    };
  }
}
