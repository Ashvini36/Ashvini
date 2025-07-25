import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/material.dart';

class TextFieldThem {
  const TextFieldThem(Key? key);

  static buildTextField(
      {required String title,
      required TextEditingController controller,
      IconData? icon,
      required String? Function(String?) validators,
      TextInputType textInputType = TextInputType.text,
      bool obscureText = true,
      bool enabled = true,
      EdgeInsets contentPadding = EdgeInsets.zero,
      maxLine = 1,
      maxLength = 300,
      String? labelText}) {
    return TextFormField(
      obscureText: !obscureText,
      validator: validators,
      keyboardType: textInputType,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLine,
      maxLength: maxLength,
      enabled: enabled,
      textInputAction: TextInputAction.done,
      decoration:
          InputDecoration(counterText: "", labelText: labelText, hintText: title, contentPadding: contentPadding, suffixIcon: Icon(icon), border: const UnderlineInputBorder()),
    );
  }

  static boxBuildTextField({
    required String hintText,
    TextEditingController? controller,
    String? Function(String?)? validators,
    TextInputType textInputType = TextInputType.text,
    bool obscureText = true,
    EdgeInsets contentPadding = EdgeInsets.zero,
    maxLine = 1,
    bool enabled = true,
    maxLength = 300,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(color: ConstantColors.titleTextColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
            obscureText: !obscureText,
            validator: validators,
            keyboardType: textInputType,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            maxLines: maxLine,
            maxLength: maxLength,
            enabled: enabled,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: ConstantColors.titleTextColor),
            decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.all(8),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: ConstantColors.hintTextColor))),
      ],
    );
  }
}
