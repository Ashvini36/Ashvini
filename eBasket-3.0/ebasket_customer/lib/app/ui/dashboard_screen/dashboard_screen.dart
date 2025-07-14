import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/dashbaord_controller.dart';
import 'package:ebasket_customer/app/ui/favourite_screen/favourite_screen.dart';
import 'package:ebasket_customer/app/ui/setting_screen/setting_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_screen/view_all_category_screen.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.white,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10),
            decoration: const BoxDecoration(
              color: AppThemeData.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 20,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: AppThemeData.groceryAppDarkBlue,
                elevation: 15,
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: AppThemeData.white,
                type: BottomNavigationBarType.fixed,
                unselectedFontSize: 12,
                selectedLabelStyle: TextStyle(fontSize: 14, color: AppThemeData.groceryAppDarkBlue),
                unselectedLabelStyle: const TextStyle(fontSize: 0),
                currentIndex: controller.selectedIndex.value,
                unselectedIconTheme: const IconThemeData(size: 26),
                selectedIconTheme: IconThemeData(size: 26, color: AppThemeData.groceryAppDarkBlue),
                selectedFontSize: 0,
                onTap: (v) {
                  controller.selectedIndex.value = 0;
                  if (v == 1) {
                    Get.to(const ViewAllCategoryListScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                      controller.homeController.getData();
                      controller.homeController.getFavoriteData();
                    });
                  } else if (v == 2) {
                    Get.to(const FavouriteScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                      controller.homeController.getData();
                      controller.homeController.getFavoriteData();
                    });
                  } else if (v == 3) {
                    Get.to(const SettingScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                      controller.homeController.getData();
                      controller.homeController.getUserData();
                    });
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/icons/ic_home.svg"),
                    label: "",
                    activeIcon: Container(
                        decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/ic_home.svg",
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.white,
                            BlendMode.srcIn,
                          ),
                        )),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/icons/ic_category.svg"),
                    label: "",
                    activeIcon: Container(
                        decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/ic_category.svg",
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.white,
                            BlendMode.srcIn,
                          ),
                        )),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Center(child: SvgPicture.asset("assets/icons/ic_union.svg")),
                        controller.homeController.listFav.isNotEmpty
                            ? Positioned(
                                right: 30,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    controller.homeController.listFav.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                    label: "",
                    activeIcon: Container(
                        decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/ic_union.svg",
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.white,
                            BlendMode.srcIn,
                          ),
                        )),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset("assets/icons/ic_profile.svg"),
                    label: "",
                    activeIcon: Container(
                        decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          "assets/icons/ic_profile.svg",
                          colorFilter: const ColorFilter.mode(
                            AppThemeData.white,
                            BlendMode.srcIn,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          body: (controller.selectedIndex.value == 0) ? controller.listOfScreen[controller.selectedIndex.value] : null,
        );
      },
    );
  }
}
