import 'package:get/get.dart';
import 'package:scaneats_owner/app/model/currencies_model.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranchData();
  }

  RxBool isLoading = true.obs;

  Future<void> getBranchData() async {
    await FireStoreUtils.getActiveLanguage().then((value) {
      if (value!.isNotEmpty) {
        Constant.lngList = value;
      } else {
        Constant.lngList.add(LanguageModel(
          id: "1234",
          isActive: true,
          name: "English",
          code: "en",
          image:
              "https://firebasestorage.googleapis.com/v0/b/foodeat-96046.appspot.com/o/languages%2F836784ec-cba6-40c6-84a0-bb3f4d9f0434?alt=media&token=3f71379b-9898-432f-92ca-9c047e457382",
        ));
      }
    });
    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        if(value.isNotEmpty){
          Constant.currency = value.first;
        }else{
          Constant.currency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    isLoading.value = false;
  }
}
