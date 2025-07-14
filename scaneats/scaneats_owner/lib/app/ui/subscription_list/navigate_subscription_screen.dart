import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/controller/subscription_controller.dart';
import 'package:scaneats_owner/app/ui/subscription_list/subscription_view.dart';

class NavigateSubscriptionScreen extends StatelessWidget {
  const NavigateSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: SubscriptionController(),
        builder: (controller) {
          return SubscriptionViewScreen(controller);
        });
  }
}
