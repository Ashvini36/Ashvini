import 'dart:async';
import 'dart:developer';

import 'package:store/app/auth_screen/login_screen.dart';
import 'package:store/app/dash_board_screens/app_not_access_screen.dart';
import 'package:store/app/dash_board_screens/dash_board_screen.dart';
import 'package:store/app/on_boarding_screen.dart';
import 'package:store/app/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:store/constant/constant.dart';
import 'package:store/models/user_model.dart';
import 'package:store/utils/fire_store_utils.dart';
import 'package:store/utils/notification_service.dart';
import 'package:store/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
      Get.offAll(const OnBoardingScreen());
    } else {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
          if (value != null) {
            UserModel userModel = value;
            log(userModel.toJson().toString());
            if (userModel.role == Constant.userRoleVendor) {
              if (userModel.active == true) {
                userModel.fcmToken = await NotificationService.getToken();
                await FireStoreUtils.updateUser(userModel);
                bool isPlanExpire = false;
                if (userModel.subscriptionPlan?.id != null) {
                  if (userModel.subscriptionExpiryDate == null) {
                    if (userModel.subscriptionPlan?.expiryDay == '-1') {
                      isPlanExpire = false;
                    } else {
                      isPlanExpire = true;
                    }
                  } else {
                    DateTime expiryDate = userModel.subscriptionExpiryDate!.toDate();
                    isPlanExpire = expiryDate.isBefore(DateTime.now());
                  }
                } else {
                  isPlanExpire = true;
                }
                if (userModel.subscriptionPlanId == null || isPlanExpire == true) {
                  if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                    Get.offAll(const DashBoardScreen());
                  } else {
                    Get.offAll(const SubscriptionPlanScreen());
                  }
                } else if (userModel.subscriptionPlan?.features?.restaurantMobileApp == true) {
                  Get.offAll(const DashBoardScreen());
                } else {
                  Get.offAll(const AppNotAccessScreen());
                }
              } else {
                await FirebaseAuth.instance.signOut();
                Get.offAll(const LoginScreen());
              }
            } else {
              await FirebaseAuth.instance.signOut();
              Get.offAll(const LoginScreen());
            }
          }
        });
      } else {
        await FirebaseAuth.instance.signOut();
        Get.offAll(const LoginScreen());
      }
    }
  }
}
