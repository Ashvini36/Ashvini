import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/controller/edit_profile_controller.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:ebasket_driver/widgets/mobile_number_textfield.dart';
import 'package:ebasket_driver/widgets/round_button_fill.dart';
import 'package:ebasket_driver/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: EditProfileController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title:  Text("Edit Profile".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Form(
                  key: controller.formKey.value,
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            controller.profileImage.value.isEmpty
                                ? ClipOval(
                                    child: Container(
                                      width: Responsive.height(14, context),
                                      height: Responsive.height(14, context),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(Constant.placeHolder.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                                        border: Border.all(
                                          color: AppThemeData.groceryAppDarkBlue,
                                          width: 4.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : Constant().hasValidUrl(controller.profileImage.value) == false
                                    ? ClipOval(
                                        child: Container(
                                          width: Responsive.height(14, context),
                                          height: Responsive.height(14, context),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(File(controller.profileImage.value)),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                                            border: Border.all(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              width: 4.0,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ClipOval(
                                        child: Container(
                                          width: Responsive.height(14, context),
                                          height: Responsive.height(14, context),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                                            border: Border.all(
                                              color: AppThemeData.groceryAppDarkBlue,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: controller.profileImage.value.toString(),
                                              fit: BoxFit.cover,
                                              height: Responsive.width(14, context),
                                              width: Responsive.width(14, context),
                                              placeholder: (context, url) => Constant.loader(),
                                              errorWidget: (context, url, error) => Image.network(Constant.placeHolder, fit: BoxFit.fill),
                                            ),
                                          ),
                                        ),
                                      ),
                            Positioned(
                              right: 5,
                              child: InkWell(
                                onTap: () {
                                  buildBottomSheet(context, controller);
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/ic_edit_view.svg",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Responsive.height(65, context),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            TextFieldWidget(
                              controller: controller.fullNameController.value,
                              hintText: "Jonson Patel".tr,
                              title: "Enter Full Name *".tr,
                              textInputType: TextInputType.text,
                              validation: (value) {
                                String pattern = r'(^[a-zA-Z ]*$)';
                                RegExp regExp = RegExp(pattern);
                                if (value == null || value.isEmpty) {
                                  return 'Full Name is required';
                                }
                                // else if (!regExp.hasMatch(value)) {
                                //   return 'Wrong Full Name'.tr;
                                // }
                                return null;
                              },
                              prefix: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset("assets/icons/ic_user.svg", height: 22, width: 22),
                              ),
                            ),
                            MobileNumberTextField(
                              title: "Enter Mobile Number *".tr,
                              read: false,
                              controller: controller.mobileNumberController.value,
                              countryCodeController: controller.countryCode.value,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validation: (value) {
                                String pattern = r'(^\+?[0-9]*$)';
                                RegExp regExp = RegExp(pattern);
                                if (value!.isEmpty) {
                                  return 'Mobile is required'.tr;
                                } else if (!regExp.hasMatch(value)) {
                                  return 'Mobile Number must be digits'.tr;
                                } else if (value.length < 10 || value.length > 10) {
                                  return 'Wrong Mobile Number.'.tr;
                                }
                                return null;
                              },
                              onPress: () {},
                            ),
                            TextFieldWidget(
                              controller: controller.emailAddressController.value,
                              hintText: "yash_patel@gmail.com".tr,
                              title: "Enter Email Address".tr,
                              textInputType: TextInputType.emailAddress,
                              enable: false,
                              validation: (value) {
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = RegExp(pattern);
                                if (value!.isNotEmpty) {
                                  if (!regex.hasMatch(value ?? '')) {
                                    return 'Enter valid Email Address'.tr;
                                  } else {
                                    return null;
                                  }
                                }
                                return null;
                              },
                              prefix: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SvgPicture.asset("assets/icons/ic_email.svg", height: 22, width: 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RoundedButtonFill(
                        title: "Update".tr,
                        color: AppThemeData.groceryAppDarkBlue,
                        textColor: AppThemeData.white,
                        fontFamily: AppThemeData.bold,
                        onPress: () {
                          if (controller.formKey.value.currentState!.validate()) {
                            controller.updateProfile();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  buildBottomSheet(BuildContext context, EditProfileController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("Please Select".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "camera".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "gallery".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
