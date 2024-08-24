import 'package:flutter/foundation.dart';

class SelectedItemsNotifier extends ChangeNotifier {
  final Set<String> _selectedItems = {};

  Set<String> get selectedItems => _selectedItems;

  void addSelection(String item) {
    _selectedItems.add(item);
    notifyListeners();
  }

  void removeSelection(String item) {
    _selectedItems.remove(item);
    notifyListeners();
  }

  void toggleSelection(String item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }
}
