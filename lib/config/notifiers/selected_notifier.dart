import 'package:flutter/foundation.dart'; // Importa la biblioteca de Flutter para usar ChangeNotifier.

class SelectedItemsNotifier extends ChangeNotifier {
  final Set<String> _selectedItems =
      {}; // Conjunto privado para almacenar los elementos seleccionados.

  // Getter para acceder al conjunto de elementos seleccionados.
  Set<String> get selectedItems => _selectedItems;

  // Método para agregar un elemento a la selección.
  void addSelection(String item) {
    _selectedItems.add(
        item); // Agrega el elemento al conjunto de elementos seleccionados.
    notifyListeners(); // Notifica a los oyentes que ha habido un cambio en el estado.
  }

  // Método para eliminar un elemento de la selección.
  void removeSelection(String item) {
    _selectedItems.remove(
        item); // Elimina el elemento del conjunto de elementos seleccionados.
    notifyListeners(); // Notifica a los oyentes sobre el cambio.
  }

  // Método para alternar la selección de un elemento.
  void toggleSelection(String item) {
    if (_selectedItems.contains(item)) {
      _selectedItems
          .remove(item); // Si el elemento ya está seleccionado, lo elimina.
    } else {
      _selectedItems.add(item); // Si no está seleccionado, lo agrega.
    }
    notifyListeners(); // Notifica a los oyentes que ha habido un cambio en el estado.
  }
}
