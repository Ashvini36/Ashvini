import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/pos_orders_controller.dart';
import 'package:scaneats/app/ui/pos_order_screen/widget_order.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/widgets/common_ui.dart';


class PosOrderScreen extends StatelessWidget {
  final PosOrdersController controller;

  const PosOrderScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive.isMobile(context)
            ? Column(
                children: [
                  CommonUI.appBarMobileUI(context),
                  CommonUI.appMoblieUI(context,
                      onSelectBranch: ((V) => controller.searchByName()), onChange: ((v) => Constant().debouncer.call(() => controller.searchByName(name: v.toString())))),
                ],
              )
            : CommonUI.appBarUI(context,
                onSelectBranch: ((V) => controller.searchByName()), onChange: ((v) => Constant().debouncer.call(() => controller.searchByName(name: v.toString())))),
        const PosOrderWidget()
      ],
    );
  }
}
