import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/item_controller.dart';
import 'package:scaneats/app/ui/item_screen/item_view.dart';
import 'package:get/get.dart';

class NavigateItemScreen extends StatelessWidget {
  const NavigateItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: ItemController(),
        builder: (controller) {
          return ItemScreen(controller);
        });
  }
}
