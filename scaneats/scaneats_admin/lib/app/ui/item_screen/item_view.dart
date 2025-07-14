import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/item_controller.dart';
import 'package:scaneats/app/ui/item_screen/widget_item.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/widgets/common_ui.dart';


class ItemScreen extends StatelessWidget {
  final ItemController controller;

  const ItemScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Responsive.isMobile(context)) CommonUI.appBarMobileUI(context),
        if (Responsive.isMobile(context)) CommonUI.appMoblieUI(context),
        if (!Responsive.isMobile(context)) CommonUI.appBarUI(context, onChange: ((v) => controller.getAllItem(name: v.toString()))),
        const AllItemWidget()
      ],
    );
  }
}
