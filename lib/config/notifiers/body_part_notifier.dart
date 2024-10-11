import 'package:flutter/foundation.dart'; // Importa la biblioteca para usar ChangeNotifier.

class BodyPartNotifier with ChangeNotifier {
  // Lista privada que almacena las categorías de partes del cuerpo.
  final List<Map<String, dynamic>> _categories = [];

  // Getter que permite acceder a la lista de categorías desde fuera de la clase.
  List<Map<String, dynamic>> get categories => _categories;

  // Método para agregar una nueva categoría de parte del cuerpo.
  void addBodyPart(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega la nueva categoría a la lista.
    notifyListeners(); // Notifica a los oyentes (listeners) que se ha realizado un cambio.
  }
}
