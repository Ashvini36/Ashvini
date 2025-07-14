import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/subscription_controller.dart';
import 'package:scaneats_owner/app/model/day_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SubscriptionController(),
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!Responsive.isMobile(context)) Expanded(child: TextCustom(title: controller.title.value, maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              if (!Responsive.isMobile(context)) spaceW(),
                              RoundedButtonFill(
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
                                  title: "Add Trial Plan",
                                  color: AppThemeData.crusta500,
                                  textColor: AppThemeData.pickledBluewood50,
                                  onPress: () {
                                    controller.resetSetting();
                                    SubscriptionModel subscriptionModel = SubscriptionModel(
                                        id: Constant().getUuid(),
                                        durations: controller.setTrailDayList,
                                        isActive: true,
                                        noOfAdmin: "0",
                                        noOfBranch: "0",
                                        noOfEmployee: "0",
                                        noOfItem: "0",
                                        noOfOrders: "0",
                                        noOfTablePerBranch: "0",
                                        planName: "Trial");
                                    controller.editRestaurantData(subscriptionModel);
                                    showDialog(context: context, builder: (ctxt) => const AddTrailDialog());
                                  }),
                              spaceW(),
                              RoundedButtonFill(
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
                                    controller.resetSetting();
                                    print("=========>");
                                    SubscriptionModel subscriptionModel = SubscriptionModel(
                                        id: Constant().getUuid(),
                                        durations: controller.setDayList,
                                        isActive: true,
                                        noOfAdmin: "0",
                                        noOfBranch: "0",
                                        noOfEmployee: "0",
                                        noOfItem: "0",
                                        noOfOrders: "0",
                                        noOfTablePerBranch: "0",
                                        planName: "Trial");
                                    controller.editRestaurantData(subscriptionModel);
                                    showDialog(context: context, builder: (ctxt) => const AddSubscriptionDialog());
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
                        child: controller.subscriptionList.isEmpty
                            ? Constant.loaderWithNoFound(context, isLoading: controller.isRestaurantLoading.value, isNotFound: controller.subscriptionList.isEmpty)
                            : DataTable(
                                horizontalMargin: 20,
                                columnSpacing: 30,
                                dataRowMaxHeight: 70,
                                border: TableBorder.all(
                                  color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                headingRowColor:
                                    MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 110 : MediaQuery.of(context).size.width * 0.08,
                                      child: const TextCustom(title: 'Name'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Item'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Branch'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Employee'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Orders'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Admin'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06,
                                      child: const TextCustom(title: 'No Of Table \nPer Branch'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.04,
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
                                rows: controller.subscriptionList
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(
                                            TextCustom(
                                              fontFamily: AppThemeData.medium,
                                              title: e.planName ?? '',
                                              color: AppThemeData.crusta500,
                                            ),
                                          ),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfItem ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfBranch ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfEmployee ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfOrders ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfAdmin ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.noOfTablePerBranch ?? '')),
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
                                                      controller.resetSetting();
                                                      if (e.planName == "Trial") {
                                                        controller.editRestaurantData(e);
                                                        showDialog(context: context, builder: (ctxt) => AddTrailDialog(isEdit: true, itemCategoryId: e.id.toString()));
                                                      } else {
                                                        controller.editRestaurantData(e);
                                                        showDialog(context: context, builder: (ctxt) => AddSubscriptionDialog(isEdit: true, itemCategoryId: e.id.toString()));
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    )),
                                                spaceW(),
                                                IconButton(
                                                  onPressed: () {
                                                    controller.resetSetting();
                                                    if (e.planName == "Trial") {
                                                      controller.editRestaurantData(e);
                                                      showDialog(context: context, builder: (ctxt) => AddTrailDialog(isSave: true, itemCategoryId: e.id.toString()));
                                                    } else {
                                                      controller.editRestaurantData(e);
                                                      showDialog(context: context, builder: (ctxt) => AddSubscriptionDialog(isSave: true, itemCategoryId: e.id.toString()));
                                                    }
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
                                                        controller.deleteRestaurant(e);
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
                  ]),
                )
              ],
            ));
      },
    );
  }
}

class AddSubscriptionDialog extends StatelessWidget {
  final bool isEdit;
  final bool isSave;
  final String? itemCategoryId;

  const AddSubscriptionDialog({super.key, this.isEdit = false, this.isSave = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: SubscriptionController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: TextCustom(
                title: isEdit == true
                    ? 'Edit Subscription'
                    : isSave == true
                        ? 'View Subscription'
                        : 'Add Subscription',
                fontSize: 18),
            content: SizedBox(
              width: 1000,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Expanded(
                            child: TextFieldWidget(
                          hintText: '',
                          controller: controller.planNameTextFiledController.value,
                          title: 'Plan Name',
                          isReadOnly: isSave,
                        )),
                        spaceW(width: 20),
                        Expanded(
                          flex: 1,
                          child: customRadioButton(
                            context,
                            parameter: controller.status.value,
                            title: 'Status',
                            radioOne: "Active",
                            onChangeOne: () {
                              if (!isSave) {
                                controller.status.value = "Active";
                                controller.update();
                              }
                            },
                            radioTwo: "Inactive",
                            onChangeTwo: () {
                              if (!isSave) {
                                controller.status.value = "Inactive";
                                controller.update();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    spaceH(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: const TextCustom(title: 'Active'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                                child: const TextCustom(title: 'Name'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                                child: const TextCustom(title: 'Plan Price'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                                child: const TextCustom(title: 'Strike-Out Price'),
                              ),
                            ),
                          ],
                          rows: controller.dayList.asMap().entries.map((e1) {
                            DayModel e = controller.dayList[e1.key];
                            return DataRow(
                              cells: [
                                DataCell(
                                  Checkbox(
                                      side: const BorderSide(color: AppThemeData.pickledBluewood200, width: 1.5),
                                      activeColor: AppThemeData.crusta500,
                                      checkColor: AppThemeData.white,
                                      value: e.enable ?? false,
                                      onChanged: (v) {
                                        e.enable = v;
                                        controller.updateList(e1.key, e);
                                      }),
                                ),
                                DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? '')),
                                DataCell(
                                  TextFormField(
                                    initialValue: e.planPrice,
                                    cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    textCapitalization: TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) {
                                      e.planPrice = value.toString();
                                      controller.updateList(e1.key, e);
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        fontFamily: AppThemeData.medium),
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                        isDense: true,
                                        filled: true,
                                        enabled: !isSave,
                                        fillColor: (themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        hintText: "Plan Price",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood300,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                  ),
                                ),
                                DataCell(
                                  TextFormField(
                                    initialValue: e.strikePrice,
                                    cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    textCapitalization: TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) {
                                      e.strikePrice = value.toString();
                                      controller.updateList(e1.key, e);
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        fontFamily: AppThemeData.medium),
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                        isDense: true,
                                        filled: true,
                                        enabled: !isSave,
                                        fillColor: (themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        hintText: "Strike Price",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood300,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                    ),
                    spaceH(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(title: 'Plan Settings', fontSize: 18),
                        spaceH(),
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
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfItemTextFiledController.value,
                                title: 'No of Item',
                                isReadOnly: isSave,
                              ),
                            ),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfBranchTextFiledController.value,
                                title: 'No of Branch',
                                isReadOnly: isSave,
                              ),
                            ),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfTablePerBranchTextFiledController.value,
                                title: 'No of Table Per Branch',
                                isReadOnly: isSave,
                              ),
                            ),
                          ],
                        ),
                        spaceH(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextFieldWidget(
                              hintText: '',
                              controller: controller.noOfEmployeeTextFiledController.value,
                              title: 'No of Employee',
                              isReadOnly: isSave,
                            )),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfOrdersTextFiledController.value,
                                title: 'No of Orders',
                                isReadOnly: isSave,
                              ),
                            ),
                            spaceW(width: 20),
                            Expanded(
                                child: TextFieldWidget(
                              hintText: '',
                              controller: controller.noOfAdminTextFiledController.value,
                              title: 'No of admin',
                              isReadOnly: isSave,
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
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
                visible: !isSave,
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
                        if (controller.planNameTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter Plan Name");
                        } else if (controller.noOfItemTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Item");
                        } else if (controller.noOfBranchTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Branch");
                        } else if (controller.noOfEmployeeTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of employee");
                        } else if (controller.noOfOrdersTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of orders");
                        } else if (controller.noOfAdminTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of admin");
                        } else if (controller.noOfTablePerBranchTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Table per Branch");
                        } else {
                          controller.subscriptionData(itemCategoryId: itemCategoryId ?? '', isEdit: isEdit);
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}

class AddTrailDialog extends StatelessWidget {
  final bool isEdit;
  final bool isSave;
  final String? itemCategoryId;

  const AddTrailDialog({super.key, this.isEdit = false, this.isSave = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionController(),
        builder: (controller) {
          log("==> ${controller.dayList.length}");
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: TextCustom(
                title: isEdit == true
                    ? 'Edit Subscription'
                    : isSave == true
                        ? 'View Subscription'
                        : 'Add Subscription',
                fontSize: 18),
            content: SizedBox(
              width: 1000,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Expanded(
                            child: TextFieldWidget(
                          hintText: '',
                          controller: controller.planNameTextFiledController.value,
                          title: 'Plan Name',
                          isReadOnly: true,
                        )),
                        spaceW(width: 20),
                        Expanded(
                          flex: 1,
                          child: customRadioButton(
                            context,
                            parameter: controller.status.value,
                            title: 'Status',
                            radioOne: "Active",
                            onChangeOne: () {
                              if (!isSave) {
                                controller.status.value = "Active";
                                controller.update();
                              }
                            },
                            radioTwo: "Inactive",
                            onChangeTwo: () {
                              if (!isSave) {
                                controller.status.value = "Inactive";
                                controller.update();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    spaceH(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                                width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                                child: const TextCustom(title: 'Name'),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.09,
                                child: const TextCustom(title: 'Days'),
                              ),
                            ),
                          ],
                          rows: controller.dayList.asMap().entries.map((e1) {
                            DayModel e = controller.dayList[e1.key];
                            return DataRow(
                              cells: [
                                DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? '')),
                                DataCell(
                                  TextFormField(
                                    initialValue: e.planPrice,
                                    cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    textCapitalization: TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (value) {
                                      e.planPrice = value.toString();
                                      controller.updateList(e1.key, e);
                                    },
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        fontFamily: AppThemeData.medium),
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                        isDense: true,
                                        filled: true,
                                        enabled: !isSave,
                                        fillColor: (themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        hintText: "Days",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood300,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                  ),
                                ),
                              ],
                            );
                          }).toList()),
                    ),
                    spaceH(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(title: 'Plan Settings', fontSize: 18),
                        spaceH(),
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
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfItemTextFiledController.value,
                                title: 'No of Item',
                                isReadOnly: isSave,
                              ),
                            ),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfBranchTextFiledController.value,
                                title: 'No of Branch',
                                isReadOnly: isSave,
                              ),
                            ),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(
                                hintText: '',
                                controller: controller.noOfTablePerBranchTextFiledController.value,
                                title: 'No of Table Per Branch',
                                isReadOnly: isSave,
                              ),
                            ),
                          ],
                        ),
                        spaceH(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: TextFieldWidget(hintText: '', controller: controller.noOfEmployeeTextFiledController.value, title: 'No of Employee')),
                            spaceW(width: 20),
                            Expanded(
                              child: TextFieldWidget(hintText: '', controller: controller.noOfOrdersTextFiledController.value, title: 'No of Orders'),
                            ),
                            spaceW(width: 20),
                            Expanded(
                                child: TextFieldWidget(
                              hintText: '',
                              controller: controller.noOfAdminTextFiledController.value,
                              title: 'No of admin',
                              isReadOnly: isSave,
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
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
                visible: !isSave,
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
                        if (controller.planNameTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter Plan Name");
                        } else if (controller.noOfItemTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Item");
                        } else if (controller.noOfBranchTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Branch");
                        } else if (controller.noOfEmployeeTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of employee");
                        } else if (controller.noOfOrdersTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of orders");
                        } else if (controller.noOfAdminTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter no of admin");
                        } else if (controller.noOfTablePerBranchTextFiledController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please Enter No of Table per Branch");
                        } else {
                          controller.subscriptionData(itemCategoryId: itemCategoryId ?? '', isEdit: isEdit);
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}
