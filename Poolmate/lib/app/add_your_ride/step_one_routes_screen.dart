import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:poolmate/app/add_your_ride/step_two_stop_over_screen.dart';
import 'package:poolmate/controller/add_your_ride_controller.dart';
import 'package:poolmate/model/map/direction_api_model.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/round_button_fill.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class StepOneRoutesScreen extends StatelessWidget {
  const StepOneRoutesScreen({super.key});

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
              title: Text(
                "Select Your Route".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
              ),
              elevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return google.GoogleMap(
                      onMapCreated: controller.setMapController,
                      polylines: controller.polylines.value,
                      initialCameraPosition: google.CameraPosition(
                        target: google.LatLng(controller.pickUpLocation.value.geometry!.location!.lat!, controller.pickUpLocation.value.geometry!.location!.lng!),
                        zoom: 10,
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.routes.length,
                    itemBuilder: (context, index) {
                      Routes route = controller.routes[index];
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: InkWell(
                            onTap: () => controller.selectRoute(index),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${route.legs!.first.duration!.text.toString()} - ${route.legs!.first.steps!.any((step) => step.htmlInstructions!.contains('Toll road') || step.htmlInstructions!.contains('Toll plaza')) ? "Tolls" : "No Tolls"}",
                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                                      ),
                                      Text(
                                        "${route.legs!.first.distance!.text.toString()} - ${route.summary.toString()}",
                                        style:
                                            TextStyle(color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, fontFamily: AppThemeData.regular, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Radio(
                                  value: index,
                                  groupValue: controller.selectedRouteIndex.value,
                                  activeColor: AppThemeData.primary300,
                                  onChanged: (value) {
                                    controller.selectedRouteIndex.value = value!;
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: RoundedButtonFill(
                    title: "Next".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () {
                      controller.getPopularCity(
                        controller.pickUpLocation.value.geometry!.location!.lat!,
                        controller.pickUpLocation.value.geometry!.location!.lng!,
                        controller.dropLocation.value.geometry!.location!.lat!,
                        controller.dropLocation.value.geometry!.location!.lng!,
                      );
                      controller.distance.value = controller.routes[controller.selectedRouteIndex.value].legs!.first.distance!.value!;
                      controller.estimatedTime.value = controller.routes[controller.selectedRouteIndex.value].legs!.first.duration!.text!;

                      Get.to(const StepTwoStopOverScreen());
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
