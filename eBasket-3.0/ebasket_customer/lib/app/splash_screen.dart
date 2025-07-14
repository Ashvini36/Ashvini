import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/splash_controller.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            color: AppThemeData.groceryAppDarkBlue,
            child: Center(
              child: Image.asset(
                "assets/icons/logo.png",
                height: 160,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
