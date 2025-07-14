import 'dart:async';

import 'package:get/get.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/constant/constant.dart';

class SuccessController extends GetxController {
  late Timer timer;

  RxInt start = 5.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    startTimer();
    super.onInit();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          Constant.paymentStatus = null;
          Get.offAll(const DashBoardScreen());
        } else {
          start.value--;
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }
}
