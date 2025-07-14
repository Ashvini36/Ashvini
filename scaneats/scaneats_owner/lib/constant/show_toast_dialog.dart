import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToastDialog {
  static showToast(String? message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.top, int duration = 1}) {
    EasyLoading.showToast(message!, toastPosition: position, duration: Duration(seconds: duration));
  }

  static showLoader(String message) {
    EasyLoading.show(status: message);
  }

  static closeLoader() {
    EasyLoading.dismiss();
  }
}
