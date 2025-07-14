import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats/app/controller/settings_controller.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AllSettingsWidget extends StatefulWidget {
  const AllSettingsWidget({super.key});

  @override
  State<AllSettingsWidget> createState() => _AllSettingsWidgetState();
}

class _AllSettingsWidgetState extends State<AllSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsController(),
        builder: (controller) {
          return Padding(
              padding: paddingEdgeInsets(),
              child: Column(
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
                            ),
                          ],
                        ),
                  spaceH(),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        flex: 1,
                        child: ContainerCustom(
                          radius: 12,
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: controller.settinsAllPage.length,
                              separatorBuilder: (itemBuilder, index) {
                                return devider(context, height: themeChange.getThem() ? 1 : 2);
                              },
                              itemBuilder: (itemBuilder, index) {
                                return InkWell(
                                  onTap: () {
                                    controller.settinsAllPage[index].selectIndex = 0;
                                    controller.selectSettingWidget.value = controller.settinsAllPage[index];
                                    controller.update();
                                    setState(() {});
                                  },
                                  child: ContainerCustom(
                                    radius: 2,
                                    color: controller.selectSettingWidget.value.title![0] == controller.settinsAllPage[index].title![0]
                                        ? themeChange.getThem()
                                            ? AppThemeData.pickledBluewood950
                                            : AppThemeData.pickledBluewood100
                                        : null,
                                    child: Row(children: [
                                      SvgPicture.asset(controller.settinsAllPage[index].icon ?? '',
                                          height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood600),
                                      spaceW(width: 15),
                                      Expanded(child: TextCustom(title: controller.settinsAllPage[index].title?[0] ?? ''))
                                    ]),
                                  ),
                                );
                              }),
                        )),
                    spaceW(width: 20),
                    GetBuilder(
                        init: SettingsController(),
                        builder: (controller) {
                          return Expanded(flex: 3, child: controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!]);
                        },)
                  ])
                ],
              ));
        });
  }
}
