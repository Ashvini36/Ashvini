import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:scaneats_customer/constant/collection_name.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/model/currencies_model.dart';
import 'package:scaneats_customer/model/dining_table_model.dart';
import 'package:scaneats_customer/model/item_attributes_model.dart';
import 'package:scaneats_customer/model/item_category_model.dart';
import 'package:scaneats_customer/model/item_model.dart';
import 'package:scaneats_customer/model/notification_model.dart';
import 'package:scaneats_customer/model/offer_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/model/payment_method_model.dart';
import 'package:scaneats_customer/model/restaurant_model.dart';
import 'package:scaneats_customer/model/tax_model.dart';
import 'package:scaneats_customer/model/theme_model.dart';
import 'package:scaneats_customer/model/user_model.dart';
import 'package:scaneats_customer/widget/global_widgets.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<String> uploadUserImageToFireStorage(Uint8List image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = upload.putData(image, metadata);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<ItemModel>?> getAllItem(String name, {String categoryId = '', String? foodType = ''}) async {
    List<ItemModel> modelData = [];
    if (categoryId == "All") {
      await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.item).orderBy('name', descending: true).get().then((value) {
        for (var element in value.docs) {
          ItemModel model = ItemModel.fromJson(element.data());
          modelData.add(model);
        }
      }).catchError((error) {
        debugPrint("Failed to update user: $error");
        // ignore: invalid_return_type_for_catch_error
        return modelData;
      });
    } else if (categoryId == "Feature") {
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.item)
          .where('isFeature', isEqualTo: true)
          .orderBy('name', descending: true)
          .get()
          .then((value) {
        for (var element in value.docs) {
          ItemModel model = ItemModel.fromJson(element.data());
          modelData.add(model);
        }
        printLog("categoryId :: $categoryId :: ${modelData.length}");
      }).catchError((error) {
        debugPrint("Failed to update user: $error");
        // ignore: invalid_return_type_for_catch_error
        return modelData;
      });
    } else {
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.item)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('name', descending: true)
          .get()
          .then((value) {
        for (var element in value.docs) {
          ItemModel model = ItemModel.fromJson(element.data());
          modelData.add(model);
        }
      }).catchError((error) {
        debugPrint("Failed to update user: $error");
        // ignore: invalid_return_type_for_catch_error
        return modelData;
      });
    }

    List<ItemModel> data = modelData.where((e) => e.name!.toLowerCase().contains(name.toLowerCase())).toList();
    if (foodType != 'All') {
      data = modelData.where((e) => e.itemType!.toLowerCase() == foodType!.toLowerCase()).toList();
    }
    return data;
  }

  static Future<List<ItemCategoryModel>?> getItemCategory() async {
    List<ItemCategoryModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemCategory).get().then(
      (value) {
        for (var element in value.docs) {
          ItemCategoryModel data = ItemCategoryModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
      // ignore: body_might_complete_normally_catch_error
    ).catchError((error) {
      printLog(error);
    });
    return model;
  }

  static Future<List<ItemAttributeModel>?> getItemAttribute() async {
    List<ItemAttributeModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemAttribute).get().then(
      (value) {
        for (var element in value.docs) {
          ItemAttributeModel data = ItemAttributeModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
      // ignore: body_might_complete_normally_catch_error
    ).catchError((error) {
      printLog(error);
    });
    return model;
  }

  static Future<List<CurrenciesModel>?> getActiveCurrencies() async {
    List<CurrenciesModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).where("isActive", isEqualTo: true).get().then(
      (value) {
        for (var element in value.docs) {
          CurrenciesModel data = CurrenciesModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
      // ignore: body_might_complete_normally_catch_error
    ).catchError((error) {
      printLog(error);
    });
    return model;
  }

  static Future<List<TaxModel>?> getActiveTax() async {
    List<TaxModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).where("isActive", isEqualTo: true).get().then(
      (value) {
        for (var element in value.docs) {
          TaxModel data = TaxModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
      // ignore: body_might_complete_normally_catch_error
    ).catchError((error) {
      printLog(error);
    });
    return model;
  }

  static Future<bool> orderPlace(OrderModel model) async {
    var isPlace = false;
    if (model.id == null) {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).doc().id;
      model.id = ref;
    }
    model.createdAt = Timestamp.now();
    model.updatedAt = Timestamp.now();
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.order).doc(model.id).set(model.toJson()).then((value) {
      isPlace = true;
    }).catchError((error) {
      isPlace = false;
    });
    return isPlace;
  }

  static Future<ThemeModel?> getThem() async {
    ThemeModel? companyDetailsModel;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.settings).doc(CollectionName.theme).get().then((value) {
      if (value.exists) {
        companyDetailsModel = ThemeModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
  }

  static Future<DiningTableModel?> getDiningTableById(String id) async {
    DiningTableModel? model;
    if (id.isNotEmpty) {
      await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.diningTables).doc(id).get().then((value) {
        if (value.exists) {
          model = DiningTableModel.fromJson(value.data()!);
        }
        return model;
      }).catchError((error) {
        printLog("Failed to update user: $error");
        return model;
      });
      return model;
    }
    return model;
  }

  static Future<NotificationModel?> getServerKeyDetails() async {
    NotificationModel? companyDetailsModel;
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.settings)
        .doc(CollectionName.notification)
        .get()
        .then((value) {
      if (value.exists) {
        companyDetailsModel = NotificationModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
  }

  static Future<List<UserModel>?> getAllUserByBranch(String branchId) async {
    List<UserModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.user)
        .where('branchId', isEqualTo: branchId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        UserModel data = UserModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<List<OfferModel>> getAllOffer() async {
    List<OfferModel> model = <OfferModel>[];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.offers)
        .where('isActive', isEqualTo: true)
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
        .get()
        .then((value) {
      for (var element in value.docs) {
        OfferModel data = OfferModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<RestaurantModel?> getRestaurantById({required String restaurantId}) async {
    RestaurantModel? model;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).get().then((value) {
      if (value.exists) {
        model = RestaurantModel.fromJson(value.data()!);
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<List<OrderModel>?> getAllOrderWithoutBranch() async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      printLog("ORDER MODEL :: ${value.docs.length}");
      for (var element in value.docs) {
        OrderModel data = OrderModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<PaymentMethodModel?> getPaymentData() async {
    PaymentMethodModel? paymentModel;
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.settings)
        .doc(CollectionName.paymentSettings)
        .get()
        .then((value) {
      if (value.exists) {
        paymentModel = PaymentMethodModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
    });
    return paymentModel;
  }

  static Future<UserModel?> getRestaurantUserById(String id) async {
    try {
      UserModel? model;
      await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).doc(id).get().then((value) {
        if (value.exists) {
          model = UserModel.fromJson(value.data()!);
        }
        return model;
      }).catchError((error) {
        printLog("Failed to update user: $error");
        return model;
      });
      return model;
    } catch (e) {
      printLog(e.toString());
    }
    return null;
  }

  static Future<List<OrderModel>?> getAllOrderwithTableNo({String? tableNo}) async {
    log("TableNo :: $tableNo ");
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where('tableId', isEqualTo: tableNo)
        .where('status', isNotEqualTo: Constant.statusRejected)
        .where('paymentStatus', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      printLog("TableNo :: ${value.docs.length}");
      for (var element in value.docs) {
        OrderModel data = OrderModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<void> getNotificationData() async {
    await fireStore.collection(CollectionName.settings).doc("notification_setting").get().then((event) {
      if (event.exists) {
        Constant.senderId = event.data()!["senderId"];
        Constant.jsonNotificationFileURL = event.data()!["serviceJson"];
      }
    });
  }
}
