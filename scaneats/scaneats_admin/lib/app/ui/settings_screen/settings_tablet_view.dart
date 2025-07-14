import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/settings_controller.dart';
import 'package:scaneats/app/ui/settings_screen/widget_settings.dart';
import 'package:scaneats/widgets/common_ui.dart';


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
