import 'package:flutter/material.dart';
import 'package:scaneats_owner/app/controller/notification_settings_controller.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_field_widget.dart';
import 'package:get/get.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        global: true,
        init: SettingsNotificationController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  hintText: '',
                  controller: controller.serverKeyController.value,
                  title: 'Server Key',
                  maxLine: 3,
                  obscureText: Constant.isDemo(),
                ),
                RoundedButtonFill(
                  width: 100,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Save",
                  icon: controller.isAddItemLoading.value == true
                      ? Constant.loader(context, color: AppThemeData.white)
                      : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () {
                    if (Constant.isDemo()) {
                      ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                    } else {
                      if (controller.serverKeyController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter valid server key");
                      } else {
                        controller.addCompanyData();
                      }
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
