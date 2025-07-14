import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/model/category_model.dart';

class CategoryListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxBool isServiceAvailable = true.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    categoryList.clear();
    if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
      await FireStoreUtils.getCategories().then((value) {
        if (value != null) {
          categoryList.value = value;

        }
      });
    }else{
      isServiceAvailable.value = false;
    }
    isLoading.value = false;
  }
}
