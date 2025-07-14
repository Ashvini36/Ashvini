import 'package:flutter/material.dart';
import 'package:scaneats_owner/app/controller/restaurant_controller.dart';
import 'package:scaneats_owner/app/ui/restaurant_screens/restaurant_screen.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/utils/common_ui.dart';


class RestaurantViewScreen extends StatelessWidget {
  final RestaurantController controller;

  const RestaurantViewScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Responsive.isMobile(context)) CommonUI.appBarMobileUI(context),
        if (Responsive.isMobile(context)) CommonUI.appMoblieUI(context),
        if (!Responsive.isMobile(context)) CommonUI.appBarUI(context),
        const RestaurantScreen()
      ],
    );
  }
}
