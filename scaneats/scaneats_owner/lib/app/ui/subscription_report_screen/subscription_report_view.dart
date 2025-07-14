import 'package:flutter/material.dart';
import 'package:scaneats_owner/app/controller/subscription_report_controller.dart';
import 'package:scaneats_owner/app/ui/subscription_report_screen/widget_subscription_report.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/utils/common_ui.dart';

class SubscriptionReportView extends StatelessWidget {
  final SubscriptionReportController controller;

  const SubscriptionReportView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isMobile(context)
            ? Column(
                children: [
                  CommonUI.appBarMobileUI(context),
                  CommonUI.appMoblieUI(context),
                ],
              )
            : CommonUI.appBarUI(context),
        const WidgetSubscriptionReportScreen(),
      ],
    );
  }
}
