import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final Color? fillColor;
  final Color? borderColor;
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final dynamic onChanged;
  final dynamic onSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? obscureText;
  final int? maxLine;
  final TextInputType? textInputType;
  final double bottom;
  final double top;
  final bool isReadOnly;
  final List<TextInputFormatter>? inputFormatters;
  final double radius;
  final TextAlign textAlign;

  const TextFieldWidget(
      {super.key,
      this.borderColor,
      this.fillColor,
      this.textInputType,
      this.enable,
      this.prefix,
      this.suffix,
      this.title,
      required this.hintText,
      required this.controller,
      this.maxLine,
      this.isReadOnly = false,
      this.inputFormatters,
      this.obscureText,
      this.top = 0,
      this.bottom = 16.0,
      this.radius = 8,
      this.onChanged,
      this.onSubmitted,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  title: title ?? '',
                  fontSize: 12,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          TextFormField(
            readOnly: isReadOnly,
            cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: textAlign,
            maxLines: maxLine ?? 1,
            textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
            decoration: InputDecoration(
                errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enable ?? true,
                fillColor: fillColor ?? (themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: prefix != null ? 0 : 20),
                prefixIcon: prefix,
                suffixIcon: suffix,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  borderSide: BorderSide(
                    color: borderColor ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  borderSide: BorderSide(
                    color: borderColor ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  borderSide: BorderSide(
                    color: borderColor ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  borderSide: BorderSide(
                    color: borderColor ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                  borderSide: BorderSide(
                    color: borderColor ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100),
                  ),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood300,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppThemeData.medium)),
          ),
        ],
      ),
    );
  }
}
