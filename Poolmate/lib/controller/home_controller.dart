import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:poolmate/app/home_screen/search_screen.dart';
import 'package:poolmate/constant/collection_name.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/constant/show_toast_dialog.dart';
import 'package:poolmate/model/booking_model.dart';
import 'package:poolmate/model/map/direction_api_model.dart';
import 'package:poolmate/model/map/geometry.dart';
import 'package:poolmate/model/recent_search_model.dart';
import 'package:poolmate/model/stop_over_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> pickUpLocationController = TextEditingController().obs;
  Rx<TextEditingController> dropLocationController = TextEditingController().obs;
  Rx<TextEditingController> personController = TextEditingController(text: "1").obs;
  Rx<TextEditingController> dateController = TextEditingController().obs;

  RxInt numberOfSheet = 1.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Rx<Location> pickUpLocation = Location().obs;
  Rx<Location> dropLocation = Location().obs;

  RxList<RecentSearchModel> recentSearch = <RecentSearchModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    dateController.value.text = Constant.dateCustomizationShow(selectedDate.value).toString();
    getSearchHistory();
    addDepartureTime();
    super.onInit();
  }

  getSearchHistory() async {
    await FireStoreUtils.getSearchHistory().then((value) {
      if (value != null) {
        recentSearch.value = value;
      }
    });
    isLoading.value = false;
  }

  RxList<BookingModel> searchedBookingList = <BookingModel>[].obs;

  searchRide() async {
    ShowToastDialog.showLoader("Please wait");
    searchedBookingList.clear();

    if (pickUpLocation.value.lat != null) {
      List<geocoding.Placemark> placeMarks = await geocoding.placemarkFromCoordinates(pickUpLocation.value.lat!, pickUpLocation.value.lng!);
      Constant.country = placeMarks.first.country;
    }

    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });
    Timestamp startTime;
    if (Constant.dateCustomizationShow(selectedDate.value) == "Today") {
      startTime = Timestamp.fromDate(DateTime.now());
    } else {
      startTime = Timestamp.fromDate(DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 0, 0, 0));
    }
    Timestamp endTime = Timestamp.fromDate(DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 23, 59, 0));
    await FireStoreUtils.fireStore
        .collection(CollectionName.booking)
        .where('departureDateTime', isGreaterThanOrEqualTo: startTime)
        .where('departureDateTime', isLessThanOrEqualTo: endTime)
        .where('status', isEqualTo: Constant.placed)
        .where('publish', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data());
        bool isPickupSame = pickupIsSame(bookingModel);
        if (isPickupSame) {
          searchedBookingList.add(bookingModel);
        }
      }
    });

    ShowToastDialog.closeLoader();
    Get.to(const SearchScreen());
  }

  bool pickupIsSame(BookingModel bookingModel) {
    bool isSame = false;
    double pickUpDistance = Constant.calculateDistance(bookingModel.pickupLocation!.geometry!.location!, pickUpLocation.value);

    double dropDistance = Constant.calculateDistance(bookingModel.dropLocation!.geometry!.location!, dropLocation.value);
    if (pickUpDistance <= int.parse(Constant.radius) && dropDistance <= int.parse(Constant.radius)) {
      isSame = true;
    } else {
      for (var element in bookingModel.stopOverList!) {
        double distancePickup = Constant.calculateDistance(Location(lat: element.startLocation!.lat, lng: element.startLocation!.lng), pickUpLocation.value);
        double distanceDrop = Constant.calculateDistance(Location(lat: element.endLocation!.lat, lng: element.endLocation!.lng), dropLocation.value);
        if (distancePickup <= int.parse(Constant.radius) && distanceDrop <= int.parse(Constant.radius)) {
          isSame = true;
        }
      }
    }
    return isSame;
  }

  getPrice(BookingModel bookingModel) {
    StopOverModel? stopOverModel;
    double pickUpDistance = Constant.calculateDistance(bookingModel.pickupLocation!.geometry!.location!, pickUpLocation.value);

    double dropDistance = Constant.calculateDistance(bookingModel.dropLocation!.geometry!.location!, dropLocation.value);
    if (pickUpDistance <= int.parse(Constant.radius) && dropDistance <= int.parse(Constant.radius)) {
      stopOverModel = StopOverModel(
          startAddress: bookingModel.pickUpAddress,
          startLocation: Northeast(lat: bookingModel.pickupLocation!.geometry!.location!.lat, lng: bookingModel.pickupLocation!.geometry!.location!.lng),
          endLocation: Northeast(lat: bookingModel.dropLocation!.geometry!.location!.lat, lng: bookingModel.dropLocation!.geometry!.location!.lng),
          price: bookingModel.pricePerSeat.toString(),
          endAddress: bookingModel.dropAddress,
          distance: Distance(value: int.parse(bookingModel.distance.toString())),
          duration: Distance(text: bookingModel.estimatedTime.toString()),
          recommendedPrice: bookingModel.pricePerSeat.toString());
    } else {
      for (var element in bookingModel.stopOverList!) {
        double distancePickup = Constant.calculateDistance(Location(lat: element.startLocation!.lat, lng: element.startLocation!.lng), pickUpLocation.value);
        double distanceDrop = Constant.calculateDistance(Location(lat: element.endLocation!.lat, lng: element.endLocation!.lng), dropLocation.value);
        if (distancePickup <= int.parse(Constant.radius) && distanceDrop <= int.parse(Constant.radius)) {
          stopOverModel = element;
        }
      }
    }
    return stopOverModel;
  }

  setSearchHistory() async {
    RecentSearchModel recentSearchModel = RecentSearchModel();
    recentSearchModel.pickUpAddress = pickUpLocationController.value.text;
    recentSearchModel.dropAddress = dropLocationController.value.text;
    recentSearchModel.pickUpLocation = pickUpLocation.value;
    recentSearchModel.dropLocation = dropLocation.value;
    recentSearchModel.person = personController.value.text;
    recentSearchModel.createdAt = Timestamp.now();
    recentSearchModel.bookedDate = Timestamp.fromDate(selectedDate.value);
    recentSearchModel.id = Constant.getUuid();
    recentSearchModel.userId = FireStoreUtils.getCurrentUid();

    await FireStoreUtils.setSearchHistory(recentSearchModel);
    await getSearchHistory();
  }

  RxList<TimeSlot> departureTime = <TimeSlot>[].obs;
  RxList<TimeSlot> selectedDepartureTime = <TimeSlot>[].obs;
  RxBool verifyDriver = false.obs;
  RxBool isWoman = false.obs;

  Rx<RangeValues> currentRangeValues = const RangeValues(1, 10000).obs;
  Rx<TextEditingController> minPriceController = TextEditingController(text: "1").obs;
  Rx<TextEditingController> maxPriceController = TextEditingController(text: "10000").obs;

  addDepartureTime() {
    departureTime.add(TimeSlot(
        title: "Select All",
        start: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 0, 0, 0),
        end: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 23, 59, 0)));
    departureTime.add(TimeSlot(
        title: "Before 6:00 AM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 0, 0, 0),
        end: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 06, 00, 0)));
    departureTime.add(TimeSlot(
        title: "06:00 AM - 12:00 noon",
        start: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 06, 00, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 11, 59, 00)));
    departureTime.add(TimeSlot(
        title: "12:00 noon - 06:00 PM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 12, 01, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 18, 00, 00)));
    departureTime.add(TimeSlot(
        title: "after 06:00 PM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 18, 00, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, 23, 59, 00)));
  }

  filterBookings({
    List<TimeSlot>? timeSlots,
    bool? verifyDrivers,
    bool? womenOnly,
    double? minPrice,
    double? maxPrice,
  }) async {
    print("===> ${searchedBookingList.length}");
    await searchRide();
    List<BookingModel> filterList = searchedBookingList.where((booking) {
      bool matches = true;

      // Filter by multiple time slots
      if (timeSlots != null && timeSlots.isNotEmpty) {
        bool withinTimeSlot = false;
        for (var slot in timeSlots) {
          if (booking.departureDateTime != null && booking.departureDateTime!.toDate().isAfter(slot.start) && booking.departureDateTime!.toDate().isBefore(slot.end)) {
            withinTimeSlot = true;
            break;
          }
        }
        if (!withinTimeSlot) {
          matches = false;
        }
      }

      // Verify drivers (assuming createdBy is not null or meets some criteria)
      if (verifyDrivers != null && verifyDrivers) {
        if (booking.driverVerify != true) {
          matches = false;
        }
      }

      // Filter by women only
      if (womenOnly != null && womenOnly) {
        if (booking.womenOnly != true) {
          matches = false;
        }
      }

      // Filter by price range
      if (minPrice != null || maxPrice != null) {
        double price = double.tryParse(booking.pricePerSeat ?? '0') ?? 0;
        if ((minPrice != null && price < minPrice) || (maxPrice != null && price > maxPrice)) {
          matches = false;
        }
      }
      return matches;
    }).toList();
    searchedBookingList.value = filterList;
    Get.back();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class TimeSlot {
  String title;
  DateTime start;
  DateTime end;

  TimeSlot({required this.title, required this.start, required this.end});
}
