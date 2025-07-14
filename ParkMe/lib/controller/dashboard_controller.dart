import 'package:get/get.dart';
import 'package:parkMe/ui/home/home_screen.dart';
import 'package:parkMe/ui/my_booking/my_booking_screen.dart';
import 'package:parkMe/ui/profile/profile_screen.dart';
import 'package:parkMe/ui/saved/saved_screen.dart';

class DashboardScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList pageList = [
    const HomeScreen(),
    const SavedScreen(),
    const MyBookingScreen(),
    const ProfileScreen(),
  ].obs;
}
