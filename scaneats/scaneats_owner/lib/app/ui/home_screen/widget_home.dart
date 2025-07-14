import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/home_controller.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/constant/collection_name.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

Widget dashboardTitleWidget(context) {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
        TextCustom(title: 'Manage your restaurant, Subscription', fontSize: 14, fontFamily: AppThemeData.regular),
      ]),
    ],
  );
}

class TotalCountWidget extends StatelessWidget {
  final HomeController controller;
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
          alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore.collection(CollectionName.restaurants).get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CoinTile(icon: 'assets/icons/ic_restaurant.svg', title: "Total Restaurant", value: '${snapshot.data!.docs.length}', color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
            alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore.collection(CollectionName.restaurants).get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<RestaurantModel> restaurantList = [];
                    for (var element in snapshot.data!.docs) {
                      RestaurantModel model = RestaurantModel.fromJson(element.data());
                      if (Constant.checkSubscription(model.subscribed) == true) {
                        restaurantList.add(model);
                      }
                    }
                    return CoinTile(icon: 'assets/icons/ic_restaurant.svg', title: "Subscribed Restaurant", value: '${restaurantList.length}', color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
            alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore.collection(CollectionName.restaurants).get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Constant.loader(context);
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<RestaurantModel> restaurantList = [];
                    for (var element in snapshot.data!.docs) {
                      RestaurantModel model = RestaurantModel.fromJson(element.data());
                      if (Constant.checkSubscription(model.subscribed) == false) {
                        restaurantList.add(model);
                      }
                    }
                    return CoinTile(icon: 'assets/icons/ic_restaurant.svg', title: "Expired Restaurant", value: '${restaurantList.length}', color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
            alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.subscriptionTransaction)
                .where('startDate', isGreaterThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0)))
                .where('startDate', isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0)))
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
                      SubscriptionTransaction model = SubscriptionTransaction.fromJson(element.data());
                      if (model.subscription!.planName != "Trial") {
                        if (model.durations!.strikePrice!.isEmpty || model.durations!.strikePrice == "0") {
                          revenue = revenue + double.parse(model.durations!.planPrice ?? "0");
                        } else {
                          revenue = revenue + double.parse(model.durations!.strikePrice ?? "0");
                        }
                      }
                    }
                    return CoinTile(
                        icon: 'assets/icons/dollar_sign_2.svg', title: "Today revenue", value: Constant.amountShow(amount: revenue.toString()), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
            alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore
                .collection(CollectionName.subscriptionTransaction)
                .where('startDate',
                    isGreaterThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0).subtract(const Duration(days: 30))))
                .where('startDate', isLessThan: Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0)))
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
                      SubscriptionTransaction model = SubscriptionTransaction.fromJson(element.data());
                      if (model.subscription!.planName != "Trial") {
                        if (model.durations!.strikePrice!.isEmpty || model.durations!.strikePrice == "0") {
                          revenue = revenue + double.parse(model.durations!.planPrice ?? "0");
                        } else {
                          revenue = revenue + double.parse(model.durations!.strikePrice ?? "0");
                        }
                      }
                    }
                    return CoinTile(
                        icon: 'assets/icons/dollar_sign_2.svg', title: 'Monthly revenue', value: Constant.amountShow(amount: revenue.toString()), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
        ContainerCustom(
            alignment: TextDirection.rtl == Directionality.of(context) ? Alignment.centerRight : Alignment.centerLeft,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FireStoreUtils.fireStore.collection(CollectionName.subscriptionTransaction).get(),
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
                      SubscriptionTransaction model = SubscriptionTransaction.fromJson(element.data());
                      if (model.subscription!.planName != "Trial") {
                        if (model.durations!.strikePrice!.isEmpty || model.durations!.strikePrice == "0") {
                          revenue = revenue + double.parse(model.durations!.planPrice ?? "0");
                        } else {
                          revenue = revenue + double.parse(model.durations!.strikePrice ?? "0");
                        }
                      }
                    }
                    return CoinTile(
                        icon: 'assets/icons/dollar_sign_2.svg', title: 'Total revenue', value: Constant.amountShow(amount: revenue.toString()), color: AppThemeData.crusta400);
                  }
              }
            },
          ),
        ),
      ],
    );
  }
}

class RecentOrderWidget extends StatelessWidget {
  final HomeController controller;

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
              Expanded(child: TextCustom(title: 'Recent Subscription Transaction', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
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
                              child: TextCustom(title: 'Subscription Status'),
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
                        rows: controller.orderDataList
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
                                            }else if(snapshot.data == null){
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
                                      title:
                                          e.durations!.name == "Trial Plan" ? Constant.amountShow(amount: "0.0") : Constant.amountShow(amount: e.durations!.planPrice.toString()),
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
