import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats/app/controller/settings_role_permissions_controller.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/delete_dialog_widget.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsRolePermissionController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextCustom(title: 'Role & Permissions', fontFamily: AppThemeData.bold, fontSize: 18),
                    RoundedButtonFill(
                        radius: 6,
                        width: 110,
                        height: 40,
                        icon: SvgPicture.asset('assets/icons/plus.svg', height: 20, width: 20, fit: BoxFit.cover, color: AppThemeData.pickledBluewood50),
                        title: "Add Role",
                        color: AppThemeData.crusta500,
                        fontSizes: 14,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () async {
                          showDialog(context: context, builder: (ctxt) => const AddRoleDialog());

                          // controller.addNewRole("Branch Manager");
                        }),
                  ],
                ),
                spaceH(height: 20),
                devider(context, height: 2),
                spaceH(),
                controller.isRoleLoading.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Constant.loader(context),
                        ],
                      )
                    : controller.roleList.isEmpty
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [TextCustom(title: 'No Role Found')],
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) =>
                                Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: devider(context, height: themeChange.getThem() ? 1 : 1.5)),
                            shrinkWrap: true,
                            itemCount: controller.roleList.length,
                            itemBuilder: (context, i) {
                              RoleModel model = controller.roleList[i];
                              return FutureBuilder<int>(
                                  future: controller.getRoleCountById(model.id!),
                                  builder: (context, AsyncSnapshot<int> as) {
                                    if (as.hasData) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextCustom(title: model.title.toString(), fontSize: 16),
                                              TextCustom(title: 'Members (${as.data})', fontFamily: AppThemeData.medium, fontSize: 12),
                                            ],
                                          ),
                                          spaceW(),
                                          Flexible(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 30,
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller.selectPermission(model);
                                                    },
                                                    child: ContainerBorderCustom(
                                                        radius: 5,
                                                        padding: const EdgeInsets.all(4),
                                                        color: AppThemeData.crusta500,
                                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                          Icon(Icons.key, color: AppThemeData.crusta500, size: 12),
                                                          spaceW(width: 5),
                                                          TextCustom(title: 'Permission', fontSize: 12, color: AppThemeData.crusta500)
                                                        ])),
                                                  ),
                                                ),
                                                spaceW(),
                                                Visibility(
                                                  visible: model.isEdit ?? false,
                                                  child: SizedBox(
                                                      width: 70,
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          controller.selectRole.value = model;
                                                          controller.roleController.value.text = model.title ?? '';
                                                          showDialog(context: context, builder: (ctxt) => AddRoleDialog(isEdit: true, model: model));
                                                        },
                                                        child: ContainerBorderCustom(
                                                            radius: 5,
                                                            padding: const EdgeInsets.all(4),
                                                            color: Colors.green,
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                              const Icon(Icons.edit_note, color: Colors.green, size: 12),
                                                              spaceW(width: 5),
                                                              const TextCustom(title: 'Edit', fontSize: 12, color: Colors.green)
                                                            ])),
                                                      )),
                                                ),
                                                spaceW(),
                                                Visibility(
                                                  visible: model.isEdit ?? false,
                                                  child: SizedBox(
                                                      width: 75,
                                                      height: 30,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (Constant.isDemo()) {
                                                            ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                          } else {
                                                            if (as.data != 0) {
                                                              showDialog(context: context, builder: (ctxt) => const RoleMemberAlertWidget());
                                                            } else {
                                                              showDialog(context: context, builder: (ctxt) => const DeleteAlertWidget()).then((value) async {
                                                                if (value) {
                                                                  controller.deleteRole(model, i);
                                                                }
                                                              });
                                                            }
                                                          }
                                                        },
                                                        child: ContainerBorderCustom(
                                                            radius: 5,
                                                            padding: const EdgeInsets.all(4),
                                                            color: Colors.red,
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                              const Icon(Icons.delete_outline_outlined, color: Colors.red, size: 12),
                                                              spaceW(width: 5),
                                                              const TextCustom(title: 'Delete', fontSize: 12, color: Colors.red)
                                                            ])),
                                                      )),
                                                )
                                              ]),
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  });
                            }),
              ],
            ),
          );
        });
  }
}

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return FittedBox(
      fit: BoxFit.fill,
      child: GetX(
          init: SettingsRolePermissionController(),
          builder: (controller) {
            return ContainerCustom(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextCustom(
                          title: 'Role & Permissions (${controller.selectRole.value.title})', fontFamily: AppThemeData.bold, fontSize: 18, color: AppThemeData.pickledBluewood400)
                    ],
                  ),
                  spaceH(),
                  DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.white),
                      // AppThemeData.pickledBluewood50),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: const TextCustom(title: 'PAGE'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                            child: const TextCustom(title: 'Create/Update'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                            child: const TextCustom(title: 'Delete'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                            child: const TextCustom(title: 'View'),
                          ),
                        )
                      ],
                      rows: controller.selectRole.value.permission!.map((e) {
                        return DataRow(
                          cells: [
                            DataCell(TextCustom(title: e.title ?? '')),
                            DataCell(
                              e.isEdit == false || e.title == "Sales Report"
                                  ? const SizedBox()
                                  : Checkbox(
                                      side: const BorderSide(color: AppThemeData.pickledBluewood200, width: 1.5),
                                      activeColor: AppThemeData.crusta500,
                                      checkColor: AppThemeData.white,
                                      value: e.isUpdate ?? false,
                                      onChanged: (v) {
                                        e.isUpdate = v;
                                        setState(() {});
                                      }),
                            ),
                            DataCell(
                              e.isEdit == false || e.title == "Sales Report"
                                  ? const SizedBox()
                                  : Checkbox(
                                      side: const BorderSide(color: AppThemeData.pickledBluewood200, width: 1.5),
                                      activeColor: AppThemeData.crusta500,
                                      checkColor: AppThemeData.white,
                                      value: e.isDelete ?? false,
                                      onChanged: (v) {
                                        e.isDelete = v;
                                        setState(() {});
                                      }),
                            ),
                            DataCell(
                              e.isEdit == false
                                  ? const SizedBox()
                                  : Checkbox(
                                      side: const BorderSide(color: AppThemeData.pickledBluewood200, width: 1.5),
                                      activeColor: AppThemeData.crusta500,
                                      checkColor: AppThemeData.white,
                                      value: e.isView ?? true,
                                      onChanged: (v) {
                                        e.isView = v;
                                        setState(() {});
                                      }),
                            ),
                          ],
                        );
                      }).toList()),
                  spaceH(height: 20),
                  Visibility(
                    visible: controller.selectRole.value.isEdit == true,
                    child: RoundedButtonFill(
                        width: 100,
                        radius: 8,
                        height: 45,
                        fontSizes: 14,
                        title: "Save",
                        icon: controller.isSaveLoading.value == true
                            ? Constant.loader(context, color: AppThemeData.white)
                            : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                        color: AppThemeData.crusta500,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () {
                          if (Constant.isDemo()) {
                            ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                          } else {
                            controller.editRole(controller.selectRole.value);
                          }
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AddRoleDialog extends StatelessWidget {
  final bool isEdit;
  final RoleModel? model;

  const AddRoleDialog({super.key, this.isEdit = false, this.model});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsRolePermissionController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Role', fontSize: 18),
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
                  TextFieldWidget(hintText: '', controller: controller.roleController.value, title: 'Name'),
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
              RoundedButtonFill(
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Save",
                  icon: controller.isAddRoleLoading.value == true
                      ? Constant.loader(context, color: AppThemeData.white)
                      : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () {
                    if (Constant.isDemo()) {
                      ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                    } else {
                      if (controller.roleController.value.text.isNotEmpty) {
                        RoleModel modelData;
                        if (isEdit) {
                          modelData = model!;
                          modelData.title = controller.roleController.value.text.trim();
                        } else {
                          modelData = RoleModel(
                              isActive: true,
                              isEdit: true,
                              position: controller.roleList.length,
                              title: controller.roleController.value.text.trim(),
                              permission: controller.setRoleList());
                        }
                        controller.addNewRole(modelData, isEdit: isEdit);
                      } else {
                        ShowToastDialog.showToast("Please Enter Valid Role Name");
                      }
                    }
                  }),
            ],
          );
        });
  }
}
