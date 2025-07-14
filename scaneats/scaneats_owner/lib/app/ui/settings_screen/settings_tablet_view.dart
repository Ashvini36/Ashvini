import 'package:flutter/material.dart';
import 'package:scaneats_owner/app/controller/settings_controller.dart';
import 'package:scaneats_owner/app/ui/settings_screen/widget_settings.dart';
import 'package:scaneats_owner/utils/common_ui.dart';


class SettingsTabletScreen extends StatelessWidget {
  final SettingsController controller;
  const SettingsTabletScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context),
        const AllSettingsWidget(),
      ],
    );
  }
}
