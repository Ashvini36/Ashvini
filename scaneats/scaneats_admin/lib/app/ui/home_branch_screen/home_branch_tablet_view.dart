import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaneats/app/controller/home_branch_controller.dart';
import 'package:scaneats/app/ui/home_branch_screen/widget_home_branch.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/widgets/common_ui.dart';
import 'package:scaneats/widgets/global_widgets.dart';


class HomeBranchTabletScreen extends StatelessWidget {
  final HomeBranchController controller;
  const HomeBranchTabletScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context, onSelectBranch: ((V) => controller.callData(branch: Constant.selectedBranch))),
        SingleChildScrollView(
          child: Padding(
            padding: paddingEdgeInsets(),
            child: Column(children: [
              dashboardTitleWidget(context),
              spaceH(height: 15),
              SingleChildScrollView(
                child: Column(children: [
                  TotalCountWidget(childAspectRatio: 1 / 4, crossAxisCount: 3, controller: controller),
                  spaceH(height: 15),
                  Row(
                    children: [
                      const Expanded(child: DailyRevenueWidget()),
                      spaceW(),
                      const Expanded(child: CustomerGraphWidget()),
                    ],
                  ),
                  spaceH(height: 15),
                  RecentOrderWidget(controller: controller),
                  spaceH(height: 15),
                ]),
              ),
            ]),
          ),
        )
      ],
    );
  }
}
