import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:poolmate/app/add_your_ride/map_view_screen.dart';
import 'package:poolmate/app/add_your_ride/step_four_passengers_take_screen.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/controller/add_your_ride_controller.dart';
import 'package:poolmate/model/map/city_list_model.dart';
import 'package:poolmate/model/map/geometry.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/round_button_fill.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class StepThreeStopOverDetailsScreen extends StatelessWidget {
  const StepThreeStopOverDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddYourRideController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                centerTitle: false,
                titleSpacing: 0,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                      child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                    height: 4.0,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Timeline.tileBuilder(
                      shrinkWrap: true,
                      theme: TimelineThemeData(
                        nodePosition: 0,
                        // indicatorPosition: 0,
                      ),
                      builder: TimelineTileBuilder.connected(
                        contentsAlign: ContentsAlign.basic,
                        indicatorBuilder: (context, index) {
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: ShapeDecoration(
                              color: index == 0
                                  ? AppThemeData.warning100
                                  : controller.allSelectedCityList.length - 1 == index
                                      ? AppThemeData.success100
                                      : AppThemeData.grey100,
                              shape: const OvalBorder(),
                              shadows: [
                                BoxShadow(
                                  color: index == 0
                                      ? AppThemeData.warning300
                                      : controller.allSelectedCityList.length - 1 == index
                                          ? AppThemeData.success400
                                          : AppThemeData.grey300,
                                  blurRadius: 0,
                                  offset: const Offset(0, 0),
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                          );
                        },
                        connectorBuilder: (context, index, connectorType) {
                          return const DashedLineConnector(
                            color: AppThemeData.grey300,
                            gap: 2,
                          );
                        },
                        contentsBuilder: (context, index) {
                          CityModel cityModel = controller.allSelectedCityList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Constant.getCityName(themeChange, cityModel.geometry!.location!,
                                      style: index == 0
                                          ? TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 12)
                                          : index == controller.allSelectedCityList.length - 1
                                              ? TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 12)
                                              : TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14)),
                                ),
                                index == 0 || index == controller.allSelectedCityList.length - 1
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () async {
                                          int newIndex = controller.selectedCityList.indexWhere((p0) => p0.placeId == cityModel.placeId);
                                          print("=========>");
                                          print(newIndex);
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlacePicker(
                                                apiKey: Constant.mapAPIKey,
                                                onPlacePicked: (result) {
                                                  Get.back();

                                                  CityModel newCityModel = CityModel(
                                                    name: result.formattedAddress.toString(),
                                                    placeId: result.placeId.toString(),
                                                    geometry: Geometry(location: Location.fromJson(result.geometry!.location.toJson())),
                                                  );
                                                  controller.selectedCityList.removeAt(newIndex);
                                                  controller.selectedCityList.insert(newIndex, newCityModel);
                                                  controller.wayPointFilter();
                                                },
                                                initialPosition: LatLng(cityModel.geometry!.location!.lat!, cityModel.geometry!.location!.lng!),
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
                                        },
                                        child: const Icon(Icons.chevron_right_outlined))
                              ],
                            ),
                          );
                        },
                        itemCount: controller.allSelectedCityList.length,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const MapViewScreen());
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "View Map".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppThemeData.primary300,
                                    color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                                    fontFamily: AppThemeData.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                           Icon(
                            Icons.chevron_right_outlined,
                            color: AppThemeData.primary300,
                          ),
                        ],
                      ),
                    )
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
                    controller.calculatePrice();
                    print("=====>");
                    Get.to(const StepFourPassengerTakeScreen());
                  },
                ),
              ));
        });
  }
}
