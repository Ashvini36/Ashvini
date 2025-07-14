import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/favourite_screen/favourite_screen.dart';
import 'package:ebasket_customer/app/ui/home_screen/home_screen.dart';
import 'package:ebasket_customer/app/ui/setting_screen/setting_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_screen/view_all_category_screen.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;

  HomeController homeController = Get.put(HomeController());

  RxList<Widget> listOfScreen = <Widget>[
    const HomeScreen(),
    const ViewAllCategoryListScreen(),
    const FavouriteScreen(),
    const SettingScreen(),
  ].obs;

}
