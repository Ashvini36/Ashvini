import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/ui/delivery_address_screen/delivery_address_screen.dart';
import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_customer/app/ui/profile_screen/profile_screen.dart';
import 'package:ebasket_customer/services/helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/widgets/empty_data.dart';
import 'package:ebasket_customer/widgets/place_picker_osm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/controller/product_details_controller.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_brand_screen/view_all_brand_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_product_screen/view_all_category_product_screen.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/ui/cart_screen/cart_screen.dart';
import 'package:ebasket_customer/app/ui/notification_screen/notification_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_screen/view_all_category_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:ebasket_customer/widgets/trusted_brand_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppThemeData.white,
              elevation: 0,
              titleSpacing: 10,
              leadingWidth: 65,
              surfaceTintColor: AppThemeData.white,
              leading: InkWell(
                onTap: () {
                  Get.to(const ProfileScreen(), transition: Transition.rightToLeftWithFade);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: controller.userModel.value.id != null
                        ? controller.userModel.value.image!.isNotEmpty
                        ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(
                            color: AppThemeData.groceryAppDarkBlue,
                            width: 1.0,
                          ),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Image.network(
                              controller.userModel.value.image.toString(),
                              fit: BoxFit.cover,
                            )))
                        : Image.asset("assets/icons/ic_logo.png", color: AppThemeData.groceryAppDarkBlue)
                        : Image.asset("assets/icons/ic_logo.png", color: AppThemeData.groceryAppDarkBlue),
                  ),
                ),
              ),
              title: InkWell(
                onTap: () async {
                  if (Constant.currentUser.id != null) {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryAddressScreen())).then((value) async {
                      controller.isLoading.value = true;
                      await controller.getUserData();

                      controller.update();
                    });
                  } else {
                    checkPermission(
                          () async {
                        await ShowToastDialog.showLoader("Please Wait".tr);
                        AddressModel addressModel = AddressModel();
                        try {
                          await Geolocator.requestPermission();
                          await Geolocator.getCurrentPosition();

                          if (Constant.selectedMapType == 'osm') {
                            await ShowToastDialog.closeLoader();
                            Get.to(() => const LocationPicker())?.then((value) async {
                              if (value != null) {
                                AddressModel addressModel = AddressModel();
                                addressModel.id = Uuid().v4();
                                addressModel.addressAs = "Home";
                                addressModel.locality = value.displayName!.toString();
                                addressModel.location = UserLocation(latitude: value.lat, longitude: value.lon);
                                controller.isLoading.value = true;
                                Constant.selectedPosition = addressModel;
                                controller.getUserData();
                                controller.update();
                              }
                            });
                          } else {
                            await ShowToastDialog.closeLoader();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlacePicker(
                                      apiKey: Constant.mapKey,
                                      onPlacePicked: (result) async {
                                        print("-========>");
                                        print(result);
                                        await ShowToastDialog.closeLoader();
                                        AddressModel addressModel = AddressModel();
                                        addressModel.id = Uuid().v4();
                                        addressModel.addressAs = "Home";
                                        addressModel.locality = result.formattedAddress!.toString();
                                        addressModel.location = UserLocation(latitude: result.geometry!.location.lat, longitude: result.geometry!.location.lng);
                                        controller.isLoading.value = true;
                                        Constant.selectedPosition = addressModel;
                                        controller.getUserData();
                                        controller.update();
                                        Get.back();
                                      },
                                      initialPosition: LatLng(-33.8567844, 151.213108),
                                      useCurrentLocation: true,
                                      selectInitialPosition: true,
                                      usePinPointingSearch: true,
                                      usePlaceDetailSearch: true,
                                      zoomGesturesEnabled: true,
                                      zoomControlsEnabled: true,
                                      resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                    ),
                              ),
                            );
                          }
                        } catch (e) {
                          await ShowToastDialog.closeLoader();
                          await placemarkFromCoordinates(19.228825, 72.854118).then((valuePlaceMaker) {
                            Placemark placeMark = valuePlaceMaker[0];

                            addressModel.location = UserLocation(latitude: 19.228825, longitude: 72.854118);
                            String currentLocation =
                                "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark
                                .country}";
                            addressModel.locality = currentLocation;
                          });

                          Constant.selectedPosition = addressModel;

                          controller.getUserData();
                          controller.update();
                        }
                      },
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Constant.selectedPosition.locality != null
                              ? Text(
                            Constant.selectedPosition.getFullAddress().toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppThemeData.black,
                              fontSize: 12,
                              fontFamily: AppThemeData.regular,
                            ),
                          )
                              : Text(
                            "Select Address",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: AppThemeData.black,
                              fontSize: 12,
                              fontFamily: AppThemeData.regular,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset("assets/icons/ic_down.svg", width: 24, height: 24),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance))
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                if (controller.userModel.value.id != null) {
                                  Get.to(const CartScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                                    controller.getUserData();
                                    controller.update();
                                  });
                                } else {
                                  Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/icons/ic_bag.svg",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            StreamBuilder<List<CartProduct>>(
                              stream: controller.cartDatabase.value.watchProducts,
                              builder: (context, snapshot) {
                                controller.cartCount.value = 0;
                                if (snapshot.hasData) {
                                  for (var element in snapshot.data!) {
                                    controller.cartCount.value += element.quantity;
                                  }
                                }
                                return Visibility(
                                  visible: controller.cartCount.value >= 1,
                                  child: Positioned(
                                    right: 2,
                                    top: -1,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppThemeData.groceryAppDarkBlue,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.cartCount.value <= 99 ? '${controller.cartCount.value}' : '+99',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.userModel.value.id != null) {
                              Get.to(const NotificationScreen(), transition: Transition.rightToLeftWithFade);
                            } else {
                              Get.to(const LoginScreen(), transition: Transition.rightToLeftWithFade);
                            }
                          },
                          child: SvgPicture.asset(
                            "assets/icons/ic_notification_home.svg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.selectedPosition.id != null
                ? Constant.loader()
                : Center(
                child: Text(
                  "No Address found, please create address.",
                  style: TextStyle(
                    color: AppThemeData.black,
                    fontSize: 16,
                    fontFamily: AppThemeData.medium,
                  ),
                ))
                : controller.bestOfferList.isEmpty || controller.productList.isEmpty
                ? EmptyData()
                : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Next Day Delivery'.tr,
                          style: TextStyle(
                            color: AppThemeData.black,
                            fontSize: 18,
                            fontFamily: AppThemeData.semiBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: SvgPicture.asset("assets/icons/ic_delivery.svg"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Responsive.width(100, context),
                    color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        "Offers will be displayed here!".tr,
                        style: TextStyle(
                          color: AppThemeData.black,
                          fontSize: 14,
                          fontFamily: AppThemeData.medium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    controller: controller.searchTextFiledController.value,
                                    hintText: "Search".tr,
                                    enable: true,
                                    onFieldSubmitted: (v) {
                                      return null;
                                    },
                                    onChanged: (value) {
                                      controller.getFilterData(value!);
                                      return null;
                                    },
                                    suffix: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SvgPicture.asset("assets/icons/ic_search.svg", height: 22, width: 22),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.filterProductList.isNotEmpty && controller.searchTextFiledController.value.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Card(
                                  color: Colors.white,
                                  child: ListView.builder(
                                      itemCount: controller.filterProductList.length,
                                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        print("========${controller.filterProductList[index].brandID.toString()}");
                                        return InkWell(
                                          onTap: () {
                                            Get.to(const ProductDetailsScreen(), arguments: {
                                              "productModel": controller.filterProductList[index],
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                controller.filterProductList[index].name.toString(),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: AppThemeData.regular,
                                                ),
                                              ),
                                              StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection(CollectionName.brands)
                                                    .where("id", isEqualTo: controller.filterProductList[index].brandID.toString())
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  dynamic data = snapshot.data != null ? snapshot.data!.docs[0].data() : null;

                                                  return snapshot.data != null && snapshot.data!.docs.isNotEmpty
                                                      ? Text(
                                                    "by ${data['title']}",
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      color: AppThemeData.black,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: AppThemeData.regular,
                                                    ),
                                                  )
                                                      : Container();
                                                },
                                              )
                                            ]),
                                          ),
                                        );
                                      }),
                                ),
                              )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Best Offers".tr,
                                style: TextStyle(color: AppThemeData.black, fontSize: 18, fontFamily: AppThemeData.semiBold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const ViewAllBrandScreen(), arguments: {"type": 'offer'})!.then((value) {});
                              },
                              child: Text(
                                "View All".tr,
                                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.semiBold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: Responsive.height(18, context),
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.bestOfferList.length,
                            itemBuilder: (context, index) {
                              ProductModel offerItem = controller.bestOfferList[index];
                              return InkWell(
                                onTap: () {},
                                child: OffersItemWidget(
                                  offerItem: offerItem,
                                  controller: controller,
                                  index: index,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Categories".tr,
                                style: TextStyle(color: AppThemeData.black, fontSize: 18, fontFamily: AppThemeData.semiBold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const ViewAllCategoryListScreen())!.then((value) {
                                  controller.getFavoriteData();
                                });
                              },
                              child: Text(
                                "View All".tr,
                                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.semiBold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 6 / 6),
                          itemCount: controller.categoryList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CategoryModel categoryItem = controller.categoryList[index];
                            return CategoryItemWidget(
                              categoryItem: categoryItem,
                            );
                          },
                        ),

                        // Container(
                        //   height: Responsive.height(15, context),
                        //   alignment: Alignment.centerLeft,
                        //   child: ListView.builder(
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: controller.categoryList.length,
                        //     itemBuilder: (context, index) {
                        //       CategoryModel categoryItem = controller.categoryList[index];
                        //       return CategoryItemWidget(
                        //         categoryItem: categoryItem,
                        //       );
                        //     },
                        //   ),
                        // ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Established Brands".tr,
                                style: TextStyle(color: AppThemeData.black, fontSize: 18, fontFamily: AppThemeData.semiBold),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const ViewAllBrandScreen(), arguments: {"type": 'brand'})!.then((value) {
                                  controller.getFavoriteData();
                                });
                              },
                              child: Text(
                                "View All".tr,
                                style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.semiBold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: Responsive.height(38.3, context),
                          alignment: Alignment.centerLeft,
                          child: controller.establishedProductList.isEmpty
                              ? Constant.showEmptyView(message: "No Established Brands Found".tr)
                              : ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemCount: controller.establishedProductList.length >= 8 ? 8 : controller.establishedProductList.length,
                              itemBuilder: (context, index) {
                                ProductModel establishedBrandItem = controller.establishedProductList[index];

                                return EstablishedBrandItemWidget(
                                  establishedBrandItem: establishedBrandItem,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class OffersItemWidget extends StatelessWidget {
  final ProductModel offerItem;
  final HomeController controller;
  final int index;

  const OffersItemWidget({super.key, required this.offerItem, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const ProductDetailsScreen(), arguments: {
          "productModel": offerItem,
        })!
            .then((value) {
          Get.delete<ProductDetailsController>();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: Responsive.width(60, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppThemeData.color[index % AppThemeData.color.length],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: NetworkImageWidget(
                    height: Responsive.height(6, context),
                    width: Responsive.height(6, context),
                    imageUrl: offerItem.photo.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerItem.name.toString(),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppThemeData.black,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: AppThemeData.regular,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        offerItem.qty_pack.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppThemeData.black.withOpacity(0.50),
                          fontSize: 12,
                          fontFamily: AppThemeData.semiBold,
                        ),
                      ),
                    ),
                    offerItem.discount == "" || offerItem.discount == "0"
                        ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        Constant.amountShow(amount: offerItem.price),
                        style: const TextStyle(
                            color: AppThemeData.black,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppThemeData.semiBold,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(
                            Constant.amountShow(amount: Constant.calculateDiscount(amount: offerItem.price!, discount: offerItem.discount!).toString()),
                            style: const TextStyle(color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Constant.amountShow(amount: offerItem.price),
                            style: TextStyle(
                                color: AppThemeData.black.withOpacity(0.50),
                                fontSize: 12,
                                fontFamily: AppThemeData.semiBold,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel categoryItem;

  const CategoryItemWidget({super.key, required this.categoryItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HomeController controller = Get.find<HomeController>();
        Get.to(const ViewAllCategoryProductScreen(), arguments: {"categoryId": categoryItem.id, "categoryName": categoryItem.title})!.then((value) {
          controller.getFavoriteData();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: NetworkImageWidget(
                height: Responsive.height(7, context),
                width: Responsive.height(7, context),
                imageUrl: categoryItem.photo.toString(),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              categoryItem.title.toString(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppThemeData.semiBold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
