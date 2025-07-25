import 'package:store/themes/app_them_data.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.surfaceDark : AppThemeData.surface,
      primaryColor: isDarkTheme ? AppThemeData.secondary300 : AppThemeData.secondary300,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemeData.grey700 : AppThemeData.grey300,
        dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: isDarkTheme ? AppThemeData.grey800 : AppThemeData.grey800),
        dialTextColor: isDarkTheme ? AppThemeData.grey100 : AppThemeData.grey800,
        hourMinuteTextColor: isDarkTheme ? AppThemeData.grey100 : AppThemeData.grey800,
        dayPeriodTextColor: isDarkTheme ? AppThemeData.grey100 : AppThemeData.grey800,
      ),
    );
  }
}
