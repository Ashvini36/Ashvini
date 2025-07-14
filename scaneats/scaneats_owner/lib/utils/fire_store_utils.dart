import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:scaneats_owner/app/model/currencies_model.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/app/model/notification_model.dart';
import 'package:scaneats_owner/app/model/payment_method_model.dart';
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/role_model.dart';
import 'package:scaneats_owner/app/model/subscription_model.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/app/model/theme_model.dart';
import 'package:scaneats_owner/app/model/user_model.dart';
import 'package:scaneats_owner/constant/collection_name.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<bool> loginWithEmailAndPassword(String email, String password) async {
    bool isLogin = false;
    await fireStore.collection(CollectionName.owner).doc('owner').get().then((value) {
      if (value.exists) {
        if (email == value.data()!['email'] && password == value.data()!['password']) {
          isLogin = true;
        } else {
          isLogin = false;
        }
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      // ignore: invalid_return_type_for_catch_error
      return isLogin;
    });
    return isLogin;
  }

  static Future<ThemeModel?> getThem() async {
    ThemeModel? companyDetailsModel;
    await fireStore.collection(CollectionName.settings).doc(CollectionName.theme).get().then((value) {
      if (value.exists) {
        companyDetailsModel = ThemeModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
  }

  static Future<List<LanguageModel>?> getActiveLanguage() async {
    List<LanguageModel> model = [];
    await fireStore.collection(CollectionName.languages).where("isActive", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        LanguageModel data = LanguageModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<List<CurrenciesModel>?> getCurrencies() async {
    List<CurrenciesModel> model = [];
    await fireStore.collection(CollectionName.currencies).get().then(
      (value) {
        for (var element in value.docs) {
          CurrenciesModel data = CurrenciesModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
    ).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<bool> deleteCurrenciesById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.currencies).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<List<CurrenciesModel>?> getActiveCurrencies() async {
    List<CurrenciesModel>? model = [];
    await fireStore.collection(CollectionName.currencies).where("isActive", isEqualTo: true).get().then(
      (value) {
        for (var element in value.docs) {
          CurrenciesModel data = CurrenciesModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
    ).catchError((error) {
      // ignore: invalid_return_type_for_catch_error
      return null;
    });
    return model;
  }

  static Future<CurrenciesModel> addCurrencies(CurrenciesModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.currencies).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.currencies).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<List<RestaurantModel>?> getAllRestaurant() async {
    List<RestaurantModel> model = [];
    await fireStore.collection(CollectionName.restaurants).get().then((value) {
      for (var element in value.docs) {
        RestaurantModel data = RestaurantModel.fromJson(element.data());
        model.add(data);
      }
      var data = model.sort((a, b) => b.updateAt!.compareTo(a.updateAt!));
      return data;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<RestaurantModel?> deleteRestaurantById(RestaurantModel model) async {
    await fireStore.collection(CollectionName.restaurants).doc(model.id).delete().then((value) {
      // secondaryApp.delete();
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<UserModel?> setUserModel({required String restaurantId, required UserModel model}) async {
    DocumentReference<Map<String, dynamic>> documentRef;
    documentRef = fireStore.collection(CollectionName.restaurants).doc(restaurantId).collection(CollectionName.user).doc(model.id);
    await documentRef.set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<UserModel?> getUser({required String restaurantId}) async {
    UserModel? userModel;
    await fireStore.collection(CollectionName.restaurants).doc(restaurantId).collection(CollectionName.user).where("restaurantId", isEqualTo: restaurantId).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(value.docs.first.data());
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return userModel;
    });
    return userModel;
  }

  static Future<RestaurantModel?> setRestaurant({required RestaurantModel model}) async {
    DocumentReference<Map<String, dynamic>> documentRef = fireStore.collection(CollectionName.restaurants).doc(model.id);
    await documentRef.set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<RestaurantModel?> getRestaurantById(String restaurantId) async {
    RestaurantModel? companyDetailsModel;
    await fireStore.collection(CollectionName.restaurants).doc(restaurantId).get().then((value) {
      if (value.exists) {
        companyDetailsModel = RestaurantModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
  }

  static Future<String?> setRole({required String restaurantId}) async {
    String? roleId;
    List<RolePermission> rolePermission = [
      RolePermission(title: 'Items', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Dining Tables', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Offers', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Administrators', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Customers', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Employees', isEdit: true, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Sales Report', isEdit: true, isUpdate: true, isDelete: true, isView: true),
    ];

    RoleModel modelData = RoleModel(id: Constant().getUuid(), isActive: true, isEdit: false, position: 0, title: "Admin", permission: rolePermission);

    DocumentReference<Map<String, dynamic>> documentRef = fireStore.collection(CollectionName.restaurants).doc(restaurantId).collection(CollectionName.role).doc(modelData.id);
    await documentRef.set(modelData.toJson()).then((value) {
      roleId = modelData.id;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      // ignore: invalid_return_type_for_catch_error
      return roleId;
    });
    return roleId;
  }

  static Future<LanguageModel> addLanguage(LanguageModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.languages).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.languages).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<LanguageModel?> deleteLanguageId(LanguageModel model) async {
    await fireStore.collection(CollectionName.languages).doc(model.id).delete().then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<NotificationModel?> getServerKeyDetails() async {
    NotificationModel? companyDetailsModel;
    await fireStore.collection(CollectionName.settings).doc(CollectionName.notification).get().then((value) {
      if (value.exists) {
        companyDetailsModel = NotificationModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
  }

  static Future<NotificationModel> addUpdateNotification(NotificationModel model) async {
    await fireStore.collection(CollectionName.settings).doc(CollectionName.notification).set(model.toJson()).then((value) {
      return model;
    });
    return model;
  }

  static Future<ThemeModel> addUpdateThem(ThemeModel model) async {
    await fireStore.collection(CollectionName.settings).doc(CollectionName.theme).set(model.toJson()).then((value) {
      return model;
    });
    return model;
  }

  static Future<String> uploadUserImageToFireStorage(Uint8List image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = upload.putData(image, metadata);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> model = [];
    await fireStore.collection(CollectionName.languages).get().then((value) {
      for (var element in value.docs) {
        LanguageModel data = LanguageModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<List<SubscriptionModel>?> getAllSubscription() async {
    List<SubscriptionModel> model = [];
    await fireStore.collection(CollectionName.subscriptions).get().then((value) {
      for (var element in value.docs) {
        SubscriptionModel data = SubscriptionModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<SubscriptionModel?> deleteSubscriptionById(SubscriptionModel model) async {
    await fireStore.collection(CollectionName.subscriptions).doc(model.id).delete().then((value) {
      // secondaryApp.delete();
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<SubscriptionModel> setSubscriptionTable(SubscriptionModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.subscriptions).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.subscriptions).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      throw error;
    });
    return model;
  }

  static Future<List<SubscriptionTransaction>?> getAllSubscriptionTransaction() async {
    try {
      List<SubscriptionTransaction> model = [];
      await fireStore.collection(CollectionName.subscriptionTransaction).orderBy('startDate', descending: true).get().then((value) {
        printLog("ORDER MODEL :: ${value.docs.length}");
        for (var element in value.docs) {
          SubscriptionTransaction data = SubscriptionTransaction.fromJson(element.data());
          model.add(data);
        }
        return model;
      }).catchError((error) {
        throw error;
      });
      return model;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<SubscriptionTransaction?> setSubscriptionTraction({required SubscriptionTransaction model}) async {
    DocumentReference<Map<String, dynamic>> documentRef = fireStore.collection(CollectionName.subscriptionTransaction).doc(model.id);
    await documentRef.set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<PaymentModel?> getPaymentData() async {
    PaymentModel? paymentModel;
    await fireStore.collection(CollectionName.settings).doc(CollectionName.paymentSettings).get().then((value) {
      if (value.exists) {
        paymentModel = PaymentModel.fromJson(value.data()!);
      }
    });
    return paymentModel;
  }

  static Future<PaymentModel?> setPaymentData({required PaymentModel model}) async {
    DocumentReference<Map<String, dynamic>> documentRef = fireStore.collection(CollectionName.settings).doc(CollectionName.paymentSettings);
    await documentRef.set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
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
