import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:ebasket_driver/app/model/admin_commission_model.dart';
import 'package:ebasket_driver/app/model/delievery_charge_model.dart';
import 'package:ebasket_driver/app/model/notification_payload_model.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/app/model/user_model.dart';
import 'package:ebasket_driver/constant/collection_name.dart';
import 'package:ebasket_driver/constant/constant.dart';

class FireStoreUtils {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static String getCurrentUid() {
    return auth.FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<dynamic> loginWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await fireStore.collection(CollectionName.users).doc(result.user?.uid ?? '').get();
      DriverModel? user;

      if (documentSnapshot.exists) {
        user = DriverModel.fromJson(documentSnapshot.data() ?? {});

        user.fcmToken = await firebaseMessaging.getToken() ?? '';
      }
      return user;
    } on auth.FirebaseAuthException catch (exception) {
      switch (exception.code) {
        case 'invalid-credential':
          return 'Invalid credential, Please check.';
        case 'invalid-email':
          return 'Invalid Email address, Please check.';
        // return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e) {
      return 'Login failed, Please try again.';
    }
  }

  static Future<DriverModel?> updateCurrentUser(DriverModel user) async {
    return await fireStore.collection(CollectionName.users).doc(user.id).set(user.toJson()).then((document) {
      return user;
    });
  }

  static Future<DriverModel?> getUserProfile(String uuid) async {
    DriverModel? userModel;
    await fireStore.collection(CollectionName.users).doc(uuid).get().then((value) {
      if (value.exists) {
        userModel = DriverModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      userModel = null;
    });
    return userModel;
  }

  static Future<UserModel?> getUser(String? id) async {
    UserModel? driverModel;
    await fireStore.collection(CollectionName.users).where('role', isEqualTo: 'customer').where('id', isEqualTo: id).get().then((value) {
      driverModel = UserModel.fromJson(value.docs.first.data());
    });
    return driverModel;
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

  static Future<OrderModel?> updateOrder(OrderModel orderModel) async {
    return await fireStore.collection(CollectionName.orders).doc(orderModel.id).set(orderModel.toJson()).then((document) {
      return orderModel;
    });
  }

  static Future<OrderModel?> getOrder(String uuid) async {
    OrderModel? orderModel;
    await fireStore.collection(CollectionName.orders).doc(uuid).get().then((value) {
      if (value.exists) {
        orderModel = OrderModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      orderModel = null;
    });
    return orderModel;
  }

  static Future<List<NotificationPayload>?> getNotification(String userId) async {
    List<NotificationPayload> notificationList = [];

    await fireStore
        .collection(CollectionName.notifications)
        .where('userId', isEqualTo: userId)
        .where('role', isEqualTo: Constant.USER_ROLE_DRIVER)
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        NotificationPayload notificationModel = NotificationPayload.fromJson(element.data());
        notificationList.add(notificationModel);
      }
    }).catchError((error) {});
    return notificationList;
  }

  static Future<bool?> setNotification(NotificationPayload notificationData) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.notifications).doc(notificationData.id).set(notificationData.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      isAdded = false;
    });
    return isAdded;
  }

  getSettings() async {
    await fireStore.collection(CollectionName.setting).doc("DeliveryCharge").get().then((value) {
      if (value.exists) {
        Constant.deliveryChargeModel = DeliveryChargeModel.fromJson(value.data()!);
      }
    });

    await fireStore.collection(CollectionName.setting).doc("AdminCommission").get().then((value) {
      if (value.exists) {
        Constant.adminCommission = AdminCommission.fromJson(value.data()!);
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
        Constant.placeHolder = value.data()!["image"];
      }
    });
    await fireStore.collection(CollectionName.setting).doc("globalSettings").get().then((value) {
      if (value.exists) {
        Constant.minorderAmount = value.data()!["min_order_amount"];
        Constant.selectedMapType = value.data()!["selectedMapType"];
      }
    });

    await fireStore.collection(CollectionName.setting).doc("notification_setting").get().then((value) {
      if (value.exists) {
        Constant.senderId = value.data()!['senderId'].toString();
        Constant.jsonNotificationFileURL = value.data()!['serviceJson'].toString();
      }
    });
    await fireStore.collection(CollectionName.setting).doc("googleMapKey").get().then((value) {
      if (value.exists) {
        Constant.mapKey = value.data()!["key"];
      }
    });
  }
}
