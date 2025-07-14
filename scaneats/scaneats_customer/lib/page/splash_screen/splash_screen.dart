import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/controller/splash_controller.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ic_logo.png', height: 35, width: 35, fit: BoxFit.cover),
                  spaceW(width: 5),
                   TextCustom(title: Constant.projectName, color: AppThemeData.crusta500, fontSize: 20),
                ],
              ),
            ),
          );
        });
  }
}
