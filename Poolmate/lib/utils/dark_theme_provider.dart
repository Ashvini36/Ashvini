import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:poolmate/utils/dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  int _darkTheme = 0;

  int get darkTheme => _darkTheme;

  set darkTheme(int value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  bool getThem() {
    return darkTheme == 0
        ? true
        : darkTheme == 1
            ? false
            : false;
  }

  bool getSystemThem() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}
