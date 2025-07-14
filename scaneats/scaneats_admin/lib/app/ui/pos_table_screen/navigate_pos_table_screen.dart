import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/pos_table_controller.dart';
import 'package:scaneats/app/ui/pos_table_screen/pos_tablelist_desktop_view.dart';
import 'package:scaneats/app/ui/pos_table_screen/pos_tablelist_mobile_view.dart';
import 'package:scaneats/app/ui/pos_table_screen/pos_tablelist_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigatePosTableScreen extends StatelessWidget {
  const NavigatePosTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PosTableController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: PosTableListMobileScreen(), tabletBody: PosTableListTabletScreen(), desktopBody: PosTableListDesktopScreen());
      },
    );
  }
}
