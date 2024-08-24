class SelectedEquipment {
  final String id;
  final String equipmentEsp;
  final String equipmentEng;

  SelectedEquipment({
    required this.id,
    required this.equipmentEsp,
    required this.equipmentEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipmentEsp': equipmentEsp,
      'equipmentEng': equipmentEng,
    };
  }
}
