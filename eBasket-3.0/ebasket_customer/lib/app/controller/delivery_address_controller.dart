import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';

class DeliveryAddressController extends GetxController {
  RxList<AddressModel> shippingAddress = <AddressModel>[].obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getListAddress();
    super.onInit();
  }

  getListAddress() async{

    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;

        update();
      }
    });
    shippingAddress.value = userModel.value.shippingAddress!;
  }
}
