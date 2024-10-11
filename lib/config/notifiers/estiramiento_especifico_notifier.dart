import 'package:flutter/foundation.dart'; // Importa la biblioteca para usar ChangeNotifier.

class EstiramientoEspecificoNotifier with ChangeNotifier {
  // Lista privada que almacena los estiramientos específicos.
  final List<Map<String, dynamic>> _categories = [];

  // Getter que permite acceder a la lista de estiramientos desde fuera de la clase.
  List<Map<String, dynamic>> get categories => _categories;

  // Método para agregar un nuevo estiramiento específico.
  void addEstiramientoEspecifico(Map<String, dynamic> newCategory) {
    _categories.add(newCategory); // Agrega el nuevo estiramiento a la lista.
    notifyListeners(); // Notifica a los oyentes (listeners) que se ha realizado un cambio.
  }
}
