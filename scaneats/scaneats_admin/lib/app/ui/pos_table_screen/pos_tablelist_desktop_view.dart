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

class PosTableListDesktopScreen extends StatelessWidget {
  const PosTableListDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: PosTableController(),
        builder: (controller) {
          return Column(
            children: [
              CommonUI.appBarUI(context,
                  isPOSTable: true,
                  onSelectBranch: ((V) => controller.getDiningTableData()),
                  onChange: ((v) => Constant().debouncer.call(() => controller.getDiningTableData(name: v.toString())))),
              Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                    Row(
                      children: [
                        const TextCustom(
                          title: 'Dashboard',
                          fontSize: 14,
                          fontFamily: AppThemeData.medium,
                          isUnderLine: true,
                          color: AppThemeData.pickledBluewood600,
                        ),
                        const TextCustom(
                          title: ' > ',
                          fontSize: 14,
                          fontFamily: AppThemeData.medium,
                          color: AppThemeData.pickledBluewood600,
                        ),
                        TextCustom(
                          title: ' ${controller.title.value} ',
                          fontSize: 14,
                          fontFamily: AppThemeData.medium,
                        ),
                      ],
                    ),
                    spaceH(height: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [SizedBox(width: Responsive.width(100, context), height: Responsive.height(82, context), child: const PosTableListView())]),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
