import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkMe/constant/constant.dart';
import 'package:parkMe/constant/show_toast_dialog.dart';
import 'package:parkMe/model/location_lat_lng.dart';
import 'package:parkMe/model/parking_model.dart';
import 'package:parkMe/ui/parking_details_screen/parking_details_screen.dart';
import 'package:parkMe/utils/fire_store_utils.dart';
import 'package:parkMe/utils/utils.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;

  GoogleMapController? mapController;
  BitmapDescriptor? parkingMarker;
  BitmapDescriptor? currentLocationMarker;
//OSM
  late MapController mapOsmController;
  Map<String, GeoPoint> osmMarkers = <String, GeoPoint>{};
  Image? currentLocationMarkerOSM; //OSM
  Image? parkingMarkerOSM; //OSM
  @override
  void onInit() {
    getLocation();

    super.onInit();
  }

  getLocation() async {
    await addMarkerSetup();
    await Utils.getCurrentLocation().then((value) async {
      print(value);
      if (value != null) {
        permissionDenied.value = false;
        mapOsmController = MapController(initPosition: GeoPoint(latitude: value.latitude, longitude: value.longitude), useExternalTracking: false); //OSM
        Constant.currentLocation = LocationLatLng(latitude: value.latitude, longitude: value.longitude);
      } else {
        isLoading.value = false;
        permissionDenied.value = true;
        mapOsmController = MapController(
            initPosition: GeoPoint(
                latitude: Constant.currentLocation != null ? Constant.currentLocation!.latitude! : 45.521563,
                longitude: Constant.currentLocation != null ? Constant.currentLocation!.longitude! : -122.677433),
            useExternalTracking: false); //OSM
      }
    });
    // await mapOsmController
    //     .addMarker(
    //   GeoPoint(latitude: Constant.currentLocation!.latitude!, longitude: Constant.currentLocation!.longitude!),
    //   markerIcon: MarkerIcon(
    //     iconWidget: currentLocationMarkerOSM,
    //   ),
    //   angle: pi / 3,
    //   iconAnchor: IconAnchor(anchor: Anchor.top),
    // )
    //     .then((value) {
    //   osmMarkers['currentLocation'] = GeoPoint(latitude: Constant.currentLocation!.latitude!, longitude: Constant.currentLocation!.longitude!);
    // });
    List<Placemark> placeMarks = await placemarkFromCoordinates(Constant.currentLocation!.latitude!, Constant.currentLocation!.longitude!);
    Constant.country = placeMarks.first.country;
    await getTax();
    await getParking();
    isLoading.value = false;
  }

  RxBool permissionDenied = false.obs;

  getTax() async {
    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });
  }

  RxList<ParkingModel> parkingList = <ParkingModel>[].obs;

  getParking() {
    FireStoreUtils().getParkingNearest(latitude: Constant.currentLocation!.latitude, longLatitude: Constant.currentLocation!.longitude).listen((event) {
      parkingList.value = event;
      for (var element in parkingList) {
        addMarker(
            latitude: element.location!.latitude,
            longitude: element.location!.longitude,
            id: element.id.toString(),
            descriptor: parkingMarker!,
            descriptorOSM: parkingMarkerOSM!,
            rotation: 0);
      }
    });
  }

  addMarkerSetup() async {
    currentLocationMarkerOSM = Image.asset("assets/icon/ic_current_user.png", width: 30, height: 30); //OSM
    parkingMarkerOSM = Image.asset("assets/icon/ic_parking_icon.png", width: 30, height: 30); //OSM

    final Uint8List parking = await Constant().getBytesFromAsset("assets/icon/ic_parking_icon.png", 100);
    parkingMarker = BitmapDescriptor.fromBytes(parking);

    final Uint8List currentLocation = await Constant().getBytesFromAsset("assets/icon/ic_current_user.png", 100);
    currentLocationMarker = BitmapDescriptor.fromBytes(currentLocation);
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  addMarker({
    required double? latitude,
    required double? longitude,
    required String id,
    Widget? descriptorOSM,
    BitmapDescriptor? descriptor,
    double? rotation,
  }) async {
    MarkerId markerId = MarkerId(id);
    if (Constant.selectedMapType == 'osm') {
      Future.delayed(const Duration(seconds: 3), () {
        mapOsmController
            .addMarker(GeoPoint(latitude: latitude!, longitude: longitude!),
                markerIcon: MarkerIcon(
                  iconWidget: descriptorOSM!,
                ),
                angle: pi / 3,
                iconAnchor: IconAnchor(
                  anchor: Anchor.top,
                ))
            .then((value) {
          osmMarkers[id] = GeoPoint(latitude: latitude, longitude: longitude);
        });
      });

      update();
    } else {
      Marker marker = Marker(
        markerId: markerId,
        icon: descriptor!,
        position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
        rotation: rotation ?? 0.0,
        onTap: () {
          redirect(id);
        },
      );
      markers[markerId] = marker;
    }
    update();
  }

  redirect(String id) async {
    ShowToastDialog.showLoader("Please wait..");
    await FireStoreUtils.getParkingDetails(id).then((value) {
      ShowToastDialog.closeLoader();
      Get.to(() => const ParkingDetailsScreen(), arguments: {"parkingModel": value!});
    });
  }

  @override
  void dispose() {
    FireStoreUtils().getNearestOrderRequestController!.close();
    super.dispose();
  }
}
