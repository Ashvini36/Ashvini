import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/email_template_model.dart';
import 'package:ebasket_customer/app/model/language_model.dart';
import 'package:ebasket_customer/app/model/mail_setting.dart';
import 'package:ebasket_customer/app/model/payment_method_model.dart';
import 'package:ebasket_customer/app/model/wallet_transaction_model.dart';
import 'package:ebasket_customer/services/helper.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:ebasket_customer/app/model/attributes_model.dart';
import 'package:ebasket_customer/app/model/brands_model.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/model/coupon_model.dart';
import 'package:ebasket_customer/app/model/delivery_charge_model.dart';
import 'package:ebasket_customer/app/model/driver_model.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/my_card.dart';
import 'package:ebasket_customer/app/model/notification_payload_model.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/model/vendor_model.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:intl/intl.dart';

class FireStoreUtils {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static String getCurrentUid() {
    return auth.FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<String?> firebaseCreateNewUser(UserModel user) async =>
      await fireStore.collection(CollectionName.users).doc(user.id).set(user.toJson()).then((value) => null, onError: (e) => e);

  static Future<UserModel?> getUserProfile(String uuid) async {
    UserModel? userModel;
    await fireStore.collection(CollectionName.users).doc(uuid).get().then((value) {
      if (value.exists) {
        print(value.data());
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.users).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> updateCurrentUser(UserModel user) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.users).doc(user.id).set(user.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (auth.FirebaseAuth.instance.currentUser != null) {
      isLogin = await fireStore.collection(CollectionName.users).doc(auth.FirebaseAuth.instance.currentUser!.uid).get().then(
        (value) {
          if (value.exists) {
            return true;
          } else {
            return false;
          }
        },
      ).catchError((error) {
        return false;
      });
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<List<CategoryModel>?> getCategories() async {
    List<CategoryModel> categories = [];

    await fireStore.collection(CollectionName.vendorCategories).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        CategoryModel categoryModel = CategoryModel.fromJson(element.data());
        categories.add(categoryModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return categories;
  }

  getSettings() async {
    await fireStore.collection(CollectionName.setting).doc("DeliveryCharge").get().then((value) {
      if (value.exists) {
        Constant.deliveryChargeModel = DeliveryChargeModel.fromJson(value.data()!);
      }
    });

    await fireStore.collection(CollectionName.setting).doc("privacyPolicy").get().then((value) {
      if (value.exists) {
        Constant.privacyPolicy = value.data()!["privacy_policy"];
      }
    });

    await fireStore.collection(CollectionName.setting).doc("termsAndConditions").get().then((value) {
      if (value.exists) {
        Constant.termsAndConditions = value.data()!["termsAndConditions"];
      }
    });

    await fireStore.collection(CollectionName.setting).doc("refundPolicy").get().then((value) {
      if (value.exists) {
        Constant.refundPolicy = value.data()!["refund_policy"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("support").get().then((value) {
      if (value.exists) {
        Constant.help = value.data()!["support"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("aboutUs").get().then((value) {
      if (value.exists) {
        Constant.aboutUs = value.data()!["about_us"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("placeHolderImage").get().then((value) {
      if (value.exists) {
        Constant.placeholderImage = value.data()!["image"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("globalSettings").get().then((value) {
      if (value.exists) {
        print(value.data());
        Constant.minorderAmount = value.data()!["min_order_amount"];
        Constant.minimumAmountToDeposit = value.data()!["minimumAmountToDeposit"] ?? "0.0";
        Constant.vendorRadius = value.data()!["vendorRadius"] ?? '0.0';
        AppThemeData.groceryAppDarkBlue = Color(int.parse(value.data()!["colour_customer"].replaceFirst("#", "0xff")));
        Constant.selectedMapType = value.data()!["selectedMapType"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("googleMapKey").get().then((value) {
      if (value.exists) {
        Constant.mapKey = value.data()!["key"];
      }
    });
    await FirebaseFirestore.instance.collection(CollectionName.setting).doc("emailSetting").get().then((value) {
      if (value.exists) {
        mailSettings = MailSettings.fromJson(value.data()!);
      }
    });

    await FirebaseFirestore.instance.collection(CollectionName.setting).doc("notification_setting").get().then((value) {
      if (value.exists) {
        Constant.senderId = value.data()!["senderId"];
        Constant.jsonNotificationFileURL = value.data()!["serviceJson"];
      }
    });
  }

  Future<List<TaxModel>?> getTaxList() async {
    List<TaxModel> taxList = [];

    await fireStore.collection(CollectionName.tax).where('country', isEqualTo: Constant.country).where('enable', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        TaxModel taxModel = TaxModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<List<ProductModel>?> getAllDeliveryProducts() async {
    List<ProductModel> product = [];

    await fireStore.collection(CollectionName.products).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        product.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return product;
  }

  static Future<List<ProductModel>?> getEstablishBrandProducts() async {
    List<ProductModel> product = [];

    await fireStore.collection(CollectionName.products).where('is_establish_brand', isEqualTo: true).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        product.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return product;
  }

  static Future<List<ProductModel>?> getBestOfferProducts() async {
    List<ProductModel> product = [];

    await fireStore.collection(CollectionName.products).where('is_best_offer', isEqualTo: true).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        product.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return product;
  }

  static Future<List<BrandsModel>?> getBrands() async {
    List<BrandsModel> brand = [];

    await fireStore.collection(CollectionName.brands).where('is_publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        BrandsModel productModel = BrandsModel.fromJson(element.data());
        brand.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return brand;
  }

  static Future<List<ProductModel>?> getProductListByBrandId(String brandId) async {
    List<ProductModel> brand = [];

    await fireStore.collection(CollectionName.products).where('brandID', isEqualTo: brandId).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        brand.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return brand;
  }

  static Future<ProductModel?> updateProduct(ProductModel prodduct) async {
    return await fireStore.collection(CollectionName.products).doc(prodduct.id).set(prodduct.toJson()).then((document) {
      return prodduct;
    });
  }

  static Future<List<ProductModel>?> getProductListByCategoryId(String categoryId) async {
    List<ProductModel> category = [];

    await fireStore.collection(CollectionName.products).where('categoryID', isEqualTo: categoryId).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ProductModel productModel = ProductModel.fromJson(element.data());
        category.add(productModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return category;
  }

  static Future<List<FavouriteItemModel>?> getFavouritesProductList(String userId) async {
    List<FavouriteItemModel> listFavourites = [];
    await fireStore.collection(CollectionName.favouriteItem).where('user_id', isEqualTo: userId).get().then((value) {
      for (var element in value.docs) {
        FavouriteItemModel favoriteModel = FavouriteItemModel.fromJson(element.data());
        listFavourites.add(favoriteModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return listFavourites;
  }

  static Future<String?> addFavouriteItem(FavouriteItemModel favouriteModel) async {
    try {
      await fireStore.collection(CollectionName.favouriteItem).doc(favouriteModel.id).set(favouriteModel.toJson());
    } catch (e, s) {
      log('FireStoreUtils.addFavouriteItem $e $s');
      return null;
    }
    return null;
  }

  static Future<String?> removeFavouriteItem(FavouriteItemModel favouriteModel) async {
    try {
      await fireStore.collection(CollectionName.favouriteItem).doc(favouriteModel.id).delete();
    } catch (e, s) {
      log('FireStoreUtils.removeFavouriteItem $e $s');
      return null;
    }
    return null;
  }

  static Future<VendorModel?> getVendor() async {
    VendorModel? vendor;
    await fireStore.collection(CollectionName.vendor).get().then((value) {
      vendor = VendorModel.fromJson(value.docs.first.data());
    });
    return vendor;
  }

  static Future<ProductModel?> getProductByProductId(String productId) async {
    ProductModel? product;
    await fireStore.collection(CollectionName.products).where('id', isEqualTo: productId).where('publish', isEqualTo: true).get().then((value) {
      product = ProductModel.fromJson(value.docs.first.data());
    }).catchError((error) {
      log(error.toString());
    });
    return product;
  }

  static Future<List<CouponModel>?> getCoupon() async {
    List<CouponModel> couponModel = [];

    await fireStore.collection(CollectionName.coupons).where('isEnabled', isEqualTo: true).where('expiresAt', isGreaterThanOrEqualTo: Timestamp.now()).get().then((value) {
      for (var element in value.docs) {
        CouponModel taxModel = CouponModel.fromJson(element.data());
        couponModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return couponModel;
  }

  static Future<bool?> placeOrder(OrderModel orderModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.orders).doc(orderModel.id).set(orderModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<OrderModel?> getOrderById(String orderId) async {
    OrderModel? orderModel;
    await fireStore.collection(CollectionName.orders).doc(orderId).get().then((value) {
      if (value.data() != null) {
        orderModel = OrderModel.fromJson(value.data()!);
      }
    });
    return orderModel;
  }

  static Future<bool?> setCard(CardData cardData) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.cards).doc(cardData.id).set(cardData.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to setCard: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<CardData>?> getCardList(String userId) async {
    List<CardData> cardList = [];

    await fireStore.collection(CollectionName.cards).where('user_id', isEqualTo: userId).get().then((value) {
      for (var element in value.docs) {
        CardData cardModel = CardData.fromJson(element.data());
        cardList.add(cardModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return cardList;
  }

  static Future<List<NotificationPayload>?> getNotification(String userId) async {
    List<NotificationPayload> notificationList = [];

    await fireStore
        .collection(CollectionName.notifications)
        .where('userId', isEqualTo: userId)
        .where('role', isEqualTo: Constant.USER_ROLE_CUSTOMER)
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      print('====>');
      print(value.docs.length);
      for (var element in value.docs) {
        NotificationPayload notificationModel = NotificationPayload.fromJson(element.data());
        notificationList.add(notificationModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return notificationList;
  }

  static Future<bool?> setNotification(NotificationPayload notificationData) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.notifications).doc(notificationData.id).set(notificationData.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to setCard: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<AttributesModel>?> getVendorAttribute() async {
    List<AttributesModel> attributeModel = [];

    await fireStore.collection(CollectionName.vendorAttributes).get().then((value) {
      for (var element in value.docs) {
        AttributesModel taxModel = AttributesModel.fromJson(element.data());
        attributeModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return attributeModel;
  }

  static Future<DriverModel?> getDriver(String? pinCode) async {
    DriverModel? driverModel;
    await fireStore.collection(CollectionName.users).where('role', isEqualTo: 'driver').where('pinCode', isEqualTo: pinCode).where('active', isEqualTo: true).get().then((value) {
      driverModel = DriverModel.fromJson(value.docs.first.data());
    }).catchError((error) {
      log(error.toString());
    });
    return driverModel;
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> updateUserWallet({required String amount}) async {
    bool isAdded = false;
    await getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
      if (value != null) {
        UserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.users).doc(userModel.id).set(userModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore.collection(CollectionName.setting).doc("payment").get().then((value) {
      if (value.data() != null) {
        paymentModel = PaymentModel.fromJson(value.data()!);
      }
    });
    return paymentModel;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModel = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WalletTransactionModel taxModel = WalletTransactionModel.fromJson(element.data());
        walletTransactionModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModel;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    await fireStore.collection(CollectionName.languages).get().then((value) {
      for (var element in value.docs) {
        LanguageModel taxModel = LanguageModel.fromJson(element.data());
        languageList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return languageList;
  }

  static sendOrderEmail({required OrderModel orderModel}) async {
    String firstHTML = """
       <table style="width: 100%; border-collapse: collapse; border: 1px solid rgb(0, 0, 0);">
    <thead>
        <tr>
            <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Product Name<br></th>
            <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Quantity<br></th>
            <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Price<br></th>
            <th style="text-align: left; border: 1px solid rgb(0, 0, 0);">Total<br></th>
        </tr>
    </thead>
    <tbody>
    """;

    EmailTemplateModel? emailTemplateModel = await FireStoreUtils.getEmailTemplates(CollectionName.newOrderPlaced);

    String newString = emailTemplateModel!.message.toString();
    newString = newString.replaceAll("{username}", Constant.currentUser.fullName.toString());
    newString = newString.replaceAll("{orderid}", orderModel.id);
    newString = newString.replaceAll("{date}", DateFormat('dd-MM-yyyy').format(orderModel.createdAt.toDate()));
    newString = newString.replaceAll(
      "{address}",
      '${orderModel.address!.getFullAddress()}',
    );
    newString = newString.replaceAll(
      "{paymentmethod}",
      orderModel.paymentMethod,
    );

    double deliveryCharge = 0.0;
    double total = 0.0;
    double specialDiscount = 0.0;
    double discount = 0.0;
    double taxAmount = 0.0;
    double tipValue = 0.0;
    List<String> htmlList = [];

    if (orderModel.deliveryCharge != null) {
      deliveryCharge = double.parse(orderModel.deliveryCharge.toString());
    }

    orderModel.products.forEach((element) {

      double productTotalValue = 0.0;

      if (element.discountPrice != '0') {

        productTotalValue += double.parse(element.discountPrice!) *element.quantity;
      } else {

        productTotalValue += double.parse(element.price) * element.quantity;
      }

      total += productTotalValue;


      String product = """
        <tr>
            <td style="width: 20%; border-top: 1px solid rgb(0, 0, 0);">${element.name}</td>
            <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" >${element.quantity}</td>
            <td style="width: 20%; border: 1px solid rgb(0, 0, 0);" >${Constant.amountShow(amount:productTotalValue.toString())}</td>
            <td style="width: 20%; border: 1px solid rgb(0, 0, 0);">${Constant.amountShow(amount:  (element.quantity * productTotalValue).toString())}</td>
      
        </tr>
    
    """;
      htmlList.add(product);
    });

    if (orderModel.coupon!.id != null && orderModel.coupon!.id!.isNotEmpty) {
      if (orderModel.coupon!.discountType == "Fix Price") {
       discount = double.parse(orderModel.coupon!.discount.toString());
      } else {
       discount = double.parse(total.toString()) * double.parse(orderModel.coupon!.discount.toString()) / 100;
      }
    }

    List<String> taxHtmlList = [];
    if (orderModel.taxModel != null) {
      for (var element in orderModel.taxModel!) {
        taxAmount = taxAmount + Constant.calculateTax(amount: (total - discount).toString(), taxModel: element);
        String taxHtml =
            """<span style="font-size: 1rem;">${element.title}: ${Constant.amountShow(amount: Constant.calculateTax(amount: (total - discount).toString(), taxModel: element).toString())}${orderModel.taxModel!.indexOf(element) == orderModel.taxModel!.length - 1 ? "</span>" : "<br></span>"}""";
        taxHtmlList.add(taxHtml);
      }
    }

    var totalamount = orderModel.deliveryCharge == null || orderModel.deliveryCharge!.isEmpty
        ? total + taxAmount - discount
        : total + taxAmount + double.parse(orderModel.deliveryCharge!)  -discount;

    newString = newString.replaceAll("{subtotal}", Constant.amountShow(amount: total.toString()));
    newString = newString.replaceAll("{discount}", Constant.amountShow(amount: discount.toString()));
    newString = newString.replaceAll("{deliverycharge}", Constant.amountShow(amount: deliveryCharge.toString()));
    newString = newString.replaceAll("{totalAmount}", Constant.amountShow(amount: totalamount.toString()));

    String tableHTML = htmlList.join();
    String lastHTML = "</tbody></table>";
    newString = newString.replaceAll("{productdetails}", firstHTML + tableHTML + lastHTML);
    newString = newString.replaceAll("{taxdetails}", taxHtmlList.join());

    String subjectNewString = emailTemplateModel.subject.toString();
    subjectNewString = subjectNewString.replaceAll("{orderid}", orderModel.id);
    await sendMail(subject: subjectNewString, isAdmin: emailTemplateModel.isSendToAdmin, body: newString, recipients: [Constant.currentUser.email]);
  }

  static Future<EmailTemplateModel?> getEmailTemplates(String type) async {
    EmailTemplateModel? emailTemplateModel;
    await fireStore.collection(CollectionName.emailTemplates).where('type', isEqualTo: type).get().then((value) {
      print("------>");
      if (value.docs.isNotEmpty) {
        print(value.docs.first.data());
        emailTemplateModel = EmailTemplateModel.fromJson(value.docs.first.data());
      }
    });
    return emailTemplateModel;
  }
}
