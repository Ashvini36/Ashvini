import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/home_controller.dart';
import 'package:scaneats/app/ui/home_screen/home_desktop_view.dart';
import 'package:scaneats/app/ui/home_screen/home_tablet_view.dart';

import 'package:scaneats/responsive/responsive.dart';

import 'home_mobile_view.dart';

class NavigateHomeScreen extends StatelessWidget {
  const NavigateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: HomeMobileScreen(controller), tabletBody: HomeTabletScreen(controller), desktopBody: HomeDesktopScreen(controller));
      },
    );
  }
}
