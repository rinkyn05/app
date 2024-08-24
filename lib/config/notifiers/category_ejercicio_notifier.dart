import 'package:flutter/foundation.dart';


class CatEjercicioNotifier with ChangeNotifier {
  final List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get categories => _categories;

  void addCatEjercicio(Map<String, dynamic> newCategory) {
    _categories.add(newCategory);
    notifyListeners();
  }

}
