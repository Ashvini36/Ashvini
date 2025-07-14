import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/subscription_controller.dart';
import 'package:scaneats/app/ui/subscription_screen/subscription_screen_desktop_view.dart';
import 'package:scaneats/app/ui/subscription_screen/subscription_screen_mobile_view.dart';
import 'package:scaneats/app/ui/subscription_screen/subscription_screen_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigateSubscriptionScreen extends StatelessWidget {
  const NavigateSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SubscriptionController(),
      builder: (controller) {
        return ResponsiveLayout(
            mobileBody: SubscriptionScreenMobileScreen(controller),
            tabletBody: SubscriptionScreenTabletScreen(controller),
            desktopBody: SubscriptionScreenDesktopScreen(controller));
      },
    );
  }
}
