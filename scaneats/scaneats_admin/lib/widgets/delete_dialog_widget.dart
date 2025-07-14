import 'package:flutter/material.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme_data.dart';

class DeleteAlertWidget extends StatelessWidget {
  const DeleteAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      title: const TextCustom(title: 'Delete', fontSize: 18),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: TextCustom(title: 'Are you sure you want delete?', fontSize: 16),
      ),
      actions: <Widget>[
        RoundedButtonFill(
            borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
            width: 90,
            radius: 8,
            height: 35,
            fontSizes: 14,
            title: "Cancel",
            textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
            isRight: false,
            onPress: () {
              Get.back(result: false);
            }),
        RoundedButtonFill(
            borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
            width: 90,
            radius: 8,
            height: 35,
            fontSizes: 14,
            title: "Okay",
            textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
            isRight: false,
            onPress: () {
              Get.back(result: true);
            }),
      ],
    );
  }
}

class RoleMemberAlertWidget extends StatelessWidget {
  const RoleMemberAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: TextCustom(
            title:
                'You do not have permission to delete this role until all members associated with this role are removed. Once all members have been removed, you will be able to delete this role.',
            fontSize: 16),
      ),
      actions: <Widget>[
        RoundedButtonFill(
            borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
            width: 90,
            radius: 8,
            height: 35,
            fontSizes: 14,
            title: "Okay",
            textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
            isRight: false,
            onPress: () {
              Get.back();
            }),
      ],
    );
  }
}
