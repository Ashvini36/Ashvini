import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/controller/restaurant_controller.dart';
import 'package:scaneats_owner/app/ui/restaurant_screens/restaurant_view.dart';

class NavigateRestaurantScreen extends StatelessWidget {
  const NavigateRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: RestaurantController(),
        builder: (controller) {
          return RestaurantViewScreen(controller);
        });
  }
}
