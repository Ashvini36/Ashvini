import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poolmate/controller/add_your_ride_controller.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

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
            body: google.GoogleMap(
              onMapCreated: controller.setWayMapController,
              polylines: Set<google.Polyline>.of(controller.wayPointPolyLines),
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              buildingsEnabled: true,
              initialCameraPosition: google.CameraPosition(
                target: google.LatLng(controller.pickUpLocation.value.geometry!.location!.lat!, controller.pickUpLocation.value.geometry!.location!.lng!),
                zoom: 10,
              ),
            ),
          );
        });
  }
}
