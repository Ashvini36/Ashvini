import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/send_notification.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/model/dining_table_model.dart';
import 'package:scaneats_customer/model/item_attributes_model.dart';
import 'package:scaneats_customer/model/item_category_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/offer_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/temp_model.dart';
import 'package:scaneats_customer/page/pos_screen/order_detail_screen.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';

class PosController extends GetxController {
  RxString title = "POS Screen".obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<TextEditingController> paymentController = TextEditingController().obs;

  Rx<DiningTableModel> diningTableModel = DiningTableModel().obs;

  Rx<String> selectedPaymentMethod = "".obs;

  setThme({required DarkThemeProvider themeChange}) {
    if (themeChange.darkTheme == 1) {
      themeChange.darkTheme = 0;
    } else {
      themeChange.darkTheme = 1;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getItemCategoriesData();
    getItemAttributeData();
    getTableDetails();
    getCartData();
  }

  getTableDetails() async {
    await FireStoreUtils.getDiningTableById(Constant.tableNo).then((value) {
      if (value != null) {
        diningTableModel.value = value;
      }
    });
  }

  getCartData() {
    addToCart.value = Constant.getOrderData();
  }

  RxList<ItemCategoryModel> itemCategoryList = <ItemCategoryModel>[].obs;
  Rx<ItemCategoryModel> selectedCategory = ItemCategoryModel().obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;

  Future<void> getItemCategoriesData() async {
    await FireStoreUtils.getAllOrderWithoutBranch().then((value) {
      if (value != null) {
        orderList.value = value;
      }
    });
    await FireStoreUtils.getItemCategory().then((value) {
      itemCategoryList.clear();
      itemCategoryList.value = [
        ItemCategoryModel(
          id: 'All',
          name: 'All',
          image:
              'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/Item%2Fcategories%2Fd91b6651-eba0-4ccf-b67e-ffb8967b17de?alt=media&token=0909e5ea-224d-473a-b235-3735a6d03f15',
          isActive: true,
          description: '',
        ),
        ItemCategoryModel(
          id: 'Feature',
          name: 'Feature',
          image: 'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/item%2Fsalad.png?alt=media&token=8f9e2959-d641-4934-92e0-daffe9c4041f',
          isActive: true,
          description: '',
        )
      ];
      if (value!.isNotEmpty) {
        itemCategoryList.addAll(value);
      }
    });
    selectedCategory.value = itemCategoryList.first;
    getAllItem();
  }

  defaultSelectedCategory() {}

  RxList<ItemModel> allItemModel = <ItemModel>[].obs;

  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxBool isItemLoading = true.obs;

  getAllItem({String name = ''}) async {
    isItemLoading.value = true;
    FireStoreUtils.getAllItem(name, categoryId: selectedCategory.value.id ?? '', foodType: selectFoodType.value).then((value) {
      itemList.clear();
      if (value != null) itemList.value = value;
      isItemLoading.value = false;
      update();
    });
  }

  Rx<TempModel> productDetails = TempModel().obs;

  RxList<ItemAttributeModel> itemAttributeList = <ItemAttributeModel>[].obs;

  Future<void> getItemAttributeData() async {
    await FireStoreUtils.getItemAttribute().then((value) {
      if (value!.isNotEmpty) {
        itemAttributeList.value = value;
      }
    });
  }

  var specialInstruController = TextEditingController().obs;
  RxList<ItemModel> cartList = <ItemModel>[].obs;

  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;

  productDetailInit(ItemModel model) async {
    printLog("Addon model :: ${model.addons!.length}");
    selectedVariants.clear();
    selectedIndexVariants.clear();
    selectedIndexArray.clear();

    productDetails.value = TempModel.fromJson(model.toJson());
    printLog("Addon model 2 :: ${productDetails.value.addons!.length}");
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
    printLog("Addon :: ${productDetails.value.addons!.length}");
  }

  Rx<OrderModel> addToCart = OrderModel().obs;
  Rx<OfferModel> offerModel = OfferModel().obs;

  calculateAddToCart() {
    RxString taxAmount = "0.0".obs;
    RxString subTotal = "0.0".obs;
    RxString productAmount = "0.0".obs;

    RxString addonAmount = "0.0".obs;
    for (var product in addToCart.value.product!) {
      productAmount.value = (double.parse(productAmount.value) + double.parse(product.price!) * product.qty!).toString();
      for (var element in product.addons!) {
        addonAmount.value = (double.parse(addonAmount.value.toString()) + element.qty!.toDouble() * double.parse(element.price!)).toString();
      }
      subTotal.value = (double.parse(productAmount.toString()) + double.parse(addonAmount.value)).toString();
    }

    addToCart.value.subtotal = subTotal.value;

    if (offerModel.value.rate != null || offerModel.value.rate != "0" || offerModel.value.rate!.isNotEmpty) {
      addToCart.value.discount = Constant().calculateDiscount(amount: addToCart.value.subtotal, offerModel: offerModel.value).toString();
    }

    for (var element in Constant.taxList) {
      taxAmount.value = (double.parse(taxAmount.value) +
              Constant()
                  .calculateTax(amount: (double.parse(addToCart.value.subtotal.toString()) - double.parse(addToCart.value.discount.toString())).toString(), taxModel: element))
          .toStringAsFixed(int.parse(Constant.currency.decimalDigits.toString()));
    }

    addToCart.value.total = (double.parse(addToCart.value.subtotal.toString()) - double.parse(addToCart.value.discount.toString()) + double.parse(taxAmount.value)).toString();

    update();
  }

  RxString selectedDiscountType = "Percentage".obs;

  orderPlace(BuildContext context, String amount) async {
    update();
    //Remove Product Count 0
    for (int i = 0; i < addToCart.value.product!.length; i++) {
      if (addToCart.value.product?[i].qty == 0) {
        addToCart.value.product?.removeAt(i);
      }
      if (addToCart.value.product != null) {
        for (int j = 0; j < addToCart.value.product![i].addons!.length; j++) {
          //Remove Addons Count 0
          if (addToCart.value.product![i].addons![j].qty == 0) {
            addToCart.value.product![i].addons!.removeAt(j);
          }
        }
      }
      // addToCart.value.product?[i].itemAttributes!.attributes = null;
    }

    if (addToCart.value.product!.isEmpty) {
      ShowToastDialog.showToast("Please Add At least One Item");
      return null;
    } else {
      selectedPaymentMethod.value = 'cash';
      OrderModel order = OrderModel(
        product: addToCart.value.product,
        subtotal: addToCart.value.subtotal,
        total: addToCart.value.total,
        offerModel: offerModel.value,
        taxList: Constant.taxList,
        type: Constant.customerRole,
        status: Constant.statusOrderPlaced,
        paymentMethod: selectedPaymentMethod.value,
        branchId: Constant.branchId,
        tableId: Constant.tableNo,
        paymentStatus: false,
        // createdAt: Timestamp.now(),
        // updatedAt: Timestamp.now(),
      );
      if (addToCart.value.id != null) {
        order.id = addToCart.value.id;
      } else {
        order.id = Constant().getUuid();
      }
      await Preferences.setString(Preferences.orderData, jsonEncode(order.toJson()));
      await placeOrder(order);
      ShowToastDialog.showToast("Order Place successfully");
      Get.offAll(OrderDetailScreen(ordermodel: order, restaurantId: Constant.restaurantModel.id ?? ''));
    }
  }

  placeOrder(OrderModel order) async {
    ShowToastDialog.showLoader("Please wait...");
    log("PlaceOrder :: ${order.toJson()}");
    await FireStoreUtils.orderPlace(order).then((value) async {
      await FireStoreUtils.getAllUserByBranch(Constant.branchId).then((value) async {
        if (value != null) {
          for (var element in value) {
            if (element.fcmToken != null) {
              if (element.notificationReceive == true || element.fcmToken!.isNotEmpty) {
                Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": order.id};
                await SendNotification.sendOneNotification(
                  token: element.fcmToken.toString(),
                  title: "New Order",
                  body: "New Table Order Placed on ${diningTableModel.value.name}",
                  payload: playLoad,
                );
              }
            }
          }
        }
      });
    });
    ShowToastDialog.closeLoader();
  }

  Rx<String> selectFoodType = 'All'.obs;

  RxInt selectItemView = 0.obs;
  RxBool isReadMore = false.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var couponCodeText = TextEditingController().obs;
  RxBool isOfferApply = false.obs;

  getOfferData() async {
    await FireStoreUtils.getAllOffer().then((value) {
      for (var element in value) {
        if (element.code?.toLowerCase() == couponCodeText.value.text.trim().toLowerCase() && element.startDate!.toDate().isBefore(DateTime.now())) {
          offerModel.value = element;
          isOfferApply.value = true;
          ShowToastDialog.showToast("Offer has been applied.");
        }
      }
    });
    if (offerModel.value.id == null) {
      ShowToastDialog.showToast("Please Enter Valid Coupon Code.");
    }
    calculateAddToCart();
  }

  Rx<OrderModel> orderDetails = OrderModel().obs;
}
