import 'package:ebasket_driver/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/controller/reach_drop_location_controller.dart';
import 'package:ebasket_driver/app/ui/order_screen/deliver_order_screen.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:ebasket_driver/widgets/round_button_fill.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;

class ReachDropLocationScreen extends StatelessWidget {
  const ReachDropLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ReachDropLocationController(),
        builder: (controller) {
          return Scaffold(
            appBar: CommonUI.customAppBar(
              context,
              title: Text("Reach Drop Location".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
              isBack: true,
            ),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Constant.selectedMapType == "osm"
                    ? OSMFlutter(
                        controller: controller.mapOsmController,
                        onLocationChanged: (geopoint) {
                          controller.getOSMPolyline();
                        },
                        osmOption: OSMOption(
                          userLocationMarker: UserLocationMaker(
                            directionArrowMarker: MarkerIcon(
                              iconWidget: controller.driverOsmIcon,
                            ),
                            personMarker: MarkerIcon(
                              iconWidget: controller.driverOsmIcon,
                            ),
                          ),
                          userTrackingOption: const UserTrackingOption(
                            enableTracking: true,
                            unFollowUser: false,
                          ),
                          zoomOption: const ZoomOption(
                            initZoom: 16,
                            minZoomLevel: 2,
                            maxZoomLevel: 19,
                            stepZoom: 1.0,
                          ),
                          roadConfiguration: const RoadOption(
                            roadColor: Colors.yellowAccent,
                          ),
                        ),
                        onMapIsReady: (active) async {
                          if (active) {
                            ShowToastDialog.closeLoader();
                          }
                        })
                    : GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: controller.kLake,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        polylines: Set<Polyline>.of(controller.polyLines.values),
                        markers: Set<Marker>.of(controller.markers.values),
                        onMapCreated: (GoogleMapController controller1) {
                          controller.mapController = controller1;
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        child: RoundedButtonFill(
                          title: "Navigate to map".tr,
                          color: AppThemeData.groceryAppDarkBlue,
                          textColor: AppThemeData.white,
                          fontFamily: AppThemeData.bold,
                          onPress: () async {
                            bool? isAvailable = await mapLauncher.MapLauncher.isMapAvailable(mapLauncher.MapType.google);
                            if (isAvailable == true) {
                              await mapLauncher.MapLauncher.showDirections(
                                mapType: mapLauncher.MapType.google,
                                directionsMode: mapLauncher.DirectionsMode.driving,
                                //   destinationTitle: controller.orderModel.value.user!.businessAddress.toString(),
                                //   destination: mapLauncher.Coords(controller.orderModel.value.user!.location!.latitude!, controller.orderModel.value.user!.location!.longitude!),
                                destinationTitle: controller.orderModel.value.address!.getFullAddress().toString(),
                                destination: mapLauncher.Coords(controller.orderModel.value.address!.location!.latitude, controller.orderModel.value.address!.location!.longitude),
                              );
                            } else {
                              ShowToastDialog.showToast("Google map is not installed");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: RoundedButtonFill(
                title: "Reached At Location".tr,
                color: AppThemeData.groceryAppDarkBlue,
                textColor: AppThemeData.white,
                fontFamily: AppThemeData.bold,
                onPress: () {
                  Get.to(const DeliverOrderDetailsScreen(), arguments: {
                    "orderId": controller.orderModel.value.id,
                  });
                },
              ),
            ),
          );
        });
  }
}
