import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkMe/themes/app_them_data.dart';
import 'package:parkMe/themes/common_ui.dart';
import 'package:parkMe/themes/responsive.dart';
import 'package:parkMe/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: UiInterface().customAppBar(context, themeChange, "notification".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.separated(
          itemCount: 5,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, int index) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: themeChange.getThem() ? AppThemData.grey10 : AppThemData.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "index.isEven ? AppAssets.paymentSuccessfull : AppAssets.bookingCancle",
                    height: Responsive.height(12, context),
                    width: Responsive.width(18, context),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index.isEven ? 'Payment Successful!'.tr : 'Parking Booking Canceled'.tr,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: themeChange.getThem() ? AppThemData.grey10 : AppThemData.grey10),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          index.isEven ? 'Parking booking at Portley was succ...'.tr : 'You have canceled parking at Gouse..'.tr,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeChange.getThem() ? AppThemData.grey10 : AppThemData.grey10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8,
            );
          },
        ),
      ),
    );
  }
}
