import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Function()? onPress;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onFieldSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? obscureText;
  final int? maxLine;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validation;

  const TextFieldWidget({
    super.key,
    this.textInputType,
    this.enable,
    this.prefix,
    this.suffix,
    this.title,
    required this.hintText,
    required this.controller,
    this.onPress,
    this.maxLine,
    this.inputFormatters,
    this.obscureText,
    this.onChanged,
    this.onFieldSubmitted,
    this.validation,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(title ?? '', style: const TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            maxLines: maxLine ?? 1,
            textInputAction: TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: obscureText ?? false,
            validator: validation,
            onChanged: onChanged,
            onFieldSubmitted:onFieldSubmitted,
            style: const TextStyle(
              fontSize: 16,
              color: AppThemeData.black,
              fontFamily: AppThemeData.medium,
            ),
            decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.red),
              isDense: true,
              filled: true,
              enabled: enable ?? true,
              fillColor: AppThemeData.colorLightWhite,
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: prefix != null ? 0 : 10),
              prefixIcon: prefix,
              suffixIcon: suffix,
              disabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
              focusedBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
              enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
              errorBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
              border:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
              hintText: hintText.tr,
              hintStyle: TextStyle(
                fontSize: 16,
                color: AppThemeData.black.withOpacity(0.50),
                fontWeight: FontWeight.w400,
                fontFamily: AppThemeData.regular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
