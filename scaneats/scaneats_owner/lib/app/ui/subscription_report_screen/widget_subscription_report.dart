import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/subscription_report_controller.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

class WidgetSubscriptionReportScreen extends StatelessWidget {
  const WidgetSubscriptionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SubscriptionReportController(),
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
                SingleChildScrollView(
                  child: ContainerCustom(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!Responsive.isMobile(context))
                            Expanded(flex: 1, child: TextCustom(title: controller.title.value, maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                          Flexible(
                            flex: 3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(mainAxisAlignment: Responsive.isMobile(context) ? MainAxisAlignment.start : MainAxisAlignment.end, children: [
                                if (!Responsive.isMobile(context)) spaceW(),
                                spaceW(),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                    ),
                                    value: controller.totalItemPerPage.value,
                                    hint: const TextCustom(title: 'Select'),
                                    onChanged: (String? newValue) {
                                      controller.setPagition(newValue!);
                                    },
                                    decoration: InputDecoration(
                                        iconColor: AppThemeData.crusta500,
                                        isDense: true,
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        hintText: "Select",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood950,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                    items: Constant.numofpageitemList.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: TextCustom(
                                          title: value,
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                spaceW(),
                                Row(
                                  children: [
                                    RoundedButtonFill(
                                        isRight: true,
                                        icon: SvgPicture.asset(
                                          'assets/icons/filter.svg',
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.cover,
                                          color: AppThemeData.pickledBluewood50,
                                        ),
                                        width: 100,
                                        radius: 6,
                                        height: 40,
                                        fontSizes: 14,
                                        title: "Filter",
                                        color: AppThemeData.crusta500,
                                        textColor: AppThemeData.pickledBluewood50,
                                        onPress: () {
                                          showDialog(context: context, builder: (ctxt) => const FilterDialog());
                                        }),
                                    spaceW(width: 10),
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
                                            const TextCustom(title: 'Export', fontSize: 15, color: AppThemeData.pickledBluewood50, fontFamily: AppThemeData.medium),
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
                                          if (value == "PDF") {
                                            controller.downLoadPdf();
                                          } else {
                                            controller.createExcel(value);
                                          }
                                        },
                                        itemBuilder: (BuildContext bc) {
                                          return Constant.exportList
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
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      spaceH(),
                      spaceH(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          child: controller.currentPageOrder.isEmpty || controller.isOrderLoading.value
                              ? Constant.loaderWithNoFound(context, isLoading: controller.isOrderLoading.value, isNotFound: controller.posOrderList.isEmpty)
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
                                  columns: const [
                                    DataColumn(
                                      label: SizedBox(
                                        width: 140,
                                        child: TextCustom(title: 'Subscription Plan'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 200,
                                        child: TextCustom(title: 'Restaurant Name'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 200,
                                        child: TextCustom(title: 'Plan Duration'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 140,
                                        child: TextCustom(title: 'Plan Price'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 200,
                                        child: TextCustom(title: 'Payment Type'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 140,
                                        child: TextCustom(title: 'Subscription\nStatus'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 240,
                                        child: TextCustom(title: 'Purchase Date'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: 240,
                                        child: TextCustom(title: 'Renew Date'),
                                      ),
                                    ),
                                  ],
                                  rows: controller.currentPageOrder
                                      .map(
                                        (e) => DataRow(
                                          cells: [
                                            DataCell(
                                              TextCustom(
                                                title: e.subscription!.planName.toString(),
                                              ),
                                            ),
                                            DataCell(
                                              FutureBuilder<RestaurantModel?>(
                                                future: FireStoreUtils.getRestaurantById(e.restaurantId.toString()), // async work
                                                builder: (BuildContext context, AsyncSnapshot<RestaurantModel?> snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.waiting:
                                                      return const SizedBox();
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else if (snapshot.data == null) {
                                                        return const TextCustom(
                                                          title: 'Deleted Restaurant',
                                                        );
                                                      } else {
                                                        return TextCustom(
                                                          title: snapshot.data!.name.toString(),
                                                        );
                                                      }
                                                  }
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              TextCustom(
                                                title: Constant.durationName(e.durations!),
                                              ),
                                            ),
                                            DataCell(
                                              TextCustom(
                                                title: e.durations!.name == "Trial Plan"
                                                    ? Constant.amountShow(amount: "0.0")
                                                    : Constant.amountShow(amount: e.durations!.planPrice.toString()),
                                              ),
                                            ),
                                            DataCell(
                                              TextCustom(
                                                title: e.paymentType.toString(),
                                              ),
                                            ),
                                            DataCell(
                                              Constant.checkSubscriptionOfTraction(e) == true
                                                  ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                                  : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                            ),
                                            DataCell(
                                              TextCustom(
                                                title: Constant.timestampToDateAndTime(e.startDate!),
                                              ),
                                            ),
                                            DataCell(
                                              TextCustom(
                                                title: Constant.timestampToDateAndTime(e.endDate!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList()),
                        ),
                      ),
                      spaceH(),
                      Visibility(
                        visible: controller.totalPage.value > 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: WebPagination(
                                  currentPage: controller.currentPage.value,
                                  totalPage: controller.totalPage.value,
                                  displayItemCount: controller.pageValue(controller.totalItemPerPage.value),
                                  onPageChanged: (page) {
                                    controller.currentPage.value = page;
                                    controller.setPagition(controller.totalItemPerPage.value);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ));
      },
    );
  }
}

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionReportController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Filter', fontSize: 18),
            content: SizedBox(
              width: 500,
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
                  InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () async {
                        await Constant.selectDateAndTimeRange(context: context, date: DateTime.now()).then((value) {
                          if (value != null) {
                            controller.selectedDate.value = value;
                            controller.dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(value.start)} to ${DateFormat('yyyy-MM-dd').format(value.end)}";
                          }
                        });
                      },
                      child: TextFieldWidget(
                        hintText: '',
                        controller: controller.dateFiledController.value,
                        title: 'Select Date'.toUpperCase(),
                        enable: false,
                      )),
                  spaceH(),
                  TextCustom(title: 'Select Restaurant'.toUpperCase(), fontSize: 12, fontFamily: AppThemeData.bold),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<RestaurantModel>(
                            isExpanded: true,
                            hint: Text(
                              'Select Restaurant',
                              style: TextStyle(
                                fontSize: 14,
                                color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                              ),
                            ),
                            items: controller.restaurantList
                                .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.name.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ))))
                                .toList(),
                            value: controller.selectedRestaurant.value.id == null ? null : controller.selectedRestaurant.value,
                            onChanged: (value) {
                              controller.selectedRestaurant.value = value!;
                              controller.update();
                            },
                            buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)), color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100)),
                            dropdownStyleData:
                                DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100)),
                            dropdownSearchData: DropdownSearchData(
                              searchController: controller.searchEditingController.value,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: TextFieldWidget(
                                  hintText: 'Select Restaurant',
                                  fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                                  controller: controller.searchEditingController.value,
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.value!.name!.toLowerCase().contains(searchValue.toLowerCase());
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                controller.searchEditingController.value.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
                    // controller.getPosOrderData();
                    Get.back();
                  }),
              RoundedButtonFill(
                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Clear",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    controller.getPosOrderData();
                    Get.back();
                  }),
              RoundedButtonFill(
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Apply",
                  icon: const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () {
                    Get.back();
                    controller.filter();
                  }),
            ],
          );
        });
  }
}
