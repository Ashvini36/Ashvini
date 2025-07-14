import 'package:flutter/material.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        primary: isDarkTheme ? AppThemeData.black : AppThemeData.white,
        onPrimary: isDarkTheme ? AppThemeData.black : AppThemeData.white,
        secondary: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        onSecondary: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        error: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        onError: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        background: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        onBackground: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        surface: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
        onSurface: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
      ),
      hintColor: AppThemeData.pickledBluewood950,
      iconTheme: IconThemeData(color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
      appBarTheme:
          AppBarTheme(backgroundColor: isDarkTheme ? AppThemeData.black : AppThemeData.white, centerTitle: true, iconTheme: IconThemeData(color: AppThemeData.crusta500)),
    );
  }
}
