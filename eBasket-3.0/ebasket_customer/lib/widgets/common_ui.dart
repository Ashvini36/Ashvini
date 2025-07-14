import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class CommonUI {
  static AppBar customAppBar(
    BuildContext context, {
    Widget? title,
    bool isBack = true,
    Color? backgroundColor,
    Color? iconColor,
    Color textColor = AppThemeData.black,
    List<Widget>? actions,
    Function()? onBackTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isBack
              ? InkWell(
                  onTap: onBackTap ??
                      () {
                        Get.back();
                      },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 16),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          "assets/icons/ic_arrow_back1.svg",
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            width: isBack == true ? 0 : 16,
          ),
          title ??
              Text(
                "",
                style: TextStyle(color: textColor, fontFamily: AppThemeData.semiBold, fontSize: 18),
              ),
        ],
      ),
      backgroundColor: AppThemeData.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false ,
      surfaceTintColor: AppThemeData.white,
      actions: actions,
    );
  }
}
