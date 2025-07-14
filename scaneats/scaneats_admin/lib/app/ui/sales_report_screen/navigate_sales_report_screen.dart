import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/sales_report_controller.dart';
import 'package:scaneats/app/ui/sales_report_screen/sales_report_view.dart';

class NavigateSalesReportScreen extends StatelessWidget {
  const NavigateSalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: SalesReportController(),
        builder: (controller) {
          return SalesReportView(controller);
        });
  }
}
