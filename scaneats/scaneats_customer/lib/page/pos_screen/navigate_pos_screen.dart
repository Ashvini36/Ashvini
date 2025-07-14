import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/controller/pos_controller.dart';
import 'package:scaneats_customer/page/pos_screen/pos_screen_desktop_view.dart';
import 'package:scaneats_customer/page/pos_screen/pos_screen_mobile_view.dart';
import 'package:scaneats_customer/page/pos_screen/pos_screen_tablet_view.dart';
import 'package:scaneats_customer/responsive/responsive.dart';
import 'package:scaneats_customer/widget/common_ui.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';

class NavigatePosScreen extends StatelessWidget {
  const NavigatePosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showMyDialog(context);
          return false;
        },
        child: GetBuilder(
            init: PosController(),
            builder: (controller) {
              return Scaffold(
                  appBar: CommonUI.appBarUI(context),
                  body: ResponsiveLayout(
                    mobileBody: PosScreenMobileScreen(controller),
                    tabletBody: PosScreenTabletScreen(controller),
                    desktopBody: PosScreenDesktopScreen(controller),
                  ));
            }));
  }
}
