class SelectedUnequipment {
  final String id;
  final String unequipmentEsp;
  final String unequipmentEng;

  SelectedUnequipment({
    required this.id,
    required this.unequipmentEsp,
    required this.unequipmentEng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unequipmentEsp': unequipmentEsp,
      'unequipmentEng': unequipmentEng,
    };
  }
}
