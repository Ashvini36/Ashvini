
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/coupon_model.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/model/vendor_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/cart_model.dart';
import 'package:ebasket_customer/constant/constant.dart';

class BillDetailsController extends GetxController {
  Rx<CartModel> productModel = CartModel().obs;
  RxBool isLoading = true.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  HomeController homeController = Get.find<HomeController>();
  Rx<UserModel> userModel = UserModel().obs;
  RxDouble totalAmount = 0.0.obs;
  RxDouble subTotal = 0.0.obs;
  RxString deliveryCharges = '0'.obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;
  RxInt cartItem = 0.obs;
  RxInt hour = 0.obs;
  RxDouble minutes = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;
  RxList<String> tempProduct = <String>[].obs;
  Rx<AddressModel> addressModel = AddressModel().obs;

  @override
  void onInit() {
    getUserData();

    super.onInit();
  }

  getUserData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
        if (userModel.value.shippingAddress!.where((element) => element.isDefault == true).isNotEmpty) {
          Constant.selectedPosition = userModel.value.shippingAddress!.where((element) => element.isDefault == true).single;
        } else {
          Constant.selectedPosition = userModel.value.shippingAddress!.first;
        }
        addressModel.value = Constant.selectedPosition;
        update();
      }
    });
    getData();
  }

  getData() async {
    await FireStoreUtils.getVendor().then((value) {
      if (value != null) {
        vendorModel.value = value;
      }
    });
    Constant.distance = (Constant.getKm(LocationLatLng(latitude: addressModel.value.location!.latitude, longitude: addressModel.value.location!.longitude),
        LocationLatLng(latitude: vendorModel.value.latitude, longitude: vendorModel.value.longitude)));

    productList.clear();
    if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
      await FireStoreUtils.getAllDeliveryProducts().then((value) {
        if (value != null) {
          productList.value = value;
        }
      });

      await getDeliveryData();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getDeliveryData() async {
    num km = num.parse(Constant.getKm(LocationLatLng(latitude: addressModel.value.location!.latitude, longitude: addressModel.value.location!.longitude),
        LocationLatLng(latitude: vendorModel.value.latitude, longitude: vendorModel.value.longitude)));

    if (km > Constant.deliveryChargeModel!.minimumDeliveryChargesWithinKm!) {
      deliveryCharges.value = (km * Constant.deliveryChargeModel!.deliveryChargesPerKm!).toDouble().toString();
      update();
    } else {
      deliveryCharges.value = Constant.deliveryChargeModel!.minimumDeliveryCharges!.toDouble().toString();
    }
    minutes.value = 1.2;
    double value = minutes * double.parse(km.toString());
    hour.value = value ~/ 60;
    minutes.value = value % 60;

    update();
  }
}
