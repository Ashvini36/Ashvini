import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/app/model/model.dart';
import 'package:scaneats_owner/app/model/owner_model.dart';
import 'package:scaneats_owner/app/ui/home_screen/navigate_home_screen.dart';
import 'package:scaneats_owner/app/ui/login_screen/login_screen.dart';
import 'package:scaneats_owner/app/ui/restaurant_screens/navigate_restaurant_screen.dart';
import 'package:scaneats_owner/app/ui/settings_screen/navigate_settings_screen.dart';
import 'package:scaneats_owner/app/ui/subscription_list/navigate_subscription_screen.dart';
import 'package:scaneats_owner/app/ui/subscription_report_screen/navigate_sales_report_screen.dart';
import 'package:scaneats_owner/constant/collection_name.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class DashBoardController extends GetxController {
  RxInt selectedDrawerIndex = 0.obs;
  RxString orderViewType = "".obs;
  RxBool isLoading = true.obs;

  changeView({required String screenType}) {
    orderViewType.value = screenType;
  }

  //Drawer
  List<DrawerItem> drawerItems = [
    DrawerItem(title: 'Dashboard', icon: "assets/icons/one.svg", widget: const NavigateHomeScreen(), isVisible: true),
    DrawerItem(title: 'Restaurant', icon: "assets/icons/three.svg", widget: const NavigateRestaurantScreen(), isVisible: true),
    DrawerItem(title: 'Subscription', icon: "assets/icons/seven.svg", widget: const NavigateSubscriptionScreen(), isVisible: true),
    DrawerItem(title: 'Subscription Report', icon: "assets/icons/twelve.svg", widget: const NavigateSubscriptionReportScreen(), isVisible: true),
    DrawerItem(title: 'Settings', icon: "assets/icons/fifteen.svg", widget: const NavigateSettingsScreen(), isVisible: true)
  ];

  onSelectItem(int index) async {
    if (index == 19) {
      await FirebaseAuth.instance.signOut();
      Get.offAll(const LoginScreen());
    } else {
      selectedDrawerIndex.value = index;
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

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  getArgument() async {
    await FireStoreUtils.fireStore.collection(CollectionName.owner).doc('owner').get().then((value) {
      if (value.exists) {
        ownerModel.value = OwnerModel.fromJson(value.data()!);
        print(value.data());
      }
    });
    LanguageModel languageModel = Constant.getLanguage();
    for (var element in Constant.lngList) {
      if (element.code == languageModel.code) {
        selectedLng.value = element;
      }
    }
    isLoading.value = false;
  }

  setThme({required DarkThemeProvider themeChange}) {
    if (themeChange.darkTheme == 1) {
      themeChange.darkTheme = 0;
    } else {
      themeChange.darkTheme = 1;
    }
  }
}
