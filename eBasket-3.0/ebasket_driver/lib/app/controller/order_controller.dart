import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Rx<DriverModel> userModel = DriverModel().obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        userModel.value = value;

        isLoading.value = false;
      }
    });
  }
}
