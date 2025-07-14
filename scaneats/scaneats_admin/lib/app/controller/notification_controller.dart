import 'package:get/get.dart';
import 'package:scaneats/app/controller/dash_board_controller.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class NotificationController extends GetxController {
  DashBoardController dashBoardController  = Get.find<DashBoardController>();

  @override
  void onInit() {
    // TODO: implement onInit
    getRecentOrder();
    super.onInit();
  }

  RxList<OrderModel> orderList = <OrderModel>[].obs;
  RxBool isOrderoading = true.obs;

  getRecentOrder() async {
    await FireStoreUtils.getRecentOrder().then((value) {
      if (value != null) {
        orderList.value = value;
      }
    });
    isOrderoading.value = false;
  }
}
