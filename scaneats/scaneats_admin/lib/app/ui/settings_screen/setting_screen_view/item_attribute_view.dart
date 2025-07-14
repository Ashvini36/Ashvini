import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/settting_item_attributes_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class ItemAttributeView extends StatelessWidget {
  const ItemAttributeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsItemAttributesController(),
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
                        title: "Add Item Attribute",
                        color: AppThemeData.crusta500,
                        fontSizes: 14,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () async {
                          controller.reset();
                          showDialog(context: context, builder: (ctxt) => const AddItemAttributeDialog());

                          // controller.addNewRole("Branch Manager");
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
                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.2,
                            child: const TextCustom(title: 'NAME'),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.14,
                            child: const TextCustom(title: 'STATUS'),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.2,
                            child: const TextCustom(title: 'ACTION'),
                          )),
                        ],
                        rows: controller.itemAttributeList
                            .map((e) => DataRow(cells: [
                                  DataCell(TextCustom(title: e.name ?? '')),
                                  DataCell(
                                    e.isActive == true
                                        ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                        : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                  ),
                                  DataCell(Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.nameController.value.text = e.name.toString();
                                          controller.status.value = e.isActive == true ? "Active" : "Inactive";
                                          showDialog(context: context, builder: (ctxt) => AddItemAttributeDialog(itemCategoryId: e.id.toString(), isEdit: true));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                        )),
                                    spaceW(),
                                    IconButton(
                                      onPressed: () {
                                        controller.nameController.value.text = e.name.toString();
                                        controller.status.value = e.isActive == true ? "Active" : "Inactive";
                                        showDialog(context: context, builder: (ctxt) => AddItemAttributeDialog(itemCategoryId: e.id.toString(), isReadOnly: true));
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
                                            controller.deleteByItemAttributeId(e.id.toString());
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_outlined,
                                          size: 20,
                                        )),
                                  ])),
                                ]))
                            .toList()),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class AddItemAttributeDialog extends StatelessWidget {
  final bool isEdit;
  final bool isReadOnly;
  final String? itemCategoryId;
  const AddItemAttributeDialog({super.key, this.isEdit = false, this.isReadOnly = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsItemAttributesController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Item Attributes', fontSize: 18),
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
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: TextFieldWidget(hintText: '', controller: controller.nameController.value, title: 'Name')),
                    spaceW(width: 20),
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
                            })),
                  ]),
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
                    icon: controller.isaddItemLoading.value == true
                        ? Constant.loader(context, color: AppThemeData.white)
                        : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                    color: AppThemeData.crusta500,
                    textColor: AppThemeData.white,
                    isRight: false,
                    onPress: () {
                      if (Constant.isDemo()) {
                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                      } else {
                        if (controller.nameController.value.text != '') {
                          controller.addItemAttributesData(itemCategoryId: itemCategoryId ?? '', isEdit: isEdit);
                        } else {
                          ShowToastDialog.showToast("It is necessary to fill out every field in its entirety without exception..");
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}
