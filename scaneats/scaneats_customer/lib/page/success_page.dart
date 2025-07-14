import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/controller/success_controller.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/widget/container_custom.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class SuccessPage extends StatelessWidget {
  final bool isSuccess;

  const SuccessPage({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: SuccessController(),
        initState: (state) async {
          if (isSuccess == true) {
            state.controller!.startTimer(true);
          }
        },
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                height: 600,
                child: ContainerCustom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(isSuccess ? "assets/images/success.gif" : "assets/images/failer.gif"),
                            spaceH(height: 20),
                            TextCustom(
                              title: isSuccess ? "Payment Successful!" : "Payment Failed",
                              fontSize: 20,
                              fontFamily: AppThemeData.bold,
                            ),
                            spaceH(height: 10),
                            Flexible(
                              child: TextCustom(
                                title: isSuccess
                                    ? "Thank you for your payment! Your transaction has been successfully processed"
                                    : "We're sorry, but it seems there was an issue processing your payment.",
                                fontSize: 14,
                                textAlign: TextAlign.center,
                                fontFamily: AppThemeData.regular,
                                maxLine: 3,
                              ),
                            ),
                            spaceH(height: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Column(
                          children: [
                            TextCustom(
                              title: isSuccess ? "Please wait for : ${controller.start.value} sec" : "Please try again.${controller.status.value}",
                              fontSize: 18,
                              fontFamily: AppThemeData.medium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
