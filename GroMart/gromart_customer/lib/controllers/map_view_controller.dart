import 'dart:typed_data';

import 'package:customer/app/restaurant_details_screen/restaurant_details_screen.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osmMap;


class MapViewController extends GetxController {
  GoogleMapController? mapController;
  BitmapDescriptor? parkingMarker;
  BitmapDescriptor? currentLocationMarker;

  HomeController homeController = Get.find<HomeController>();

  late osmMap.MapController mapOsmController;
  Map<String, osmMap.GeoPoint> osmMarkers = <String, osmMap.GeoPoint>{};
  Image? departureOsmIcon; //OSM

  @override
  void onInit() {
    // TODO: implement onInit
    addMarkerSetup();
    if (Constant.selectedMapType == 'osm') {
      mapOsmController =
          osmMap.MapController(initPosition: osmMap.GeoPoint(latitude: 20.9153, longitude: -100.7439), useExternalTracking: false); //OSM
    }
    super.onInit();
  }

  addMarkerSetup() async {
    if (Constant.selectedMapType == "osm") {
      departureOsmIcon = Image.asset("assets/images/map_selected.png", width: 30, height: 30); //OSM
    } else {
      final Uint8List parking = await Constant().getBytesFromAsset("assets/images/map_selected.png", 20);
      parkingMarker = BitmapDescriptor.bytes(parking);
      for (var element in homeController.allNearestRestaurant) {
        addMarker(
            latitude: element.latitude,
            longitude: element.longitude,
            id: element.id.toString(),
            rotation: 0,
            descriptor: parkingMarker!,
            title: element.title.toString());
      }
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  addMarker(
      {required double? latitude,
        required double? longitude,
        required String id,
        required BitmapDescriptor descriptor,
        required double? rotation,
        required String title}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      infoWindow: InfoWindow(
        title: title,
        onTap: () {
          int index = homeController.allNearestRestaurant.indexWhere((p0) => p0.id == id);
          Get.to(const RestaurantDetailsScreen(), arguments: {"vendorModel": homeController.allNearestRestaurant[index]});
        },
      ),
      position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
      rotation: rotation ?? 0.0,
    );
    markers[markerId] = marker;
  }
}
