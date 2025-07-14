import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/home_branch_controller.dart';
import 'package:scaneats/app/ui/home_branch_screen/home_branch_desktop_view.dart';
import 'package:scaneats/app/ui/home_branch_screen/home_branch_mobile_view.dart';
import 'package:scaneats/app/ui/home_branch_screen/home_branch_tablet_view.dart';

import 'package:scaneats/responsive/responsive.dart';

class NavigateHomeBranchScreen extends StatelessWidget {
  const NavigateHomeBranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeBranchController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: HomeBranchMobileScreen(controller), tabletBody: HomeBranchTabletScreen(controller), desktopBody: HomeBranchDesktopScreen(controller));
      },
    );
  }
}
