import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/setting_them_controller.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/network_image_widget.dart';
import 'package:scaneats_owner/widgets/pickup_image_widget.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

class ThemView extends StatelessWidget {
  const ThemView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsThemController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(
                          title: 'Logo',
                          fontSize: 12,
                          fontFamily: AppThemeData.bold,
                        ),
                        spaceH(height: 20),
                        InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                              if (value != null) {
                                XFile stringFile = value;
                                controller.logoImage.value = stringFile.path;
                                controller.logoImageUin8List.value = await stringFile.readAsBytes();
                              }
                            });
                          },
                          child: controller.logoImage.isEmpty
                              ? SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: DottedBorder(
                                    radius: const Radius.circular(12),
                                    strokeWidth: 2,
                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                    padding: const EdgeInsets.all(6),
                                    child: const Center(child: Icon(Icons.add)),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Constant().hasValidUrl(controller.logoImage.value) == false
                                      ? kIsWeb
                                          ? controller.logoImageUin8List.value.isEmpty
                                              ? Constant.loader(context)
                                              : Image.memory(
                                                  controller.logoImageUin8List.value,
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              File(controller.logoImage.value),
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            )
                                      : NetworkImageWidget(
                                          imageUrl: controller.logoImage.value.toString(),
                                          fit: BoxFit.cover,
                                          height: 90,
                                          width: 90,
                                        ),
                                ),
                        ),
                      ],
                    ),
                    spaceW(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(
                          title: 'Fav Icon',
                          fontSize: 12,
                          fontFamily: AppThemeData.bold,
                        ),
                        spaceH(height: 20),
                        InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                              if (value != null) {
                                XFile stringFile = value;
                                controller.favImage.value = stringFile.path;
                                controller.favImageUin8List.value = await stringFile.readAsBytes();
                              }
                            });
                          },
                          child: controller.favImage.isEmpty
                              ? SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: DottedBorder(
                                    radius: const Radius.circular(12),
                                    strokeWidth: 2,
                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                    padding: const EdgeInsets.all(6),
                                    child: const Center(child: Icon(Icons.add)),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Constant().hasValidUrl(controller.favImage.value) == false
                                      ? kIsWeb
                                          ? controller.favImageUin8List.value.isEmpty
                                              ? Constant.loader(context)
                                              : Image.memory(
                                                  controller.favImageUin8List.value,
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                )
                                          : Image.file(
                                              File(controller.favImage.value),
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            )
                                      : NetworkImageWidget(
                                          imageUrl: controller.favImage.value.toString(),
                                          fit: BoxFit.cover,
                                          height: 90,
                                          width: 90,
                                        ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                spaceH(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        hintText: '',
                        controller: controller.nameController.value,
                        title: 'Name',
                      ),
                    ),
                    spaceW(width: 20),
                    Expanded(
                      child: TextFieldWidget(
                        hintText: '',
                        controller: controller.colourCodeController.value,
                        title: 'Colour',
                        prefix: InkWell(
                          onTap: () async {
                            Color newColor = await showColorPickerDialog(
                              // The dialog needs a context, we pass it in.
                              context,
                              // We use the dialogSelectColor, as its starting color.
                              controller.selectedColor.value,
                              width: 40,
                              height: 40,
                              spacing: 0,
                              runSpacing: 0,
                              borderRadius: 0,
                              enableOpacity: true,
                              showColorCode: true,
                              colorCodeHasColor: true,
                              enableShadesSelection: false,
                              pickersEnabled: <ColorPickerType, bool>{
                                ColorPickerType.wheel: true,
                              },
                              copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                copyButton: true,
                                pasteButton: false,
                                longPressMenu: false,
                              ),
                              actionButtons: const ColorPickerActionButtons(
                                okButton: true,
                                closeButton: true,
                                dialogActionButtons: false,
                              ),
                            );
                            print("======>");
                            controller.colourCodeController.value.text = "#${newColor.hex}";
                            controller.selectedColor.value = newColor;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              child: SizedBox(
                                width: 80,
                                child: Container(
                                  color: controller.selectedColor.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const TextCustom(
                  title: 'Note : Refreshing the page is necessary for the color changes to take effect.',
                  fontSize: 12,
                  fontFamily: AppThemeData.bold,
                  color: AppThemeData.crusta900,
                ),
                spaceH(height: 20),
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
                      controller.addCompanyData();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
