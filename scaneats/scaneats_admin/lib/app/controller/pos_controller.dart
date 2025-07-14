// ignore_for_file: avoid_types_as_parameter_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/model/item_attributes_model.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/temp_model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/send_notification.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class PosController extends GetxController {
  RxString title = "POS Screen".obs;

  Rx<TextEditingController> textEditingController = TextEditingController().obs;
  final Rx<TextEditingController> searchEditingController = TextEditingController().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    isItemLoading.value = true;
    await getItemCategoriesData();
    await getAllItem();
    await getItemAttributeData();
    await getCustomerData();
    await getCartData();
  }

  getCartData() {
    // Preferences.clearKeyData(Preferences.order);
    addToCart.value = Constant.getOrderData();
  }

  RxList<ItemCategoryModel> itemCategoryList = <ItemCategoryModel>[].obs;
  RxList<OrderModel> orderList = <OrderModel>[].obs;
  Rx<ItemCategoryModel> selectedCategory = ItemCategoryModel().obs;

  Future<void> getItemCategoriesData() async {
    await FireStoreUtils.getAllOrderWithoutBranch().then((value) {
      if (value != null) {
        orderList.value = value;
      }
    });
    await FireStoreUtils.getItemCategory().then((value) {
      itemCategoryList.clear();
      itemCategoryList.add(ItemCategoryModel(
        id: '',
        name: 'All',
        image:
            'https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/Item%2Fcategories%2Fd91b6651-eba0-4ccf-b67e-ffb8967b17de?alt=media&token=0909e5ea-224d-473a-b235-3735a6d03f15',
        isActive: true,
        description: '',
      ));
      if (value!.isNotEmpty) {
        itemCategoryList.addAll(value);
      }
    });
    selectedCategory.value = itemCategoryList.first;
  }

  RxList<ItemModel> allItemModel = <ItemModel>[].obs;

  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxBool isItemLoading = true.obs;

  getAllItem({String name = ''}) async {
    await FireStoreUtils.getAllItem(name, categoryId: selectedCategory.value.id ?? '').then((value) {
      if (value != null) {
        itemList.clear();
        itemList.value = value;
        isItemLoading.value = false;
        update();
      }
    });
  }

  RxList<ItemAttributeModel> itemAttributeList = <ItemAttributeModel>[].obs;
  Rx<TempModel> productDetails = TempModel().obs;

  Future<void> getItemAttributeData() async {
    await FireStoreUtils.getItemAttribute().then((value) {
      if (value!.isNotEmpty) {
        itemAttributeList.value = value;
      }
    });
  }

  Rx<UserModel> selectedCustomer = UserModel().obs;
  RxList<UserModel> customerList = <UserModel>[].obs;

  Future<void> getCustomerData() async {
    await FireStoreUtils.getAllUser('customer').then((value) {
      customerList.value = value ?? [];
    });
  }

  Rx<TextEditingController> specialInstruController = TextEditingController().obs;
  Rx<TextEditingController> discountController = TextEditingController().obs;
  Rx<TextEditingController> tokenController = TextEditingController().obs;

  var name = TextEditingController().obs;
  var email = TextEditingController().obs;
  var phone = TextEditingController().obs;
  var password = TextEditingController().obs;
  var conPassword = TextEditingController().obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConformationPasswordVisible = false.obs;
  var active = false.obs;
  RxBool isNotAdded = false.obs;
  RxString status = 'Active'.obs;
  RxString profileImage = ''.obs;
  Rx<Uint8List> profileImageUin8List = Uint8List(100).obs;

  Future<void> setCustomerData(UserModel model, {bool isEdit = false}) async {
    FireStoreUtils.setUserModel(model).then((value) async {
      if (value?.id != null) {
        customerList.add(model);
        customerList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
        setDefaultData();
        isNotAdded.value = false;
        selectedCustomer.value = model;
        Get.back();
        ShowToastDialog.showToast("Added Customer data successfully!");
      } else {
        ShowToastDialog.showToast("Something Went Wrong...");
        isNotAdded.value = false;
      }
    });

    update();
  }

  Future loginUser() async {
    String? userId = '';
    try {
      if (name.value.text.isEmpty) {
        ShowToastDialog.showToast("Please Enter the Name.");
        return null;
      } else if (!email.value.text.isEmail) {
        ShowToastDialog.showToast("Please Enter the Valid Email.");
        return null;
      } else if (password.value.text.length <= 5) {
        ShowToastDialog.showToast("Please Enter Minimum 6 Pharacter Password");
        return null;
      } else if (password.value.text != conPassword.value.text) {
        ShowToastDialog.showToast("Your password and confirmation password do not match.");
        return null;
      } else if (name.value.text.trim().isNotEmpty && email.value.text.trim().isNotEmpty) {
        isNotAdded.value = true;

        userId = await Constant().crateWithEmailOrPassword(email.value.text, password.value.text, Constant().getUuid());
        if (userId.isEmpty) {
          isNotAdded.value = false;
          return null;
        }

        if (!profileImage.value.contains("firebasestorage.googleapis.com")) {
          profileImage.value =
              await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "profileImage/customers/", File(profileImage.value).path.split('/').last);
        }

        UserModel model = UserModel(
            id: userId,
            branchId: Constant.selectedBranch.id,
            name: name.value.text.trim(),
            email: email.value.text.toLowerCase().trim(),
            mobileNo: phone.value.text.toLowerCase().trim(),
            password: password.value.text.trim(),
            profileImage: profileImage.value == "" ? Constant.userPlaceholderURL : profileImage.value,
            isActive: status.value == 'Active',
            role: Constant.customerRole,
            roleId: Constant.customerPermissionID,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now());

        if (password.value.text.trim() == conPassword.value.text.trim() && password.value.text.trim().isNotEmpty) {
          setCustomerData(model, isEdit: false);
        } else {
          isNotAdded.value = false;
          ShowToastDialog.showToast("Please Enter the Valid Password.");
        }
      } else {
        isNotAdded.value = false;
        ShowToastDialog.showToast("It is necessary to fill out every field in its entirety without exception..");
      }
    } catch (e) {
      ShowToastDialog.showToast('notSignUp');
    }
  }

  setDefaultData() {
    name.value = TextEditingController();
    email.value = TextEditingController();
    phone.value = TextEditingController();
    password.value = TextEditingController();
    conPassword.value = TextEditingController();
    profileImageUin8List.value = Uint8List(100);
    profileImage.value = '';
    status.value = 'Active';
  }

  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;

  productDetailInit(ItemModel model) async {
    selectedVariants.clear();
    selectedIndexVariants.clear();
    selectedIndexArray.clear();
    print("c=========>");
    print("${productDetails.value.qty}");
    productDetails.value = TempModel.fromJson(model.toJson());
    print("c=========>");
    print("${productDetails.value.qty}");
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

  // calculateProductDetails() {
  //   var productAmount = double.parse(productDetails.value.price!) * productDetails.value.qty!;
  //   var addonAmount = productDetails.value.addons!.isNotEmpty ? productDetails.value.addons!.fold(0.0, (sum, item) => sum + item.qty!.toDouble() * double.parse(item.price!)) : 0.0;
  //   update();
  //   calculateAddToCart();
  // }

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

  orderPlace() {
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

    if (selectedCustomer.value.id == null) {
      ShowToastDialog.showToast("Please Add and Select One Customer.");
      return null;
    } else if (tokenController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please Enter Valid Token No.");
      return null;
    } else {
      OrderModel order = OrderModel(
          paymentMethod: Constant.paymentTypeCash,
          product: addToCart.value.product,
          customer: selectedCustomer.value,
          tokenNo: tokenController.value.text.trim(),
          subtotal: addToCart.value.subtotal,
          total: addToCart.value.total,
          discount: addToCart.value.discount,
          offerModel: offerModel.value,
          taxList: Constant.taxList,
          branchId: Constant.selectedBranch.id,
          status: Constant.statusOrderPlaced,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          type: Constant.orderTypePos);
      ShowToastDialog.showLoader("Please wait");
      FireStoreUtils.orderPlace(order).then((value) async {
        await FireStoreUtils.getAllUserByBranch(Constant.selectedBranch.id.toString()).then((value) async {
          if (value != null) {
            for (var element in value) {
              if (element.notificationReceive == true || (element.fcmToken != null && element.fcmToken!.isNotEmpty)) {
                Map<String, dynamic> playLoad = <String, dynamic>{"type": "order", "orderId": order.id};
                await SendNotification.sendOneNotification(
                  token: element.fcmToken.toString(),
                  title: "New Order",
                  body: "New Table Order Placed.Token No ${tokenController.value.text.trim()}",
                  payload: playLoad,
                );
              }
            }
          }
        });
        Preferences.clearKeyData(Preferences.order);
        addToCart.value = OrderModel();
        productDetails.value = TempModel();
        update();
        Get.back();
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Order Placed successfully!");
        selectedCustomer.value = UserModel();
        specialInstruController.value.clear();
        discountController.value.clear();
        tokenController.value.clear();
      });
    }
  }

  RxBool isReadMore = false.obs;
}
