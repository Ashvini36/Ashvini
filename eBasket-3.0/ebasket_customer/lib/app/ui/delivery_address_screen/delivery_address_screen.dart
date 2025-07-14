import 'package:ebasket_customer/app/controller/delivery_address_controller.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/app/ui/delivery_address_screen/add_address_screen.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_ui.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: DeliveryAddressController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemeData.white,
            appBar: CommonUI.customAppBar(context,
                title: Text("Delivery Address".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
                isBack: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Get.to(AddAddressScreen(), transition: Transition.rightToLeftWithFade)!.then((value) {
                          controller.getListAddress();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: AppThemeData.groceryAppDarkBlue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Add".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: controller.shippingAddress.isEmpty
                  ? Center(
                      child: Text("No address found".tr),
                    )
                  : ListView.builder(
                      itemCount: controller.shippingAddress.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        AddressModel addressModel = controller.shippingAddress[index];
                        return InkWell(
                          onTap: () {
                           Get.back(result: addressModel);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_on_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${addressModel.getFullAddress()}",
                                                  style: TextStyle(fontFamily: AppThemeData.medium, color: Colors.black.withOpacity(0.80)),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              if (addressModel.addressAs != null && addressModel.addressAs != 'null')
                                                Container(
                                                  height: 32,
                                                  decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: const BorderRadius.all(Radius.circular(20))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    child: Center(
                                                      child: Text(
                                                        addressModel.addressAs.toString(),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              addressModel.isDefault == true
                                                  ? Container(
                                                      height: 32,
                                                      decoration: BoxDecoration(color: Colors.green, borderRadius: const BorderRadius.all(Radius.circular(20))),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                                        child: Center(
                                                          child: Text(
                                                            "Default",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _showActionSheet(context, index, controller);
                                        },
                                        child: Icon(Icons.more_vert)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        });
  }

  void _showActionSheet(BuildContext context1, int index, DeliveryAddressController controller) {
    showCupertinoModalPopup<void>(
      context: context1,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              ShowToastDialog.showLoader("Please Wait".tr);
              RxList<AddressModel> tempShippingAddress = <AddressModel>[].obs;
              UserModel user = controller.userModel.value;
              controller.shippingAddress.forEach((element) {
                AddressModel addressModel = element;
                if (addressModel.id == controller.shippingAddress[index].id) {
                  addressModel.isDefault = true;

                } else {
                  addressModel.isDefault = false;
                }
                // tempShippingAddress.add(element);
                tempShippingAddress.add(addressModel);
              });

              user.shippingAddress = tempShippingAddress;

              await FireStoreUtils.updateCurrentUser(user);
              controller.getListAddress();
              ShowToastDialog.closeLoader();
              Get.back(result: tempShippingAddress.where((element) => element.isDefault == true).single);
            },
            child: const Text('Default', style: TextStyle(color: Colors.blue)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Get.back();

              Get.to(AddAddressScreen(), transition: Transition.rightToLeftWithFade, arguments: {'index': index})!.then((value) {
                controller.getListAddress();
              });
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              controller.shippingAddress.removeAt(index);
              UserModel user = controller.userModel.value;
              user.shippingAddress = controller.shippingAddress;
              FireStoreUtils.updateCurrentUser(user);
              controller.getListAddress();
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }
}
