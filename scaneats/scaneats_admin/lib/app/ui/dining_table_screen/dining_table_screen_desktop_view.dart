import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/dining_table_controller.dart';
import 'package:scaneats/app/ui/dining_table_screen/dining_table_screen.dart';
import 'package:scaneats/widgets/common_ui.dart';


class DiningTableScreenDesktopScreen extends StatelessWidget {
  final DiningTableController controller;

  const DiningTableScreenDesktopScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context, onSelectBranch: ((V) => controller.getDiningTableData()), onChange: ((v) => controller.getDiningTableData(name: v.toString()))),
        const DiningTableScreen()
      ],
    );
  }
}
