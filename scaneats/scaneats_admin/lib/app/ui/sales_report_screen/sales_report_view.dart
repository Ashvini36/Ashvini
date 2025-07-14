import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/sales_report_controller.dart';
import 'package:scaneats/app/ui/sales_report_screen/widget_sales_report.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/widgets/common_ui.dart';


class SalesReportView extends StatelessWidget {
  final SalesReportController controller;

  const SalesReportView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isMobile(context)
            ? Column(
          children: [
            CommonUI.appBarMobileUI(context),
            CommonUI.appMoblieUI(context, onSelectBranch: ((V) => controller.getPosOrderData())),
          ],
        )
            : CommonUI.appBarUI(context, onSelectBranch: ((V) => controller.getPosOrderData())),
        const WidgetSalesReportScreen(),
      ],
    );
  }
}
