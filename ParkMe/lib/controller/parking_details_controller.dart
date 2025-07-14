import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkMe/constant/constant.dart';
import 'package:parkMe/model/parking_model.dart';
import 'package:parkMe/utils/fire_store_utils.dart';

class ParkingDetailsController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  Rx<ParkingModel> parkingModel = ParkingModel().obs;

  RxString duration = "".obs;
  RxString distance = "".obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      parkingModel.value = argumentData['parkingModel'];
      calculate();
    }
    isLoading.value = false;
    update();
  }

  getData() async {
    await FireStoreUtils.getParkingDetails(parkingModel.value.id.toString()).then((value) {
      if (value != null) {
        parkingModel.value = value;
      }
    });
  }

  calculate() async {
    log("------->");

    await Constant.getDurationDistance(LatLng(Constant.currentLocation!.latitude!, Constant.currentLocation!.longitude!),
            LatLng(parkingModel.value.location!.latitude!, parkingModel.value.location!.longitude!))
        .then((value) {
      if (value != null) {
        log(value.toJson().toString());
        duration.value = value.rows!.first.elements!.first.duration!.text.toString();

        if (Constant.distanceType == "Km") {
          distance.value = "${(value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toStringAsFixed(1)} Km";
        } else {
          distance.value = "${(value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toStringAsFixed(1)} Miles";
        }
      }
    });
  }
}
