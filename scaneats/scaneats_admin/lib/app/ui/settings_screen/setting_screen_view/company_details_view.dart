import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/settting_company_details_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:scaneats/widgets/text_widget.dart';

class CompanyDetailsView extends StatelessWidget {
  const CompanyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsDetailsController(),
        builder: (controller) {
          return ContainerCustom(
            child: controller.isLoading.value
                ? Constant.loader(context)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.nameController.value, title: 'Name')),
                          spaceW(width: 20),
                          Expanded(
                            child: TextFieldWidget(hintText: '', controller: controller.emailController.value, title: 'Email'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFieldWidget(
                            hintText: '',
                            controller: controller.phoneController.value,
                            title: 'PHONE',
                            textInputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          )),
                          spaceW(width: 20),
                          Expanded(
                            child: TextFieldWidget(hintText: '', controller: controller.websiteController.value, title: 'WEBSITE',enable: false,),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TextFieldWidget(hintText: '', controller: controller.cityController.value, title: 'City')),
                          spaceW(width: 20),
                          Expanded(
                            child: TextFieldWidget(hintText: '', controller: controller.stateController.value, title: 'State'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const TextCustom(
                                  title: "Country",
                                  fontSize: 12,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: CountryCodePicker(
                                      initialSelection: controller.codeController.value.text,
                                      showCountryOnly: false,
                                      showOnlyCountryWhenClosed: true,
                                      onChanged: (value) {
                                        controller.codeController.value.text = value.code.toString();
                                      },
                                      alignLeft: true,
                                      dialogTextStyle: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppThemeData.medium),
                                      dialogBackgroundColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                                      backgroundColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                                      dialogSize: const Size(500, 500),
                                      comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                      flagDecoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                      ),
                                      textStyle: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppThemeData.medium),
                                      searchDecoration: InputDecoration(
                                          errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                          isDense: true,
                                          filled: true,
                                          enabled: true,
                                          fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                            ),
                                          ),
                                          hintText: "Search",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood300,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppThemeData.medium)),
                                      searchStyle: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppThemeData.medium),
                                      boxDecoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          spaceW(width: 20),
                          Expanded(
                            child: TextFieldWidget(
                              hintText: '',
                              controller: controller.zipCodeController.value,
                              title: 'Zip Code',
                              textInputType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ],
                      ),
                      TextFieldWidget(hintText: '', controller: controller.addressController.value, title: 'Address', maxLine: 8),
                      RoundedButtonFill(
                        width: 100,
                        radius: 8,
                        height: 40,
                        fontSizes: 14,
                        title: "Save",
                        icon: controller.isAddItemLoading.value == true
                            ? Constant.loader(context, color: AppThemeData.white)
                            : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                        color: AppThemeData.crusta500,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () {
                          if (Constant.isDemo()) {
                            ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                          } else {
                            if (!Constant.isEmailValid(controller.emailController.value.text)) {
                              ShowToastDialog.showToast("Please enter valid email");
                            } else {
                              controller.addCompanyData();
                            }
                          }
                        },
                      ),
                    ],
                  ),
          );
        });
  }
}
