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

  // Home Page
  String get greetings => _en ? 'Good Morning, Aran' : 'Selamat Pagi, Aran';
  String get slogan => _en ? 'Stay Hydrated' : 'Tetap Terhidrasi';

  //button add waters
  String get button1 => _en ? 'Cup' : 'Cangkir';
  String get button2 => _en ? 'Bottle' : 'Botol';
  String get button3 => _en ? 'Glass' : 'Gelas';
  String get button4 => _en ? 'Thumbler' : 'Tumbler';
  String get customAddWater => _en ? 'Custom' : 'Manual';
  String get customAddWaterHint => _en
      ? 'Enter a custom amount'
      : 'Masukkan jumlah sendiri';
  String get customAmountLabel => _en ? 'Amount' : 'Jumlah';
  String get customAmountHint => _en ? 'Example: 350' : 'Contoh: 350';
  String get amountPositiveError => _en
      ? 'Enter a positive number'
      : 'Masukkan angka positif';
  String get add => _en ? 'Add' : 'Tambah';
  String get cancel => _en ? 'Cancel' : 'Batal';

  // ----------

  // Progress Page

  //summary card
  String get labelAvg => _en ? 'Weekly Average' : 'Rata-rata Pekanan';
  String get labelGoal => _en ? 'Goal Met' : 'Target Tercapai';
  String get liter => _en ? 'Liters' : 'Liter';

  String get lastWeek => _en ? 'last week' : 'pekan terakhir';
  String get streak => _en ? 'Streak' : 'Beruntun';
  String get day => _en ? 'Days' : 'Hari';

  //barchart
  String get labelChart => _en ? 'Weekly Intake' : 'Asupan Mingguan';
  String get monday => _en ? 'Mon' : 'Sen';
  String get tuesday => _en ? 'Tue' : 'Sel';
  String get wednesday => _en ? 'Wed' : 'Rab';
  String get thursday => _en ? 'Thu' : 'Kam';
  String get friday => _en ? 'Fri' : 'Jum';
  String get saturday => _en ? 'Sat' : 'Sab';
  String get sunday => _en ? 'Sun' : 'Min';

  // ----------

  // History Page
  String get dateCard => _en ? 'Today' : 'Hari ini';
  String get dailyGOalCard => _en ? 'Daily Goal' : 'Target Harian';
  String get achieve => _en ? 'Achieve' : 'Tercapai';
  String get notAchieve => _en ? 'Of Goal' : 'Dari Goal';

  // ----------

  // Profile Page
  String get lifeTime => _en ? 'Lifetime' : 'Total';

  //summary card
  String get labelWinCard => _en ? 'Current Winstreak' : 'Konsistensi Saat ini';
  String get labelSince => _en ? 'Since Last Sip' : 'Sejak Minum Terakhir';

  //mode theme section
  String get settingModeLabel => _en ? 'Setting' : 'Pengaturan';
  String get darkMode => _en ? 'Dark Mode' : 'Mode Gelap';
  String get lightMode => _en ? 'Light Mode' : 'Mode Terang';
}

extension LanguageControllerStrings on LanguageController {
  AppStrings get strings => AppStrings(language);
}
