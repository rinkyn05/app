import 'package:flutter/foundation.dart'; // Importa la biblioteca para usar ChangeNotifier.

class CategoryNotifier with ChangeNotifier {
  // Lista privada que almacena las categorías.
  final List<Map<String, dynamic>> _categories = [];

  // Getter que permite acceder a la lista de categorías desde fuera de la clase.
  List<Map<String, dynamic>> get categories => _categories;

  // Método para agregar una nueva categoría.
  void addCategory(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega la nueva categoría a la lista.
    notifyListeners(); // Notifica a los oyentes (listeners) que se ha realizado un cambio.
  }
}
