import 'package:flutter/foundation.dart'; // Importa la biblioteca de Flutter para la gestión de cambios.

class UnequipmentNotifier with ChangeNotifier {
  final List<Map<String, dynamic>> _categories =
      []; // Lista privada para almacenar categorías de equipos no utilizados.

  // Getter que devuelve la lista de categorías.
  List<Map<String, dynamic>> get categories => _categories;

  // Método que añade una nueva categoría de equipo no utilizado a la lista.
  void addUnequipment(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega la nueva categoría a la lista.
    notifyListeners(); // Notifica a los oyentes que ha habido un cambio en la lista de categorías.
  }
}
