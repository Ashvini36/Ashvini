import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/subscription_controller.dart';
import 'package:scaneats/app/controller/success_controller.dart';
import 'package:scaneats/app/model/day_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/text_widget.dart';

class SuccessPage extends StatelessWidget {
  final bool isSuccess;

  const SuccessPage({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: SuccessController(),
        initState: (state) async {
          if (isSuccess == true) {
            SubscriptionController subscriptionController = Get.put(SubscriptionController());
            DayModel dayModel = Constant.getSubscriptionDayModel();
            SubscriptionModel subscriptionModel = Constant.getSubscription();
            String paymentType = Preferences.getString(Preferences.paymentType);

            await subscriptionController.setSubscription(subscriptionModel: subscriptionModel, dayModel: dayModel, paymentType: paymentType);
            Constant.clearSubscription();
          }
        },
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                height: 600,
                child: ContainerCustom(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 90),
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
                              title: "Please wait for : ${controller.start.value} sec",
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
