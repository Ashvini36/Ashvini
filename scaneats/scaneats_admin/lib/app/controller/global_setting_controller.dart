import 'package:get/get.dart';
import 'package:scaneats/app/model/currencies_model.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranchData();
  }

  Future<void> getBranchData() async {
    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.currency = value.first;
        } else {
          Constant.currency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    await FireStoreUtils.getActiveCurrenciesOfOwner().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.ownerCurrency = value.first;
        } else {
          Constant.ownerCurrency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });

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
  }
}
