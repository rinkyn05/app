import 'package:flutter/foundation.dart';

class BodyPartNotifier with ChangeNotifier {
  final List<Map<String, dynamic>> _categories = [];

  List<Map<String, dynamic>> get categories => _categories;

  void addBodyPart(Map<String, dynamic> newCategory) {
    _categories.add(newCategory);
    notifyListeners();
  }

}
