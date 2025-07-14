import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/restaurant_controller.dart';
import 'package:scaneats_owner/app/model/day_model.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: RestaurantController(),
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              spaceW(),
                              Row(
                                children: [
                                  ContainerCustom(
                                    color: AppThemeData.crusta500,
                                    radius: 6,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: PopupMenuButton<String>(
                                      color: AppThemeData.pickledBluewood50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const TextCustom(title: 'Filter', fontSize: 15, color: AppThemeData.pickledBluewood50, fontFamily: AppThemeData.medium),
                                          SvgPicture.asset(
                                            'assets/icons/down.svg',
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            color: AppThemeData.pickledBluewood50,
                                          ),
                                        ],
                                      ),
                                      onSelected: (value) {
                                        controller.filter(value);
                                      },
                                      itemBuilder: (BuildContext bc) {
                                        return Constant.restaurantSubscriptionList
                                            .map(
                                              (String e) => PopupMenuItem<String>(
                                                value: e,
                                                child: Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black)),
                                              ),
                                            )
                                            .toList();
                                      },
                                    ),
                                  ),
                                  spaceW(width: 10),
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
                                        controller.reset();
                                        showDialog(context: context, builder: (ctxt) => const AddRestaurantDialog());
                                      }),
                                ],
                              ),
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
                        child: controller.restaurantList.isEmpty
                            ? Constant.loaderWithNoFound(context, isLoading: controller.isRestaurantLoading.value, isNotFound: controller.restaurantList.isEmpty)
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
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.08,
                                      child: const TextCustom(title: 'Email'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.08,
                                      child: const TextCustom(title: 'Phone Number'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05,
                                      child: const TextCustom(title: 'Slug'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.20,
                                      child: const TextCustom(title: 'WebSite'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.05,
                                      child: const TextCustom(title: 'Subscription\nPlan'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.05,
                                      child: const TextCustom(title: 'Subscription'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10,
                                      child: const TextCustom(title: 'Actions'),
                                    ),
                                  )
                                ],
                                rows: controller.currentPageUser
                                    .map((e) => DataRow(cells: [
                                          DataCell(
                                            onTap: () {
                                              controller.reset();
                                              controller.editRestaurantData(e);
                                              showDialog(context: context, builder: (ctxt) => const AddRestaurantDialog(isEdit: true));
                                            },
                                            TextCustom(
                                              fontFamily: AppThemeData.medium,
                                              title: e.name ?? '',
                                              color: AppThemeData.crusta500,
                                            ),
                                          ),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.email ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.phoneNumber ?? '')),
                                          DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.slug ?? '')),
                                          DataCell(
                                            onTap: () async {
                                              final Uri url = Uri.parse('${e.webSiteUrl}');
                                              if (!await launchUrl(url)) {
                                                throw Exception('Could not launch }');
                                              }
                                            },
                                            TextCustom(
                                              fontFamily: AppThemeData.medium,
                                              title: e.webSiteUrl ?? '',
                                              color: AppThemeData.crusta500,
                                            ),
                                          ),
                                          DataCell(
                                            TextCustom(
                                              fontFamily: AppThemeData.medium,
                                              title: e.subscription != null ? e.subscription!.planName ?? '' : '',
                                            ),
                                          ),
                                          DataCell(
                                            Constant.checkSubscription(e.subscribed)
                                                ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                                : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                          ),
                                          DataCell(Row(children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.reset();
                                                  controller.editRestaurantData(e);
                                                  showDialog(context: context, builder: (ctxt) => const AddRestaurantDialog(isEdit: true));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                )),
                                            spaceW(),
                                            IconButton(
                                              onPressed: () {
                                                controller.editRestaurantData(e);
                                                showDialog(context: context, builder: (ctxt) => const AddRestaurantDialog(isEdit: true, isSave: false));
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
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (ctxt) => SubscriptionListDialog(
                                                          restaurantModel: e,
                                                        ));
                                              },
                                              icon: const Icon(
                                                Icons.currency_exchange,
                                                size: 20,
                                              ),
                                            ),
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

class AddRestaurantDialog extends StatelessWidget {
  final bool isEdit;
  final bool isSave;
  final String? itemCategoryId;

  const AddRestaurantDialog({super.key, this.isEdit = false, this.isSave = true, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RestaurantController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: TextCustom(
                title: isEdit == true
                    ? 'Edit Restaurant'
                    : isSave == true
                        ? 'View Restaurant'
                        : 'Add Restaurant',
                fontSize: 18),
            content: SizedBox(
              width: 1000,
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
                        controller: controller.nameTextFiledController.value,
                        title: 'Restaurant Name',
                        isReadOnly: !isSave,
                      )),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.emailTextFiledController.value,
                          title: 'Email',
                          isReadOnly: !isSave,
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.phoneTextFiledController.value,
                          title: 'Phone Number',
                          textInputType: TextInputType.number,
                          isReadOnly: !isSave,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                        controller: controller.cityTextFiledController.value,
                        title: 'City',
                        isReadOnly: !isSave,
                      )),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.stateTextFiledController.value,
                          title: 'State',
                          isReadOnly: !isSave,
                        ),
                      ),
                      spaceW(width: 20),
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
                                  initialSelection: controller.countryTextFiledController.value.text,
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: true,
                                  onChanged: (value) {
                                    controller.countryTextFiledController.value.text = value.code.toString();
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
                        controller: controller.zipcodeTextFiledController.value,
                        title: 'ZipCode',
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        isReadOnly: !isSave,
                      )),
                    ],
                  ),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.addressTextFiledController.value,
                          title: 'Address',
                          maxLine: 3,
                          isReadOnly: !isSave,
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldWidget(
                              hintText: '',
                              controller: controller.slugTextFiledController.value,
                              title: 'Domain Name (Slug)',
                              textInputType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^[a-z]+$'))],
                              isReadOnly: !isSave,
                              onChanged: (value) {
                                controller.domainURL.value = Constant.adminWebSite + value;
                              },
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextCustom(
                                    title: "Restaurant Website URL : ",
                                    fontSize: 14,
                                    color: AppThemeData.pickledBluewood600,
                                  ),
                                  Expanded(
                                    child: TextCustom(
                                      title: controller.domainURL.value,
                                      fontSize: 14,
                                      maxLine: 2,
                                      color: AppThemeData.crusta900,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH(),
                  isEdit
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextCustom(title: 'Admin Details', fontSize: 18),
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
                                Expanded(child: TextFieldWidget(hintText: '', controller: controller.adminNameTextFiledController.value, title: 'Admin Name')),
                                spaceW(width: 20),
                                Expanded(
                                  child: TextFieldWidget(hintText: '', controller: controller.adminEmailTextFiledController.value, title: 'Admin Email'),
                                ),
                                spaceW(width: 20),
                                Expanded(
                                  child: TextFieldWidget(
                                    hintText: '',
                                    controller: controller.adminPhoneNumberTextFiledController.value,
                                    title: 'Admin Phone Number',
                                    textInputType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                                    controller: controller.adminPasswordTextFiledController.value,
                                    title: 'Password',
                                    obscureText: !controller.isPasswordVisible.value,
                                    suffix: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      ),
                                      onPressed: () {
                                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                      },
                                    ),
                                  ),
                                ),
                                spaceW(width: 20),
                                Expanded(
                                  child: TextFieldWidget(
                                    hintText: '',
                                    controller: controller.adminConformPasswordTextFiledController.value,
                                    title: 'Confirm Password',
                                    obscureText: !controller.isConformationPasswordVisible.value,
                                    suffix: IconButton(
                                      icon: Icon(
                                        controller.isConformationPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      ),
                                      onPressed: () {
                                        controller.isConformationPasswordVisible.value = !controller.isConformationPasswordVisible.value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  controller.editRestaurantModel.value.subscription == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: ContainerCustom(
                            radius: 10,
                            color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/ic_subscription_plan.png",
                                  height: 60,
                                ),
                                spaceW(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: '${controller.editRestaurantModel.value.subscription!.planName}',
                                        fontSize: 18,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                      ),
                                      spaceH(height: 4),
                                      TextCustom(
                                        title: 'Renews ${Constant.timestampToDateAndTime(controller.editRestaurantModel.value.subscribed!.endDate!)}',
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood500,
                                      ),
                                    ],
                                  ),
                                ),
                                RoundedButtonFill(
                                    isRight: true,
                                    width: 160,
                                    radius: 40,
                                    height: 40,
                                    fontSizes: 14,
                                    title: "Cancel Subscription",
                                    color: AppThemeData.crusta500,
                                    textColor: AppThemeData.pickledBluewood50,
                                    onPress: () async {
                                      ShowToastDialog.showLoader("Please wait.");
                                      controller.editRestaurantModel.value.subscription = null;
                                      controller.editRestaurantModel.value.subscribed = null;
                                      await FireStoreUtils.setRestaurant(model: controller.editRestaurantModel.value).then((value) {
                                        ShowToastDialog.closeLoader();
                                        Get.back();
                                      });
                                    })
                              ],
                            ),
                          ),
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
                visible: isSave,
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
                        if (isEdit) {
                          controller.editRestaurant();
                        } else {
                          controller.addRestaurant();
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}

class SubscriptionListDialog extends StatelessWidget {
  final RestaurantModel restaurantModel;

  const SubscriptionListDialog({super.key, required this.restaurantModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RestaurantController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Subscription', fontSize: 18),
            content: SizedBox(
              width: 1000,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    restaurantModel.subscription == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ContainerCustom(
                              radius: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/icons/ic_subscription_plan.png",
                                    height: 60,
                                  ),
                                  spaceW(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          title: '${restaurantModel.subscription!.planName}',
                                          fontSize: 18,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        ),
                                        spaceH(height: 4),
                                        TextCustom(
                                          title: 'Renews ${Constant.timestampToDateAndTime(restaurantModel.subscribed!.endDate!)}',
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood500,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RoundedButtonFill(
                                      isRight: true,
                                      width: 160,
                                      radius: 40,
                                      height: 40,
                                      fontSizes: 14,
                                      title: "Cancel Subscription",
                                      color: AppThemeData.crusta500,
                                      textColor: AppThemeData.pickledBluewood50,
                                      onPress: () async {
                                        ShowToastDialog.showLoader("Please wait.");
                                        restaurantModel.subscription = null;
                                        restaurantModel.subscribed = null;
                                        await FireStoreUtils.setRestaurant(model: restaurantModel).then((value) {
                                          ShowToastDialog.closeLoader();
                                          Get.back();
                                        });
                                      })
                                ],
                              ),
                            ),
                          ),
                    spaceH(height: 20),
                    SizedBox(
                      height: 600,
                      child: controller.subscriptionList.isEmpty
                          ? SizedBox(
                              width: Responsive.width(100, context),
                              height: Responsive.height(90, context),
                              child: Constant.loaderWithNoFound(context, isNotFound: controller.subscriptionList.isEmpty))
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: controller.subscriptionList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                SubscriptionModel model = controller.subscriptionList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: SizedBox(
                                    width: 360,
                                    child: ContainerCustom(
                                      radius: 10,
                                      borderColor: AppThemeData.pickledBluewood300,
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            child: SizedBox(
                                              height: 4,
                                              child: ContainerCustom(
                                                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Constant.checkCurrentPlanName(model, restaurantModel) == false ||
                                                        Constant.checkCurrentPlanActive(restaurantModel.subscribed!) == false
                                                    ? const SizedBox()
                                                    : Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: RoundedButtonFill(
                                                          icon: const SizedBox(),
                                                          radius: 20,
                                                          height: 30,
                                                          width: 80,
                                                          title: "Active".tr,
                                                          fontSizes: 14,
                                                          color: AppThemeData.forestGreen,
                                                          textColor: AppThemeData.white,
                                                          isRight: false,
                                                          onPress: () async {},
                                                        ),
                                                      ),
                                                TextCustom(
                                                  title: model.planName ?? '',
                                                  fontSize: 20,
                                                  color: AppThemeData.crusta500,
                                                ),
                                                const TextCustom(
                                                  title: 'Best for personal use',
                                                  fontSize: 14,
                                                  color: AppThemeData.pickledBluewood700,
                                                ),
                                                spaceH(height: 4),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Constant.enableSubscriptionList(model)!.first.strikePrice!.isEmpty ||
                                                          Constant.enableSubscriptionList(model)!.first.strikePrice == "0" ||
                                                          model.planName == "Trial"
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            TextCustom(
                                                              title: Constant.amountShow(
                                                                  amount: model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.planPrice.toString()),
                                                              fontSize: 24,
                                                              fontFamily: AppThemeData.bold,
                                                            ),
                                                            TextCustom(
                                                              title:
                                                                  ' / ${model.planName == "Trial" ? "${Constant.enableSubscriptionList(model)!.first.planPrice} days" : Constant.durationName(Constant.enableSubscriptionList(model)!.first)}',
                                                              fontSize: 16,
                                                              fontFamily: AppThemeData.bold,
                                                              color: AppThemeData.pickledBluewood500,
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                TextCustom(
                                                                  title: Constant.amountShow(
                                                                      amount:
                                                                          model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.strikePrice.toString()),
                                                                  fontSize: 24,
                                                                  fontFamily: AppThemeData.bold,
                                                                ),
                                                                TextCustom(
                                                                  title:
                                                                      ' / ${model.planName == "Trial" ? "${Constant.enableSubscriptionList(model)!.first.planPrice} days" : Constant.durationName(Constant.enableSubscriptionList(model)!.first)}',
                                                                  fontSize: 16,
                                                                  fontFamily: AppThemeData.bold,
                                                                  color: AppThemeData.pickledBluewood500,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                TextCustom(
                                                                  title: Constant.amountShow(
                                                                      amount: model.planName == "Trial" ? "0" : Constant.enableSubscriptionList(model)!.first.planPrice.toString()),
                                                                  fontSize: 14,
                                                                  fontFamily: AppThemeData.bold,
                                                                  islineThrough: true,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title: 'Number of Items Access to manage up to ${model.noOfItem} items within your inventory!',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title: 'Number of Branches Capability to oversee operations across ${model.noOfBranch} branches or locations.',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title:
                                                                'Number of Employees Ability to assign roles and responsibilities to ${model.noOfEmployee} employees within your organization.',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title: 'Number of Orders Track and process orders efficiently ${model.noOfOrders} orders placed.',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title: 'Admin Accounts You can create up to ${model.noOfAdmin} admin accounts to manage your system.',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_check.svg",
                                                          colorFilter: const ColorFilter.mode(AppThemeData.forestGreen, BlendMode.srcIn),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: TextCustom(
                                                            title:
                                                                'Tables per Branch Each branch can accommodate up to ${model.noOfTablePerBranch} tables for efficient organization',
                                                            fontSize: 14,
                                                            fontFamily: AppThemeData.regular,
                                                            maxLine: 3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                              child: Constant.checkCurrentPlanName(model, restaurantModel) == false
                                                  ? RoundedButtonFill(
                                                      icon: const SizedBox(),
                                                      radius: 10,
                                                      height: 40,
                                                      width: Responsive.height(100, context),
                                                      title: "Get started".tr,
                                                      fontSizes: 16,
                                                      color: AppThemeData.crusta500,
                                                      textColor: AppThemeData.white,
                                                      isRight: false,
                                                      onPress: () async {
                                                        if (model.planName == "Trial") {
                                                          if (restaurantModel.isTrail == true) {
                                                            ShowToastDialog.showToast("Your trial is already subscribed, you can't subscribe it multiple times.");
                                                          } else {
                                                            controller.selectedDuration.value = model.durations!.first;
                                                            controller.setSubscription(model, restaurantModel);
                                                          }
                                                        } else {
                                                          controller.reset();
                                                          controller.selectedDuration.value = model.durations!.first;
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctxt) => SubscriptionDialog(
                                                                    subscriptionModel: model,
                                                                    restaurantModel: restaurantModel,
                                                                  ));
                                                        }
                                                      },
                                                    )
                                                  : RoundedButtonFill(
                                                      icon: const SizedBox(),
                                                      radius: 10,
                                                      height: 40,
                                                      width: Responsive.height(100, context),
                                                      title: "Renew".tr,
                                                      fontSizes: 16,
                                                      borderColor: AppThemeData.crusta500,
                                                      textColor: AppThemeData.crusta500,
                                                      isRight: false,
                                                      onPress: () async {
                                                        if (model.planName == "Trial") {
                                                          if (restaurantModel.isTrail == true) {
                                                            ShowToastDialog.showToast("Your trial is already subscribed, you can't subscribe it multiple times.");
                                                          } else {
                                                            controller.selectedDuration.value = model.durations!.first;
                                                            controller.setSubscription(model, restaurantModel);
                                                          }
                                                        } else {
                                                          controller.reset();
                                                          controller.selectedDuration.value = model.durations!.first;
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctxt) => SubscriptionDialog(
                                                                    subscriptionModel: model,
                                                                    restaurantModel: restaurantModel,
                                                                  ));
                                                        }
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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
              // Visibility(
              //   visible: isSave,
              //   child: RoundedButtonFill(
              //       width: 80,
              //       radius: 8,
              //       height: 40,
              //       fontSizes: 14,
              //       title: "Save",
              //       icon: controller.isAddItemLoading.value == true
              //           ? Constant.loader(context, color: AppThemeData.white)
              //           : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
              //       color: AppThemeData.crusta500,
              //       textColor: AppThemeData.white,
              //       isRight: false,
              //       onPress: () {
              //         if (Constant.isDemo()) {
              //           ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
              //         } else {
              //           if (isEdit) {
              //             controller.editRestaurant();
              //           } else {
              //             controller.addRestaurant();
              //           }
              //         }
              //       }),
              // ),
            ],
          );
        });
  }
}

class SubscriptionDialog extends StatelessWidget {
  final SubscriptionModel subscriptionModel;
  final RestaurantModel restaurantModel;

  const SubscriptionDialog({super.key, required this.subscriptionModel, required this.restaurantModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: RestaurantController(),
      builder: (controller) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          title: TextCustom(title: '${subscriptionModel.planName}', fontSize: 18),
          content: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DropdownButtonFormField<DayModel>(
                //   isExpanded: true,
                //   style: TextStyle(
                //     fontFamily: AppThemeData.medium,
                //     color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                //   ),
                //   value: controller.selectedDuration.value.name == null ? null : controller.selectedDuration.value,
                //   hint: const TextCustom(title: 'Select'),
                //   onChanged: (DayModel? newValue) {
                //     if (newValue != null) {
                //       controller.selectedDuration.value = newValue;
                //     }
                //   },
                //   decoration: InputDecoration(
                //       iconColor: AppThemeData.crusta500,
                //       isDense: true,
                //       filled: true,
                //       fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                //       contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                //       disabledBorder: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                //       ),
                //       errorBorder: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                //         borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                //       ),
                //       hintText: "Select",
                //       hintStyle: TextStyle(
                //           fontSize: 14,
                //           color: themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood950,
                //           fontWeight: FontWeight.w500,
                //           fontFamily: AppThemeData.medium)),
                //   items: Constant.enableSubscriptionList(subscriptionModel)!.map<DropdownMenuItem<DayModel>>((value) {
                //     return DropdownMenuItem<DayModel>(
                //       value: value,
                //       child: TextCustom(
                //         title: Constant.durationName(value),
                //         fontFamily: AppThemeData.medium,
                //         color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                //       ),
                //     );
                //   }).toList(),
                // )
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: Constant.enableSubscriptionList(subscriptionModel)!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DayModel model = Constant.enableSubscriptionList(subscriptionModel)![index];
                      return InkWell(
                        onTap: () {
                          controller.selectedDuration.value = model;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 200,
                            child: Obx(
                              () => ContainerCustom(
                                radius: 10,
                                borderColor: controller.selectedDuration.value.name == model.name ? AppThemeData.crusta500 : AppThemeData.pickledBluewood300,
                                padding: EdgeInsets.zero,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: SizedBox(
                                        height: 4,
                                        child: ContainerCustom(
                                          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                controller.selectedDuration.value.name == model.name
                                                    ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                                                    : Icon(Icons.circle_outlined,
                                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: TextCustom(
                                                    title: model.name.toString(),
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: model.strikePrice == null || model.strikePrice.toString() == "0" || model.strikePrice!.isEmpty
                                                  ? Center(
                                                      child: TextCustom(
                                                        title: Constant.amountShow(amount: model.planPrice.toString()),
                                                        fontSize: 18,
                                                        fontFamily: AppThemeData.bold,
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          TextCustom(
                                                            title: Constant.amountShow(amount: model.strikePrice.toString()),
                                                            fontSize: 18,
                                                            fontFamily: AppThemeData.bold,
                                                          ),
                                                          TextCustom(
                                                            title: Constant.amountShow(amount: model.planPrice.toString()),
                                                            fontSize: 12,
                                                            fontFamily: AppThemeData.bold,
                                                            islineThrough: true,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TextCustom(
                                      title:
                                          "Plan renews at\n${Constant.timestampToDate(Timestamp.fromDate(DateTime.now().add(Duration(days: Constant.dayCalculationOfSubscription(model)))))}",
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
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
              width: 100,
              radius: 8,
              height: 40,
              fontSizes: 14,
              title: "Subscribe",
              icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
              color: AppThemeData.crusta500,
              textColor: AppThemeData.white,
              isRight: false,
              onPress: () async {
                if (controller.selectedDuration.value.name == null) {
                  ShowToastDialog.showToast("Please select plan duration.");
                } else {
                  controller.setSubscription(subscriptionModel, restaurantModel);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
