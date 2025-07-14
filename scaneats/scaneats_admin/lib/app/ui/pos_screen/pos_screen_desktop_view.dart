import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/pos_controller.dart';
import 'package:scaneats/app/ui/pos_screen/widget_pos_screen.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/widgets/common_ui.dart';

class PosScreenDesktopScreen extends StatelessWidget {
  final PosController controller;

  const PosScreenDesktopScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context, onSelectBranch: ((V) {}), onChange: ((v) => Constant().debouncer.call(() => controller.getAllItem(name: v.toString())))),
        const PosView(),
      ],
    );
  }
}
