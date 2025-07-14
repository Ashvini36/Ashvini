// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:parkMe/constant/constant.dart';
// import 'package:parkMe/constant/show_toast_dialog.dart';
// import 'package:parkMe/model/parking_model.dart';
// import 'package:parkMe/model/vehicle_model.dart';
// import 'package:parkMe/utils/fire_store_utils.dart';
//
// class AddParkingSlotController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
//   RxList<Slot> slotData = <Slot>[].obs;
//
//   @override
//   void onInit() {
//     getArgument();
//     getVehicle();
//     super.onInit();
//   }
//
//   Rx<ParkingModel> parkingModel = ParkingModel().obs;
//
//   getArgument() async {
//     dynamic argumentData = Get.arguments;
//     if (argumentData != null) {
//       parkingModel.value = argumentData['parkingModel'];
//       if (parkingModel.value.id != null) {
//         await FireStoreUtils.getUserParkingDetails(parkingModel.value.id.toString()).then((value) {
//           if (value != null) {
//             parkingModel.value = value;
//             if (parkingModel.value.slot != null) {
//               slotData.value = parkingModel.value.slot!;
//             } else {
//               slotData.value = [
//                 Slot(day: 'Monday', timeslot: []),
//                 Slot(day: 'Tuesday', timeslot: []),
//                 Slot(day: 'Wednesday', timeslot: []),
//                 Slot(day: 'Thursday', timeslot: []),
//                 Slot(day: 'Friday', timeslot: []),
//                 Slot(day: 'Saturday', timeslot: []),
//                 Slot(day: 'Sunday', timeslot: [])
//               ];
//             }
//           }
//         });
//       } else {
//         slotData.value = [
//           Slot(day: 'Monday', timeslot: []),
//           Slot(day: 'Tuesday', timeslot: []),
//           Slot(day: 'Wednesday', timeslot: []),
//           Slot(day: 'Thursday', timeslot: []),
//           Slot(day: 'Friday', timeslot: []),
//           Slot(day: 'Saturday', timeslot: []),
//           Slot(day: 'Sunday', timeslot: [])
//         ];
//       }
//     }
//     isLoading.value = false;
//
//     update();
//   }
//
//   getVehicle() async {
//     await FireStoreUtils.getVehicle().then((value) {
//       if (value != null) {
//         vehicleList.value = value;
//       }
//     });
//     update();
//   }
//
//   saveSlot(context) async {
//     bool isEmptyField = false;
//     for (var element in slotData) {
//       var emptyList = element.timeslot!.where((element1) => element1.from!.isEmpty || element1.to!.isEmpty || element1.price!.isEmpty || element1.vehicle == null);
//
//       if (element.timeslot!.isNotEmpty && emptyList.isNotEmpty && !isEmptyField) {
//         ShowToastDialog.showToast("enter_valid_details".tr);
//         isEmptyField = true;
//       }
//     }
//     if (!isEmptyField) {
//       FocusScope.of(context).requestFocus(FocusNode()); //remove focus
//
//       ShowToastDialog.showLoader("please_wait".tr);
//       if (parkingModel.value.id == null || parkingModel.value.userId == null) {
//         parkingModel.value.id = Constant.getUuid();
//         parkingModel.value.userId = FireStoreUtils.getCurrentUid();
//       }
//       parkingModel.value.slot = slotData;
//       await FireStoreUtils.saveParkingDetails(parkingModel.value).then((value) async {});
//       Get.back();
//       Get.back();
//       ShowToastDialog.closeLoader();
//     }
//   }
//
//   addSlot(index) {
//     isLoading.value = true;
//     slotData[index].timeslot!.add(Timeslot(id: Constant.getUuid(), from: '', to: '', price: ''));
//     isLoading.value = false;
//     update();
//   }
//
//   removeSlot(index, index1) {
//     isLoading.value = true;
//     slotData[index].timeslot!.removeAt(index1);
//     isLoading.value = false;
//     update();
//   }
//
//   String calculateDuration(String? startTime, String? endTime) {
//     if (startTime != null && startTime.isNotEmpty && endTime != null && endTime.isNotEmpty) {
//       return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(endTime.split(":").first), int.parse(endTime.split(":").last))
//           .difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(startTime.split(":").first), int.parse(startTime.split(":").last)))
//           .inHours
//           .toString();
//     } else {
//       return "";
//     }
//   }
// }
