import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/main.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:provider/provider.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<ProductModel> bestOfferList = <ProductModel>[].obs;

  RxList<ProductModel> brandList = <ProductModel>[].obs;
  RxList<FavouriteItemModel> listFav = <FavouriteItemModel>[].obs;
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxInt cartCount = 0.obs;
  Rx<CartDatabase> cartDatabase = CartDatabase().obs;
  RxList<ProductModel> filterProductList = <ProductModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> establishedProductList = <ProductModel>[].obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserData();
    getAllProduct();

    cartDatabase.value = Provider.of<CartDatabase>(MyAppState.navigatorKey.currentContext!);
    super.onInit();
  }

  getUserData() async {

    if (Constant.currentUser.id != null) {
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
        if (value != null) {
          userModel.value = value;
          if (userModel.value.shippingAddress!.isNotEmpty) {
            if (userModel.value.shippingAddress!.where((element) => element.isDefault == true).isNotEmpty) {
              Constant.selectedPosition = userModel.value.shippingAddress!.where((element) => element.isDefault == true).single;
            } else {
              Constant.selectedPosition = userModel.value.shippingAddress!.first;
            }
          } else {
            Constant.selectedPosition = AddressModel();
          }

          update();
        }
      });
    }
    await getFavoriteData();
    await getTax();

    update();
  }

  getTax() async {
    if (Constant.selectedPosition.id != null) {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          double.parse(Constant.selectedPosition.location!.latitude.toString()), double.parse(Constant.selectedPosition.location!.longitude.toString()));

      Constant.country = placeMarks.first.country;
      await FireStoreUtils().getTaxList().then((value) {
        if (value != null) {
          Constant.taxList = value;
        }
      });
      getData();
    } else {
      Constant.selectedPosition = AddressModel();
    }
  }

  getData() async {
    await FireStoreUtils.getCategories().then((value) {
      if (value != null) {
        categoryList.value = value;
      }
    });

    await FireStoreUtils.getVendor().then((value) {
      if (value != null) {
        vendorModel.value = value;
      }
    });
    Constant.distance = (Constant.getKm(LocationLatLng(latitude: Constant.selectedPosition.location!.latitude, longitude: Constant.selectedPosition.location!.longitude),
        LocationLatLng(latitude: vendorModel.value.latitude, longitude: vendorModel.value.longitude)));

    bestOfferList.clear();
    establishedProductList.clear();


    if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
      FireStoreUtils.getBestOfferProducts().then((value) {
        if (value != null) {
          bestOfferList.value = value;
          update();
        }
      });

      FireStoreUtils.getEstablishBrandProducts().then((value) {
        if (value != null) {
          for (var element in value) {
            if (element.brandID != null) {
              establishedProductList.value = value;
              update();
            }
          }
        }
      });
    }
    isLoading.value = false;

    update();
  }

  getFavoriteData() async {
    if (Constant.currentUser.id != null) {
    await FireStoreUtils.getFavouritesProductList(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        listFav.value = value;
      }
    });
  }
    update();
  }

  getAllProduct() async {
    await FireStoreUtils.getAllDeliveryProducts().then((value) {
      if (value != null) {
        productList.value = value;
      }
    });
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      filterProductList.value = productList.where((e) => e.name!.toLowerCase().contains(value.toLowerCase().toString()) || e.name!.startsWith(value.toString())).toList();
    } else {
      filterProductList.value = productList;
    }
    update();
  }
}
