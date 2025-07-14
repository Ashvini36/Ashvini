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

class PosTableListTabletScreen extends StatelessWidget {
  const PosTableListTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: PosTableController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonUI.appBarUI(context,
                  isPOSTable: true,
                  onSelectBranch: ((V) => controller.getDiningTableData()),
                  onChange: ((v) => Constant().debouncer.call(() => controller.getDiningTableData(name: v.toString())))),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                    const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                    TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium),
                  ],
                ),
              ),
              Padding(
                padding: paddingEdgeInsets(),
                child: SizedBox(
                  width: Responsive.width(100, context),
                  height: Responsive.height(90, context),
                  child: const PosTableListView(crossAxisCount: 4, childAspectRatio: 1),
                ),
              )
            ],
          );
        });
  }
}
