import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/payment_method_model.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class PaymentViewController extends GetxController {
  Rx<TextEditingController> razorpayKey = TextEditingController().obs;
  Rx<String> enableRazorPay = "Active".obs;
  Rx<String> razorPay = "RazorPay".obs;

  Rx<TextEditingController> payStackSecretKey = TextEditingController().obs;
  Rx<TextEditingController> payStackPublicKey = TextEditingController().obs;
  Rx<String> enablePayStack = "Active".obs;
  Rx<String> payStack = "Paystack".obs;


  Rx<String> enableCash = "Active".obs;
  Rx<String> cashName = "cash".obs;

  Rx<TextEditingController> stripSecretKey = TextEditingController().obs;
  Rx<String> enableStripe = "Active".obs;
  Rx<String> stripName = "Stripe".obs;


  Rx<TextEditingController> paypalSecret = TextEditingController().obs;
  Rx<TextEditingController> paypalClient = TextEditingController().obs;
  Rx<String> isSandboxPaypal = "Active".obs;
  Rx<String> enablePaypal = "Active".obs;
  Rx<String> payPalName = "PayPal".obs;


  RxBool isLoading = true.obs;

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  Rx<RazorpayModel> razorPayModel = RazorpayModel().obs;
  Rx<PayStack> payStackModel = PayStack().obs;
  Rx<FlutterWave> flutterWaveModel = FlutterWave().obs;
  Rx<Strip> stripModel = Strip().obs;
  Rx<Paypal> payPalModel = Paypal().obs;
  Rx<Wallet> cashModel = Wallet().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getPaymentData().then((value) {
      if (value != null) {
        paymentModel.value = value;
        if (value.razorpay != null) {
          razorPay.value = value.razorpay!.name.toString();
          razorpayKey.value.text = value.razorpay!.razorpayKey.toString();
          enableRazorPay.value = value.razorpay!.enable == true ? "Active" : "Inactive";
        }
        if (value.payStack != null) {
          payStack.value = value.payStack!.name.toString();
          payStackSecretKey.value.text = value.payStack!.secretKey.toString();
          payStackPublicKey.value.text = value.payStack!.publicKey.toString();
          enablePayStack.value = value.payStack!.enable == true ? "Active" : "Inactive";
        }

        if (value.strip != null) {
          stripName.value = value.strip!.name.toString();
          stripSecretKey.value.text = value.strip!.stripeSecret.toString();
          enableStripe.value = value.strip!.enable == true ? "Active" : "Inactive";
        }

        if (value.paypal != null) {
          payPalName.value = value.paypal!.name.toString();
          paypalSecret.value.text = value.paypal!.paypalSecret.toString();
          paypalClient.value.text = value.paypal!.paypalClient.toString();
          isSandboxPaypal.value = value.paypal!.isSandbox == true ? "Active" : "Inactive";
          enablePaypal.value = value.paypal!.enable == true ? "Active" : "Inactive";
        }
        if (value.cash != null) {
          cashName.value = value.cash!.name.toString();
          enableCash.value = value.cash!.enable == true ? "Active" : "Inactive";
        }
      }
      isLoading.value = false;
      update();
    });
  }


  Future<void> addCompanyData({String itemCategoryId = '', bool isEdit = false}) async {
    PaymentModel model = PaymentModel();

    razorPayModel.value.name = razorPay.value;
    razorPayModel.value.razorpayKey = razorpayKey.value.text;
    razorPayModel.value.enable = enableRazorPay.value == "Active" ? true : false;
    model.razorpay = razorPayModel.value;

    payStackModel.value.name = payStack.value;
    payStackModel.value.enable = enablePayStack.value == "Active" ? true : false;
    payStackModel.value.secretKey = payStackSecretKey.value.text;
    payStackModel.value.publicKey = payStackPublicKey.value.text;
    model.payStack = payStackModel.value;

    stripModel.value.name = stripName.value;
    stripModel.value.stripeSecret = stripSecretKey.value.text;
    stripModel.value.enable = enableStripe.value == "Active" ? true : false;
    model.strip = stripModel.value;

    payPalModel.value.name = payPalName.value;
    payPalModel.value.paypalSecret = paypalSecret.value.text;
    payPalModel.value.paypalClient = paypalClient.value.text;
    payPalModel.value.isSandbox = isSandboxPaypal.value == "Active" ? true : false;
    payPalModel.value.enable = enablePaypal.value == "Active" ? true : false;
    model.paypal = payPalModel.value;


    ShowToastDialog.showLoader("Please wait");
    await FireStoreUtils.setPaymentData(model: model).then((value) {
      update();
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Payment details updated successfully.");
    });
  }
}

