import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return const Scaffold(
            body: Center(),
          );
        });
  }
}
