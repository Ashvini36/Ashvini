import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/app/model/user_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:get/get.dart';

class EmployeesController extends GetxController {
  RxString title = "Employees".obs;

  @override
  void onInit() {
    super.onInit();
    totalItemPerPage.value = Constant.numofpageitemList.first;
    getRoleList();
    callData();
  }

  callData() {
    setDefaultData();
    getEmployeeData();
  }

  RxBool notificationReceive = false.obs;

  RxBool isNotAdded = false.obs;

  Future<void> setCustomerData(UserModel model, {bool isEdit = false}) async {
    FireStoreUtils.setUserModel(model).then((value) async {
      if (value?.id != null) {
        updateUserList(value!, isEdit: isEdit);
        setDefaultData();
        isNotAdded.value = false;
        Get.back();
        ShowToastDialog.showToast("Added Customer data Successfully!");
      } else {
        ShowToastDialog.showToast("Something Went Wrong...");
        isNotAdded.value = false;
      }
    });

    update();
  }

  RxList<String> filterList = ['Name', 'Date', 'Recent'].obs;
  RxString selectedfilter = "".obs;

  RxList<String> exportAsList = ['Export as'].obs;
  RxString selectedExport = ''.obs;

  Future loginUser({bool edit = false}) async {
    String? userId = '';
    try {
      if (!email.value.text.isEmail) {
        ShowToastDialog.showToast("Please Enter the Valid Email.");
        return null;
      } else if (password.value.text.length <= 5 && !edit) {
        ShowToastDialog.showToast("Please Enter Minimum 6 Pharacter Password");
        return null;
      } else if (password.value.text != conPassword.value.text) {
        ShowToastDialog.showToast("Your password and confirmation password do not match.");
        return null;
      } else if (selectedRole.value.id == null) {
        ShowToastDialog.showToast("Please Select Role");
        return null;
      } else if (name.value.text.trim().isNotEmpty && email.value.text.trim().isNotEmpty) {
        isNotAdded.value = true;
        if (!edit) {
          printLog(email.value.text.toString());
          userId = await Constant().crateWithEmailOrPassword(email.value.text, password.value.text, Constant().getUuid());
          printLog("Email Data :: $userId");
          if (userId.isEmpty) {
            isNotAdded.value = false;
            return null;
          }
        } else {
          userId = editUserModel.value.id;
        }
        if (!profileImage.value.contains("firebasestorage.googleapis.com")) {
          profileImage.value =
              await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "profileImage/employees/", File(profileImage.value).path.split('/').last);
        }

        UserModel model = UserModel(
            id: userId,
            branchId: selectBranchEmp.value.id ?? Constant.selectedBranch.id,
            name: name.value.text.trim(),
            email: email.value.text.toLowerCase().trim(),
            mobileNo: phone.value.text.toLowerCase().trim(),
            password: password.value.text.trim(),
            profileImage: profileImage.value == "" ? Constant.userPlaceholderURL : profileImage.value,
            isActive: status.value == 'Active',
            role: Constant.employeeRole,
            roleId: selectedRole.value.id,
            createdAt: Timestamp.now(),
            notificationReceive: notificationReceive.value,
            updatedAt: Timestamp.now());

        if (password.value.text.trim() == conPassword.value.text.trim() && password.value.text.trim().isNotEmpty) {
          setCustomerData(model, isEdit: false);
        } else if (edit == true) {
          model.updatedAt = editUserModel.value.updatedAt;
          setCustomerData(model, isEdit: true);
        } else {
          isNotAdded.value = false;
          ShowToastDialog.showToast("Please Enter the Valid Password.");
        }
      } else {
        isNotAdded.value = false;
        ShowToastDialog.showToast("It is necessary to fill out every field in its entirety without exception..");
      }
    } catch (e) {
      ShowToastDialog.showToast('notSignUp');
    }
  }

  RxList<UserModel> customerList = <UserModel>[].obs;

  updateUserList(UserModel model, {bool isEdit = false, bool isRemove = false}) {
    if (isEdit) {
      for (int i = 0; i < customerList.length; i++) {
        if (customerList[i].id.toString() == model.id.toString()) {
          if (isRemove == true) {
            customerList.removeAt(i);
          } else {
            customerList[i] = model;
          }
        }
      }
    } else {
      if (model.branchId == Constant.selectedBranch.id) {
        customerList.add(model);
      }
      customerList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
    setPagition(totalItemPerPage.value);
    update();
  }

  deleteUser(UserModel model) async {
    await FireStoreUtils.deleteUserById(model).then((value) {
      updateUserList(model, isEdit: true, isRemove: true);
      ShowToastDialog.showToast("Delete User Successfully!");
    });
  }

  RxBool isUserLoading = true.obs;

  Future<void> getEmployeeData() async {
    isUserLoading.value = true;
    await FireStoreUtils.getAllUser(Constant.employeeRole).then((value) {
      customerList.value = value!;
      setPagition(totalItemPerPage.value);
      isUserLoading.value = false;
    });
  }

  searchByName({String name = ''}) async {
    isUserLoading.value = true;
    FireStoreUtils.getAllUserByName(name, Constant.employeeRole).then((value) {
      customerList.value = value ?? [];
      setPagition(totalItemPerPage.value);
      isUserLoading.value = false;
    });
  }

  Rx<UserModel> editUserModel = UserModel().obs;
  var name = TextEditingController().obs;
  var email = TextEditingController().obs;
  var phone = TextEditingController().obs;
  var password = TextEditingController().obs;
  var conPassword = TextEditingController().obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConformationPasswordVisible = false.obs;

  var active = false.obs;
  RxString status = 'Active'.obs;
  RxString profileImage = ''.obs;
  Rx<BranchModel> selectBranchEmp = BranchModel().obs;
  Rx<Uint8List> profileImageUin8List = Uint8List(0).obs;

  setDefaultData() {
    selectedfilter.value = '';
    selectedExport.value = exportAsList.first;
    name.value = TextEditingController();
    email.value = TextEditingController();
    phone.value = TextEditingController();
    password.value = TextEditingController();
    conPassword.value = TextEditingController();
    profileImage.value = '';
    editUserModel.value = UserModel();
    if(Constant.allBranch.isNotEmpty){
      selectBranchEmp.value = selectBranchEmp.value = Constant.allBranch.where((element) => element.id == Constant.selectedBranch.id).first;
    }
    status.value = 'Active';
    notificationReceive.value = false;
  }

  editCustomerData(UserModel model) {
    editUserModel.value = model;
    selectedfilter.value = '';
    selectedExport.value = exportAsList.first;
    name.value = TextEditingController(text: model.name);
    email.value = TextEditingController(text: model.email);
    phone.value = TextEditingController(text: model.mobileNo);
    profileImage.value = model.profileImage ?? '';
    status.value = 'Active';
    selectBranchEmp.value = Constant.allBranch.where((element) => element.id == model.branchId).first;
    notificationReceive.value = model.notificationReceive!;
    for (var element in roleList) {
      if (element.id == model.roleId) {
        selectedRole.value = element;
      }
    }
  }

  RxList<RoleModel> roleList = <RoleModel>[].obs;
  Rx<RoleModel> selectedRole = RoleModel().obs;

  Future<void> getRoleList() async {
    await FireStoreUtils.getAllRole().then((value) {
      if (value!.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          if (value[i].isEdit == true) {
            roleList.add(value[i]);
          }
        }
      }
      roleList.sort((a, b) => a.position!.compareTo(b.position!));
    });
  }

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<UserModel> currentPageUser = <UserModel>[].obs;

  setPagition(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (customerList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > customerList.length ? customerList.length : (currentPage.value * itemPerPage);
    currentPageUser.value = customerList.sublist(startIndex.value, endIndex.value);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagition(page);
      update();
    } else {
      currentPageUser.value = customerList.sublist(startIndex.value, endIndex.value);
    }
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return currentPageUser.length;
    } else {
      return int.parse(data);
    }
  }
}
