import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scaneats_owner/app/controller/home_controller.dart';
import 'package:scaneats_owner/app/ui/home_screen/widget_home.dart';
import 'package:scaneats_owner/utils/common_ui.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';


class HomeDesktopScreen extends StatelessWidget {
  final HomeController controller;

  const HomeDesktopScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          child: SingleChildScrollView(
            child: Column(children: [
              spaceH(height: 15),
              dashboardTitleWidget(context),
              spaceH(height: 15),
              TotalCountWidget(childAspectRatio: 1 / 4, crossAxisCount: 3, controller: controller),
              spaceH(height: 15),
              RecentOrderWidget(controller: controller),
            ]),
          ),
        ),
      ],
    );
  }
}
