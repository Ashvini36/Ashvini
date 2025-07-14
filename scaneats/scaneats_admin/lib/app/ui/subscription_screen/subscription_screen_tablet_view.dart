import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/subscription_controller.dart';
import 'package:scaneats/app/ui/subscription_screen/widget_subscription_screen.dart';
import 'package:scaneats/widgets/common_ui.dart';

class SubscriptionScreenTabletScreen extends StatelessWidget {
  final SubscriptionController controller;

  const SubscriptionScreenTabletScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context),
        const SubscriptionView(),
      ],
    );
  }
}
