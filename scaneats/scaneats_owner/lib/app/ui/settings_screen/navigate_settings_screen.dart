import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/controller/settings_controller.dart';
import 'package:scaneats_owner/app/ui/settings_screen/settings_desktop_view.dart';
import 'package:scaneats_owner/app/ui/settings_screen/settings_mobile_view.dart';
import 'package:scaneats_owner/app/ui/settings_screen/settings_tablet_view.dart';
import 'package:scaneats_owner/responsive/responsive.dart';

class NavigateSettingsScreen extends StatelessWidget {
  const NavigateSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SettingsController(),
        builder: (controller) {
          return ResponsiveLayout(mobileBody: SettingsMobileScreen(controller), tabletBody: SettingsTabletScreen(controller), desktopBody: SettingsDesktopScreen(controller));
        });
  }
}
