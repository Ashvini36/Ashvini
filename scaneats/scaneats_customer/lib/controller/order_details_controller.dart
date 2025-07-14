import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/send_notification.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/model/dining_table_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/temp_model.dart';
import 'package:scaneats_customer/page/success_page.dart';
import 'package:scaneats_customer/payment/paypal/Model/accesstokenmodel.dart';
import 'package:scaneats_customer/payment/paypal/Model/paymentmodel.dart';
import 'package:scaneats_customer/payment/paypal/paypalservice.dart';
import 'package:scaneats_customer/payment/paystack/paystack.dart';
import 'package:scaneats_customer/payment/razorpay/razorpay.dart';
import 'package:scaneats_customer/payment/stripe/stripe_service.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';

class OrderDetailsController extends GetxController {
  Rx<OrderModel> selectedOrder = OrderModel().obs;

  RxList<String> paymentStatus = ['Paid', 'Unpaid'].obs;
  RxString selectedPaymentStatus = ''.obs;

  RxList<String> orderType =
      [Constant.statusOrderPlaced, Constant.statusAccept, Constant.statusPending, Constant.statusDelivered, Constant.statusTakeaway, Constant.statusRejected].obs;
  RxString selectedOrderStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Constant.paymentModel?.cash?.enable == true) {
      selectedPaymentMethod.value = Constant.paymentModel?.cash?.name ?? '';
      paymentController.value.text = Constant.paymentModel?.cash?.name ?? '';
    }
  }

  RxString selectedPaymentMethod = ''.obs;
  Rx<TextEditingController> paymentController = TextEditingController().obs;

  setOrderModel(OrderModel orderModel) async {
    selectedOrder.value = orderModel;
    selectedOrderStatus.value = selectedOrder.value.status ?? Constant.statusDelivered;
    selectedPaymentStatus.value = selectedOrder.value.paymentStatus == true ? 'Paid' : 'Unpaid';
  }

  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;
  Rx<TempModel> productDetails = TempModel().obs;

  productDetailInit(ItemModel model) async {
    // printLog("Addon model :: ${model.addons!.length}");
    selectedVariants.clear();
    selectedIndexVariants.clear();
    selectedIndexArray.clear();

    productDetails.value = TempModel.fromJson(model.toJson());
    if (productDetails.value.itemAttributes != null) {
      if (productDetails.value.itemAttributes!.attributes!.isNotEmpty) {
        for (var element in productDetails.value.itemAttributes!.attributes!) {
          if (element.attributeOptions!.isNotEmpty) {
            selectedVariants
                .add(productDetails.value.itemAttributes!.attributes![productDetails.value.itemAttributes!.attributes!.indexOf(element)].attributeOptions![0].toString());
            selectedIndexVariants.add(
                '${productDetails.value.itemAttributes!.attributes!.indexOf(element)} _${productDetails.value.itemAttributes!.attributes![0].attributeOptions![0].toString()}');
            selectedIndexArray.add('${productDetails.value.itemAttributes!.attributes!.indexOf(element)}_0');
          }
        }
      }

      if (productDetails.value.itemAttributes!.variants!.where((element) => element.variantSku == selectedVariants.join('-')).isNotEmpty) {
        productDetails.value.price = productDetails.value.itemAttributes!.variants!.where((element) => element.variantSku == selectedVariants.join('-')).first.variantPrice ?? '0';
        productDetails.value.variantId = productDetails.value.itemAttributes!.variants!.where((element) => element.variantSku == selectedVariants.join('-')).first.variantId ?? '0';
        productDetails.value.disPrice = '0';
      }
    }
  }

  Future<void> setOrderData(OrderModel model) async {
    if (model.customer?.id != null) {
      model.customer?.createdAt = null;
      model.customer?.updatedAt = null;
    }
    await Preferences.setString(Preferences.orderData, jsonEncode(model.toStringData()));
  }

  Future makePayment(context, {required String amount}) async {
    if (selectedPaymentMethod.value == Constant.paymentModel!.strip!.name) {
      ShowToastDialog.showLoader("Please wait...");
      await StripeService.createPrice(secretKey: Constant.paymentModel!.strip!.stripeSecret.toString(), amount: amount).then((value) async {
        if (value != '') {
          await StripeService.makeStripeCheckoutCall(priceId: value, secretKey: Constant.paymentModel!.strip!.stripeSecret.toString()).then((value) async {
            if (value != '') {
              ShowToastDialog.closeLoader();
              bool? isSuccess = await StripeService.handlePayPalPayment(context, approvalUrl: value);
              if (isSuccess == true) {
                Get.offAll(const SuccessPage(isSuccess: true));
              }
            }
          });
        }
      });
    } else if (selectedPaymentMethod.value == Constant.paymentModel!.paypal!.name) {
      ShowToastDialog.showLoader("Please wait...");
      FlutterPaypalSDK sdk = FlutterPaypalSDK(
          paypalClient: Constant.paymentModel!.paypal!.paypalClient.toString(),
          paypalSecret: Constant.paymentModel!.paypal!.paypalSecret.toString(),
          isSendBox: true,
          amount: amount);
      AccessToken accessToken = await sdk.getAccessToken();
      if (accessToken.token != null) {
        Payment payment = await sdk.createPayment(sdk.transaction(), accessToken.token!);
        if (payment.status) {
          ShowToastDialog.closeLoader();
          bool? isSuccess = await sdk.handlePayPalPayment(context, payment: payment);
          if (isSuccess == true) {
            Get.offAll(const SuccessPage(isSuccess: true));
          }
        }
      }
    } else if (selectedPaymentMethod.value == Constant.paymentModel!.payStack!.name) {
      Get.to(PayStackPage(
        publicKey: Constant.paymentModel!.payStack!.publicKey.toString(),
        secretKey: Constant.paymentModel!.payStack!.secretKey.toString(),
        amount: amount,
      ));
    } else if (selectedPaymentMethod.value == Constant.paymentModel!.razorpay!.name) {
      RazorPayService().init();
      RazorPayService().openCheckout(amount: amount, key: Constant.paymentModel!.razorpay!.razorpayKey.toString());
    } else if (selectedPaymentMethod.value.isEmpty ||
        selectedPaymentMethod.value == Constant.paymentModel!.card!.name ||
        selectedPaymentMethod.value == Constant.paymentModel!.cash!.name) {
      selectedOrder.value.createdAt = Timestamp.now();
      selectedOrder.value.updatedAt = Timestamp.now();
      if (selectedPaymentMethod.value.isEmpty) {
        selectedOrder.value.paymentMethod = "Cash";
      } else {
        selectedOrder.value.paymentMethod = selectedOrder.value.paymentMethod;
      }
      Get.offAll(const SuccessPage(isSuccess: true));
    } else {
      ShowToastDialog.showToast("Please select Payment method");
    }
  }

  placeOrder(OrderModel order) async {
    await FireStoreUtils.orderPlace(order).then((value) async {
      await FireStoreUtils.getAllUserByBranch(Constant.branchId).then((value) async {
        if (value != null) {
          for (var element in value) {
            if (element.fcmToken != null) {
              if (element.notificationReceive == true || element.fcmToken!.isNotEmpty) {
                Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": order.id};
                DiningTableModel? diningTableModel = await FireStoreUtils.getDiningTableById(order.tableId ?? '');
                await SendNotification.sendOneNotification(
                  token: element.fcmToken.toString(),
                  title: "New Order",
                  body: "New Table Order Placed on ${diningTableModel?.name}",
                  payload: playLoad,
                );
              }
            }
          }
        }
      });
    });
  }
}
