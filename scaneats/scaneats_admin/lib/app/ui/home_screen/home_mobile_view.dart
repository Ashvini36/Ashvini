import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaneats/app/controller/home_controller.dart';
import 'package:scaneats/app/ui/home_screen/widget_home.dart';
import 'package:scaneats/widgets/common_ui.dart';
import 'package:scaneats/widgets/global_widgets.dart';

class HomeMobileScreen extends StatelessWidget {
  final HomeController controller;

  const HomeMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            child: Column(children: [
              spaceH(height: 10),
              dashboardTitleWidget(context),
              TotalCountWidget(childAspectRatio: 1 / 4, crossAxisCount: 2, controller: controller),
              spaceH(height: 15),
              const DailyRevenueWidget(),
              spaceH(height: 15),
              const CustomerGraphWidget(),
              spaceH(height: 15),
            ]),
          ),
        ),
      ],
    );
  }
}
