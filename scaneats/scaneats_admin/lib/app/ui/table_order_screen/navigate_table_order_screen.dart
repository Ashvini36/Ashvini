import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/table_orders_controller.dart';
import 'package:scaneats/app/ui/table_order_screen/table_order_view.dart';

class NavigateTableOrderScreen extends StatelessWidget {
  const NavigateTableOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: TableOrdersController(),
        builder: (controller) {
          return TableOrderScreen(controller);
        });
  }
}
