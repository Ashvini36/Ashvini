import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/pos_controller.dart';
import 'package:scaneats/app/ui/pos_screen/pos_screen_desktop_view.dart';
import 'package:scaneats/app/ui/pos_screen/pos_screen_mobile_view.dart';
import 'package:scaneats/app/ui/pos_screen/pos_screen_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigatePosScreen extends StatelessWidget {
  const NavigatePosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PosController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: PosScreenMobileScreen(controller), tabletBody: PosScreenTabletScreen(controller), desktopBody: PosScreenDesktopScreen(controller));
      },
    );
  }
}
