import 'package:flutter/material.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:provider/provider.dart';

class TextCustom extends StatelessWidget {
  final int? maxLine;
  final String title;
  final double? fontSize;
  final Color? color;
  final bool islineThrough;
  final bool isUnderLine;
  final String? fontFamily;
  final TextAlign? textAlign;
  final double? letterSpacing;

  const TextCustom(
      {super.key,
      this.isUnderLine = false,
      this.textAlign,
      required this.title,
      this.islineThrough = false,
      this.maxLine,
      this.fontSize = 14,
      this.fontFamily = AppThemeData.medium,
      this.letterSpacing = 0.6,
      this.color});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Text(title,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            color: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
            decorationColor: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
            decoration: islineThrough
                ? TextDecoration.lineThrough
                : isUnderLine
                    ? TextDecoration.underline
                    : null,
            fontFamily: fontFamily));
  }
}
