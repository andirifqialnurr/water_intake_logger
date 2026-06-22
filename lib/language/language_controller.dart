import 'package:flutter/material.dart';

enum AppLanguage { ind, eng }

class LanguageController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ind;

  AppLanguage get language => _language;

  bool get isEnglish => _language == AppLanguage.eng;

  String get languageCode => isEnglish ? 'ENG' : 'IND';

  String get flag => isEnglish ? '\u{1F1EC}\u{1F1E7}' : '\u{1F1EE}\u{1F1E9}';

  void setLanguage(AppLanguage language) {
    if (_language == language) return;

    _language = language;
    notifyListeners();
  }
}
