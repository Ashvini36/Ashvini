import 'package:flutter/material.dart';
import 'package:scaneats_owner/app/controller/subscription_controller.dart';
import 'package:scaneats_owner/app/ui/subscription_list/subscription_screen.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/utils/common_ui.dart';


class SubscriptionViewScreen extends StatelessWidget {
  final SubscriptionController controller;

  const SubscriptionViewScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Responsive.isMobile(context)) CommonUI.appBarMobileUI(context),
        if (Responsive.isMobile(context)) CommonUI.appMoblieUI(context),
        if (!Responsive.isMobile(context)) CommonUI.appBarUI(context),
        const SubscriptionScreen()
      ],
    );
  }
}
