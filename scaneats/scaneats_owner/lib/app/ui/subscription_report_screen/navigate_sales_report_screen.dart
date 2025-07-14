import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/controller/subscription_report_controller.dart';
import 'package:scaneats_owner/app/ui/subscription_report_screen/subscription_report_view.dart';

class NavigateSubscriptionReportScreen extends StatelessWidget {
  const NavigateSubscriptionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: SubscriptionReportController(),
        builder: (controller) {
          return SubscriptionReportView(controller);
        });
  }
}
