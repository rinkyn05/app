import 'package:flutter/foundation.dart'; // Importa la biblioteca para usar ChangeNotifier.

class EquipmentNotifier with ChangeNotifier {
  // Lista privada que almacena los equipos.
  final List<Map<String, dynamic>> _categories = [];

  // Getter que permite acceder a la lista de equipos desde fuera de la clase.
  List<Map<String, dynamic>> get categories => _categories;

  // Método para agregar un nuevo equipo.
  void addEquipment(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega el nuevo equipo a la lista.
    notifyListeners(); // Notifica a los oyentes (listeners) que se ha realizado un cambio.
  }
}
