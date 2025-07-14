import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/offers_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/pickup_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: OffersController(),
      builder: (controller) {
        return Padding(
            padding: paddingEdgeInsets(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceH(),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                  Row(children: [
                    const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                    const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                    TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium)
                  ])
                ]),
                spaceH(height: 20),
                ContainerCustom(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!Responsive.isMobile(context))
                          Expanded(
                              child: TextCustom(title: '${controller.title.value} (${controller.offerList.length})', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              if (!Responsive.isMobile(context)) spaceW(),
                              spaceW(),
                              Constant.selectedRole.permission!.firstWhere((element) => element.title == "Offers").isUpdate == false
                                  ? const SizedBox()
                                  : RoundedButtonFill(
                                      isRight: true,
                                      icon: SvgPicture.asset(
                                        'assets/icons/plus.svg',
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                        color: AppThemeData.pickledBluewood50,
                                      ),
                                      width: 145,
                                      radius: 6,
                                      height: 40,
                                      fontSizes: 14,
                                      title: "Add ${controller.title.value}",
                                      color: AppThemeData.crusta500,
                                      textColor: AppThemeData.pickledBluewood50,
                                      onPress: () {
                                        showGlobalDrawer(
                                            duration: const Duration(milliseconds: 400),
                                            barrierDismissible: true,
                                            context: context,
                                            builder: horizontalDrawerBuilder(),
                                            direction: AxisDirection.right);
                                      }),
                            ]),
                          ),
                        ),
                      ],
                    ),
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
                                  width: Responsive.isMobile(context) ? 110 : MediaQuery.of(context).size.width * 0.12,
                                  child: const TextCustom(title: 'Name'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06,
                                  child: const TextCustom(title: 'Code'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05,
                                  child: const TextCustom(title: 'Type'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05,
                                  child: const TextCustom(title: 'Amount'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12,
                                  child: const TextCustom(title: 'Start Date'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12,
                                  child: const TextCustom(title: 'End Date'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.05,
                                  child: const TextCustom(title: 'Status'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10,
                                  child: const TextCustom(title: 'Actions'),
                                ),
                              )
                            ],
                            rows: controller.offerList
                                .map((e) => DataRow(cells: [
                                      DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? '')),
                                      DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.code ?? '')),
                                      DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.isFix == true ? "Fix" : "Percentage")),
                                      DataCell(TextCustom(
                                          title: e.isFix == true ? Constant.amountShow(amount: e.rate.toString()) : Constant.percentageAmountShow(amount: e.rate.toString()))),
                                      DataCell(TextCustom(title: Constant.timestampToDateAndTime(e.startDate!))),
                                      DataCell(TextCustom(title: Constant.timestampToDateAndTime(e.endDate!))),
                                      DataCell(
                                        e.isActive == true
                                            ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                            : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                      ),
                                      DataCell(Row(children: [
                                        Constant.selectedRole.permission!.firstWhere((element) => element.title == "Offers").isUpdate == false
                                            ? const SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  controller.setEditValue(e);
                                                  showGlobalDrawer(
                                                      duration: const Duration(milliseconds: 200),
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: horizontalDrawerBuilder(
                                                        itemId: e.id.toString(),
                                                        isEdit: true,
                                                      ),
                                                      direction: AxisDirection.right);
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )),
                                        spaceW(),
                                        IconButton(
                                          onPressed: () {
                                            controller.setEditValue(e);
                                            showGlobalDrawer(
                                                duration: const Duration(milliseconds: 200),
                                                barrierDismissible: true,
                                                context: context,
                                                builder: horizontalDrawerBuilder(
                                                  itemId: e.id.toString(),
                                                  isReadOnly: true,
                                                ),
                                                direction: AxisDirection.right);
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 20,
                                          ),
                                        ),
                                        spaceW(),
                                        Constant.selectedRole.permission!.firstWhere((element) => element.title == "Offers").isDelete == false
                                            ? const SizedBox()
                                            : IconButton(
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
                                      ])),
                                    ]))
                                .toList()),
                      ),
                    ),
                  ]),
                )
              ],
            ));
      },
    );
  }
}

WidgetBuilder horizontalDrawerBuilder({String? itemId, bool isEdit = false, bool isReadOnly = false}) {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OffersController>(
        init: OffersController(),
        builder: (controller) {
          return Drawer(
            width: 500,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
                child: IntrinsicWidth(
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          spaceH(),
                          TextCustom(title: controller.title.value, fontSize: 20),
                          spaceH(height: 20),
                          SizedBox(height: 2, child: ContainerCustom(color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100)),
                          spaceH(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                  if (value != null) {
                                    XFile stringFile = value;
                                    controller.image.value = stringFile.path;
                                    controller.profileImageUin8List.value = await stringFile.readAsBytes();
                                  }
                                });
                              },
                              child: Stack(alignment: Alignment.bottomCenter, children: [
                                controller.image.value.isEmpty
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
                                                    ? Constant.loader(
                                                        context,
                                                      )
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
                                                placeHolderUrl: Constant.placeholderURL,
                                                fit: BoxFit.cover,
                                                height: 90,
                                                width: 90,
                                              ),
                                      ),
                                Positioned(
                                  bottom: 50,
                                  right: Responsive.width(36, context),
                                  child: InkWell(
                                    onTap: () {},
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.black,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            'assets/icons/ic_edit_profile.svg',
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          spaceH(height: 40),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.nameTextFiledController.value,
                                  title: 'Name',
                                  isReadOnly: isReadOnly,
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.rateTextFiledController.value,
                                  title: 'Rate',
                                  isReadOnly: isReadOnly,
                                )),
                          ]),
                          spaceH(),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Constant().selectDateAndTime(context: context, date: DateTime.now()).then((value) {
                                      if (value != null) {
                                        controller.startDateTextFiledController.value.text = DateFormat('yyyy-MM-dd – HH:mm a').format(value);
                                      }
                                    });
                                  },
                                  child: TextFieldWidget(
                                    hintText: '',
                                    controller: controller.startDateTextFiledController.value,
                                    title: 'Start Date',
                                    isReadOnly: isReadOnly,
                                    enable: false,
                                  ),
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    await Constant()
                                        .selectDateAndTime(context: context, date: Constant().stringToDate(controller.startDateTextFiledController.value.text))
                                        .then((value) {
                                      if (value != null) {
                                        controller.endDateTextFiledController.value.text = DateFormat('yyyy-MM-dd – HH:mm a').format(value);
                                      }
                                    });
                                  },
                                  child: TextFieldWidget(
                                    hintText: '',
                                    controller: controller.endDateTextFiledController.value,
                                    title: 'End Date',
                                    isReadOnly: isReadOnly,
                                    enable: false,
                                  ),
                                )),
                          ]),
                          spaceH(),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.codeTextFiledController.value,
                                  title: 'Offer Code',
                                  isReadOnly: isReadOnly,
                                ),
                              ),
                              spaceW(width: 15),
                              Expanded(
                                  flex: 1,
                                  child: customRadioButton(context,
                                      parameter: controller.status.value,
                                      title: 'Status',
                                      radioOne: "Active",
                                      onChangeOne: () {
                                        if (!isReadOnly) {
                                          controller.status.value = "Active";
                                          controller.update();
                                        }
                                      },
                                      radioTwo: "Inactive",
                                      onChangeTwo: () {
                                        if (!isReadOnly) {
                                          controller.status.value = "Inactive";
                                          controller.update();
                                        }
                                      })),
                            ],
                          ),
                          spaceH(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextCustom(
                                title: "Select Type",
                                fontSize: 12,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: controller.selectedType.value,
                                hint: const TextCustom(title: 'Type'),
                                onChanged: (String? newValue) {
                                  controller.selectedType.value = newValue!;
                                  controller.update();
                                },
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                    isDense: true,
                                    filled: true,
                                    fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
                                    hintText: "Select Role".tr,
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppThemeData.medium)),
                                items: Constant.rateTypeList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: TextCustom(title: value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          spaceH(),
                          spaceH(),
                          Row(
                            children: [
                              Visibility(
                                visible: !isReadOnly,
                                child: RoundedButtonFill(
                                    width: 120,
                                    radius: 8,
                                    height: 45,
                                    icon: controller.isAddItemLoading.value == true
                                        ? Constant.loader(context, color: AppThemeData.white)
                                        : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                                    title: "Save",
                                    color: AppThemeData.crusta500,
                                    fontSizes: 14,
                                    textColor: AppThemeData.white,
                                    isRight: false,
                                    onPress: () {
                                      if (Constant.isDemo()) {
                                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                      } else {
                                        if (controller.nameTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please enter name");
                                        } else if (controller.rateTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please enter rate");
                                        } else if (controller.codeTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please enter coupon code");
                                        } else if (controller.startDateTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please select start date");
                                        } else if (controller.endDateTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please select end date");
                                        } else {
                                          controller.addOfferData(itemCategoryId: itemId ?? '', isEdit: isEdit);
                                        }
                                      }
                                    }),
                              ),
                              spaceW(width: 15),
                              RoundedButtonFill(
                                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  width: 120,
                                  radius: 8,
                                  height: 45,
                                  fontSizes: 14,
                                  title: "Close",
                                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  isRight: false,
                                  onPress: () {
                                    controller.reset();
                                    Get.back();
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  };
}
