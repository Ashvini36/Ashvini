import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartstore/constants.dart';
import 'package:emartstore/main.dart';
import 'package:emartstore/model/AttributesModel.dart';
import 'package:emartstore/model/BlockUserModel.dart';
import 'package:emartstore/model/BrandsModel.dart';
import 'package:emartstore/model/ChatVideoContainer.dart';
import 'package:emartstore/model/CurrencyModel.dart';
import 'package:emartstore/model/DeliveryChargeModel.dart';
import 'package:emartstore/model/OrderModel.dart';
import 'package:emartstore/model/ProductModel.dart';
import 'package:emartstore/model/Ratingmodel.dart';
import 'package:emartstore/model/ReviewAttributeModel.dart';
import 'package:emartstore/model/User.dart';
import 'package:emartstore/model/VendorModel.dart';
import 'package:emartstore/model/categoryModel.dart';
import 'package:emartstore/model/conversation_model.dart';
import 'package:emartstore/model/document_model.dart';
import 'package:emartstore/model/driver_document_model.dart';
import 'package:emartstore/model/email_template_model.dart';
import 'package:emartstore/model/inbox_model.dart';
import 'package:emartstore/model/notification_model.dart';
import 'package:emartstore/model/on_boarding_model.dart';
import 'package:emartstore/model/referral_model.dart';
import 'package:emartstore/model/story_model.dart';
import 'package:emartstore/model/topupTranHistory.dart';
import 'package:emartstore/model/withdrawHistoryModel.dart';
import 'package:emartstore/model/withdraw_method_model.dart';
import 'package:emartstore/services/show_toast_dailog.dart';
import 'package:emartstore/ui/DineIn/BookTableModel.dart';
import 'package:emartstore/ui/offer/offer_model/offer_model.dart';
import 'package:emartstore/ui/reauthScreen/reauth_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../model/SectionModel.dart';

class FireStoreUtils {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();
  late StreamSubscription ordersStreamSub;
  late StreamController<List<OrderModel>> ordersStreamController;
  late StreamSubscription productsStreamSub;
  late StreamController<List<ProductModel>> productsStreamController;
  bool isShowLoader = true;

  Future<StoryModel?> getStory(String vendorId) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(STORY).doc(vendorId).get();
    if (userDocument.data() != null && userDocument.exists) {
      return StoryModel.fromJson(userDocument.data()!);
    } else {
      print("nulllll");
      return null;
    }
  }

  static Future<bool> getFirestOrderOrNOt(OrderModel orderModel) async {
    bool isFirst = true;
    await firestore
        .collection(ORDERS)
        .where('authorID', isEqualTo: orderModel.authorID)
        .where('section_id', isEqualTo: orderModel.sectionId)
        .get()
        .then((value) {
      if (value.size == 1) {
        isFirst = true;
      } else {
        isFirst = false;
      }
    });
    return isFirst;
  }

  static Future<SectionModel?> getSectionBySectionId(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(SECTION).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      // print('milaa');

      return SectionModel.fromJson(userDocument.data()!);
    } else {
      return null;
    }
  }

  static Future<WithdrawMethodModel?> getWithdrawMethod() async {
    WithdrawMethodModel? withdrawMethodModel;
    await firestore.collection(withdrawMethod).where("userId", isEqualTo: MyAppState.currentUser!.userID).get().then((value) async {
      if (value.docs.isNotEmpty) {
        withdrawMethodModel = WithdrawMethodModel.fromJson(value.docs.first.data());
      }
    });
    return withdrawMethodModel;
  }

  static Future<List<OnBoardingModel>> getOnBoardingList() async {
    List<OnBoardingModel> onBoardingModel = [];
    await firestore.collection(ONBoarding).where("type", isEqualTo: "store").get().then((value) {
      for (var element in value.docs) {
        OnBoardingModel documentModel = OnBoardingModel.fromJson(element.data());
        onBoardingModel.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return onBoardingModel;
  }

  static Future<WithdrawMethodModel?> setWithdrawMethod(WithdrawMethodModel withdrawMethodModel) async {
    if (withdrawMethodModel.id == null) {
      withdrawMethodModel.id = Uuid().v4();
      withdrawMethodModel.userId = MyAppState.currentUser!.userID;
    }
    await firestore.collection(withdrawMethod).doc(withdrawMethodModel.id).set(withdrawMethodModel.toJson()).then((value) async {});
    return withdrawMethodModel;
  }

  static Future updateReferralAmount(OrderModel orderModel) async {
    ReferralModel? referralModel;
    print(orderModel.authorID);
    print(orderModel.sectionId);
    await getSectionBySectionId(orderModel.sectionId).then((valueSection) async {
      await firestore.collection(REFERRAL).doc(orderModel.authorID).get().then((value) {
        if (value.data() != null) {
          referralModel = ReferralModel.fromJson(value.data()!);
        } else {
          return;
        }
      });

      print("refferealAMount----->${valueSection!.referralAmount.toString()}");
      print("refferealAMount----->${referralModel!.referralBy}");

      if (referralModel != null) {
        if (referralModel!.referralBy != null && referralModel!.referralBy!.isNotEmpty) {
          await firestore.collection(USERS).doc(referralModel!.referralBy).get().then((value) async {
            DocumentSnapshot<Map<String, dynamic>> userDocument = value;
            if (userDocument.data() != null && userDocument.exists) {
              try {
                print(userDocument.data());
                User user = User.fromJson(userDocument.data()!);
                await firestore.collection(USERS).doc(user.userID).update(
                    {"wallet_amount": user.walletAmount + double.parse(valueSection.referralAmount.toString())}).then((value) => print("north"));

                await FireStoreUtils.createPaymentId().then((value) async {
                  final paymentID = value;
                  await FireStoreUtils.topUpWalletAmountRefral(
                      paymentMethod: "Referral Amount",
                      amount: double.parse(valueSection.referralAmount.toString()),
                      id: paymentID,
                      userId: referralModel!.referralBy);
                });
              } catch (error) {
                print(error);
                if (error.toString() == "Bad state: field does not exist within the DocumentSnapshotPlatform") {
                  print("does not exist");
                  //await firestore.collection(USERS).doc(userId).update({"wallet_amount": 0});
                  //walletAmount = 0;
                } else {
                  print("went wrong!!");
                }
              }
              print("data val");
            }
          });
        } else {
          return;
        }
      }
    });
  }

  static Future topUpWalletAmountRefral(
      {String paymentMethod = "test", bool isTopup = true, required amount, required id, orderId = "", userId}) async {
    print("this is te payment id");
    print(id);
    print(userId);

    await firestore.collection(Wallet).doc(id).set({
      "user_id": userId,
      "payment_method": paymentMethod,
      "amount": amount,
      "id": id,
      "order_id": orderId,
      "isTopUp": isTopup,
      "payment_status": "success",
      "date": DateTime.now(),
      "transactionUser": "driver",
    }).then((value) {
      firestore.collection(Wallet).doc(id).get().then((value) {
        DocumentSnapshot<Map<String, dynamic>> documentData = value;
        print("nato");
        print(documentData.data());
      });
    });

    return "updated Amount".tr();
  }

  Future<String> uploadImageOfStory(File image, BuildContext context, String extansion) async {
    ShowToastDialog.showLoader('Uploading thumbnail...'.tr());

    final data = await image.readAsBytes();
    final mime = lookupMimeType('', headerBytes: data);
    print("---------->");
    print(mime);

    Reference upload = storage.child(
      'Story/images/${image.path.split('/').last}',
    );
    UploadTask uploadTask = upload.putFile(image, SettableMetadata(contentType: mime));
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    ShowToastDialog.closeLoader();
    return downloadUrl.toString();
  }

  Future<String?> uploadVideoStory(File video, BuildContext context) async {
    ShowToastDialog.showLoader('Uploading Video...'.tr());
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('Story/$uniqueID.mp4');
    File compressedVideo = await _compressVideo(video);
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    ShowToastDialog.closeLoader();
    return downloadUrl.toString();
  }

  Future addOrUpdateStory(StoryModel storyModel) async {
    await firestore.collection(STORY).doc(storyModel.vendorID).set(storyModel.toJson());
  }

  Future removeStory(String vendorId) async {
    await firestore.collection(STORY).doc(vendorId).delete();
  }

  static Future addInbox(InboxModel inboxModel) async {
    return await firestore.collection("chat_store").doc(inboxModel.orderId).set(inboxModel.toJson()).then((document) {
      return inboxModel;
    });
  }

  static sendPayoutMail({required String amount, required String payoutrequestid}) async {
    EmailTemplateModel? emailTemplateModel = await FireStoreUtils.getEmailTemplates(payoutRequest);

    String body = emailTemplateModel!.subject.toString();
    body = body.replaceAll("{userid}", MyAppState.currentUser!.userID);

    String newString = emailTemplateModel.message.toString();
    newString = newString.replaceAll("{username}", MyAppState.currentUser!.firstName + " " + MyAppState.currentUser!.lastName);
    newString = newString.replaceAll("{userid}", MyAppState.currentUser!.userID);
    newString = newString.replaceAll("{amount}", amountShow(amount: amount));
    newString = newString.replaceAll("{date}", DateFormat('dd-MM-yyyy').format(Timestamp.now().toDate()));
    newString = newString.replaceAll("{payoutrequestid}", payoutrequestid.toString());
    newString = newString.replaceAll("{usercontactinfo}", "${MyAppState.currentUser!.email}\n${MyAppState.currentUser!.phoneNumber}");
    await sendMail(subject: body, isAdmin: emailTemplateModel.isSendToAdmin, body: newString, recipients: [MyAppState.currentUser!.email]);
  }

  static sendNewVendorMail(User user) async {
    EmailTemplateModel? emailTemplateModel = await FireStoreUtils.getEmailTemplates(newVendorSignup);

    String newString = emailTemplateModel!.message.toString();
    newString = newString.replaceAll("{userid}", user.userID);
    newString = newString.replaceAll("{username}", user.firstName + " " + user.lastName);
    newString = newString.replaceAll("{useremail}", user.email);
    newString = newString.replaceAll("{userphone}", user.phoneNumber);
    newString = newString.replaceAll("{date}", DateFormat('dd-MM-yyyy').format(Timestamp.now().toDate()));
    await sendMail(subject: emailTemplateModel.subject, isAdmin: emailTemplateModel.isSendToAdmin, body: newString, recipients: []);
  }

  static Future<EmailTemplateModel?> getEmailTemplates(String type) async {
    EmailTemplateModel? emailTemplateModel;
    await firestore.collection(emailTemplates).where('type', isEqualTo: type).get().then((value) {
      print("------>");
      if (value.docs.isNotEmpty) {
        print(value.docs.first.data());
        emailTemplateModel = EmailTemplateModel.fromJson(value.docs.first.data());
      }
    });
    return emailTemplateModel;
  }

  static Future addChat(ConversationModel conversationModel) async {
    return await firestore
        .collection("chat_store")
        .doc(conversationModel.orderId)
        .collection("thread")
        .doc(conversationModel.id)
        .set(conversationModel.toJson())
        .then((document) {
      return conversationModel;
    });
  }

  static Future<List<BrandsModel>> getBrands() async {
    List<BrandsModel> brandList = [];
    QuerySnapshot<Map<String, dynamic>> currencyQuery = await firestore.collection(BRANDS).where('is_publish', isEqualTo: true).get();
    await Future.forEach(currencyQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        print("------>");
        print(document.data());
        brandList.add(BrandsModel.fromJson(document.data()));
      } catch (e) {
        print('FireStoreUtils.getCurrencys Parse error $e');
      }
    });
    return brandList;
  }

  Future<RatingModel?> getOrderReviewsbyID(String ordertId, String productId) async {
    RatingModel? ratingproduct;
    QuerySnapshot<Map<String, dynamic>> vendorsQuery =
        await firestore.collection(Order_Rating).where('orderid', isEqualTo: ordertId).where('productId', isEqualTo: productId).get();
    if (vendorsQuery.docs.isNotEmpty) {
      try {
        if (vendorsQuery.docs.isNotEmpty) {
          ratingproduct = RatingModel.fromJson(vendorsQuery.docs.first.data());
        }
      } catch (e) {
        print('FireStoreUtils.getVendorByVendorID Parse error $e');
      }
    }
    return ratingproduct;
  }

  Future<ProductModel> getProductByProductID(String productId) async {
    late ProductModel productModel;
    QuerySnapshot<Map<String, dynamic>> vendorsQuery =
        await firestore.collection(PRODUCTS).where('id', isEqualTo: productId).where('publish', isEqualTo: true).get();
    try {
      if (vendorsQuery.docs.isNotEmpty) {
        productModel = ProductModel.fromJson(vendorsQuery.docs.first.data());
      }
    } catch (e) {
      print('FireStoreUtils.getVendorByVendorID Parse error $e');
    }
    return productModel;
  }

  static Future<List<AttributesModel>> getAttributes() async {
    List<AttributesModel> attributesList = [];
    QuerySnapshot<Map<String, dynamic>> currencyQuery = await firestore.collection(VENDOR_ATTRIBUTES).get();
    await Future.forEach(currencyQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        print(document.data());
        attributesList.add(AttributesModel.fromJson(document.data()));
      } catch (e) {
        print('FireStoreUtils.getCurrencys Parse error $e');
      }
    });
    return attributesList;
  }

  late StreamSubscription offerStreamSub;
  late StreamController<List<OfferModel>> offerStreamController;

  static Future<User?> getCurrentUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(USERS).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      return User.fromJson(userDocument.data()!);
    } else {
      return null;
    }
  }

  static Stream<User?> getCurrentUserStream(String uid) async* {
    DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(USERS).doc(uid).get();
    if (userDocument.data() != null && userDocument.exists) {
      yield User.fromJson(userDocument.data()!);
    } else {
      yield null;
    }
  }

  static Future<NotificationModel?> getNotificationContent(String type) async {
    NotificationModel? notificationModel;
    await firestore.collection(dynamicNotification).where('type', isEqualTo: type).get().then((value) {
      print("------>");
      if (value.docs.isNotEmpty) {
        print(value.docs.first.data());

        notificationModel = NotificationModel.fromJson(value.docs.first.data());
      } else {
        notificationModel = NotificationModel(id: "", message: "Notification setup is pending".tr(), subject: "setup notification".tr(), type: "");
      }
    });
    return notificationModel;
  }

  //   static Future<VendorModel?> getVendor(String vid) async {
  //   DocumentSnapshot<Map<String, dynamic>> userDocument =
  //       await firestore.collection(VENDORS).doc(vid).get();
  //   if (userDocument.data() != null && userDocument.exists) {
  //     return VendorModel.fromJson(userDocument.data()!);
  //   } else {
  //     return null;
  //   }
  // }

  Stream<User> getUserByID(String id) async* {
    StreamController<User> userStreamController = StreamController();
    firestore.collection(USERS).doc(id).snapshots().listen((user) {
      try {
        User userModel = User.fromJson(user.data() ?? {});
        userStreamController.sink.add(userModel);
      } catch (e) {
        print('FireStoreUtils.getUserByID failed to parse user object ${user.id}');
      }
    });
    yield* userStreamController.stream;
  }

  Future<bool> blockUser(User blockedUser, String type) async {
    bool isSuccessful = false;
    BlockUserModel blockUserModel =
        BlockUserModel(type: type, source: MyAppState.currentUser!.userID, dest: blockedUser.userID, createdAt: Timestamp.now());
    await firestore.collection(REPORTS).add(blockUserModel.toJson()).then((onValue) {
      isSuccessful = true;
    });
    return isSuccessful;
  }

  Future<Url> uploadAudioFile(File file, BuildContext context) async {
    ShowToastDialog.showLoader('Uploading Audio...'.tr());
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('audio/$uniqueID.mp3');
    SettableMetadata metadata = SettableMetadata(contentType: 'audio');
    UploadTask uploadTask = upload.putFile(file, metadata);
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    ShowToastDialog.closeLoader();
    return Url(mime: metaData.contentType ?? 'audio', url: downloadUrl.toString());
  }

  static Future<User?> updateCurrentUser(User user) async {
    return await firestore.collection(USERS).doc(user.userID).set(user.toJson()).then((document) {
      return user;
    });
  }

  getplaceholderimage() async {
    var collection = FirebaseFirestore.instance.collection(Setting);
    var docSnapshot = await collection.doc('placeHolderImage').get();
// if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    var value = data?['image'];
    placeholderImage = value;
    return Center();
  }

  /*Future<List<CurrencyModel>> getCurrency() async {
    List<CurrencyModel> currency = [];

    QuerySnapshot<Map<String, dynamic>> currencyQuery = await firestore.collection(Currency).where("isActive", isEqualTo: true).get();
    await Future.forEach(currencyQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        print('eee ayaaaaaaaaaa');
        currency.add(CurrencyModel.fromJson(document.data()));
      } catch (e) {
        print('FireStoreUtils.getCurrencys Parse error $e');
      }
    });
    return currency;
  */
  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currency;
    await firestore.collection(Currency).where("isActive", isEqualTo: true).get().then((value) {
      if (value.docs.isNotEmpty) {
        currency = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currency;
  }

  // static Future<VendorCategoryModel> getVendorCategoryById() async {
  //   late VendorCategoryModel vendorCategoryModel;
  //   QuerySnapshot<Map<String, dynamic>> vendorsQuery =
  //       await firestore.collection(VENDORS_CATEGORIES).get();
  //   try {
  //     vendorCategoryModel =
  //         VendorCategoryModel.fromJson(vendorsQuery.docs.first.data());
  //   } catch (e) {
  //     print('FireStoreUtils.getVendorByVendorID Parse error $e');
  //   }
  //   return vendorCategoryModel;
  // }

  static Future<List<VendorCategoryModel>> getVendorCategoryById(String sectionId) async {
    List<VendorCategoryModel> category = [];

    QuerySnapshot<Map<String, dynamic>> categoryQuery =
        await firestore.collection(VENDORS_CATEGORIES).where('section_id', isEqualTo: sectionId).where("publish", isEqualTo: true).get();
    await Future.forEach(categoryQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        category.add(VendorCategoryModel.fromJson(document.data()));
      } catch (e, stacksTrace) {
        print('FireStoreUtils.getVendorOrders Parse error ${document.id} $e '
            '$stacksTrace');
      }
    });
    return category;
  }

  static Future<DeliveryChargeModel> getDelivery() async {
    DeliveryChargeModel deliveryChargeModel = DeliveryChargeModel();
    await firestore.collection(Setting).doc('DeliveryCharge').get().then((value) {
      deliveryChargeModel = DeliveryChargeModel.fromJson(value.data()!);
    });
    return deliveryChargeModel;
  }

  static Future<bool> getDineStatus(String sectionid) async {
    bool isDineINActive = false;
    await firestore.collection(SECTION).doc(sectionid).get().then((value) {
      if (value.exists) {
        if (value.data()!.containsKey("dine_in_active")) {
          isDineINActive = value.data()!["dine_in_active"];
        }
      }
    });
    return isDineINActive;
  }

  static Future<SectionModel?> getSectionsById(String sectionId) async {
    SectionModel? sectionModel;
    await firestore.collection(SECTION).doc(sectionId).get().then((value) {
      sectionModel = SectionModel.fromJson(value.data()!);
    });
    return sectionModel;
  }

  static Future<List<SectionModel>> getSections() async {
    List<SectionModel> sections = [];
    QuerySnapshot<Map<String, dynamic>> productsQuery = await firestore.collection(SECTION).where("isActive", isEqualTo: true).get();
    await Future.forEach(productsQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        if (document.data()['name'] != "Banner") {
          sections.add(SectionModel.fromJson(document.data()));
        }
      } catch (e) {
        print('**-FireStoreUtils.getSection Parse error $e');
      }
    });

    return sections;
  }

  static Future createPaymentId({collectionName = "wallet"}) async {
    DocumentReference documentReference = firestore.collection(collectionName).doc();
    final paymentId = documentReference.id;
    //UserPreference.setPaymentId(paymentId: paymentId);
    return paymentId;
  }

  static Future orderTransaction({required OrderModel orderModel, required double amount}) async {
    DocumentReference documentReference = firestore.collection(OrderTransaction).doc();
    Map<String, dynamic> data = {
      "order_id": orderModel.id,
      "id": documentReference.id,
      "date": DateTime.now(),
    };
    if (orderModel.takeAway!) {
      data.addAll({"vendorId": orderModel.vendorID, "vendorAmount": amount});
    }

    await firestore.collection(OrderTransaction).doc(documentReference.id).set(data).then((value) {});
    return "updated transaction";
  }

  static Future topUpWalletAmount(
      {required String userId, String paymentMethod = "test", bool isTopup = true, required amount, required id, orderId = ""}) async {
    print("this is te payment id");
    print(id);
    print(MyAppState.currentUser!.userID);

    await firestore.collection("wallet").doc(id).set({
      "user_id": userId,
      "payment_method": paymentMethod,
      "amount": amount,
      "id": id,
      "order_id": orderId,
      "isTopUp": isTopup,
      "payment_status": "Refund success",
      "date": DateTime.now(),
    }).then((value) {
      firestore.collection("wallet").doc(id).get().then((value) {
        DocumentSnapshot<Map<String, dynamic>> documentData = value;
        print("nato");
        print(documentData.data());
      });
    });
    return "updated Amount".tr();
  }

  static Future withdrawWalletAmount({required WithdrawHistoryModel withdrawHistory}) async {
    print("this is te payment id");
    print(withdrawHistory.id);
    print(MyAppState.currentUser!.userID);

    await firestore.collection(Payouts).doc(withdrawHistory.id).set(withdrawHistory.toJson()).then((value) {
      firestore.collection(Payouts).doc(withdrawHistory.id).get().then((value) {
        DocumentSnapshot<Map<String, dynamic>> documentData = value;
        print(documentData.data());
      });
    });
    return "updated Amount".tr();
  }

  static Future updateWalletAmount({required String userId, required amount}) async {
    dynamic walletAmount = 0;

    await firestore.collection(USERS).doc(userId).get().then((value) async {
      DocumentSnapshot<Map<String, dynamic>> userDocument = value;
      if (userDocument.data() != null && userDocument.exists) {
        try {
          print(userDocument.data());
          await firestore
              .collection(USERS)
              .doc(userId)
              .update({"wallet_amount": (num.parse(userDocument.data()!['wallet_amount'].toString()) + amount)}).then((value) {
            MyAppState.currentUser!.walletAmount = num.parse(userDocument.data()!['wallet_amount'].toString()) + amount;
          });
        } catch (error) {
          print(error);
          if (error.toString() == "Bad state: field does not exist within the DocumentSnapshotPlatform") {
            print("does not exist");
          } else {
            print("went wrong!!");
            walletAmount = "ERROR";
          }
        }
        print("data val");
        print(walletAmount);
        return walletAmount; //User.fromJson(userDocument.data()!);
      } else {
        return 0.111;
      }
    });
  }

  Future<ReviewAttributeModel?> getVendorReviewAttribute(String attrubuteId) async {
    DocumentSnapshot<Map<String, dynamic>> documentReference = await firestore.collection(REVIEW_ATTRIBUTES).doc(attrubuteId).get();
    if (documentReference.data() != null && documentReference.exists) {
      print("dataaaaaa aaa ");
      return ReviewAttributeModel.fromJson(documentReference.data()!);
    } else {
      print("nulllll");
      return null;
    }
  }

  Future<VendorCategoryModel?> getVendorCategoryByCategoryId(String vendorCategoryID) async {
    DocumentSnapshot<Map<String, dynamic>> documentReference = await firestore.collection(VENDORS_CATEGORIES).doc(vendorCategoryID).get();
    if (documentReference.data() != null && documentReference.exists) {
      return VendorCategoryModel.fromJson(documentReference.data()!);
    } else {
      return null;
    }
  }

  static Future<VendorModel?>? getVendor(String vid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore.collection(VENDORS).doc(vid).get();
      if (userDocument.data() != null && userDocument.exists) {
        log(userDocument.data()!.toString());
        return VendorModel.fromJson(userDocument.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<VendorModel?> updateVendor(VendorModel vendor) async {
    return await firestore.collection(VENDORS).doc(vendor.id).set(vendor.toJson()).then((document) {
      return vendor;
    });
  }

  static Future updateUserCate(String userid, String sectionid) async {
    return await firestore.collection(USERS).doc(userid).update({"section_id": sectionid}).then((document) {
      return;
    });
  }

  static Future<VendorModel?> updatePhoto(VendorModel vendor, photo) async {
    return await firestore.collection(VENDORS).doc(vendor.id).update({'hidephotos': photo}).then((document) {
      return vendor;
    });
  }

  static Future<VendorModel?> updatestatus(VendorModel vendor, reststatus) async {
    return await firestore.collection(VENDORS).doc(vendor.id).update({'reststatus': reststatus}).then((document) {
      return vendor;
    });
  }

  static Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    Reference upload = storage.child(STORAGE_ROOT + '/images/$userID.png');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<List<OrderModel>> getVendorOrders(String userID) async {
    List<OrderModel> orders = [];

    QuerySnapshot<Map<String, dynamic>> ordersQuery =
        await firestore.collection(ORDERS).where('vendorID', isEqualTo: userID).orderBy('createdAt', descending: true).get();
    await Future.forEach(ordersQuery.docs, (QueryDocumentSnapshot<Map<String, dynamic>> document) {
      try {
        orders.add(OrderModel.fromJson(document.data()));
      } catch (e, stacksTrace) {
        print('FireStoreUtils.getVendorOrders Parse error ${document.id} $e '
            '$stacksTrace');
      }
    });
    return orders;
  }

  Stream<List<OrderModel>> watchOrdersStatus(String vendorID) async* {
    print(vendorID.toString() + "====123");
    List<OrderModel> orders = [];
    ordersStreamController = StreamController.broadcast();
    ordersStreamSub =
        firestore.collection(ORDERS).where('vendorID', isEqualTo: vendorID).orderBy('createdAt', descending: true).snapshots().listen((event) async {
      orders.clear();
      await Future.forEach(event.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) {
        try {
          orders.add(OrderModel.fromJson(element.data()));
          print(orders.length.toString() + "{}O{}");
        } catch (e, s) {
          print('watchOrdersStatus parse error ${element.id}$e $s');
        }
      });
      ordersStreamController.add(orders);
    });
    yield* ordersStreamController.stream;
  }

  Stream<List<BookTableModel>> watchDineOrdersStatus(String vendorID, bool isUpComing) async* {
    print(vendorID.toString() + "====123");
    List<BookTableModel> orders = [];
    if (isUpComing) {
      StreamController<List<BookTableModel>> dineInStreamController = StreamController.broadcast();
      firestore
          .collection(ORDERS_TABLE)
          .where('vendorID', isEqualTo: vendorID)
          .where('date', isGreaterThan: Timestamp.now())
          .orderBy('date', descending: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((event) async {
        orders.clear();
        await Future.forEach(event.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) {
          try {
            orders.add(BookTableModel.fromJson(element.data()));
            print(orders.length.toString() + "{}O{}");
          } catch (e, s) {
            print('watchDineOrdersStatus parse error ${element.id}$e $s');
          }
        });
        dineInStreamController.sink.add(orders);
      });
      yield* dineInStreamController.stream;
    } else {
      StreamController<List<BookTableModel>> dineInStreamController = StreamController.broadcast();
      firestore
          .collection(ORDERS_TABLE)
          .where('vendorID', isEqualTo: vendorID)
          .where('date', isLessThan: Timestamp.now())
          .orderBy('date', descending: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((event) async {
        orders.clear();
        await Future.forEach(event.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) {
          try {
            orders.add(BookTableModel.fromJson(element.data()));
            print(orders.length.toString() + "{}O{}");
          } catch (e, s) {
            print('watchDineOrdersStatus parse error ${element.id}$e $s');
          }
        });
        dineInStreamController.add(orders);
      });
      yield* dineInStreamController.stream;
    }
  }

  static Future updateOrder(OrderModel orderModel) async {
    await firestore.collection(ORDERS).doc(orderModel.id).set(orderModel.toJson(), SetOptions(merge: true));
  }

  static Future updateDineInOrder(BookTableModel orderModel) async {
    await firestore.collection(ORDERS_TABLE).doc(orderModel.id).set(orderModel.toJson(), SetOptions(merge: true));
  }

  closeOrdersStream() {
    ordersStreamSub.cancel();
    ordersStreamController.close();
  }

  Stream<List<ProductModel>> getProductsStream(String vendorID) async* {
    List<ProductModel> products = [];
    productsStreamController = StreamController();
    if (vendorID == "") {
      isShowLoader = false;
    } else {
      productsStreamSub = firestore.collection(PRODUCTS).where('vendorID', isEqualTo: vendorID).snapshots().listen((event) async {
        products.clear();
        await Future.forEach(event.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) {
          try {
            products.add(ProductModel.fromJson(element.data()));
          } catch (e, s) {
            print('getProductsStream parse error ${element.id}$e $s');
          }
        });
        productsStreamController.add(products);
      });
    }
    yield* productsStreamController.stream;
  }

  closeProductsStream() {
    productsStreamSub.cancel();
    productsStreamController.close();
  }

  Stream<List<OfferModel>> getOfferStream(String vendorID) async* {
    print(vendorID.toString() + "{}");
    List<OfferModel> offers = [];
    offerStreamController = StreamController<List<OfferModel>>();
    offerStreamSub = firestore.collection(COUPONS).where("vendorID", isEqualTo: vendorID).snapshots().listen((event) async {
      offers.clear();
      await Future.forEach(event.docs, (QueryDocumentSnapshot<Map<String, dynamic>> element) {
        try {
          print(element.data().toString() + "[][");
          offers.add(OfferModel.fromJson(element.data()));
        } catch (e, s) {
          print('getProductsStream parse error ${element.id}$e $s');
        }
      });
      offerStreamController.add(offers);
    });
    yield* offerStreamController.stream;
  }

  closeOfferStream() {
    offerStreamSub.cancel();
    offerStreamController.close();
  }

  Future<String> uploadProductImage(File image, String progress) async {
    var uniqueID = Uuid().v4();
    Reference upload = storage.child(STORAGE_ROOT +
        '/store/productImages/$uniqueID'
            '.png');
    UploadTask uploadTask = upload.putFile(image);
    uploadTask.whenComplete(() {}).catchError((onError) {
      print((onError as PlatformException).message);
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl.toString();
  }

  addOrUpdateProduct(ProductModel productModel) async {
    //print(productModel.toJson().toString()+"===ABC");
    if ((productModel.id).isNotEmpty) {
      await firestore.collection(PRODUCTS).doc(productModel.id).set(productModel.toJson());
    } else {
      DocumentReference docRef = firestore.collection(PRODUCTS).doc();
      productModel.id = docRef.id;
      docRef.set(productModel.toJson());
    }
  }

  addOffer(OfferModel offerModel, BuildContext context) async {
    DocumentReference docRef = firestore.collection(COUPONS).doc();
    offerModel.id = docRef.id;
    docRef.set(offerModel.toJson()).then((value) {
      Navigator.of(context).pop();
    });
  }

  updateOffer(OfferModel offerModel, BuildContext context) async {
    await firestore.collection(COUPONS).doc(offerModel.id!).set(offerModel.toJson()).then((value) {
      Navigator.of(context).pop();
    });
  }

  deleteProduct(String productID) async {
    await firestore.collection(PRODUCTS).doc(productID).delete();
  }

  static Future<auth.UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final auth.OAuthCredential facebookAuthCredential = auth.FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    print("====DFB" + facebookAuthCredential.accessToken.toString() + " " + facebookAuthCredential.token.toString());
    return auth.FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  static loginWithFacebook() async {
    /// creates a user for this facebook login when this user first time login
    /// and save the new user object to firebase and firebase auth
    ///

    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth.login(
        permissions: ['public_profile', 'email'],
      );
      // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = result.accessToken;
        print("====DFB" + "FBLOGIN SUCESS");
        return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;

      return await handleFacebookLogin(await facebookAuth.getUserData(), token!);
    }
  }

  static handleFacebookLogin(Map<String, dynamic> userData, AccessToken token) async {
    // print(token);
    auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(auth.FacebookAuthProvider.credential(token.tokenString));
    User? user = await getCurrentUser(authResult.user?.uid ?? '');
    List<String> fullName = (userData['name'] as String).split(' ');
    String firstName = '';
    String lastName = '';
    if (fullName.isNotEmpty) {
      firstName = fullName.first;
      lastName = fullName.skip(1).join(' ');
    }
    if (user != null && user.role == USER_ROLE_VENDOR) {
      print("email ${userData['email']}");
      if (userData['email'] == null) {
        return 'Email not added in Facebook'.tr();
      }

      user.profilePictureURL = userData['picture']['data']['url'];
      user.firstName = firstName;
      user.lastName = lastName;
      user.email = userData['email'];
      user.role = USER_ROLE_VENDOR;
      user.fcmToken = await firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else if (user == null) {
      user = User(
          email: userData['email'] ?? '',
          firstName: firstName,
          profilePictureURL: userData['picture']['data']['url'] ?? '',
          userID: authResult.user?.uid ?? '',
          lastOnlineTimestamp: Timestamp.now(),
          lastName: lastName,
          active: true,
          role: USER_ROLE_VENDOR,
          fcmToken: await firebaseMessaging.getToken() ?? '',
          phoneNumber: '',
          settings: UserSettings());
      String? errorMessage = await firebaseCreateNewUser(user);
      await FireStoreUtils.sendNewVendorMail(user);
      print("====DFB" + user.firstName.toString());
      if (errorMessage == null) {
        print("====DFB" + user.lastName.toString());
        return user;
      } else {
        print("====DFB" + "ERROR");
        return errorMessage;
      }
    }
  }

  static loginWithApple() async {
    final appleCredential = await apple.TheAppleSignIn.performRequests([
      apple.AppleIdRequest(requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);

    print("start lofin 55");
    if (appleCredential.error != null) {
      return "Couldn't login with apple.".tr();
    }
    print("start lofin ${appleCredential.status}");
    if (appleCredential.status == apple.AuthorizationStatus.authorized) {
      final auth.AuthCredential credential = auth.OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(appleCredential.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(appleCredential.credential?.identityToken ?? []),
      );

      print("start lofin 33");
      return await handleAppleLogin(credential, appleCredential.credential!);
    } else {
      return "Couldn't login with apple.".tr();
    }
  }

  static handleAppleLogin(
    auth.AuthCredential credential,
    apple.AppleIdCredential appleIdCredential,
  ) async {
    print("start lofin");
    auth.UserCredential authResult = await auth.FirebaseAuth.instance.signInWithCredential(credential);
    User? user = await getCurrentUser(authResult.user?.uid ?? '');
    if (user != null) {
      user.role = USER_ROLE_VENDOR;
      user.fcmToken = await firebaseMessaging.getToken() ?? '';
      dynamic result = await updateCurrentUser(user);
      return result;
    } else {
      user = User(
          email: appleIdCredential.email ?? '',
          firstName: appleIdCredential.fullName?.givenName ?? '',
          profilePictureURL: '',
          userID: authResult.user?.uid ?? '',
          lastOnlineTimestamp: Timestamp.now(),
          lastName: appleIdCredential.fullName?.familyName ?? '',
          role: USER_ROLE_VENDOR,
          active: true,
          fcmToken: await firebaseMessaging.getToken() ?? '',
          phoneNumber: '',
          settings: UserSettings());
      String? errorMessage = await firebaseCreateNewUser(user);
      await FireStoreUtils.sendNewVendorMail(user);
      if (errorMessage == null) {
        return user;
      } else {
        return errorMessage;
      }
    }
  }

  Future<Url> uploadChatImageToFireStorage(File image, BuildContext context) async {
    ShowToastDialog.showLoader('Uploading image...'.tr());
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('images/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(image);
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    ShowToastDialog.closeLoader();
    return Url(mime: metaData.contentType ?? 'image', url: downloadUrl.toString());
  }

  Future<ChatVideoContainer> uploadChatVideoToFireStorage(File video, BuildContext context) async {
    ShowToastDialog.showLoader('Uploading video...'.tr());
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('videos/$uniqueID.mp4');
    File compressedVideo = await _compressVideo(video);
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    final uint8list =
        await VideoThumbnail.thumbnailFile(video: downloadUrl, thumbnailPath: (await getTemporaryDirectory()).path, imageFormat: ImageFormat.PNG);
    final file = File(uint8list ?? '');
    String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
    ShowToastDialog.closeLoader();
    return ChatVideoContainer(videoUrl: Url(url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'), thumbnailUrl: thumbnailDownloadUrl);
  }

  Future<File> _compressVideo(File file) async {
    MediaInfo? info =
        await VideoCompress.compressVideo(file.path, quality: VideoQuality.DefaultQuality, deleteOrigin: false, includeAudio: true, frameRate: 24);
    if (info != null) {
      File compressedVideo = File(info.path!);
      return compressedVideo;
    } else {
      return file;
    }
  }

  Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = Uuid().v4();
    Reference upload = storage.child('thumbnails/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(file);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static Future<VendorModel> firebaseCreateNewVendor(VendorModel vendor) async {
    User? currentUser;
    DocumentReference documentReference = FirebaseFirestore.instance.collection(VENDORS).doc();
    vendor.id = documentReference.id;
    await documentReference.set(vendor.toJson());
    MyAppState.currentUser!.vendorID = documentReference.id;
    currentUser = MyAppState.currentUser;
    await FireStoreUtils.updateCurrentUser(currentUser!);
    vendor.fcmToken = MyAppState.currentUser!.fcmToken;
    await FireStoreUtils.updateCurrentUser(MyAppState.currentUser!);
    return vendor;
    // await firestore
    //     .collection(VENDORS)
    //     .doc(vendor.id)
    //     .set(vendor.toJson())
    //     .then((value) => null, onError: (e) => e);
  }

  /// save a new user document in the USERS table in firebase firestore
  /// returns an error message on failure or null on success
  static Future<String?> firebaseCreateNewUser(User user) async =>
      await firestore.collection(USERS).doc(user.userID).set(user.toJson()).then((value) => null, onError: (e) => e);

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<dynamic> loginWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(USERS)
          .doc(result.user?.uid ?? '')
          .
          // where('role',isEqualTo: 'vendor').
          get();
      User? user;

      if (documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data() ?? {});
        if (user.role == 'vendor') {
          user.fcmToken = await firebaseMessaging.getToken() ?? '';

          return user;
        }
      }
    } on auth.FirebaseAuthException catch (exception, s) {
      print(exception.toString() + '$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.'.tr();
        case 'wrong-password':
          return 'Wrong password.'.tr();
        case 'user-not-found':
          return 'No user corresponding to the given email address.'.tr();
        case 'user-disabled':
          return 'This user has been disabled.'.tr();
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.'.tr();
      }
      return 'Unexpected firebase error, Please try again.'.tr();
    } catch (e, s) {
      print(e.toString() + '$s');
      return 'Login failed, Please try again.'.tr();
    }
  }

  ///submit a phone number to firebase to receive a code verification, will
  ///be used later to login
  static firebaseSubmitPhoneNumber(
    String phoneNumber,
    auth.PhoneCodeAutoRetrievalTimeout? phoneCodeAutoRetrievalTimeout,
    auth.PhoneCodeSent? phoneCodeSent,
    auth.PhoneVerificationFailed? phoneVerificationFailed,
    auth.PhoneVerificationCompleted? phoneVerificationCompleted,
  ) {
    auth.FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(minutes: 2),
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted!,
      verificationFailed: phoneVerificationFailed!,
      codeSent: phoneCodeSent!,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout!,
    );
  }

  /// submit the received code to firebase to complete the phone number
  /// verification process
  static Future<dynamic> firebaseSubmitPhoneNumberCode(String verificationID, String code, String phoneNumber,
      {String firstName = 'Anonymous', String lastName = 'User', File? image, bool? auto_approve_restaurant}) async {
    auth.AuthCredential authCredential = auth.PhoneAuthProvider.credential(verificationId: verificationID, smsCode: code);
    auth.UserCredential userCredential = await auth.FirebaseAuth.instance.signInWithCredential(authCredential);
    User? user = await getCurrentUser(userCredential.user?.uid ?? '');
    if (user != null && user.role == USER_ROLE_VENDOR) {
      return user;
    } else if (user == null) {
      /// create a new user from phone login
      String profileImageUrl = '';
      if (image != null) {
        profileImageUrl = await uploadUserImageToFireStorage(image, userCredential.user?.uid ?? '');
      }
      User user = User(
        firstName: firstName,
        lastName: lastName,
        fcmToken: await firebaseMessaging.getToken() ?? '',
        phoneNumber: phoneNumber,
        profilePictureURL: profileImageUrl,
        userID: userCredential.user?.uid ?? '',
        active: auto_approve_restaurant == true ? true : false,
        lastOnlineTimestamp: Timestamp.now(),
        photos: [],
        settings: UserSettings(),
        role: USER_ROLE_VENDOR,
        email: '',
      );
      String? errorMessage = await firebaseCreateNewUser(user);
      await FireStoreUtils.sendNewVendorMail(user);
      if (errorMessage == null) {
        return user;
      } else {
        return "Couldn't create new user with phone number.".tr();
      }
    }
  }

  static firebaseSignUpWithEmailAndPassword(
      String emailAddress, String password, File? image, String firstName, String lastName, String mobile, bool? autoApproveRestaurant) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
      String profilePicUrl = '';
      if (image != null) {
        ShowToastDialog.showLoader('Uploading image, Please wait...'.tr());
        profilePicUrl = await uploadUserImageToFireStorage(image, result.user?.uid ?? '');
      }
      User user = User(
          email: emailAddress,
          settings: UserSettings(),
          photos: [],
          lastOnlineTimestamp: Timestamp.now(),
          active: autoApproveRestaurant == true ? true : false,
          phoneNumber: mobile,
          firstName: firstName,
          userID: result.user?.uid ?? '',
          // vendorID: result.user?.uid ?? '',
          lastName: lastName,
          role: USER_ROLE_VENDOR,
          fcmToken: await firebaseMessaging.getToken() ?? '',
          createdAt: Timestamp.now(),
          profilePictureURL: profilePicUrl);
      String? errorMessage = await firebaseCreateNewUser(user);
      await FireStoreUtils.sendNewVendorMail(user);
      if (errorMessage == null) {
        return user;
      } else {
        return "Couldn't sign up for firebase, Please try again.".tr();
      }
    } on auth.FirebaseAuthException catch (error) {
      print(error.toString() + '${error.stackTrace}');
      String message = "Couldn't sign up".tr();
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!'.tr();
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail'.tr();
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled'.tr();
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters'.tr();
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.'.tr();
          break;
      }
      return message;
    } catch (e) {
      return "Couldn't sign up".tr();
    }
  }

  static Future<auth.UserCredential?> reAuthUser(String email, String password) async {
    auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return result;
  }

  static Future<auth.UserCredential?> reAuthUsers(AuthProviders provider,
      {String? email,
      String? password,
      String? smsCode,
      String? verificationId,
      AccessToken? accessToken,
      apple.AuthorizationResult? appleCredential}) async {
    late auth.AuthCredential credential;
    switch (provider) {
      case AuthProviders.PASSWORD:
        credential = auth.EmailAuthProvider.credential(email: email!, password: password!);
        break;
      case AuthProviders.PHONE:
        credential = auth.PhoneAuthProvider.credential(smsCode: smsCode!, verificationId: verificationId!);
        break;
      case AuthProviders.FACEBOOK:
        credential = auth.FacebookAuthProvider.credential(accessToken!.tokenString);
        break;
      case AuthProviders.APPLE:
        credential = auth.OAuthProvider('apple.com').credential(
          accessToken: String.fromCharCodes(appleCredential!.credential?.authorizationCode ?? []),
          idToken: String.fromCharCodes(appleCredential.credential?.identityToken ?? []),
        );
        break;
    }
    return await auth.FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
  }

  static deleteUser() async {
    try {
      await firestore.collection(ORDERS_TABLE).where('vendorID', isEqualTo: MyAppState.currentUser!.vendorID).get().then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.id).delete();
        }
      });

      await firestore.collection(COUPONS).where('resturant_id', isEqualTo: MyAppState.currentUser!.vendorID).get().then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.id).delete();
        }
      });

      await firestore.collection(FOOD_REVIEW).where('VendorId', isEqualTo: MyAppState.currentUser!.vendorID).get().then((value) async {
        for (var doc in value.docs) {
          await firestore.doc(doc.reference.id).delete();
        }
      });

      await firestore.collection(PRODUCTS).where('vendorID', isEqualTo: MyAppState.currentUser!.vendorID).get().then((value) async {
        for (var doc in value.docs) {
          await firestore.collection(FavouriteItem).where('product_id', isEqualTo: doc.reference.id).get().then((value0) async {
            for (var element0 in value0.docs) {
              await firestore.collection(FavouriteItem).doc(element0.reference.path).delete();
            }
          });
          await firestore.doc(doc.reference.id).delete();
        }
      });

      if (MyAppState.currentUser!.vendorID.isNotEmpty) {
        await firestore.collection(VENDORS).doc(MyAppState.currentUser!.vendorID).delete();
      }

      await firestore.collection(USERS).doc(auth.FirebaseAuth.instance.currentUser!.uid).delete();

      await auth.FirebaseAuth.instance.currentUser!.delete();
    } catch (e, s) {
      print('FireStoreUtils.deleteUser $e $s');
    }
  }

  static resetPassword(String emailAddress) async => await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);

  Future restaurantVendorWalletSet(OrderModel orderModel) async {
    double total = 0.0;
    double discount = 0.0;
    double specialDiscount = 0.0;
    double taxAmount = 0.0;
    orderModel.products.forEach((element) {
      if (element.extras_price != null && element.extras_price!.isNotEmpty && double.parse(element.extras_price!) != 0.0) {
        total += element.quantity * double.parse(element.extras_price!);
      }
      total += element.quantity * double.parse(element.price);
    });
    if (orderModel.specialDiscount != null || orderModel.specialDiscount!['special_discount'] != null) {
      specialDiscount = double.parse(orderModel.specialDiscount!['special_discount'].toString());
    }

    if (orderModel.discount != null) {
      discount = double.parse(orderModel.discount.toString());
    }
    var totalamount = total - discount - specialDiscount;

    double adminComm = (orderModel.adminCommissionType!.toLowerCase() == 'Percent'.toLowerCase() ||
            orderModel.adminCommissionType!.toLowerCase() == 'percentage'.toLowerCase())
        ? (totalamount * double.parse(orderModel.adminCommission!)) / 100
        : double.parse(orderModel.adminCommission!);

    if (orderModel.taxModel != null) {
      for (var element in orderModel.taxModel!) {
        taxAmount = taxAmount + calculateTax(amount: totalamount.toString(), taxModel: element);
      }
    }

    double finalAmount = totalamount + taxAmount;

    TopupTranHistoryModel historyModel = TopupTranHistoryModel(
        amount: finalAmount,
        id: Uuid().v4(),
        orderId: orderModel.id,
        userId: orderModel.vendor.author,
        date: Timestamp.now(),
        isTopup: true,
        paymentMethod: "Wallet",
        paymentStatus: "success",
        transactionUser: "vendor");

    await firestore.collection(Wallet).doc(historyModel.id).set(historyModel.toJson());

    TopupTranHistoryModel adminCommission = TopupTranHistoryModel(
        amount: adminComm,
        id: Uuid().v4(),
        orderId: orderModel.id,
        userId: orderModel.vendor.author,
        date: Timestamp.now(),
        isTopup: false,
        paymentMethod: "Wallet",
        paymentStatus: "success",
        transactionUser: "vendor");

    await firestore.collection(Wallet).doc(historyModel.id).set(historyModel.toJson());
    await firestore.collection(Wallet).doc(adminCommission.id).set(adminCommission.toJson());
    await updateVendorWalletAmount(amount: finalAmount - adminComm, userId: orderModel.vendor.author);
  }

  static Future updateVendorWalletAmount({required amount, required userId}) async {
    await firestore.collection(USERS).doc(userId).get().then((value) async {
      DocumentSnapshot<Map<String, dynamic>> userDocument = value;
      if (userDocument.data() != null && userDocument.exists) {
        try {
          print(userDocument.data());
          User user = User.fromJson(userDocument.data()!);
          user.walletAmount = user.walletAmount + amount;
          await firestore.collection(USERS).doc(userId).set(user.toJson()).then((value) => print("north"));
        } catch (error) {
          print(error);
          if (error.toString() == "Bad state: field does not exist within the DocumentSnapshotPlatform") {
            print("does not exist");
          } else {
            print("went wrong!!");
          }
        }
      } else {
        return 0.111;
      }
    });
  }

  Future updateWallateAmountEcommarce(OrderModel orderModel) async {
    double total = 0.0;
    double discount = 0.0;
    double specialDiscount = 0.0;
    double taxAmount = 0.0;
    orderModel.products.forEach((element) {
      if (element.extras_price != null && element.extras_price!.isNotEmpty && double.parse(element.extras_price!) != 0.0) {
        total += element.quantity * double.parse(element.extras_price!);
      }
      total += element.quantity * double.parse(element.price);
    });
    if (orderModel.discount != null) {
      discount = double.parse(orderModel.discount.toString());
    }

    if (orderModel.specialDiscount != null || orderModel.specialDiscount!['special_discount'] != null) {
      specialDiscount = double.parse(orderModel.specialDiscount!['special_discount'].toString());
    }
    var totalamount = total - discount - specialDiscount;

    double adminComm = (orderModel.adminCommissionType!.toLowerCase() == 'Percent'.toLowerCase() ||
            orderModel.adminCommissionType!.toLowerCase() == 'percentage'.toLowerCase())
        ? (totalamount * double.parse(orderModel.adminCommission!)) / 100
        : double.parse(orderModel.adminCommission!);

    if (orderModel.taxModel != null) {
      for (var element in orderModel.taxModel!) {
        taxAmount = taxAmount + calculateTax(amount: totalamount.toString(), taxModel: element);
      }
    }

    //var finalAmount = (totalamount - adminComm).toStringAsFixed(currencyData!.decimal);
    double finalAmount = totalamount + taxAmount;

    num driverAmount = 0;
    driverAmount += (double.parse(orderModel.deliveryCharge!) + double.parse(orderModel.tipValue!));

    print("--------->");
    print(adminComm);
    print(finalAmount);
    print(driverAmount);

    TopupTranHistoryModel historyModel = TopupTranHistoryModel(
        amount: finalAmount,
        id: Uuid().v4(),
        orderId: orderModel.id,
        userId: orderModel.vendor.author,
        date: Timestamp.now(),
        isTopup: true,
        paymentMethod: "Wallet",
        paymentStatus: "success",
        transactionUser: "vendor");

    await firestore.collection(Wallet).doc(historyModel.id).set(historyModel.toJson());

    TopupTranHistoryModel adminCommission = TopupTranHistoryModel(
        amount: adminComm,
        id: Uuid().v4(),
        orderId: orderModel.id,
        userId: orderModel.vendor.author,
        date: Timestamp.now(),
        isTopup: false,
        paymentMethod: "Wallet",
        paymentStatus: "success",
        transactionUser: "vendor");

    await firestore.collection(Wallet).doc(historyModel.id).set(historyModel.toJson());
    await firestore.collection(Wallet).doc(adminCommission.id).set(adminCommission.toJson());
    await updateVendorWalletAmount(amount: finalAmount - adminComm, userId: orderModel.vendor.author);
  }

  static Future<DriverDocumentModel?> getDocumentOfDriver() async {
    DriverDocumentModel? driverDocumentModel;
    await firestore.collection(documentsVerify).doc(MyAppState.currentUser!.userID).get().then((value) async {
      if (value.exists) {
        driverDocumentModel = DriverDocumentModel.fromJson(value.data()!);
      }
    });
    return driverDocumentModel;
  }

  static Future<bool> uploadDriverDocument(Documents documents) async {
    bool isAdded = false;
    DriverDocumentModel driverDocumentModel = DriverDocumentModel();
    List<Documents> documentsList = [];
    await firestore.collection(documentsVerify).doc(MyAppState.currentUser!.userID).get().then((value) async {
      if (value.exists) {
        DriverDocumentModel newDriverDocumentModel = DriverDocumentModel.fromJson(value.data()!);
        documentsList = newDriverDocumentModel.documents!;
        var contain = newDriverDocumentModel.documents!.where((element) => element.documentId == documents.documentId);
        if (contain.isEmpty) {
          documentsList.add(documents);

          driverDocumentModel.id = MyAppState.currentUser!.userID;
          driverDocumentModel.type = "restaurant";
          driverDocumentModel.documents = documentsList;
        } else {
          var index = newDriverDocumentModel.documents!.indexWhere((element) => element.documentId == documents.documentId);

          driverDocumentModel.id = MyAppState.currentUser!.userID;
          driverDocumentModel.type = "restaurant";
          documentsList.removeAt(index);
          documentsList.insert(index, documents);
          driverDocumentModel.documents = documentsList;
          isAdded = false;
        }
      } else {
        documentsList.add(documents);
        driverDocumentModel.id = MyAppState.currentUser!.userID;
        driverDocumentModel.type = "restaurant";
        driverDocumentModel.documents = documentsList;
      }
    });

    await firestore.collection(documentsVerify).doc(MyAppState.currentUser!.userID).set(driverDocumentModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      isAdded = false;
      log(error.toString());
    });

    return isAdded;
  }

  static Future<List<DocumentModel>> getDocumentList() async {
    List<DocumentModel> documentList = [];
    await firestore.collection(documents).where('type', isEqualTo: "restaurant").where('enable', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        DocumentModel documentModel = DocumentModel.fromJson(element.data());
        documentList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return documentList;
  }
}
