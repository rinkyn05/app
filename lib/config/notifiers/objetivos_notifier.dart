import 'package:flutter/foundation.dart'; // Importa la biblioteca de Flutter para usar ChangeNotifier.

class ObjetivoNotifier with ChangeNotifier {
  final List<Map<String, dynamic>> _categories =
      []; // Lista privada para almacenar las categorías de objetivos.

  // Getter para obtener la lista de categorías.
  List<Map<String, dynamic>> get categories => _categories;

  // Método para agregar un nuevo objetivo a la lista de categorías.
  void addObjetivo(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega la nueva categoría a la lista.
    notifyListeners(); // Notifica a los oyentes que ha habido un cambio en el estado.
  }
}
