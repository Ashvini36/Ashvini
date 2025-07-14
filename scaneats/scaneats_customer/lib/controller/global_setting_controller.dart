import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranchData();
  }

  RxBool isLoading = true.obs;

  Future<void> getBranchData() async {
    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        Constant.currency = value.first;
      }
    });

    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });

    await FireStoreUtils.getPaymentData().then((value) {
      if (value != null) {
        Constant.paymentModel = value;
      }
    });

    await FireStoreUtils.getThem().then((value) {
      if (value != null) {
        if (value.color != null && value.color!.isNotEmpty) {
          AppThemeData.crusta500 = HexColor.fromHex(value.color.toString());
        }
        Constant.projectName = value.name.toString();
        Constant.projectLogo = value.logo.toString();
      }
      update();
    });

    await FireStoreUtils.getServerKeyDetails().then((value) {
      if (value != null) {
        Constant.serverKey = value.serverKey.toString();
      }
      update();
    });

    isLoading.value = false;
  }
}
