import 'package:get/get.dart';
import 'package:poolmate/model/document_model.dart';
import 'package:poolmate/model/user_verification_model.dart';
import 'package:poolmate/utils/fire_store_utils.dart';

class VerificationController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getDocument();
    super.onInit();
  }

  RxList documentList = <DocumentModel>[].obs;
  RxList driverDocumentList = <Documents>[].obs;

  getDocument() async {
    await FireStoreUtils.getDocumentList().then((value) {
      documentList.value = value;
    });
    await FireStoreUtils.getDocumentOfDriver().then((value) {
      if(value != null){
        driverDocumentList.value = value.documents!;
      }
    });
    isLoading.value = false;
    update();
  }
}
