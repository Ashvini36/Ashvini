import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/model/product_model.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  RxBool isLoading = true.obs;
  RxString selectPaymentRadioListTile = ''.obs;
  RxInt quantity = 0.obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxString orderId = ''.obs;
  RxDouble totalAmount = 0.0.obs;
  RxBool confirmOrder = false.obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  getArgument() async{
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderId.value = argumentData['orderId'];
      orderModel.value = (await FireStoreUtils.getOrder(orderId.value))!;
     selectPaymentRadioListTile.value =  orderModel.value.paymentMethod;
    }
    update();
  }

  calculation(OrderModel orderModel) {
    subTotal.value = 0.0;
    totalAmount.value = 0.0;
    quantity.value = 0;
    discount.value = 0.0;
    for (int a = 0; a < orderModel.products.length; a++) {
      ProductModel e = orderModel.products[a];
      quantity.value += e.quantity!;

      if (e.discountPrice != null && e.discountPrice != "0") {
        subTotal.value += double.parse(e.discountPrice!) * e.quantity!;
      } else {
        subTotal.value += double.parse(e.price!) * e.quantity!;
      }
    }

    if (orderModel.coupon!.id != null) {
      if (orderModel.coupon!.discountType == "Fix Price") {
        discount.value = double.parse(orderModel.coupon!.discount.toString());
      } else {
        discount.value = double.parse(subTotal.value.toString()) * double.parse(orderModel.coupon!.discount.toString()) / 100;
      }
    }
    totalAmount.value = subTotal.value + double.parse(orderModel.deliveryCharge.toString());

    totalAmount.value = totalAmount.value - discount.value;

    String taxAmount = " 0.0";
    if (orderModel.taxModel != null) {
      for (var element in orderModel.taxModel!) {
        taxAmount = (double.parse(taxAmount) + Constant.calculateTax(amount: (subTotal.value - discount.value).toString(), taxModel: element)).toString();
      }
    }
    totalAmount.value += double.parse(taxAmount);
    update();
  }

  updateOrder() async{
    ShowToastDialog.showLoader("Please wait!.");
    await FireStoreUtils.getOrder(orderId.value).then((orderModel) async {
      orderModel!.paymentMethod = selectPaymentRadioListTile.value != ''? selectPaymentRadioListTile.value.toString() : orderModel.paymentMethod;
      orderModel.status = Constant.inTransit;
      await FireStoreUtils.updateOrder(orderModel);

      ShowToastDialog.closeLoader();
    });
  }
}
