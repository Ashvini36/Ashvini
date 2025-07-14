import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/pos_controller.dart';
import 'package:scaneats/app/ui/pos_screen/widget_pos_screen.dart';
import 'package:scaneats/widgets/common_ui.dart';


class PosScreenMobileScreen extends StatelessWidget {
  final PosController controller;
  const PosScreenMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
         const PosView(crossAxisCount: 2, childAspectRatio: 1.5),
      ],
    );
  }
}
