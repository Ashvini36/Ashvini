import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaneats_customer/controller/pos_controller.dart';
import 'package:scaneats_customer/page/pos_screen/widget_pos_screen.dart';

class PosScreenTabletScreen extends StatelessWidget {
  final PosController controller;

  const PosScreenTabletScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: PosView(crossAxisCount: 3, childAspectRatio: 1.5)),
      ],
    );
  }
}
