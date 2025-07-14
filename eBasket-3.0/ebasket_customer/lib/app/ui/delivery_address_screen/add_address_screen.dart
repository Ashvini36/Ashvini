import 'dart:developer';

import 'package:ebasket_customer/app/controller/add_address_controller.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/place_picker_osm.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/common_ui.dart';

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX(
        init: AddAddressController(),
        builder: (controller) {
          return Scaffold(
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Add Address".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Card(
                      elevation: 0.5,
                      color: AppThemeData.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                checkPermission(() async {
                                  await ShowToastDialog.showLoader("Please Wait".tr);
                                  try {
                                    await Geolocator.requestPermission();

                                    await Geolocator.getCurrentPosition();
                                    if (Constant.selectedMapType == 'osm') {
                                      await ShowToastDialog.closeLoader();
                                      Get.to(() => const LocationPicker())?.then((value) {
                                        if (value != null) {
                                          controller.locality.value.text = value.displayName!;
                                          controller.userLocation.value = UserLocation(latitude: value.lat, longitude: value.lon);

                                          controller.pinCodeController.value.text = value.address ['postcode'].toString();

                                        }
                                      });
                                    } else {
                                      await ShowToastDialog.closeLoader();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlacePicker(
                                            apiKey: Constant.mapKey,
                                            onPlacePicked: (result) {
                                              controller.locality.value.text = result.formattedAddress!.toString();
                                              controller.userLocation.value = UserLocation(latitude: result.geometry!.location.lat, longitude: result.geometry!.location.lng);
                                              log(result.toString());

                                              for (int i = 0; i < result.addressComponents!.length; i++) {
                                                if (result.addressComponents![i].types.contains('postal_code')) {
                                                  controller.pinCodeController.value.text = result.addressComponents![i].longName;
                                                }
                                              }
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
                                      String currentLocation =
                                          "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";

                                      controller.locality.value.text = currentLocation;
                                      controller.userLocation.value = UserLocation(latitude: 19.228825, longitude: 72.854118);
                                      controller.pinCodeController.value.text = placeMark.postalCode.toString();
                                    });
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_searching_sharp, color: AppThemeData.groceryAppDarkBlue),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Choose location *".tr,
                                      style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontFamily: AppThemeData.medium, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0.5,
                      color: AppThemeData.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Save address as *".tr,
                                style: TextStyle(fontFamily: AppThemeData.medium, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 34,
                              child: ListView.builder(
                                itemCount: controller.saveAsList.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.selectedSaveAs.value = controller.saveAsList[index].toString();

                                      controller.update();
                                    },
                                    child: Obx(
                                      () => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: controller.selectedSaveAs.value == controller.saveAsList[index].toString()
                                                  ? AppThemeData.groceryAppDarkBlue
                                                  : Colors.grey.withOpacity(0.20),
                                              borderRadius: const BorderRadius.all(Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 30),
                                            child: Center(
                                              child: Text(
                                                controller.saveAsList[index].toString().tr,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: controller.selectedSaveAs.value == controller.saveAsList[index].toString() ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: controller.formKey.value,
                              child: Column(
                                children: [
                                  TextFieldWidget(
                                    controller: controller.address.value,
                                    hintText: 'Flat / House / Flore / Building *'.tr,
                                    title: 'Flat / House / Flore / Building *'.tr,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Flat / House / Flore / Building".tr;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
                                  ),
                                  TextFieldWidget(
                                    controller: controller.locality.value,
                                    hintText: 'Area / Sector / Locality *'.tr,
                                    title: 'Area / Sector / Locality *'.tr,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Area / Sector / locality".tr;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
                                  ),
                                  TextFieldWidget(
                                    controller: controller.landmark.value,
                                    hintText: 'Nearby Landmark (Optional)'.tr,
                                    title: 'Nearby Landmark (Optional)'.tr,
                                    textInputType: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: RoundedButtonGradiant(
                                      title: 'Save'.tr,
                                      icon: true,
                                      onPress: () async {
                                        if (controller.formKey.value.currentState!.validate()) {
                                          // if (widget.index != null) {
                                          if (controller.argumentData != null) {
                                            controller.addressModel.value.location = controller.userLocation.value;
                                            controller.addressModel.value.addressAs = controller.selectedSaveAs.value;
                                            controller.addressModel.value.locality = controller.locality.value.text;
                                            controller.addressModel.value.address = controller.address.value.text;
                                            controller.addressModel.value.landmark = controller.landmark.value.text;
                                            controller.addressModel.value.pinCode = controller.pinCodeController.value.text;
                                            controller.shippingAddress.removeAt(controller.index.value);
                                            controller.shippingAddress.insert(controller.index.value, controller.addressModel.value);
                                          } else {
                                            controller.addressModel.value.id = Uuid().v4();
                                            controller.addressModel.value.location = controller.userLocation.value;
                                            controller.addressModel.value.addressAs = controller.selectedSaveAs.value;
                                            controller.addressModel.value.locality = controller.locality.value.text;
                                            controller.addressModel.value.address = controller.address.value.text;
                                            controller.addressModel.value.landmark = controller.landmark.value.text;
                                            controller.addressModel.value.pinCode = controller.pinCodeController.value.text;
                                            controller.addressModel.value.isDefault = controller.shippingAddress.isEmpty ? true : false;
                                            controller.shippingAddress.add(controller.addressModel.value);
                                          }

                                          controller.userModel.value.shippingAddress = controller.shippingAddress;
                                          await FireStoreUtils.updateCurrentUser(controller.userModel.value);
                                          controller.update();
                                          Get.back(result: true);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
