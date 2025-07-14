import 'package:ebasket_driver/app/model/location_lat_lng.dart';
import 'package:ebasket_driver/app/model/position.dart';
import 'package:ebasket_driver/app/model/driver_model.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/widgets/geoflutterfire/src/geoflutterfire.dart';
import 'package:ebasket_driver/widgets/geoflutterfire/src/models/point.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  Rx<DriverModel> userModel = DriverModel().obs;
  RxBool isLoading = true.obs;
  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await updateCurrentLocation();
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
        if (userModel.value.location != null) {
          Constant.currentLocation = LocationLatLng(latitude: userModel.value.location!.latitude, longitude: userModel.value.location!.longitude);
        }
        isLoading.value = false;
      }
    });
  }

  Location location = Location();

  updateCurrentLocation() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
      location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: 3);
      location.onLocationChanged.listen((locationData) async {
        Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
          DriverModel driverUserModel = value!;
          if (driverUserModel.active == true) {
            driverUserModel.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
            GeoFirePoint position = Geoflutterfire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);

            driverUserModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
            driverUserModel.rotation = locationData.heading;

            print("------>${driverUserModel.location!.toJson()}");

            await FireStoreUtils.updateCurrentUser(driverUserModel);
          }
        });
      });
    } else {
      location.requestPermission().then((permissionStatus) {
        if (permissionStatus == PermissionStatus.granted) {
          location.enableBackgroundMode(enable: true);
          location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: 3);
          location.onLocationChanged.listen((locationData) async {
            Constant.currentLocation = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);

            await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
              DriverModel driverUserModel = value!;
              print("------>${driverUserModel.active}");
              if (driverUserModel.active == true) {
                driverUserModel.location = LocationLatLng(latitude: locationData.latitude, longitude: locationData.longitude);
                driverUserModel.rotation = locationData.heading;
                GeoFirePoint position = Geoflutterfire().point(latitude: locationData.latitude!, longitude: locationData.longitude!);

                driverUserModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);

                await FireStoreUtils.updateCurrentUser(driverUserModel);
              }
            });
          });
        }
      });
    }
    isLoading.value = false;
    update();
  }
}
