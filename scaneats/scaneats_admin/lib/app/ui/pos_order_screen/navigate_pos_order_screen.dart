import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/pos_orders_controller.dart';
import 'package:scaneats/app/ui/pos_order_screen/pos_order_view.dart';

class NavigatePosOrderScreen extends StatelessWidget {
  const NavigatePosOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: PosOrdersController(),
        builder: (controller) {
          return PosOrderScreen(controller);
        });
  }
}
