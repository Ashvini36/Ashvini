import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaneats/app/controller/home_branch_controller.dart';
import 'package:scaneats/app/ui/home_branch_screen/widget_home_branch.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/widgets/common_ui.dart';
import 'package:scaneats/widgets/global_widgets.dart';


class HomeBranchMobileScreen extends StatelessWidget {
  final HomeBranchController controller;

  const HomeBranchMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
        CommonUI.appMoblieUI(context, onSelectBranch: ((V) => controller.callData(branch: Constant.selectedBranch))),
        SingleChildScrollView(
          child: Padding(
            padding: paddingEdgeInsets(),
            child: Column(children: [
              dashboardTitleWidget(context),
              TotalCountWidget(childAspectRatio: 1 / 4, crossAxisCount: 2, controller: controller),
              spaceH(height: 15),
              const DailyRevenueWidget(),
              spaceH(height: 15),
              const CustomerGraphWidget(),
              spaceH(height: 15),
              RecentOrderWidget(controller: controller),
              spaceH(height: 15),
            ]),
          ),
        )
      ],
    );
  }
}
