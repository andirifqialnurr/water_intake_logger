import 'package:water_intake_logger/language/language_controller.dart';

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get _en => language == AppLanguage.eng;

  String get home => _en ? 'Home' : 'Beranda';
  String get progress => _en ? 'Progress' : 'Progres';
  String get history => _en ? 'History' : 'Riwayat';
  String get profile => _en ? 'Profile' : 'Profil';

  List<String> get tabTitles => [home, progress, history, profile];

  String get indLanguageLabel => _en ? 'Indonesian' : 'Bahasa Indonesia';
  String get engLanguageLabel => _en ? 'English' : 'Bahasa Inggris';
}

extension LanguageControllerStrings on LanguageController {
  AppStrings get strings => AppStrings(language);
}
