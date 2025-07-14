import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:poolmate/model/review_model.dart';
import 'package:poolmate/model/user_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

class RatingViewController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<UserModel> publisherUserModel = UserModel().obs;
  RxList<ReviewModel> ratingList = <ReviewModel>[].obs;

  RxBool isLoading = true.obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      publisherUserModel.value = argumentData['publisherUserModel'];
    }
    await getRating();
  }

  getRating() async {
    await FireStoreUtils.getRating(publisherUserModel.value.id.toString()).then(
      (value) {
        if (value != null) {
          ratingList.value = value;
        }
      },
    );
    isLoading.value = false;
  }
}
