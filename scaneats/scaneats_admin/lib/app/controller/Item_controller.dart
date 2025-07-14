import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaneats/app/model/item_attributes.dart';
import 'package:scaneats/app/model/item_attributes_model.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ItemController extends GetxController {
  RxString titleItem = "Items".obs;

  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxBool isItemLoading = true.obs;

  Future getAllItem({String name = ''}) async {
    if (name != '') {
      currentPage.value = 1;
    }
    itemList.clear();
    isItemLoading.value = true;
    await FireStoreUtils.getAllItem(name).then((value) {
      if (value != null) {
        itemList.value = value;
        setPagition(totalItemPerPage.value);
      }
      isItemLoading.value = false;
      update();
    });
  }

  var nameController = TextEditingController().obs;
  var priceController = TextEditingController().obs;
  RxList<ItemCategoryModel> itemCategoryList = <ItemCategoryModel>[].obs;
  Rx<ItemCategoryModel> selectItemCategory = ItemCategoryModel().obs;
  RxList<TaxModel> taxList = <TaxModel>[].obs;
  RxList itemType = ['Veg', 'Non Veg'].obs;
  RxString selectItemType = 'Veg'.obs;
  RxList featureList = ['Yes', 'No'].obs;
  RxString selectFeature = 'Yes'.obs;
  RxList statusList = ['Active', 'Inactive'].obs;
  RxString selectStatus = 'Active'.obs;
  var cautionController = TextEditingController().obs;
  var descController = TextEditingController().obs;
  RxBool isAddLoading = false.obs;

  Rx<ItemModel> selectItem = ItemModel().obs;
  RxString selectImage = ''.obs;
  Rx<Uint8List> profileImageUin8List = Uint8List(100).obs;

  getAllCategory() async {
    await FireStoreUtils.getItemCategory().then((value) {
      if (value!.isNotEmpty) {
        itemCategoryList.value = value;
      }
    });
  }

  Future<void> addItemData({bool isEdit = false}) async {
    isAddLoading.value = true;

    selectItem.value.name = nameController.value.text.trim();
    selectItem.value.price = priceController.value.text.trim();
    selectItem.value.categoryId = selectItemCategory.value.id;
    selectItem.value.image = selectImage.value;
    selectItem.value.itemType = selectItemType.value;
    selectItem.value.isFeature = selectFeature.value == 'Yes' ? true : false;
    selectItem.value.isActive = selectStatus.value == "Active" ? true : false;
    selectItem.value.caution = cautionController.value.text.trim();
    selectItem.value.description = descController.value.text.trim();
    // ItemModel model = ItemModel(
    //     id: selectItem.value.id ?? '',
    //     name: nameController.value.text.trim(),
    //     price: priceController.value.text.trim(),
    //     categoryId: selectItemCategory.value.id,
    //     image: image.value,
    //     itemType: selectItemType.value,
    //     isFeature: selectFeature.value == 'Yes' ? true : false,
    //     isActive: selectStatus.value == "Active" ? true : false,
    //     caution: cautionController.value.text.trim(),
    //     description: descController.value.text.trim());

    if (!selectImage.value.contains("firebasestorage.googleapis.com")) {
      selectItem.value.image = await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "Item/", File(selectImage.value).path.split('/').last);
    }


    await FireStoreUtils.addItem(selectItem.value).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          itemList.add(selectItem.value);
          isAddLoading.value = false;
        } else {
          for (int i = 0; i < itemList.length; i++) {
            if (itemList[i].id == value.id) {
              itemList[i] = value;
            }
          }
          isAddLoading.value = false;
        }
        setPagition(totalItemPerPage.value);
        update();
        Get.back();
        ShowToastDialog.showToast("Item successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  Future<void> deleteItemById(String id) async {
    await FireStoreUtils.deleteItemById(id).then((value) {
      if (value) {
        for (int i = 0; i < itemList.length; i++) {
          if (itemList[i].id == id) {
            itemList.removeAt(i);
          }
        }
        setPagition(totalItemPerPage.value);
        ShowToastDialog.showToast("Item has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  setModelData(ItemModel model) {
    selectItem.value = model;
    nameController.value.text = model.name ?? '';
    priceController.value.text = model.price ?? '';
    for (int i = 0; i < itemCategoryList.length; i++) {
      if (itemCategoryList[i].id == model.categoryId) {
        selectItemCategory.value = itemCategoryList[i];
      }
    }
    selectImage.value = model.image ?? '';
    selectItemType.value = model.itemType ?? 'Veg';
    selectFeature.value = model.isFeature == true ? 'Yes' : 'No';
    selectStatus.value = model.isActive == true ? 'Active' : 'Inactive';
    cautionController.value.text = model.caution ?? '';
    descController.value.text = model.description ?? '';
    isAddLoading.value = false;
  }

  setDefaultData() async {
    await getAllCategory();
    selectItem.value = ItemModel();
    nameController.value = TextEditingController();
    priceController.value = TextEditingController();
    selectItemCategory.value = ItemCategoryModel();
    selectImage.value = '';
    profileImageUin8List.value = Uint8List(100);
    selectItemType.value = 'Veg';
    selectFeature.value = 'Yes';
    selectStatus.value = 'Active';
    cautionController.value = TextEditingController();
    descController.value = TextEditingController();
    isAddLoading.value = false;
  }

  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    totalItemPerPage.value = Constant.numofpageitemList.first;
    getAllData();

  }


  getAllData() async {
    await getAllItem();
    await getAllCategory();
    await getItemAttributeData();
  }
  RxInt selectedScreenIndex = 0.obs;
  Rx<PageController> pageController = PageController(initialPage: 0).obs;

  navigateScreen(int index, {ItemModel? model}) async {
    if (index == 0) {
      getAllItem();
    }

    selectedScreenIndex.value = index;
    if (model?.id != null) {
      selectItem.value = model!;
    }

    pageController.value.jumpToPage(selectedScreenIndex.value);
    update();
  }

  RxInt selectTabBar = 0.obs;

  tabViewChange(int index) {
    selectTabBar.value = index;
    update();
  }

  Future<void> getItemAttributeData() async {
    await FireStoreUtils.getItemAttribute().then((value) {
      if (value!.isNotEmpty) {
        attributesList.value = value;
      }
    });
    update();
  }

  Rx<ItemAttributes> itemAttributes = ItemAttributes(attributes: [], variants: []).obs;

  RxList<ItemAttributeModel> attributesList = <ItemAttributeModel>[].obs;
  RxList<ItemAttributeModel> selectedAttributesList = <ItemAttributeModel>[].obs;

  var itemNameController = TextEditingController().obs;
  var itempriceController = TextEditingController().obs;
  var addonstatus = 'Active'.obs;
  var isUpdateLoading = false.obs;

  uploadItemImage() async {
    selectItem.value.image = selectImage.value;
    isUpdateLoading.value = true;
    selectItem.value.image = await FireStoreUtils.uploadUserImageToFireStorage(profileImageUin8List.value, "Item/", File(selectItem.value.image!).path.split('/').last);
    FireStoreUtils.addItem(selectItem.value).then((value) {
      isUpdateLoading.value = false;
      selectImage.value = value.image ?? '';
      selectItem.value = value;

      update();
      ShowToastDialog.showToast("Image Upload Successfully");
    });
  }

  saveItemData({bool isDelete = false}) {
    FireStoreUtils.addItem(selectItem.value).then((value) {
      isUpdateLoading.value = false;
      selectItem.value = value;
      setPagition(totalItemPerPage.value);
      if (!isDelete) {
        ShowToastDialog.showToast("Added Item Successfully");
      } else {
        ShowToastDialog.showToast("Item has been Removed");
      }
      update();
    });
  }

  Rx<Uint8List> addOnsimageUin8List = Uint8List(100).obs;
  RxString addonsimage = ''.obs;
  RxString addonsTitle = 'Addons'.obs;

  Future saveAddonData(Addons model) async {
    if (!model.image!.contains("firebasestorage.googleapis.com")) {
      model.image = await FireStoreUtils.uploadUserImageToFireStorage(addOnsimageUin8List.value, "Item/Addons", File(model.image!).path.split('/').last);
    }
    isUpdateLoading.value = true;
    if (model.id == '') {
      var id = const Uuid().v4();
      model.id = id;
      selectItem.value.addons?.add(model);
    } else {
      for (int i = 0; i < selectItem.value.addons!.length; i++) {
        if (selectItem.value.addons?[i].id == model.id) {
          selectItem.value.addons?[i] = model;
        }
      }
    }
    FireStoreUtils.addItem(selectItem.value).then((value) {
      isUpdateLoading.value = false;
      selectItem.value = value;
      ShowToastDialog.showToast("Added Item Successfully");
      update();
    });
  }

  RxString title = "Items".obs;
  var attributesValueController = TextEditingController().obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<ItemModel> currentPageItems = <ItemModel>[].obs;

  setPagition(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (itemList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > itemList.length ? itemList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagition(page);
      update();
    } else {
      currentPageItems.value = itemList.sublist(startIndex.value, endIndex.value);
    }
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return itemList.length;
    } else {
      return int.parse(data);
    }
  }
}
