import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier with ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _currentLocale;

  LanguageNotifier._(this._currentLocale, this._prefs);

  static Future<LanguageNotifier> create(String defaultLanguageCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('languageCode');
    Locale locale;
    if (savedLanguage == null) {
      locale = Locale(defaultLanguageCode, '');
      await prefs.setString('languageCode', defaultLanguageCode);
    } else {
      locale = Locale(savedLanguage, '');
    }
    return LanguageNotifier._(locale, prefs);
  }

  Locale get currentLocale => _currentLocale;

  Future<void> changeLanguage(Locale newLocale) async {
    _currentLocale = newLocale;
    await _saveLanguage();
    notifyListeners();
  }

  void updateLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }

  Future<void> _saveLanguage() async {
    await _prefs.setString('languageCode', _currentLocale.languageCode);
  }
}
