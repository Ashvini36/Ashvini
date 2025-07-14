import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats_owner/app/controller/settings_controller.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/common_ui.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/DarkThemeProvider.dart';

class SettingsMobileScreen extends StatelessWidget {
  final SettingsController controller;

  const SettingsMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
        CommonUI.appMoblieUI(context),
        GetX(
            init: SettingsController(),
            builder: (controller) {
              return Padding(
                  padding: paddingEdgeInsets(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Responsive.isMobile(context)
                          ? const SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spaceH(),
                          const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                          Row(
                            children: [
                              const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                              const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                              TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium),
                              spaceH(height: 20),
                            ],
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Center(
                            child: ContainerCustom(
                              padding: const EdgeInsets.all(0),
                              color: AppThemeData.crusta500,
                              radius: 4,
                              child: ExpansionTile(
                                  key: GlobalKey(),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                  backgroundColor: AppThemeData.crusta500,
                                  iconColor: AppThemeData.pickledBluewood100,
                                  title: const TextCustom(title: 'Settings Menu', color: AppThemeData.pickledBluewood100),
                                  children: controller.settinsAllPage
                                      .map((e) => InkWell(
                                    onTap: () {
                                      e.selectIndex = 0;
                                      controller.selectSettingWidget.value = e;
                                      controller.update();
                                    },
                                    child: ContainerCustom(
                                      radius: 0,
                                      color: controller.selectSettingWidget.value.title![0] == e.title![0]
                                          ? themeChange.getThem()
                                          ? AppThemeData.pickledBluewood900
                                          : AppThemeData.pickledBluewood100
                                          : null,
                                      child: Row(children: [
                                        SvgPicture.asset(e.icon ?? '',
                                            height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood600),
                                        spaceW(width: 15),
                                        Expanded(child: TextCustom(title: e.title?[0] ?? ''))
                                      ]),
                                    ),
                                  ))
                                      .toList()),
                            ),
                          ),
                          spaceH(height: 20),
                          GetBuilder(
                              init: SettingsController(),
                              builder: (controller) {
                                return controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!];
                              })
                        ]),
                      )
                    ],
                  ));
            }),
      ],
    );
  }
}
