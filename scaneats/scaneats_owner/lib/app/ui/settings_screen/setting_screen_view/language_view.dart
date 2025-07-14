import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats_owner/app/controller/settting_language_controller.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/network_image_widget.dart';
import 'package:scaneats_owner/widgets/pickup_image_widget.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsLanguageController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(title: controller.title.value, fontFamily: AppThemeData.bold, fontSize: 18),
                    RoundedButtonFill(
                        radius: 6,
                        width: 170,
                        height: 40,
                        icon: SvgPicture.asset('assets/icons/plus.svg', height: 20, width: 20, fit: BoxFit.cover, color: AppThemeData.pickledBluewood50),
                        title: "Add Language",
                        color: AppThemeData.crusta500,
                        fontSizes: 14,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () async {
                          controller.reset();
                          showDialog(context: context, builder: (ctxt) => const AddLanguageDialog());
                        }),
                  ],
                ),
                spaceH(height: 20),
                devider(context, height: 2),
                spaceH(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    child: DataTable(
                        horizontalMargin: 20,
                        columnSpacing: 30,
                        dataRowMaxHeight: 70,
                        border: TableBorder.all(
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.1,
                              child: const TextCustom(title: 'NAME'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 130 : MediaQuery.of(context).size.width * 0.15,
                              child: const TextCustom(title: 'LANGUAGE CODE'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.04,
                              child: const TextCustom(title: 'STATUS'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.15,
                              child: const TextCustom(title: 'ACTION'),
                            ),
                          ),
                        ],
                        rows: controller.languageList
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(TextCustom(title: e.name ?? '')),
                                  DataCell(TextCustom(title: e.code ?? '')),
                                  DataCell(
                                    e.isActive == true
                                        ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                        : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.setEditValue(e);
                                              showDialog(
                                                context: context,
                                                builder: (ctxt) => AddLanguageDialog(
                                                  itemCategoryId: e.id.toString(),
                                                  isEdit: true,
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            )),
                                        spaceW(),
                                        IconButton(
                                          onPressed: () {
                                            controller.setEditValue(e);
                                            showDialog(
                                              context: context,
                                              builder: (ctxt) => AddLanguageDialog(
                                                itemCategoryId: e.id.toString(),
                                                isReadOnly: true,
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 20,
                                          ),
                                        ),
                                        spaceW(),
                                        IconButton(
                                            onPressed: () {
                                              if (Constant.isDemo()) {
                                                ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                              } else {
                                                controller.deleteByItemAttributeId(e);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline_outlined,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class AddLanguageDialog extends StatelessWidget {
  final bool isEdit;
  final bool isReadOnly;
  final String? itemCategoryId;

  const AddLanguageDialog({super.key, this.isEdit = false, this.isReadOnly = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsLanguageController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: TextCustom(title: controller.title.value, fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.nameTextFiledController.value, title: 'Name')),
                      spaceW(width: 20),
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.codeTextFiledController.value, title: 'Language Code')),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                            if (value != null) {
                              XFile stringFile = value;
                              controller.image.value = stringFile.path;
                              controller.profileImageUin8List.value = await stringFile.readAsBytes();
                            }
                          });
                        },
                        child: controller.image.isEmpty
                            ? SizedBox(
                                height: 90,
                                width: 90,
                                child: DottedBorder(
                                  radius: const Radius.circular(12),
                                  strokeWidth: 2,
                                  padding: const EdgeInsets.all(6),
                                  child: const Center(child: Icon(Icons.add)),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Constant().hasValidUrl(controller.image.value) == false
                                    ? kIsWeb
                                        ? controller.profileImageUin8List.value.isEmpty
                                            ? Constant.loader(context)
                                            : Image.memory(
                                                controller.profileImageUin8List.value,
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.cover,
                                              )
                                        : Image.file(
                                            File(controller.image.value),
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                          )
                                    : NetworkImageWidget(
                                        imageUrl: controller.image.value.toString(),
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 90,
                                      ),
                              ),
                      ),
                      spaceW(width: 40),
                      Expanded(
                        flex: 1,
                        child: customRadioButton(context,
                            parameter: controller.status.value,
                            title: 'STATUS',
                            radioOne: "Active",
                            onChangeOne: () {
                              controller.status.value = "Active";
                              controller.update();
                            },
                            radioTwo: "Inactive",
                            onChangeTwo: () {
                              controller.status.value = "Inactive";
                              controller.update();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RoundedButtonFill(
                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Close",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    Get.back();
                  }),
              Visibility(
                visible: !isReadOnly,
                child: RoundedButtonFill(
                    width: 80,
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
                        if (controller.nameTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter language name.");
                        } else if (controller.codeTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter language code.");
                        } else if (controller.image.isEmpty) {
                          ShowToastDialog.showToast("Please select image");
                        } else {
                          controller.addBranchesData(itemCategoryId: itemCategoryId ?? '', isEdit: isEdit);
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}
