import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/model/model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/app/ui/administrators_screen/navigate_administrators_screen.dart';
import 'package:scaneats/app/ui/customers_screen/navigate_customers__screen.dart';
import 'package:scaneats/app/ui/dining_table_screen/navigate_dining_table_screen.dart';
import 'package:scaneats/app/ui/employees_screen/navigate_employees__screen.dart';
import 'package:scaneats/app/ui/home_branch_screen/navigate_home_branch_screen.dart';
import 'package:scaneats/app/ui/home_screen/navigate_home_screen.dart';
import 'package:scaneats/app/ui/item_screen/navigate_item_screen.dart';
import 'package:scaneats/app/ui/login_screen/login_screen.dart';
import 'package:scaneats/app/ui/offers_screen/navigate_offer_screen.dart';
import 'package:scaneats/app/ui/pos_order_screen/navigate_pos_order_screen.dart';
import 'package:scaneats/app/ui/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats/app/ui/pos_table_screen/navigate_pos_table_screen.dart';
import 'package:scaneats/app/ui/sales_report_screen/navigate_sales_report_screen.dart';
import 'package:scaneats/app/ui/settings_screen/navigate_settings_screen.dart';
import 'package:scaneats/app/ui/subscription_screen/navigate_subscription_screen.dart';
import 'package:scaneats/app/ui/table_order_screen/navigate_table_order_screen.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:scaneats/utils/notification_service.dart';

class DashBoardController extends GetxController {
  RxInt selectedDrawerIndex = 0.obs;
  RxString orderViewType = "".obs;
  RxBool isLoading = true.obs;

  changeView({required String screenType}) {
    orderViewType.value = screenType;
  }

  //Drawer
  List<DrawerItem> drawerItems = [];

  onSelectItem(int index) async {
    if (index == 19) {
      await FirebaseAuth.instance.signOut();
      Get.offAll(const LoginScreen());
    } else {
      selectedDrawerIndex.value = index;
      searchController.value.clear();
    }
    Get.back();
  }

  Rx<DateTime> currentBackPressTime = DateTime.now().obs;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime.value) > const Duration(seconds: 2)) {
      currentBackPressTime.value = now;
      ShowToastDialog.showToast("Double press to exit", position: EasyLoadingToastPosition.center);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Rx<LanguageModel> selectedLng = LanguageModel().obs;
  var searchController = TextEditingController().obs;
  Rx<UserModel> user = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  getArgument() async {
    await FireStoreUtils.getUserById(Preferences.getString(Preferences.user)).then((value) async {
      if (value != null) {
        user.value = value;
      } else {
        await FirebaseAuth.instance.signOut();
        Preferences.clearSharPreference();
        Get.offAll(const LoginScreen());
      }
    });

    await FireStoreUtils.getRestaurantById(restaurantId: CollectionName.restaurantId).then((value) {
      if (value != null) {
        Constant.restaurantModel = value;
      }
    });

    print("=======>");
    print(user.value.roleId);
    await FireStoreUtils.getAllRole().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.selectedRole = value.singleWhere((element) => element.id == user.value.roleId);
        }
      }
    });

    await FireStoreUtils.getRoleForAdmin().then((value) {
      if (value != null) {
        Constant.adminPermissionID = value;
      }
    });

    if (user.value.roleId == Constant.adminPermissionID) {
      if (Constant.checkCurrentPlanActive(Constant.restaurantModel.subscribed) == true) {
        drawerItems = [
          DrawerItem(title: 'Dashboard', icon: "assets/icons/one.svg", widget: const NavigateHomeScreen(), isVisible: true),
          DrawerItem(title: 'Branch Dashboard', icon: "assets/icons/one.svg", widget: const NavigateHomeBranchScreen(), isVisible: true),
          DrawerItem(title: 'Items', icon: "assets/icons/two.svg", widget: const NavigateItemScreen(), isVisible: true),
          DrawerItem(title: 'Dining Tables', icon: "assets/icons/three.svg", widget: const NavigateDiningTableScreen(), isVisible: true),
          DrawerItem(title: 'Takeaway & ORDERS', isVisible: true),
          DrawerItem(title: 'Takeaway', icon: "assets/icons/four.svg", widget: const NavigatePosScreen(), isVisible: true),
          DrawerItem(title: 'Takeaway Orders', icon: "assets/icons/five.svg", widget: const NavigatePosOrderScreen(), isVisible: true),
          DrawerItem(title: 'POS Table Orders', icon: "assets/icons/four.svg", widget: const NavigatePosTableScreen(), isVisible: true),
          DrawerItem(title: 'Table Orders', icon: "assets/icons/six.svg", widget: const NavigateTableOrderScreen(), isVisible: true),
          DrawerItem(title: 'PROMO CODS', isVisible: true),
          DrawerItem(title: 'Offers', icon: "assets/icons/seven.svg", widget: const NavigateOfferScreen(), isVisible: true),
          DrawerItem(title: 'USERS', isVisible: true),
          DrawerItem(title: 'Administrators', icon: "assets/icons/eight.svg", widget: const NavigateAdministratorsScreen(), isVisible: true),
          DrawerItem(title: 'Customers', icon: "assets/icons/nine.svg", widget: const NavigateCustomerScreen(), isVisible: true),
          DrawerItem(title: 'Employees', icon: "assets/icons/ten.svg", widget: const NavigateEmployeesScreen(), isVisible: true),
          DrawerItem(title: 'REPORTS', isVisible: true),
          DrawerItem(title: 'Sales Report', icon: "assets/icons/twelve.svg", widget: const NavigateSalesReportScreen(), isVisible: true),
          DrawerItem(title: 'SETUP', isVisible: true),
          DrawerItem(title: 'Subscription', icon: "assets/icons/seven.svg", widget: const NavigateSubscriptionScreen(), isVisible: true),
          DrawerItem(
              title: 'Settings',
              icon: "assets/icons/fifteen.svg",
              widget: const NavigateSettingsScreen(),
              isVisible: user.value.restaurantId == CollectionName.restaurantId ? true : false)
        ];
      } else {
        drawerItems = [
          DrawerItem(title: 'REPORTS', isVisible: true),
          DrawerItem(title: 'Sales Report', icon: "assets/icons/twelve.svg", widget: const NavigateSalesReportScreen(), isVisible: true),
          DrawerItem(title: 'SETUP', isVisible: true),
          DrawerItem(title: 'Subscription', icon: "assets/icons/seven.svg", widget: const NavigateSubscriptionScreen(), isVisible: true),
          DrawerItem(
              title: 'Settings',
              icon: "assets/icons/fifteen.svg",
              widget: const NavigateSettingsScreen(),
              isVisible: user.value.restaurantId == CollectionName.restaurantId ? true : false)
        ];
      }
    } else {
      if (Constant.checkCurrentPlanActive(Constant.restaurantModel.subscribed) == true) {
        drawerItems = [
          DrawerItem(title: 'Dashboard', icon: "assets/icons/one.svg", widget: const NavigateHomeBranchScreen(), isVisible: true),
          DrawerItem(
              title: 'Items',
              icon: "assets/icons/two.svg",
              widget: const NavigateItemScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isView),
          DrawerItem(
              title: 'Dining Tables',
              icon: "assets/icons/three.svg",
              widget: const NavigateDiningTableScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Dining Tables").isView),
          DrawerItem(title: 'Takeaway & ORDERS', isVisible: true),
          DrawerItem(title: 'Takeaway', icon: "assets/icons/four.svg", widget: const NavigatePosScreen(), isVisible: true),
          DrawerItem(title: 'Takeaway Orders', icon: "assets/icons/five.svg", widget: const NavigatePosOrderScreen(), isVisible: true),
          DrawerItem(title: 'POS Table Orders', icon: "assets/icons/four.svg", widget: const NavigatePosTableScreen(), isVisible: true),
          DrawerItem(title: 'Table Orders', icon: "assets/icons/six.svg", widget: const NavigateTableOrderScreen(), isVisible: true),
          DrawerItem(title: 'PROMO CODS', isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Offers").isView),
          DrawerItem(
              title: 'Offers',
              icon: "assets/icons/seven.svg",
              widget: const NavigateOfferScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Offers").isView),
          DrawerItem(
              title: 'USERS',
              isVisible: (Constant.selectedRole.permission!.firstWhere((element) => element.title == "Administrators").isView == true ||
                  Constant.selectedRole.permission!.firstWhere((element) => element.title == "Customers").isView == true ||
                  Constant.selectedRole.permission!.firstWhere((element) => element.title == "Employees").isView == true)),
          DrawerItem(
              title: 'Administrators',
              icon: "assets/icons/eight.svg",
              widget: const NavigateAdministratorsScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Administrators").isView),
          DrawerItem(
              title: 'Customers',
              icon: "assets/icons/nine.svg",
              widget: const NavigateCustomerScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Customers").isView),
          DrawerItem(
              title: 'Employees',
              icon: "assets/icons/ten.svg",
              widget: const NavigateEmployeesScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Employees").isView),
          DrawerItem(title: 'REPORTS', isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Sales Report").isView),
          DrawerItem(
              title: 'Sales Report',
              icon: "assets/icons/twelve.svg",
              widget: const NavigateSalesReportScreen(),
              isVisible: Constant.selectedRole.permission!.firstWhere((element) => element.title == "Sales Report").isView),
        ];
      } else {
        drawerItems = [
          DrawerItem(title: 'REPORTS', isVisible: true),
          DrawerItem(title: 'Sales Report', icon: "assets/icons/twelve.svg", widget: const NavigateSalesReportScreen(), isVisible: true),
          DrawerItem(title: 'SETUP', isVisible: true),
          DrawerItem(title: 'Subscription', icon: "assets/icons/seven.svg", widget: const NavigateSubscriptionScreen(), isVisible: true),
          DrawerItem(
              title: 'Settings',
              icon: "assets/icons/fifteen.svg",
              widget: const NavigateSettingsScreen(),
              isVisible: user.value.restaurantId == CollectionName.restaurantId ? true : false)
        ];
      }
    }

    await FireStoreUtils.getActiveBranch().then((value) {
      if (value != null) {
        if (user.value.branchId!.isNotEmpty) {
          Constant.allBranch = value.where((element) => element.id == user.value.branchId).toList();
        } else {
          Constant.allBranch = value;
        }
        if (Constant.allBranch.isNotEmpty) {
          Constant.selectedBranch = Constant.allBranch.first;
        }
      }
    });

    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      for (var element in Constant.lngList) {
        if (element.code == languageModel.code) {
          selectedLng.value = element;
        }
      }
    } else {
      selectedLng.value = Constant.lngList.first;
    }

    isLoading.value = false;

    String token = await NotificationService.getToken();
    user.value.fcmToken = token;
    await FireStoreUtils.setUserModel(user.value);
    log(":::::::TOKEN:::::: $token");
  }

  setThme({required DarkThemeProvider themeChange}) {
    if (themeChange.darkTheme == 1) {
      themeChange.darkTheme = 0;
    } else {
      themeChange.darkTheme = 1;
    }
  }
}
