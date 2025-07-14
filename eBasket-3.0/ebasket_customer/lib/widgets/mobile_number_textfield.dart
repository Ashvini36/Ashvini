import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:get/get.dart';

class MobileNumberTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextEditingController countryCodeController;
  final Function() onPress;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validation;
  final bool? read;

   const MobileNumberTextField({
    super.key,
    required this.controller,
    required this.countryCodeController,
    required this.onPress,
    required this.title,
    this.enabled,
    this.inputFormatters,
    this.validation,this.read
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            readOnly: read!,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            inputFormatters: inputFormatters,
            validator: validation,
            style: const TextStyle(
              fontSize: 16,
              color: AppThemeData.black,
              fontFamily: AppThemeData.medium,
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                errorStyle: const TextStyle(color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enabled ?? true,
                fillColor: AppThemeData.colorLightWhite,
                prefixIcon: CountryCodePicker(
                  onChanged: (value) {
                    countryCodeController.text = value.dialCode.toString();
                  },
                  initialSelection: countryCodeController.text,
                  comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                  flagDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                disabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
                focusedBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
                enabledBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
                errorBorder:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
                border:  OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppThemeData.groceryAppDarkBlue)),
                hintText: "Mobile Number".tr,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: AppThemeData.black.withOpacity(0.50),
                  fontWeight: FontWeight.w400,
                  fontFamily: AppThemeData.regular,
                )),
          ),
        ],
      ),
    );
  }
}
