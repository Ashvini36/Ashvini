import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/dash_board_controller.dart';
import 'package:scaneats/app/controller/home_branch_controller.dart';
import 'package:scaneats/app/controller/order_details_controller.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget dashboardTitleWidget(context) {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
        TextCustom(title: 'Manage your product, Branch and best deals', fontSize: 14, fontFamily: AppThemeData.regular),
      ]),
    ],
  );
}

class TotalCountWidget extends StatelessWidget {
  final HomeBranchController controller;
  final double? childAspectRatio;
  final int? crossAxisCount;

  const TotalCountWidget({super.key, required this.controller, required this.childAspectRatio, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 145, childAspectRatio: childAspectRatio!, crossAxisCount: crossAxisCount!),
      children: <Widget>[
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.order)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .where('createdAt', isGreaterThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0)))
                .where('createdAt', isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0)))
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CoinTile(icon: 'assets/icons/shopping_cart_1.svg', title: "Today's Orders", value: '${snapshot.data!.docs.length}', color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.order)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CoinTile(icon: 'assets/icons/shopping_cart_1.svg', title: "Total Orders", value: '${snapshot.data!.docs.length}', color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.order)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .where('createdAt', isGreaterThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0)))
                .where('createdAt', isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0)))
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double revenue = 0.0;
                    for (var element in snapshot.data!.docs) {
                      OrderModel model = OrderModel.fromJson(element.data());
                      revenue = revenue + double.parse(model.total ?? "0");
                    }
                    return CoinTile(
                        icon: 'assets/icons/dollar_sign_2.svg', title: "Today's Revenue", value: Constant.amountShow(amount: '$revenue'), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.order)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    double revenue = 0.0;
                    for (var element in snapshot.data!.docs) {
                      OrderModel model = OrderModel.fromJson(element.data());
                      revenue = revenue + double.parse('${model.total ?? 0}');
                    }
                    return CoinTile(
                        icon: 'assets/icons/dollar_sign_2.svg', title: "Total Revenue", value: Constant.amountShow(amount: revenue.toString()), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.user)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .where('role', isEqualTo: Constant.customerRole)
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CoinTile(icon: 'assets/icons/all_person.svg', title: 'Total Customer', value: snapshot.data!.docs.length.toString(), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.restaurants)
                .doc(CollectionName.restaurantId)
                .collection(CollectionName.user)
                .where("branchId", isEqualTo: controller.selectedBranchModel.value.id)
                .where('role', isEqualTo: Constant.employeeRole)
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CoinTile(icon: 'assets/icons/all_person.svg', title: 'Total Employee', value: snapshot.data!.docs.length.toString(), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        // ContainerCustom(
        //   alignment: Alignment.centerLeft,
        //   child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //     future: FireStoreUtils.fireStore.collection(CollectionName.item).get(),
        //     builder: (context, snapshot) {
        //       switch (snapshot.connectionState) {
        //         case ConnectionState.waiting:
        //           return Constant.loader(context);
        //         default:
        //           if (snapshot.hasError) {
        //             print(snapshot.error);
        //             return Text('Error: ${snapshot.error}');
        //           } else {
        //             return CoinTile(icon: 'assets/icons/pizza_5.svg', title: 'Total Items', value: snapshot.data!.docs.length.toString(), color: AppThemeData.crusta400);
        //           }
        //       }
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class FeaturedItemWidget extends StatelessWidget {
  final HomeBranchController controller;

  const FeaturedItemWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return ContainerCustom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: TextCustom(title: 'Featured Item', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
            ],
          ),
          spaceH(height: 15),
          FutureBuilder<List<ItemModel>?>(
            future: FireStoreUtils.getFeaturedItem(), // async work
            builder: (BuildContext context, AsyncSnapshot<List<ItemModel>?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const TextCustom(
                    title: 'Loading...',
                    color: AppThemeData.pickledBluewood500,
                    fontFamily: AppThemeData.regular,
                    textAlign: TextAlign.start,
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          ItemModel itemModel = snapshot.data![index];
                          return SizedBox(
                            width: Responsive.width(20, context),
                            child: ContainerCustom(
                              radius: 10,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    child: NetworkImageWidget(
                                      imageUrl: itemModel.image ?? '',
                                      placeHolderUrl: Constant.userPlaceholderURL,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: Responsive.height(100, context),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(title: itemModel.name ?? ''),
                                          spaceH(height: 4),
                                          TextCustom(title: Constant.amountShow(amount: itemModel.price ?? '0')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}

class RecentOrderWidget extends StatelessWidget {
  final HomeBranchController controller;

  const RecentOrderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return ContainerCustom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: TextCustom(title: 'Recent Orders', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
            ],
          ),
          spaceH(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: controller.orderDataList.isEmpty || controller.isOrderLoading.value
                ? Constant.loaderWithNoFound(context, isLoading: controller.isOrderLoading.value, isNotFound: controller.orderDataList.isEmpty)
                : ClipRRect(
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
                          const DataColumn(
                              label: SizedBox(
                            width: 100,
                            child: TextCustom(title: 'Order ID'),
                          )),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.1,
                              child: const TextCustom(title: 'Order Type'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 160 : Responsive.width(15, context),
                              child: const TextCustom(title: 'Customer'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 120 : Responsive.width(10, context),
                              child: const TextCustom(title: 'Amount'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.1,
                              child: const TextCustom(title: 'Status'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 120 : Responsive.width(14, context),
                              child: const TextCustom(title: 'Date and Time'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05,
                              child: const TextCustom(title: 'Actions'),
                            ),
                          )
                        ],
                        rows: controller.orderDataList
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(InkWell(
                                      onTap: () {
                                        DashBoardController dashBoardController = Get.find<DashBoardController>();
                                        OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                        dashBoardController.changeView(screenType: "order");
                                        orderDetailsController.setOrderModel(e);
                                      },
                                      child: TextCustom(
                                        title: Constant.orderId(orderId: e.id.toString()),
                                        color: AppThemeData.crusta500,
                                      ))),
                                  DataCell(
                                    Row(
                                      children: [
                                        spaceW(),
                                        Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: controller.selectColorByOrderType(order: e.type ?? ''))),
                                        spaceW(width: 5),
                                        TextCustom(title: capitalize(e.type ?? ''), color: controller.selectColorByOrderType(order: e.type ?? ''))
                                      ],
                                    ),
                                  ),
                                  DataCell(TextCustom(title: e.type == "customer" ? "No user" : capitalize(e.customer?.name ?? ''))),
                                  DataCell(TextCustom(title: Constant.amountShow(amount: e.total ?? ''))),
                                  DataCell(Container(
                                      height: 40,
                                      width: 120,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: controller.selectColorByOrderStatus(order: e.status ?? '')),
                                          color: controller.selectColorByOrderStatus(order: e.status ?? '').withAlpha(50)),
                                      child: TextCustom(title: e.status ?? '', fontSize: 12, color: controller.selectColorByOrderStatus(order: e.status ?? '')))),
                                  DataCell(TextCustom(title: DateFormat('dd-MM-yyyy HH:mm:a').format(e.createdAt!.toDate()))),
                                  DataCell(
                                    Row(
                                      children: [
                                        spaceW(),
                                        IconButton(
                                          onPressed: () {
                                            DashBoardController dashBoardController = Get.find<DashBoardController>();
                                            OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                            dashBoardController.changeView(screenType: "order");
                                            orderDetailsController.setOrderModel(e);
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 20,
                                          ),
                                        ),
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
  }
}

class CoinTile extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  // final String percentage;
  final Color color;

  const CoinTile({super.key, required this.icon, required this.title, required this.value, required this.color}); // required this.percentage,

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(icon, width: 22, height: 22),
        ),
        spaceH(height: 15),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: TextCustom(title: title, fontSize: Responsive.isMobile(context) ? 14 : 16, fontFamily: AppThemeData.regular)),
        spaceH(height: 5),
        TextCustom(title: value, fontSize: Responsive.isMobile(context) ? 16 : 18, fontFamily: AppThemeData.bold),
      ],
    );
  }
}

// areaSaleGraph({required Color color, required double height, required HomeController controller, required bool isDarkModel}) {
//   return SizedBox(
//     height: height,
//     child: SfCartesianChart(
//         plotAreaBorderWidth: 0.0,
//         primaryXAxis: CategoryAxis(
//           opposedPosition: true,
//           isVisible: true,
//           axisLabelFormatter: (axisLabelRenderArgs) {
//             final String text = DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(axisLabelRenderArgs.value.toInt()));
//             TextStyle style = TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium);
//             return ChartAxisLabel(text, style);
//           },
//         ),
//         primaryYAxis: NumericAxis(
//             labelPosition: ChartDataLabelPosition.outside,
//             crossesAt: 0,
//             isVisible: true,
//             labelStyle: TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium)),
//         series: <CartesianSeries>[
//           SplineAreaSeries<OrderModel, dynamic>(
//               borderWidth: 2,
//               borderColor: color,
//               dataSource: controller.saleData,
//               gradient: LinearGradient(colors: [color.withAlpha(50), color.withAlpha(200), color], stops: const [1, 0.5, 0.3]),
//               xValueMapper: (OrderModel data, _) => DateFormat.MMMd().format(data.updatedAt!.toDate()),
//               yValueMapper: (OrderModel data, _) => double.parse('${data.total ?? 0}'))
//         ]),
//   );
// }

areaRevenueGraph({required Color color, required double height, required bool isDarkModel, required HomeBranchController controller}) {
  return SfCartesianChart(
      primaryXAxis: DateTimeCategoryAxis(
          interval: 1,
          dateFormat: graphDate(time: controller.selectRevenueCalender.value),
          isVisible: true,
          borderColor: Colors.transparent,
          labelStyle: TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
      primaryYAxis: NumericAxis(borderColor: Colors.transparent, labelStyle: TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
      series: <CartesianSeries>[
        SplineSeries<OrderData, dynamic>(
            splineType: SplineType.natural,
            cardinalSplineTension: 0.9,
            color: color,
            dataSource: controller.saleRevenueData,
            xValueMapper: (OrderData data, _) => data.date,
            yValueMapper: (OrderData data, _) => data.amount)
      ]);
}

areaCustomerGraph({required Color color, required double height, required bool isDarkModel, required HomeBranchController controller}) {
  return SfCartesianChart(
      primaryXAxis: DateTimeCategoryAxis(
          interval: 1,
          dateFormat: graphDate(time: controller.selectCustomerCalender.value),
          borderColor: Colors.transparent,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelStyle: TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
      primaryYAxis: NumericAxis(labelStyle: TextStyle(color: isDarkModel ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
      series: <CartesianSeries>[
        SplineSeries<CustomerData, dynamic>(
            splineType: SplineType.natural,
            cardinalSplineTension: 0.9,
            color: color,
            dataSource: controller.customerListData,
            xValueMapper: (CustomerData data, _) => data.date,
            yValueMapper: (CustomerData data, _) => data.customer)
      ]);
}

class CustomerGraphWidget extends StatelessWidget {
  const CustomerGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: HomeBranchController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextCustom(title: 'Total Customers', fontSize: 18, fontFamily: AppThemeData.medium),
                    SizedBox(
                      width: 130,
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.calendar_month,
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                        ),
                        style: TextStyle(
                          fontFamily: AppThemeData.medium,
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                        ),
                        value: controller.selectCustomerCalender.value,
                        hint: const TextCustom(title: 'Select'),
                        onChanged: (String? newValue) {
                          controller.selecteCalenderForCustomer(newValue!);
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
                        items: controller.calendarList.map<DropdownMenuItem<String>>((value) {
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
                  ],
                ),
                spaceH(height: 10),
                TextCustom(title: controller.customerListData.length.toString(), fontSize: 18, fontFamily: AppThemeData.medium),
                spaceH(height: 20),
                areaCustomerGraph(color: const Color(0xff736CE8), height: 300, isDarkModel: themeChange.getThem(), controller: controller),
              ],
            ),
          );
        });
  }
}

class DailyRevenueWidget extends StatelessWidget {
  const DailyRevenueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: HomeBranchController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextCustom(title: 'Daily Revenue', fontSize: 18, fontFamily: AppThemeData.medium),
                    SizedBox(
                      width: 130,
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.calendar_month,
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                        ),
                        value: controller.selectRevenueCalender.value,
                        style: TextStyle(
                          fontFamily: AppThemeData.medium,
                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                        ),
                        hint: const TextCustom(title: 'Select'),
                        onChanged: (String? newValue) {
                          controller.selecteCalenderForRevenue(newValue!);
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
                        items: controller.calendarList.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: TextCustom(
                              title: value,
                              color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                              fontFamily: AppThemeData.medium,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                spaceH(),
                TextCustom(title: Constant.amountShow(amount: controller.revenue.value.toString()), fontSize: 18, fontFamily: AppThemeData.medium),
                spaceH(height: 20),
                areaRevenueGraph(color: const Color(0xff736CE8), height: 300, isDarkModel: themeChange.getThem(), controller: controller),
              ],
            ),
          );
        });
  }
}
