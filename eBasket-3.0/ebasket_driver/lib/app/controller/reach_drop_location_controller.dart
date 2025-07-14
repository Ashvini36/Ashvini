import 'dart:async';
import 'dart:developer';
import 'dart:math';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/constant/collection_name.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class ReachDropLocationController extends GetxController {
  CameraPosition kLake =
      const CameraPosition(bearing: 192.8334901395799, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 59.440717697143555, zoom: 14.151926040649414);
  GoogleMapController? mapController;

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  Rx<DriverModel> driverUserModel = DriverModel().obs;
  Rx<OrderModel> orderModel = OrderModel().obs;
  RxString orderId = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    if (Constant.selectedMapType == 'osm') {
      await ShowToastDialog.showLoader("Please wait");
      mapOsmController = MapController(initPosition: GeoPoint(latitude: 20.9153, longitude: -100.7439), useExternalTracking: false); //OSM
    }
    addMarkerSetup();
    getArgument();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;

    if (argumentData != null) {
      orderId.value = argumentData['orderId'];
      orderModel.value = (await FireStoreUtils.getOrder(orderId.value))!;

      kLake = CameraPosition(
        zoom: 15,
        target: LatLng(Constant.currentLocation != null ? Constant.currentLocation!.latitude! : 37.43296265331129,
            Constant.currentLocation != null ? Constant.currentLocation!.longitude! : -122.677433),
      );

      FireStoreUtils.fireStore.collection(CollectionName.orders).doc(orderModel.value.id).snapshots().listen((event) {
        if (event.data() != null) {
          OrderModel orderModelStream = OrderModel.fromJson(event.data()!);

          orderModel.value = orderModelStream;
          if (Constant.selectedMapType != 'osm') {
            FireStoreUtils.fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event1) {
              if (event1.data() != null) {
                driverUserModel.value = DriverModel.fromJson(event1.data()!);

                getPolyline(
                  sourceLatitude: driverUserModel.value.location!.latitude,
                  sourceLongitude: driverUserModel.value.location!.longitude,
                  destinationLatitude: orderModel.value.address!.location!.latitude,
                  destinationLongitude: orderModel.value.address!.location!.longitude,
                  orderModel: orderModel.value,
                );
              }
            });
          }
        }
      });
    }
    update();
  }

  void getPolyline(
      {required double? sourceLatitude,
      required double? sourceLongitude,
      required double? destinationLatitude,
      required double? destinationLongitude,
      required OrderModel orderModel}) async {
    if (sourceLatitude != null && sourceLongitude != null && destinationLatitude != null && destinationLongitude != null) {
      List<LatLng> polylineCoordinates = [];

      /* PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constant.mapKey,
        PointLatLng(sourceLatitude, sourceLongitude),
        PointLatLng(destinationLatitude, destinationLongitude),
        travelMode: TravelMode.driving,
      );*/

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: Constant.mapKey,
          request: PolylineRequest(
            origin: PointLatLng(sourceLatitude, sourceLongitude),
            destination: PointLatLng(destinationLatitude, destinationLongitude),
            mode: TravelMode.driving,
          ));
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        debugPrint(result.errorMessage.toString());
      }

      addMarker(latitude: sourceLatitude, longitude: sourceLongitude, id: "Departure", descriptor: departureIcon!, rotation: 0.0);
      addMarker(latitude: destinationLatitude, longitude: destinationLongitude, id: "Destination", descriptor: destinationIcon!, rotation: 0.0);

      _addPolyLine(polylineCoordinates);
    }
    update();
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        consumeTapEvents: true,
        startCap: Cap.roundCap,
        width: 6,
        color: AppThemeData.groceryAppDarkBlue,
        jointType: JointType.mitered);
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
    update();
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  addMarker({required double? latitude, required double? longitude, required String id, required BitmapDescriptor descriptor, required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: LatLng(latitude ?? 0.0, longitude ?? 0.0), rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  addMarkerSetup() async {
    if (Constant.selectedMapType == 'google') {
      final Uint8List departure = await Constant().getBytesFromAsset('assets/images/location_arrow.png', 150);
      final Uint8List destination = await Constant().getBytesFromAsset('assets/images/location_pin.png', 150);

      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
    } else {
      departureOsmIcon = Image.asset("assets/images/pickup.png", width: 30, height: 30); //OSM
      destinationOsmIcon = Image.asset("assets/images/dropoff.png", width: 30, height: 30); //OSM
      driverOsmIcon = Image.asset("assets/images/food_delivery.png", width: 80, height: 80); //OSM
    }
  }

  //OSM
  late MapController mapOsmController;
  Rx<RoadInfo> roadInfo = RoadInfo().obs;
  Map<String, GeoPoint> osmMarkers = <String, GeoPoint>{};
  Image? departureOsmIcon; //OSM
  Image? destinationOsmIcon; //OSM
  Image? driverOsmIcon;

  void getOSMPolyline() async {
    try {
      FireStoreUtils.fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event1) async {
        if (event1.data() != null) {
          driverUserModel.value = DriverModel.fromJson(event1.data()!);
          GeoPoint sourceLocation = GeoPoint(
            latitude: driverUserModel.value.location!.latitude ?? 0.0,
            longitude: driverUserModel.value.location!.longitude ?? 0.0,
          );

          GeoPoint destinationLocation = GeoPoint(latitude: orderModel.value.address!.location!.latitude ?? 0.0, longitude: orderModel.value.address!.location!.longitude ?? 0.0);
          await mapOsmController.removeLastRoad();
          setOsmMarker(departure: sourceLocation, destination: destinationLocation);
          roadInfo.value = await mapOsmController.drawRoad(
            sourceLocation,
            destinationLocation,
            roadType: RoadType.car,
            roadOption: const RoadOption(
              roadWidth: 15,
              roadColor: AppThemeData.groceryAppDarkBlue,
              zoomInto: false,
            ),
          );
          mapOsmController.moveTo(
            GeoPoint(latitude: sourceLocation.latitude, longitude: sourceLocation.longitude),
            animate: true,
          );
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateOSMCameraLocation({required GeoPoint source, required GeoPoint destination}) async {
    BoundingBox bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.latitude > destination.latitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    } else {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    }

    await mapOsmController.zoomToBoundingBox(bounds, paddinInPixel: 100);
  }

  setOsmMarker({required GeoPoint departure, required GeoPoint destination}) async {
    if (osmMarkers.containsKey('Source')) {
      await mapOsmController.removeMarker(osmMarkers['Source']!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mapOsmController
          .addMarker(departure,
              markerIcon: MarkerIcon(iconWidget: departureOsmIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ))
          .then((v) {
        osmMarkers['Source'] = departure;
      });

      if (osmMarkers.containsKey('Destination')) {
        await mapOsmController.removeMarker(osmMarkers['Destination']!);
      }

      await mapOsmController
          .addMarker(destination,
              markerIcon: MarkerIcon(iconWidget: destinationOsmIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ))
          .then((v) {
        osmMarkers['Destination'] = destination;
      });
    });
  }
}
