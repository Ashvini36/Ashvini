import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/settting_branches_controller.dart';
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
import 'package:url_launcher/url_launcher.dart';

class BranchesView extends StatelessWidget {
  const BranchesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsBranchesController(),
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
                        width: 160,
                        height: 40,
                        icon: SvgPicture.asset('assets/icons/plus.svg', height: 20, width: 20, fit: BoxFit.cover, color: AppThemeData.pickledBluewood50),
                        title: "Add a Branch",
                        color: AppThemeData.crusta500,
                        fontSizes: 14,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () async {
                          if (int.parse(Constant.restaurantModel.subscription!.noOfBranch.toString()) > controller.branchList.length) {
                            controller.reset();
                            showDialog(context: context, builder: (ctxt) => const AddBranchesDialog());
                          } else {
                            ShowToastDialog.showToast("Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                          }
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
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.1,
                              child: const TextCustom(title: 'NAME'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.15,
                              child: const TextCustom(title: 'Email'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.12,
                              child: const TextCustom(title: 'Phone'),
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
                        rows: controller.branchList
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(TextCustom(title: e.name ?? '')),
                                  DataCell(TextCustom(title: e.email ?? '')),
                                  DataCell(TextCustom(title: e.phoneNumber ?? '')),
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
                                                  builder: (ctxt) => AddBranchesDialog(
                                                        itemCategoryId: e.id.toString(),
                                                        isEdit: true,
                                                      ));
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
                                                builder: (ctxt) => AddBranchesDialog(
                                                      itemCategoryId: e.id.toString(),
                                                      isReadOnly: true,
                                                    ));
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

class AddBranchesDialog extends StatelessWidget {
  final bool isEdit;
  final bool isReadOnly;
  final String? itemCategoryId;

  const AddBranchesDialog({super.key, this.isEdit = false, this.isReadOnly = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsBranchesController(),
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
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  TextFieldWidget(hintText: '', controller: controller.latitudeTextFiledController.value, textInputType: TextInputType.number, title: 'Latitude'),
                            ),
                            spaceW(width: 5),
                            Expanded(
                              child: TextFieldWidget(
                                  hintText: '', controller: controller.longLatitudeTextFiledController.value, textInputType: TextInputType.number, title: 'Longitude'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH(),
                  RichText(
                    text: TextSpan(
                      text: 'Don\'t Know your cordinates ? use ',
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Latitude and Longitude Finder!',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppThemeData.crusta500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final Uri url = Uri.parse('https://www.latlong.net/');
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch }');
                                }
                              }),
                      ],
                    ),
                  ),
                  spaceH(),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.emailTextFiledController.value, title: 'Email')),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.phoneTextFiledController.value,
                          title: 'Phone Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.cityTextFiledController.value, title: 'City')),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(hintText: '', controller: controller.stateTextFiledController.value, title: 'State'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.zipCodeTextFiledController.value, title: 'Zip Code')),
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
                            }),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TextFieldWidget(
                        hintText: '',
                        controller: controller.addressCodeTextFiledController.value,
                        title: 'Address',
                        maxLine: 4,
                      )),
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
                        if (!Constant.isEmailValid(controller.emailTextFiledController.value.text)) {
                          ShowToastDialog.showToast("Please enter valid email");
                        } else if (controller.nameTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter Name.");
                        } else if (controller.cityTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter city");
                        } else if (controller.stateTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter state");
                        } else if (controller.zipCodeTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter zipCode");
                        } else if (controller.addressCodeTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter address");
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
