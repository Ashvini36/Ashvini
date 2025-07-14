import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/administrators_controller.dart';
import 'package:scaneats/app/ui/administrators_screen/administrators_desktop_view.dart';
import 'package:scaneats/app/ui/administrators_screen/administrators_mobile_view.dart';
import 'package:scaneats/app/ui/administrators_screen/administrators_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigateAdministratorsScreen extends StatelessWidget {
  const NavigateAdministratorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdministratorsController(),
        builder: (controller) {
          return ResponsiveLayout(
              mobileBody: AdministratorsMobileScreen(controller), tabletBody: AdministratorsTabletScreen(controller), desktopBody: AdministratorsDesktopScreen(controller));
        });
  }
}
