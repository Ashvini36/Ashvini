import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';

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

class SelectableTextCustom extends StatelessWidget {
  final int? maxLine;
  final String title;
  final double? fontSize;
  final Color? color;
  final bool islineThrough;
  final bool isUnderLine;
  final String? fontFamily;
  final TextAlign? textAlign;
  final double? letterSpacing;

  const SelectableTextCustom(
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
    return Theme(
      data: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.blue,
          )
      ),
      child: SelectableText(title,
          maxLines: maxLine,
          textAlign: textAlign,
          onSelectionChanged: (selection, cause) {
            print(selection);
            print(cause);
          },
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              letterSpacing: letterSpacing,
              fontSize: fontSize,
              color: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
              decorationColor: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
              decoration: islineThrough
                  ? TextDecoration.lineThrough
                  : isUnderLine
                      ? TextDecoration.underline
                      : null,
              fontFamily: fontFamily)),
    );
  }
}
