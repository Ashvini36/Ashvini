import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/pos_table_controller.dart';
import 'package:scaneats/app/ui/pos_table_screen/widget_pos_tablelist_screen.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/widgets/common_ui.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/text_widget.dart';

class PosTableListMobileScreen extends StatelessWidget {
  const PosTableListMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: PosTableController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CommonUI.appBarMobileUI(
                    context,
                    isPOSTable: true,
                  ),
                  CommonUI.appMoblieUI(context,
                      onSelectBranch: ((V) => controller.getDiningTableData()),
                      onChange: ((v) => Constant().debouncer.call(() => controller.getDiningTableData(name: v.toString())))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                    Row(
                      children: [
                        const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                        const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium)
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: paddingEdgeInsets(),
                child: SizedBox(
                  width: Responsive.width(100, context),
                  height: Responsive.height(90, context),
                  child: const PosTableListView(crossAxisCount: 3, childAspectRatio: 1),
                ),
              ),
            ],
          );
        });
  }
}
