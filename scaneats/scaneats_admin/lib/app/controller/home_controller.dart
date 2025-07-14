import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:scaneats/widgets/global_widgets.dart';

class HomeController extends GetxController {
  RxString title = "Home".obs;

  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    callData();
  }

  Rx<BranchModel> selectedBranchModel = BranchModel().obs;
  callData({BranchModel? branch}) {
    if (branch?.id != null) {
      selectedBranchModel.value = branch!;
    } else {
      selectedBranchModel.value = Constant.selectedBranch;
    }
    print("=============>");
    print(selectedBranchModel.value.id);
    getOrdereData();
    selecteCalenderForCustomer('Year');
    selecteCalenderForRevenue('Year');
    isLoading.value = false;
  }

  RxList calendarList = ['Year', 'Month'].obs;
  RxString selectCustomerCalender = 'Year'.obs;
  RxString selectRevenueCalender = 'Year'.obs;

  selecteCalenderForRevenue(String select) async {
    selectRevenueCalender.value = select;
    DateTime date = selectDateTime(select);
    await getSalesRevenueData(Timestamp.fromDate(date)).then((v) {
      update();
    });
  }

  selecteCalenderForCustomer(String select) async {
    selectCustomerCalender.value = select;
    DateTime date = selectDateTime(select);

    await getCustomerData(Timestamp.fromDate(date)).then((v) {
      update();
    });
  }

  RxList<CustomerData> customerListData = <CustomerData>[].obs;
  RxString totalCustomer = '0'.obs;

  getCustomerData(Timestamp selectedTime) async {
    customerListData.clear();
    await FireStoreUtils.getAllCustomerByTimeWithoutBranch(selectedTime).then((userData) async {
      totalCustomer.value = "${userData?.length ?? '0'}";
      customerListData.value = combineCustomer(userData!);
      printLog("CUSTOMER MODEL customerListData :: ${customerListData.length}");
    });
  }

  RxList<OrderData> saleRevenueData = <OrderData>[].obs;
  RxDouble revenue = 0.0.obs;

  getSalesRevenueData(Timestamp selectedTime) async {
    revenue.value = 0.0;
    await FireStoreUtils.getAllOrderByTimeWithoutBranch(selectedTime).then((value) {
      saleRevenueData.value = combineOrders(value!);
      for (var order in saleRevenueData) {
        revenue.value = revenue.value + double.parse('${order.amount}');
      }
    });
  }

  List<OrderData> combineOrders(List<OrderModel> orders) {
    printLog("RevenueData 00 :: ${orders.length}");
    Map<DateTime, OrderData> combinedMap = {};

    for (var order in orders) {
      DateTime time = dateTimeToDate(order.createdAt!.toDate(), selectRevenueCalender);
      if (combinedMap.containsKey(time)) {
        combinedMap[time]!.amount += double.parse(order.total!);
      } else {
        combinedMap[time] = OrderData(date: time, amount: double.parse(order.total!));
      }
    }
    List<OrderData> combinedOrders = combinedMap.values.toList();
    printLog("RevenueData 11 :: ${combinedOrders.length}");
    return combinedOrders;
  }

  List<CustomerData> combineCustomer(List<UserModel> userList) {
    printLog("Customer 00 :: ${userList.length}");
    Map<DateTime, CustomerData> combinedMap = {};

    for (var user in userList) {
      DateTime time = dateTimeToDate(user.createdAt!.toDate(), selectCustomerCalender);
      if (combinedMap.containsKey(time)) {
        combinedMap[time]!.customer += 1;
      } else {
        combinedMap[time] = CustomerData(date: time, customer: 1);
      }
    }
    List<CustomerData> combinedOrders = combinedMap.values.toList();
    return combinedOrders;
  }

  RxBool isOrderLoading = false.obs;
  RxList<OrderModel> orderDataList = <OrderModel>[].obs;

  Future<void> getOrdereData() async {
    isOrderLoading.value = true;
    orderDataList.clear();
    await FireStoreUtils.getAllOrderWithoutBranch().then((value) {
      if (value != null) {
        if (value.length > 5) {
          orderDataList.value = value.sublist(0, 5);
        }
      }
      isOrderLoading.value = false;
      update();
    });
  }

  Color selectColorByOrderType({required String order}) {
    if (order == Constant.orderTypePos) {
      return const Color(0XFFF0A42F);
    } else {
      return const Color(0XFF888AF1);
    }
  }

  Color selectColorByOrderStatus({required String order}) {
    if (order == Constant.statusOrderPlaced) {
      return const Color(0XFF888AF1);
    } else if (order == Constant.statusDelivered) {
      return AppThemeData.forestGreen600;
    } else if (order == Constant.statusAccept) {
      return const Color(0xff008000);
    } else if (order == Constant.statusPending) {
      return const Color(0XFF888AF1);
    } else if (order == Constant.statusRejected) {
      return Colors.red;
    } else {
      return const Color(0XFFF0A42F);
    }
  }
}
