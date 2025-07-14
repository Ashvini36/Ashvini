import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/controller/settings_controller.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/global_widgets.dart';

class SettingsRolePermissionController extends GetxController {
  RxString title = "View".obs;
  Rx<RoleModel> selectRole = RoleModel().obs;

  @override
  void onInit() {
    super.onInit();
    getRoleList();
  }

  RxList<RoleModel> roleList = <RoleModel>[].obs;
  RxBool isRoleLoading = true.obs;

  Future<void> getRoleList() async {
    isRoleLoading.value = true;
    await FireStoreUtils.getAllRole().then((value) {
      if (value!.isNotEmpty) {
        roleList.value = value;
      }
      roleList.sort((a, b) => a.position!.compareTo(b.position!));

      isRoleLoading.value = false;
    });
  }

  List<RolePermission> setRoleList() {
    return [
      RolePermission(title: 'Items', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Dining Tables', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'POS', isEdit: false, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'POS Orders', isEdit: false, isUpdate: true, isDelete: true, isView: true),
      RolePermission(title: 'Table Orders', isEdit: false, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Offers', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Administrators', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Customers', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Employees', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Sales Report', isEdit: true, isUpdate: false, isDelete: false, isView: false),
      RolePermission(title: 'Settings', isEdit: false, isUpdate: false, isDelete: false, isView: false)
    ];
  }

  void selectPermission(RoleModel model) {
    final settingsController = Get.put(SettingsController());
    selectRole.value = model;
    settingsController.selectSettingWidget.value.selectIndex = 1;

    if (selectRole.value.permission!.where((element) => element.title == "Dashboard").isNotEmpty) {
      selectRole.value.permission!.removeAt(selectRole.value.permission!.indexWhere((element) => element.title == "Dashboard"));
    }

    if (selectRole.value.permission!.where((element) => element.title == "POS").isNotEmpty) {
      selectRole.value.permission!.removeAt(selectRole.value.permission!.indexWhere((element) => element.title == "POS"));
    }

    if (selectRole.value.permission!.where((element) => element.title == "POS Orders").isNotEmpty) {
      selectRole.value.permission!.removeAt(selectRole.value.permission!.indexWhere((element) => element.title == "POS Orders"));
    }

    if (selectRole.value.permission!.where((element) => element.title == "Table Orders").isNotEmpty) {
      selectRole.value.permission!.removeAt(selectRole.value.permission!.indexWhere((element) => element.title == "Table Orders"));
    }

    if (selectRole.value.permission!.where((element) => element.title == "Settings").isNotEmpty) {
      selectRole.value.permission!.removeAt(selectRole.value.permission!.indexWhere((element) => element.title == "Settings"));
    }

    settingsController.update();
    update();
  }

  RxBool isSaveLoading = false.obs;

  Future<void> editRole(RoleModel model) async {
    isSaveLoading.value = true;
    await FireStoreUtils.addRole(model).then((value) {
      final settingsController = Get.put(SettingsController());
      settingsController.selectSettingWidget.value.selectIndex = 0;
      isSaveLoading.value = false;
      settingsController.update();
    });
  }

  Future<void> deleteRole(RoleModel model, index) async {
    await FireStoreUtils.deleteRoleById(model).then((value) {
      ShowToastDialog.showToast('Role has been deleted.');
      roleList.removeAt(index);
    });
  }

  var roleController = TextEditingController().obs;

  RxBool isAddRoleLoading = false.obs;

  Future<void> addNewRole(RoleModel model, {bool isEdit = false}) async {
    isAddRoleLoading.value = true;
    await FireStoreUtils.addRole(model).then((value) {
      isAddRoleLoading.value = false;
      if (isEdit == true) {
        for (int i = 0; i < roleList.length; i++) {
          if (roleList[i].id == model.id) {
            roleList[i] = model;
          }
        }
      } else {
        roleList.add(value!);
      }
      roleController.value = TextEditingController();
      Get.back();
      ShowToastDialog.showToast(isEdit == true ? "Role update successfully" : "Added New Role successfully!");
    });
  }

  Future<int> getRoleCountById(String designationId) async {
    int length = 0;
    await FireStoreUtils.fireStore
        .collection(CollectionName.restaurants)
        .doc(CollectionName.restaurantId)
        .collection(CollectionName.user)
        .where('roleId', isEqualTo: designationId)
        .get()
        .then((value) {
      length = value.docs.length;
      return length;
    }).catchError((error) {
      printLog("Failed to update user: $error");
      throw error;
    });
    return length;
  }
}
