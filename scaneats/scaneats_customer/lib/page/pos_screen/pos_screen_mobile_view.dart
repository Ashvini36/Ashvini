import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaneats_customer/controller/pos_controller.dart';
import 'package:scaneats_customer/page/pos_screen/widget_pos_screen.dart';

class PosScreenMobileScreen extends StatelessWidget {
  final PosController controller;
  const PosScreenMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // CommonUI.appBarUI(context),
        Expanded(child: PosView(crossAxisCount: 2, childAspectRatio: 1.5)),
      ],
    );
  }
}
