import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/currencies_model.dart';
import 'package:scaneats/app/model/dining_table_model.dart';
import 'package:scaneats/app/model/item_attributes_model.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/model/notification_model.dart';
import 'package:scaneats/app/model/offer_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/payment_method_model.dart';
import 'package:scaneats/app/model/restaurant_model.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/app/model/subscription_model.dart';
import 'package:scaneats/app/model/subscription_transaction.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/app/model/theme_model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/widgets/global_widgets.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<bool> isLogin() async {
    bool isLogin = false;
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        isLogin = await userExitOrNot(FirebaseAuth.instance.currentUser!.uid);
      } else {
        isLogin = false;
      }
    } catch (e) {
      printLog(e.toString());
    }
    return isLogin;
  }

  static Future<bool> userExitOrNot(String uid) async {
    bool isExit = false;
    try {
      await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).doc(uid).get().then(
        (value) {
          if (value.exists) {
            isExit = true;
          } else {
            isExit = false;
          }
        },
      ).catchError((error) {
        isExit = false;
      });
    } catch (e) {
      printLog(e.toString());
    }

    return isExit;
  }

  static Future<List<UserModel>?> getAllUserByBranch(String branchId) async {
    List<UserModel> model = [];
    try {
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
        printLog("getAllUserByBranch :: Failed to update user: $error");
        throw error;
      });
    } catch (e) {
      printLog(e.toString());
    }
    return model;
  }

  static Future<List<UserModel>?> getAllRoleUser(String role, String branchId) async {
    List<UserModel> model = [];
    try {
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.user)
          .where('branchId', isEqualTo: branchId)
          .where('role', isEqualTo: role)
          .get()
          .then(
        (value) {
          for (var element in value.docs) {
            UserModel data = UserModel.fromJson(element.data());
            model.add(data);
          }
          var data = model.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
          return data;
        },
      );
    } catch (e) {
      printLog(e.toString());
    }
    return model;
  }

  static Future<List<UserModel>?> getAllUser(String role) async {
    List<UserModel> model = [];
    try {
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.user)
          .where('branchId', isEqualTo: Constant.selectedBranch.id)
          .where('role', isEqualTo: role)
          .get()
          .then(
        (value) {
          for (var element in value.docs) {
            UserModel data = UserModel.fromJson(element.data());
            model.add(data);
          }
          var data = model.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
          return data;
        },
      );
    } catch (e) {
      printLog(e.toString());
    }
    return model;
  }

  static Future<List<UserModel>?> getAllAdmin(String role, String id) async {
    List<UserModel> model = [];
    try {
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.user)
          .where('role', isEqualTo: role)
          .where('branchId', isEqualTo: id)
          .get()
          .then(
        (value) {
          for (var element in value.docs) {
            UserModel data = UserModel.fromJson(element.data());
            model.add(data);
          }
          var data = model.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
          return data;
        },
      );
    } catch (e) {
      printLog(e.toString());
    }
    return model;
  }

  static Future<List<UserModel>?> getAllUserByName(String name, String role) async {
    try {
      List<UserModel> model = [];
      await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).orderBy('name', descending: true).get().then((value) {
        for (var element in value.docs) {
          UserModel data = UserModel.fromJson(element.data());
          if (data.branchId != '') {
            if (data.role == role && data.branchId == Constant.selectedBranch.id) {
              model.add(data);
            }
          } else {
            if (data.role == role) {
              model.add(data);
            }
          }
        }
      });
      List<UserModel> data = model
          .where((e) =>
              e.name!.toLowerCase().contains(name.toLowerCase()) || e.email!.toLowerCase().contains(name.toLowerCase()) || e.mobileNo!.toLowerCase().contains(name.toLowerCase()))
          .toList();
      return data;
    } catch (e) {
      printLog(e.toString());
    }
    return null;
  }

  static Future<UserModel?> getUserById(String id) async {
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

  static Future<UserModel?> deleteUserById(UserModel model) async {
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).doc(model.id).delete().then((value) {
      // secondaryApp.delete();
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<UserModel?> setUserModel(UserModel model) async {
    DocumentReference<Map<String, dynamic>> documentRef;
    documentRef = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).doc(model.id);
    await documentRef.set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });

    return model;
  }

  static Future<String> uploadUserImageToFireStorage(Uint8List image, String filePath, String fileName) async {
    try {
      Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = upload.putData(image, metadata);
      var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      return downloadUrl.toString();
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
      return "error ${e.toString()}";
    }
  }

  static Future<List<BranchModel>?> getAllBranch() async {
    List<BranchModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.branch).get().then((value) {
      for (var element in value.docs) {
        BranchModel data = BranchModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<BranchModel> getBranchById({required String id}) async {
    BranchModel model = BranchModel();
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.branch).doc(id).get().then((value) {
      model = BranchModel.fromJson(value.data() as Map<String, dynamic>);
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<List<BranchModel>?> getActiveBranch() async {
    List<BranchModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.branch)
        .where("isActive", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        BranchModel data = BranchModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<BranchModel> addBranch(BranchModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.branch).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.branch).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteBranch(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.branch).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<LanguageModel> addLanguage(LanguageModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.languages).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.languages).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.languages).get().then((value) {
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

  static Future<List<LanguageModel>?> getActiveLanguage() async {
    List<LanguageModel>? model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.languages)
        .where("isActive", isEqualTo: true)
        .get()
        .then((value) {
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

  static Future<LanguageModel?> deleteLanguageId(LanguageModel model) async {
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.languages).doc(model.id).delete().then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<List<RoleModel>?> getAllRole() async {
    List<RoleModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).get().then((value) {
      for (var element in value.docs) {
        RoleModel data = RoleModel.fromJson(element.data());
        model.add(data);
      }
      printLog(model[0].title.toString());
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<String?> getRoleForAdmin() async {
    String? roleId;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).where("title", isEqualTo: "Admin").get().then((value) {
      if (value.docs.isNotEmpty) {
        RoleModel data = RoleModel.fromJson(value.docs.first.data());
        roleId = data.id;
      }
      return roleId;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return roleId;
    });
    return roleId;
  }

  static Future<RoleModel?> getRoleById({required String roleId}) async {
    RoleModel? roleModel;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).doc(roleId).get().then((value) {
      if (value.exists) {
        roleModel = RoleModel.fromJson(value.data()!);
        return roleModel;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return roleModel;
    });
    return roleModel;
  }

  static Future<RoleModel?> addRole(RoleModel model) async {
    if (model.id == null || model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      model = RoleModel();
      return model;
    });
    return model;
  }

  static Future<RoleModel?> deleteRoleById(RoleModel model) async {
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.role).doc(model.id).delete().then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<UserModel> loginWithEmailAndPassword(String email, String password) async {
    UserModel model = UserModel();
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      printLog(email.toString());
      printLog("${password.toString()} ${result.user?.uid.toString()}");
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.user).doc(result.user?.uid ?? '').get();
      printLog("User :: ${documentSnapshot.exists}");
      if (documentSnapshot.exists) {
        model = UserModel.fromJson(documentSnapshot.data() ?? {});
        return model;
      } else {
        return model;
      }
    } on auth.FirebaseAuthException catch (exception) {
      switch ((exception).code) {
        case 'invalid-email':
          ShowToastDialog.showToast('Email address is malformed.');
        case 'wrong-password':
          ShowToastDialog.showToast('Wrong password.');
        case 'user-not-found':
          ShowToastDialog.showToast('No user corresponding to the given email address.');
        case 'user-disabled':
          ShowToastDialog.showToast('This user has been disabled.');
        case 'too-many-requests':
          ShowToastDialog.showToast('Too many attempts to sign in as this user.');
      }
      ShowToastDialog.showToast('Unexpected firebase error, Please try again.');
    } catch (e) {
      ShowToastDialog.showToast('Login failed, Please try again.');
    }
    return model;
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
    ).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<ItemCategoryModel> addItemCategory(ItemCategoryModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemCategory).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemCategory).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<ItemCategoryModel?> getCategoryById({required String categoryId}) async {
    ItemCategoryModel? model;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemCategory).doc(categoryId).get().then((value) {
      if (value.exists) {
        model = ItemCategoryModel.fromJson(value.data()!);
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<bool> deleteByItemCategoryId(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemCategory).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
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
    ).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<CurrenciesModel>?> getCurrencies() async {
    List<CurrenciesModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).get().then(
      (value) {
        for (var element in value.docs) {
          CurrenciesModel data = CurrenciesModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
    ).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<CurrenciesModel>?> getActiveCurrencies() async {
    List<CurrenciesModel>? model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).where("isActive", isEqualTo: true).get().then(
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

  static Future<List<CurrenciesModel>?> getActiveCurrenciesOfOwner() async {
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
      throw error;
    });
    return model;
  }

  static Future<CurrenciesModel> addCurrencies(CurrenciesModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteCurrenciesById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.currencies).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<RestaurantModel> addUpdateCompanyDetails(RestaurantModel model) async {
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.settings)
        .doc(CollectionName.companyDetails)
        .set(model.toJson())
        .then((value) {
      return model;
    });
    return model;
  }

  static Future<RestaurantModel?> getCompanyDetails() async {
    RestaurantModel? companyDetailsModel;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).get().then((value) {
      if (value.exists) {
        companyDetailsModel = RestaurantModel.fromJson(value.data()!);
      }
    });
    return companyDetailsModel;
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

  static Future<NotificationModel> addUpdateNotification(NotificationModel model) async {
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.settings)
        .doc(CollectionName.notification)
        .set(model.toJson())
        .then((value) {
      return model;
    });
    return model;
  }

  static Future<ItemAttributeModel> addItemAttribute(ItemAttributeModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemAttribute).doc().id;
      model.id = ref;
    }
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.itemAttribute)
        .doc(model.id)
        .set(model.toJson())
        .then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteByItemAttributeId(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.itemAttribute).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<List<TaxModel>?> getTax() async {
    List<TaxModel>? model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).get().then(
      (value) {
        for (var element in value.docs) {
          TaxModel data = TaxModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
    ).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<TaxModel>?> getActiveTax() async {
    List<TaxModel>? model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).where("isActive", isEqualTo: true).get().then(
      (value) {
        for (var element in value.docs) {
          TaxModel data = TaxModel.fromJson(element.data());
          model.add(data);
        }
        return model;
      },
    ).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<TaxModel?> getTaxById({required String taxId}) async {
    TaxModel? model;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).doc(taxId).get().then((value) {
      if (value.exists) {
        model = TaxModel.fromJson(value.data()!);
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<TaxModel> addTax(TaxModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteTaxById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.tax).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<List<ItemModel>?> getAllItem(String name, {String categoryId = ''}) async {
    List<ItemModel> modelData = [];
    if (categoryId.isEmpty) {
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
    return data;
  }

  static Future<List<ItemModel>?> getFeaturedItem() async {
    List<ItemModel> modelData = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.item).where('isFeature', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        ItemModel model = ItemModel.fromJson(element.data());
        modelData.add(model);
      }
    }).catchError((error) {
      debugPrint("Failed to update user: $error");
      // ignore: invalid_return_type_for_catch_error
      return modelData;
    });
    return modelData;
  }

  static Future<ItemModel> addItem(ItemModel model) async {
    printLog("ID :: ${model.id}");
    if (model.id == '' || model.id == null) {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.item).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.item).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteItemById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.item).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<OfferModel> setOffer(OfferModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<OfferModel>?> getAllOffer() async {
    List<OfferModel> model = [];
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).get().then((value) {
      for (var element in value.docs) {
        OfferModel data = OfferModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<bool> deleteOfferById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<bool> orderPlace(OrderModel model) async {
    var isPlace = false;
    if (model.id == null) {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.offers).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.order).doc(model.id).set(model.toJson()).then((value) {
      isPlace = true;
    }).catchError((error) {
      isPlace = false;
    });
    return isPlace;
  }

  static Future<bool> deleteOrderById(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.order).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      printLog("orderPlace :: Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<OrderModel?> getOrderById(String id) async {
    OrderModel? model;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.order).doc(id).get().then((value) {
      if (value.exists) {
        model = OrderModel.fromJson(value.data()!);
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<OrderModel> getOrderByTableId({required String tableId}) async {
    OrderModel model = OrderModel();
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where("tableId", isEqualTo: tableId)
        .where("paymentStatus", isEqualTo: false)
        .where("status", isNotEqualTo: Constant.statusRejected)
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        model = OrderModel.fromJson(value.docs.first.data());
        return model;
      } else {
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<OrderModel>?> getRecentOrder() async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
        .where("createdAt", isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5))))
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
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<OrderModel>?> getAllOrderByBranch() async {
    try {
      List<OrderModel> model = [];
      await fireStore
          .collection(CollectionName.restaurants)
          .doc(CollectionName.restaurantId)
          .collection(CollectionName.order)
          .where("branchId", isEqualTo: Constant.selectedBranch.id)
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
        printLog("Failed to update user: $error");
        throw error;
      });
      return model;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<List<OrderModel>?> getAllOrder({String? role}) async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where('type', isEqualTo: role)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
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
      printLog("Failed to update user: $error");
      throw error;
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
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<OrderModel>?> getAllOrderByName(String name, String type) async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where('type', isEqualTo: type)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        OrderModel data = OrderModel.fromJson(element.data());
        model.add(data);
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
    });
    List<OrderModel> data = <OrderModel>[];
    if (type == Constant.orderTypePos) {
      data = model
          .where((e) =>
              e.customer!.name!.toLowerCase().contains(name.toLowerCase()) ||
              e.status!.toLowerCase().contains(name.toLowerCase()) ||
              e.id!.toLowerCase().contains(name.toLowerCase()) ||
              e.total!.toLowerCase().contains(name.toLowerCase()) ||
              e.customer!.name!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } else {
      data = model
          .where((e) =>
              e.total!.toLowerCase().contains(name.toLowerCase()) || e.id!.toLowerCase().contains(name.toLowerCase()) || e.status!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    return data;
  }

  static Future<DiningTableModel?> getDiningTableById({required String tableId}) async {
    DiningTableModel? model;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.diningTables).doc(tableId).get().then((value) {
      if (value.exists) {
        model = DiningTableModel.fromJson(value.data()!);
        return model;
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
      return model;
    });
    return model;
  }

  static Future<OrderModel> updateOrderById({required OrderModel model}) async {
    Map<String, dynamic> mapData = model.toJson();

    printLog("Order :: 11 :: ${mapData.toString()}");
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.order).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<DiningTableModel> setDiningTable(DiningTableModel model) async {
    if (model.id == '') {
      var ref = fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.diningTables).doc().id;
      model.id = ref;
    }
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.diningTables).doc(model.id).set(model.toJson()).then((value) {
      return model;
    }).catchError((error) {
      printLog("Failed to update dining : $error");
      throw error;
    });
    return model;
  }

  static Future<List<DiningTableModel>?> getDiningTable(String name) async {
    List<DiningTableModel> modelData = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.diningTables)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
        .get()
        .then((value) {
      printLog("Failed to update user: ${value.docs.length}");
      for (var element in value.docs) {
        DiningTableModel model = DiningTableModel.fromJson(element.data());
        modelData.add(model);
      }
    }).catchError((error) {
      debugPrint("getDiningTable :: Failed to update user: ${error.toString()}");
    });
    List<DiningTableModel> data = modelData.where((e) => e.name!.toLowerCase().contains(name.toLowerCase())).toList();
    return data;
  }

  static Future<bool> deleteDiningTable(String id) async {
    bool isDelete = false;
    await fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.diningTables).doc(id).delete().then((value) {
      isDelete = true;
      return isDelete;
    }).catchError((error) {
      debugPrint("Failed to update user: $error");
      isDelete = false;
      return isDelete;
    });
    return isDelete;
  }

  static Future<ThemeModel> addUpdateThem(ThemeModel model) async {
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.settings)
        .doc(CollectionName.theme)
        .set(model.toJson())
        .then((value) {
      return model;
    });
    return model;
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

  static Future<List<OrderModel>?> getAllOrderByTime(Timestamp time) async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
        .where('updatedAt', isGreaterThanOrEqualTo: time)
        .where('updatedAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('updatedAt', descending: false)
        .get()
        .then((value) {
      printLog("ORDER MODEL :: ${value.docs.length}");
      for (var element in value.docs) {
        OrderModel data = OrderModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<OrderModel>?> getAllOrderByTimeWithoutBranch(Timestamp time) async {
    List<OrderModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.order)
        .where('createdAt', isGreaterThanOrEqualTo: time)
        .where('createdAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      printLog("ORDER MODEL :: ${value.docs.length}");
      for (var element in value.docs) {
        OrderModel data = OrderModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<UserModel>?> getAllCustomerByTime(Timestamp time) async {
    List<UserModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.user)
        .where("role", isEqualTo: Constant.customerRole)
        .where("branchId", isEqualTo: Constant.selectedBranch.id)
        .where('createdAt', isGreaterThanOrEqualTo: time)
        .where('createdAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      printLog("CUSTOMER MODEL :: ${value.docs.length}");
      for (var element in value.docs) {
        UserModel data = UserModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<UserModel>?> getAllCustomerByTimeWithoutBranch(Timestamp time) async {
    List<UserModel> model = [];
    await fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.user)
        .where("role", isEqualTo: Constant.customerRole)
        .where('createdAt', isGreaterThanOrEqualTo: time)
        .where('createdAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('createdAt', descending: false)
        .get()
        .then((value) {
      printLog("CUSTOMER MODEL :: ${value.docs.length}");
      for (var element in value.docs) {
        UserModel data = UserModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<List<RestaurantModel>?> getRestaurantBySlug(String restaurantSlug) async {
    List<RestaurantModel> model = [];
    await fireStore.collection(CollectionName.restaurants).where("slug", isEqualTo: restaurantSlug).get().then((value) {
      for (var element in value.docs) {
        RestaurantModel data = RestaurantModel.fromJson(element.data());
        model.add(data);
      }
      var data = model.sort((a, b) => b.updateAt!.compareTo(a.updateAt!));
      return data;
    }).catchError((error) {
      printLog("Failed to update user: $error");
    });
    return model;
  }

  static Future<List<SubscriptionModel>?> getAllSubscription() async {
    List<SubscriptionModel> model = [];
    await fireStore.collection(CollectionName.subscriptions).where("isActive", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        SubscriptionModel data = SubscriptionModel.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
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

  static Future<List<SubscriptionTransaction>?> getTractionByRestaurantId() async {
    List<SubscriptionTransaction> model = [];
    await fireStore
        .collection(CollectionName.subscriptionTransaction)
        .where("restaurantId", isEqualTo: CollectionName.restaurantId)
        .orderBy("startDate", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        SubscriptionTransaction data = SubscriptionTransaction.fromJson(element.data());
        model.add(data);
      }
      return model;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return model;
  }

  static Future<PaymentMethodModel?> getAdminPaymentData() async {
    PaymentMethodModel? paymentModel;
    await fireStore.collection(CollectionName.settings).doc(CollectionName.paymentSettings).get().then((value) {
      if (value.exists) {
        paymentModel = PaymentMethodModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      printLog("Failed to update user: $error");
    });
    return paymentModel;
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
    ;
    return paymentModel;
  }

  static Future<PaymentMethodModel?> setPaymentData({required PaymentMethodModel model}) async {
    DocumentReference<Map<String, dynamic>> documentRef =
        fireStore.collection(CollectionName.restaurants).doc(CollectionName.restaurantId).collection(CollectionName.settings).doc(CollectionName.paymentSettings);
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
