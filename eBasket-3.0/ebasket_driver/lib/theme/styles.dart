import 'package:flutter/material.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';


class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:AppThemeData.white,
      primaryColor: isDarkTheme ? AppThemeData.groceryAppDarkBlue : AppThemeData.groceryAppDarkBlue,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }
}
