import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map;
import 'package:poolmate/app/dashboard_screen.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/constant/show_toast_dialog.dart';
import 'package:poolmate/model/booking_model.dart';
import 'package:poolmate/model/map/city_list_model.dart';
import 'package:poolmate/model/map/direction_api_model.dart';
import 'package:poolmate/model/stop_over_model.dart';
import 'package:poolmate/model/user_model.dart';
import 'package:poolmate/model/vehicle_information_model.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/utils/fire_store_utils.dart';
import 'package:http/http.dart' as http;

class AddYourRideController extends GetxController {
  Rx<TextEditingController> pickUpLocationController = TextEditingController().obs;
  Rx<TextEditingController> dropLocationController = TextEditingController().obs;
  Rx<TextEditingController> selectedVehicleController = TextEditingController().obs;
  Rx<TextEditingController> dateController = TextEditingController().obs;

  RxInt luggageAllowed = 1.obs;
  RxInt numberOfSheet = 1.obs;
  RxBool womenOnly = false.obs;
  RxBool twoPassengerMaxInBack = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Rx<CityModel> pickUpLocation = CityModel().obs;
  Rx<CityModel> dropLocation = CityModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getUserData();
    getVehicleInformation();
    super.onInit();
  }

  RxList<VehicleInformationModel> userVehicleList = <VehicleInformationModel>[].obs;
  Rx<VehicleInformationModel> selectedUserVehicle = VehicleInformationModel().obs;

  getVehicleInformation() async {
    await FireStoreUtils.getUserVehicleInformation().then((value) {
      if (value != null) {
        userVehicleList.value = value;
      }
    });
  }

  getUserData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
  }

  var polylines = <google_map.Polyline>{}.obs;

  google_map.GoogleMapController? mapController;
  final RxList<Routes> routes = <Routes>[].obs;
  final RxInt selectedRouteIndex = (0).obs;

  void setMapController(google_map.GoogleMapController controller) {
    mapController = controller;
    fetchRoutes();
  }

  void fetchRoutes() async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickUpLocation.value.geometry!.location!.lat},${pickUpLocation.value.geometry!.location!.lng}&destination=${dropLocation.value.geometry!.location!.lat},${dropLocation.value.geometry!.location!.lng}&alternatives=true&key=${Constant.mapAPIKey}'));
    if (response.statusCode == 200) {
      log("======>");
      log(response.body);
      final data = json.decode(response.body);
      DirectionAPIModel directionAPIModel = DirectionAPIModel.fromJson(data);

      routes.clear();
      polylines.clear();
      routes.value = directionAPIModel.routes!;
      selectRoute(0);
      // for (int i = 0; i < directionAPIModel.routes!.length; i++) {
      //   Routes route = directionAPIModel.routes![i];
      //   final overviewPolyline = route.overviewPolyline!.points;
      //   final polylineCoordinates = Constant.decodePolyline(overviewPolyline!);
      //
      //   final polyline = google_map.Polyline(
      //     polylineId: google_map.PolylineId('route_$i'),
      //     color:  AppThemeData.grey400, // Highlight first route
      //     points: polylineCoordinates,
      //     width: 5,
      //   );
      //
      //   polylines.add(polyline);
      // }
    }
  }

  void selectRoute(int index) {
    var newPolylines = <google_map.Polyline>{};
    // Add all non-selected routes first
    // Add all non-selected routes first
    // for (int i = 0; i < routes.length; i++) {
    //   if (i != index) {
    //     Routes route = routes[i];
    //     final overviewPolyline = route.overviewPolyline!.points;
    //     final polylineCoordinates = Constant.decodePolyline(overviewPolyline!);
    //     newPolylines.add(google_map.Polyline(
    //       polylineId: google_map.PolylineId('route_$i'),
    //       points: polylineCoordinates,
    //       color: Colors.grey,
    //       width: 5,
    //     ));
    //   }
    // }

    Routes route = routes[index];
    final overviewPolyline = route.overviewPolyline!.points;
    final polylineCoordinates = Constant.decodePolyline(overviewPolyline!);

    // Add the selected route last to ensure it's on top
    newPolylines.add(google_map.Polyline(
      polylineId: google_map.PolylineId('route_$index'),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    ));

    polylines.value = newPolylines;
    selectedRouteIndex.value = index;
  }

  RxList<CityModel> cityList = <CityModel>[].obs;
  RxList<CityModel> selectedCityList = <CityModel>[].obs;
  RxList<CityModel> filterSelectedCityList = <CityModel>[].obs;
  RxList<CityModel> allSelectedCityList = <CityModel>[].obs;

  Future<String?> getPopularCity(double lat1, double lng1, double lat2, double lng2) async {
    selectedCityList.clear();
    final url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${(lat1 + lat2) / 2},${(lng1 + lng2) / 2}&radius=50000&type=locality&key=${Constant.mapAPIKey}');
    final response = await http.get(url);
    log("==========>");
    log(response.body);
    cityList.clear();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data['results'].forEach((v) {
        cityList.add(CityModel.fromJson(v));
      });
    } else {
      throw Exception('Failed to load cities');
    }
    return null;
  }

  final RxList<google_map.Polyline> wayPointPolyLines = <google_map.Polyline>[].obs;
  google_map.GoogleMapController? wayPointMapController;

  void setWayMapController(google_map.GoogleMapController controller) {
    wayPointMapController = controller;
  }

  RxInt distance = 0.obs;
  RxString estimatedTime = "".obs;

  RxList<StopOverModel> stopOverList = <StopOverModel>[].obs;

  wayPointFilter() async {
    allSelectedCityList.clear();
    filterSelectedCityList.clear();
    wayPointPolyLines.clear();
    stopOverList.clear();
    final waypointsString = selectedCityList.map((point) => '${point.geometry!.location!.lat},${point.geometry!.location!.lng}').join('|');
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${pickUpLocation.value.geometry!.location!.lat},${pickUpLocation.value.geometry!.location!.lng}&destination=${dropLocation.value.geometry!.location!.lat},${dropLocation.value.geometry!.location!.lng}&alternatives=true&waypoints=optimize:true|$waypointsString&key=${Constant.mapAPIKey}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      DirectionAPIModel directionAPIModel = DirectionAPIModel.fromJson(data);

      Routes route = directionAPIModel.routes!.length == 1 ? directionAPIModel.routes!.first : directionAPIModel.routes![selectedRouteIndex.value];
      for (var element in route.legs!) {
        String price = (double.parse(Constant.distanceCalculate(element.distance!.value.toString())) * double.parse(selectedUserVehicle.value.vehicleType!.perKmCharges.toString()))
            .toString();
        String recommendedPrice =
            (double.parse(Constant.distanceCalculate(element.distance!.value.toString())) * double.parse(selectedUserVehicle.value.vehicleType!.perKmCharges.toString()))
                .toString();
        stopOverList.add(StopOverModel(
            duration: element.duration,
            distance: element.distance,
            endAddress: element.endAddress,
            endLocation: element.endLocation,
            price: price,
            recommendedPrice: recommendedPrice,
            startAddress: element.startAddress,
            startLocation: element.startLocation));
      }
      final overviewPolyline = route.overviewPolyline!.points;
      final polylineCoordinates = Constant.decodePolyline(overviewPolyline!);
      final polyline = google_map.Polyline(
        polylineId: const google_map.PolylineId("0"),
        color: AppThemeData.primary300, // Highlight first route
        points: polylineCoordinates,
        width: 5,
      );

      wayPointPolyLines.add(polyline);
      for (int i = 0; i < selectedCityList.length; i++) {
        filterSelectedCityList.add(selectedCityList[directionAPIModel.routes!.first.waypointOrder![i]]); // 2 replace with waypoint order
      }
    }

    allSelectedCityList.add(pickUpLocation.value);
    allSelectedCityList.addAll(filterSelectedCityList);
    allSelectedCityList.add(dropLocation.value);
  }

  RxDouble price = 0.0.obs;
  RxDouble recommendedPrice = 0.0.obs;

  calculatePrice() {
    recommendedPrice.value = (double.parse(Constant.distanceCalculate(distance.value.toString())) * double.parse(selectedUserVehicle.value.vehicleType!.perKmCharges.toString()));
    price.value = (double.parse(Constant.distanceCalculate(distance.value.toString())) * double.parse(selectedUserVehicle.value.vehicleType!.perKmCharges.toString()));
  }

  changePriceVariant(bool isIncrement) {
    if (isIncrement) {
      price.value += 10.0;
    } else {
      price.value -= 10.0;
    }
  }

  changeStopOverPrice(int index, bool isIncrement) {
    StopOverModel stopOverModel = stopOverList[index];
    if (isIncrement) {
      stopOverModel.price = (double.parse((stopOverModel.price ?? '0.0').toString()) + 10.0).toString();
    } else {
      stopOverModel.price = (double.parse((stopOverModel.price ?? '0.0').toString()) - 10.0).toString();
    }
    stopOverList.removeAt(index);
    stopOverList.insert(index, stopOverModel);
    update();
  }

  publishRide() async {
    ShowToastDialog.showLoader("Please wait");
    BookingModel bookingModel = BookingModel();
    bookingModel.id = Constant.getUuid();
    bookingModel.createdBy = FireStoreUtils.getCurrentUid();
    bookingModel.totalSeat = numberOfSheet.value.toString();
    bookingModel.pricePerSeat = price.value.toString();
    bookingModel.pickUpAddress = pickUpLocationController.value.text;
    bookingModel.dropAddress = dropLocationController.value.text;
    bookingModel.pickupLocation = pickUpLocation.value;
    bookingModel.dropLocation = dropLocation.value;
    bookingModel.stopOver = filterSelectedCityList;
    bookingModel.vehicleInformation = selectedUserVehicle.value;
    bookingModel.departureDateTime = Timestamp.fromDate(selectedDate.value);
    bookingModel.distance = distance.value.toString();
    bookingModel.estimatedTime = estimatedTime.value;
    bookingModel.createdAt = Timestamp.now();
    bookingModel.twoPassengerMaxInBack = twoPassengerMaxInBack.value;
    bookingModel.womenOnly = womenOnly.value;
    bookingModel.luggageAllowed = luggageAllowed.value.toString();
    bookingModel.stopOverList = stopOverList;
    bookingModel.status = Constant.placed;
    bookingModel.travelPreference = userModel.value.travelPreference;
    bookingModel.driverVerify = userModel.value.isVerify;
    bookingModel.publish = true;

    await FireStoreUtils.setBooking(bookingModel).then((value) {
      ShowToastDialog.closeLoader();
      Get.offAll(const DashBoardScreen());
    });
  }
}
