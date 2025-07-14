import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:poolmate/app/add_vehicle/add_vehicle_screen.dart';
import 'package:poolmate/app/add_your_ride/step_one_routes_screen.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/constant/show_toast_dialog.dart';
import 'package:poolmate/controller/add_your_ride_controller.dart';
import 'package:poolmate/model/map/city_list_model.dart';
import 'package:poolmate/model/map/geometry.dart';
import 'package:poolmate/model/map/place_picker_model.dart';
import 'package:poolmate/model/vehicle_information_model.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/responsive.dart';
import 'package:poolmate/themes/round_button_fill.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:poolmate/utils/network_image_widget.dart';
import 'package:poolmate/widgets/google_map_search_place.dart';
import 'package:provider/provider.dart';

class AddYourRideScreen extends StatelessWidget {
  const AddYourRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddYourRideController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      NetworkImageWidget(
                        imageUrl: Constant.appBannerImage,
                        fit: BoxFit.cover,
                        width: Responsive.width(100, context),
                        height: Responsive.height(50, context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10, left: 12),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.close,
                                color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .32,
                          left: 16,
                          right: 16,
                        ),
                        child: Container(
                          width: Responsive.width(100, context),
                          decoration: BoxDecoration(
                            color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                            ),
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(const GoogleMapSearchPlacesApi())!.then((value) async {
                                    if (value != null) {
                                      PlaceDetailsModel placeDetailsModel = value;
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlacePicker(
                                            apiKey: Constant.mapAPIKey,
                                            onPlacePicked: (result) {
                                              Get.back();
                                              controller.pickUpLocationController.value.text = result.formattedAddress.toString();
                                              controller.pickUpLocation.value = CityModel(
                                                name: result.formattedAddress.toString(),
                                                placeId: result.placeId.toString(),
                                                geometry: Geometry(location: Location.fromJson(result.geometry!.location.toJson())),
                                              );
                                              print("=====>");
                                              print(controller.pickUpLocation.value);
                                              // controller.pickUpLocation.value = Location(lat: result.geometry!.location.lat, lng: result.geometry!.location.lng);
                                            },
                                            initialPosition: LatLng(placeDetailsModel.result!.geometry!.location!.lat!, placeDetailsModel.result!.geometry!.location!.lng!),
                                            useCurrentLocation: false,
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
                                  });
                                },
                                child: TextFormField(
                                  controller: controller.pickUpLocationController.value,
                                  style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter pickup location'.tr,
                                    enabled: false,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset("assets/icons/ic_source.svg"),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(const GoogleMapSearchPlacesApi())!.then((value) async {
                                    print("======>$value");

                                    if (value != null) {
                                      PlaceDetailsModel placeDetailsModel = value;
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlacePicker(
                                            apiKey: Constant.mapAPIKey,
                                            onPlacePicked: (result) {
                                              Get.back();
                                              controller.dropLocationController.value.text = result.formattedAddress.toString();
                                              controller.dropLocation.value = CityModel(
                                                name: result.formattedAddress.toString(),
                                                placeId: result.placeId.toString(),
                                                geometry: Geometry(location: Location.fromJson(result.geometry!.location.toJson())),
                                              );
                                            },
                                            initialPosition: LatLng(placeDetailsModel.result!.geometry!.location!.lat!, placeDetailsModel.result!.geometry!.location!.lng!),
                                            useCurrentLocation: false,
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
                                  });
                                },
                                child: TextFormField(
                                  controller: controller.dropLocationController.value,
                                  style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter drop-off location'.tr,
                                    enabled: false,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset("assets/icons/ic_destination.svg"),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              InkWell(
                                onTap: () async {
                                  BottomPicker.dateTime(
                                    onSubmit: (index) {
                                      controller.selectedDate.value = index;
                                      DateFormat dateFormat = DateFormat("EEE dd MMMM , hh:mm aa");
                                      String string = dateFormat.format(index);

                                      controller.dateController.value.text = string;
                                    },
                                    minDateTime: DateTime.now(),
                                    buttonAlignment: MainAxisAlignment.center,
                                    displaySubmitButton: true,
                                    pickerTitle: const Text(''),
                                    buttonSingleColor: AppThemeData.primary300,
                                  ).show(context);
                                },
                                child: TextFormField(
                                  controller: controller.dateController.value,
                                  style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabled: false,
                                    hintText: 'Date and time (departure)'.tr,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset("assets/icons/ic_calender.svg"),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              InkWell(
                                onTap: () {
                                  addVehicleBuildBottomSheet(context);
                                },
                                child: TextFormField(
                                  controller: controller.selectedVehicleController.value,
                                  style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Select Vehicle'.tr,
                                    enabled: false,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_car.svg",
                                        color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                      ),
                                    ),
                                    suffixIcon: const Icon(Icons.arrow_drop_down),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                      fontFamily: AppThemeData.medium,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: RoundedButtonFill(
                title: "Next".tr,
                color: AppThemeData.primary300,
                textColor: AppThemeData.grey50,
                onPress: () {
                  if (controller.pickUpLocationController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please select pickup location".tr);
                  } else if (controller.pickUpLocationController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please select drop location".tr);
                  } else if (controller.dateController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please select departure date".tr);
                  } else if (controller.selectedVehicleController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please select vehicle".tr);
                  } else {
                    Get.to(const StepOneRoutesScreen());
                  }
                },
              ),
            ),
          );
        });
  }

  addVehicleBuildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.50,
        minChildSize: 0.50,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: AddYourRideController(),
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Select a vehicle".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontFamily: AppThemeData.bold),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        controller: scrollController,
                        itemCount: controller.userVehicleList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          VehicleInformationModel vehicleInformationModel = controller.userVehicleList[index];
                          return Obx(
                            () => InkWell(
                              onTap: () {
                                controller.selectedUserVehicle.value = vehicleInformationModel;
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${vehicleInformationModel.vehicleBrand!.name} ${vehicleInformationModel.vehicleModel!.name} (${vehicleInformationModel.licensePlatNumber})"
                                              .tr,
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium),
                                        ),
                                      ),
                                      Radio(
                                        value: vehicleInformationModel,
                                        groupValue: controller.selectedUserVehicle.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.selectedUserVehicle.value = value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const AddVehicleScreen())!.then((value) {
                            controller.getVehicleInformation();
                          });
                        },
                        child: Row(
                          children: [
                             Icon(
                              Icons.add,
                              color: AppThemeData.primary300,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add new vehicle".tr,
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                fontSize: 16,
                                color: AppThemeData.primary300,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedButtonFill(
                        title: "Select".tr,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () {
                          controller.selectedVehicleController.value.text =
                              "${controller.selectedUserVehicle.value.vehicleBrand!.name} ${controller.selectedUserVehicle.value.vehicleModel!.name} (${controller.selectedUserVehicle.value.licensePlatNumber})";
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
