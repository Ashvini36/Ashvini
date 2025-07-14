import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/administrators_controller.dart';
import 'package:scaneats/app/ui/administrators_screen/widget_administrators.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/widgets/common_ui.dart';


class AdministratorsDesktopScreen extends StatelessWidget {
  final AdministratorsController controller;

  const AdministratorsDesktopScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context,
            onSelectBranch: ((V) => controller.getAdminData()), onChange: ((v) => Constant().debouncer.call(() => controller.searchByName(name: v.toString())))),
        const AllAdministratorsWidget()
      ],
    );
  }
}
