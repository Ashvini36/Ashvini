import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/dining_table_controller.dart';
import 'package:scaneats/app/ui/dining_table_screen/dining_table_screen_desktop_view.dart';
import 'package:scaneats/app/ui/dining_table_screen/dining_table_screen_mobile_view.dart';
import 'package:scaneats/app/ui/dining_table_screen/dining_table_screen_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigateDiningTableScreen extends StatelessWidget {
  const NavigateDiningTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DiningTableController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: DiningTableScreenMobileScreen(controller), tabletBody: DiningTableScreenTabletScreen(controller), desktopBody: DiningTableScreenDesktopScreen(controller));
      },
    );
  }
}
