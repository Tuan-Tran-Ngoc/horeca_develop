import 'package:horeca_service/horeca_service.dart';

class LanguageSetting extends ChangeNotifier {
  static Locale _locale = const Locale('vi'); // defaultl

  static Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
