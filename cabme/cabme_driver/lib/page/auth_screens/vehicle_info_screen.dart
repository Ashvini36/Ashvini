import 'dart:developer';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/vehicle_info_controller.dart';
import 'package:cabme_driver/model/brand_model.dart';
import 'package:cabme_driver/model/model.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/text_field_them.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleInfoScreen extends StatelessWidget {
  const VehicleInfoScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: VehicleInfoController(),
        builder: (vehicleInfoController) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: ConstantColors.background,
              body: vehicleInfoController.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: SizedBox(
                                height: Responsive.height(18, context),
                                child: ListView.builder(
                                    itemCount: vehicleInfoController.vehicleCategoryList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Obx(
                                        () => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              vehicleInfoController.selectedCategoryID.value = vehicleInfoController.vehicleCategoryList[index].id.toString();
                                            },
                                            child: Container(
                                              width: 120,
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: vehicleInfoController.selectedCategoryID.value == vehicleInfoController.vehicleCategoryList[index].id.toString()
                                                      ? ConstantColors.primary
                                                      : Colors.black.withOpacity(0.08),
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: vehicleInfoController.vehicleCategoryList[index].image.toString(),
                                                    fit: BoxFit.fill,
                                                    width: 80,
                                                    height: Responsive.height(8, context),
                                                    placeholder: (context, url) => Constant.loader(),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  ),
                                                  Text(
                                                    vehicleInfoController.vehicleCategoryList[index].libelle.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              vehicleInfoController.getBrand().then((value) {
                                                if (value!.isNotEmpty) {
                                                  brandDialog(context, value, vehicleInfoController);
                                                } else {
                                                  ShowToastDialog.showToast("Please contact administrator".tr);
                                                }
                                              });
                                            },
                                            child: TextFieldThem.boxBuildTextField(
                                              hintText: 'Brand'.tr,
                                              controller: vehicleInfoController.brandController.value,
                                              textInputType: TextInputType.text,
                                              maxLength: 20,
                                              enabled: false,
                                              contentPadding: EdgeInsets.zero,
                                              validators: (String? value) {
                                                if (value!.isNotEmpty) {
                                                  return null;
                                                } else {
                                                  return 'required'.tr;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (vehicleInfoController.selectedCategoryID.value.isNotEmpty) {
                                                if (vehicleInfoController.brandController.value.text.isNotEmpty) {
                                                  Map<String, String> bodyParams = {
                                                    'brand': vehicleInfoController.brandController.value.text,
                                                    'vehicle_type': vehicleInfoController.selectedCategoryID.value,
                                                  };
                                                  vehicleInfoController.getModel(bodyParams).then((value) {
                                                    if (value != null && value.isNotEmpty) {
                                                      modelDialog(context, value, vehicleInfoController);
                                                    } else {
                                                      ShowToastDialog.showToast("Car Model not Found.".tr);
                                                    }
                                                  });
                                                } else {
                                                  ShowToastDialog.showToast("Please select brand".tr);
                                                }
                                              } else {
                                                ShowToastDialog.showToast('Please select Vehicle Type'.tr);
                                              }
                                            },
                                            child: TextFieldThem.boxBuildTextField(
                                              hintText: 'Model'.tr,
                                              controller: vehicleInfoController.modelController.value,
                                              textInputType: TextInputType.text,
                                              enabled: false,
                                              maxLength: 20,
                                              contentPadding: EdgeInsets.zero,
                                              validators: (String? value) {
                                                if (value!.isNotEmpty) {
                                                  return null;
                                                } else {
                                                  return 'required'.tr;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        vehicleInfoController.getZone().then((value) {
                                          if (value!.isNotEmpty) {
                                            vehicleInfoController.zoneList.value = value;
                                            zoneDialog(context, vehicleInfoController);
                                          } else {
                                            ShowToastDialog.showToast("Please contact administrator".tr);
                                          }
                                        });
                                      },
                                      child: TextFieldThem.boxBuildTextField(
                                        hintText: 'Select Zone'.tr,
                                        controller: vehicleInfoController.zoneNameController.value,
                                        textInputType: TextInputType.text,
                                        maxLength: 20,
                                        enabled: false,
                                        contentPadding: EdgeInsets.zero,
                                        validators: (String? value) {
                                          if (value!.isNotEmpty) {
                                            return null;
                                          } else {
                                            return 'required'.tr;
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextFieldThem.boxBuildTextField(
                                      hintText: 'Color'.tr,
                                      controller: vehicleInfoController.colorController.value,
                                      textInputType: TextInputType.emailAddress,
                                      maxLength: 20,
                                      contentPadding: EdgeInsets.zero,
                                      validators: (String? value) {
                                        if (value!.isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'required'.tr;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Select Year".tr),
                                                    content: SizedBox(
                                                      // Need to use container to add size constraint.
                                                      width: 300,
                                                      height: 300,
                                                      child: YearPicker(
                                                        firstDate: DateTime(DateTime.now().year - 30, 1),
                                                        lastDate: DateTime(DateTime.now().year, 1),
                                                        initialDate: DateTime(DateTime.now().year, 1),
                                                        selectedDate: DateTime(DateTime.now().year, 1),
                                                        onChanged: (DateTime dateTime) {
                                                          // close the dialog when year is selected.
                                                          vehicleInfoController.carMakeController.value.text = dateTime.year.toString();
                                                          Get.back();
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: TextFieldThem.boxBuildTextField(
                                                hintText: 'Car Registration year'.tr,
                                                controller: vehicleInfoController.carMakeController.value,
                                                textInputType: TextInputType.number,
                                                maxLength: 40,
                                                enabled: false,
                                                contentPadding: EdgeInsets.zero,
                                                validators: (String? value) {
                                                  if (value!.isNotEmpty) {
                                                    return null;
                                                  } else {
                                                    return 'required'.tr;
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: TextFieldThem.boxBuildTextField(
                                            hintText: 'Number Plate'.tr,
                                            controller: vehicleInfoController.numberPlateController.value,
                                            textInputType: TextInputType.text,
                                            maxLength: 40,
                                            contentPadding: EdgeInsets.zero,
                                            validators: (String? value) {
                                              if (value!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'required'.tr;
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldThem.boxBuildTextField(
                                            hintText: 'Millage'.tr,
                                            controller: vehicleInfoController.millageController.value,
                                            textInputType: TextInputType.number,
                                            maxLength: 40,
                                            contentPadding: EdgeInsets.zero,
                                            validators: (String? value) {
                                              if (value!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'required'.tr;
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: TextFieldThem.boxBuildTextField(
                                            hintText: 'KM Driven'.tr,
                                            controller: vehicleInfoController.kmDrivenController.value,
                                            textInputType: TextInputType.number,
                                            maxLength: 40,
                                            contentPadding: EdgeInsets.zero,
                                            validators: (String? value) {
                                              if (value!.isNotEmpty) {
                                                return null;
                                              } else {
                                                return 'required'.tr;
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: TextFieldThem.boxBuildTextField(
                                        hintText: 'Number Of Passengers'.tr,
                                        controller: vehicleInfoController.numberOfPassengersController.value,
                                        textInputType: TextInputType.text,
                                        maxLength: 40,
                                        contentPadding: EdgeInsets.zero,
                                        validators: (String? value) {
                                          if (value!.isNotEmpty) {
                                            return null;
                                          } else {
                                            return 'required'.tr;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonThem.buildButton(
                              context,
                              title: 'Save'.tr,
                              btnHeight: 45,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.black,
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (vehicleInfoController.selectedCategoryID.value.isEmpty) {
                                    ShowToastDialog.showToast("Please select vehicle type".tr);
                                  } else if (vehicleInfoController.selectedBrandID.value.isEmpty) {
                                    ShowToastDialog.showToast("Please select vehicle brand".tr);
                                  } else if (vehicleInfoController.selectedModelID.value.isEmpty) {
                                    ShowToastDialog.showToast("Please select vehicle model".tr);
                                  } else if (vehicleInfoController.zoneList.isEmpty) {
                                    ShowToastDialog.showToast("Please select Zone".tr);
                                  } else if (vehicleInfoController.numberOfPassengersController.value.text.isEmpty) {
                                    ShowToastDialog.showToast("Please enter number of passenger".tr);
                                  } else {
                                    ShowToastDialog.showLoader("Please wait");
                                    Map<String, String> bodyParams1 = {
                                      "brand": vehicleInfoController.selectedBrandID.value,
                                      "model": vehicleInfoController.selectedModelID.value,
                                      "color": vehicleInfoController.colorController.value.text,
                                      "carregistration": vehicleInfoController.numberPlateController.value.text.toUpperCase(),
                                      "passenger": vehicleInfoController.numberOfPassengersController.value.text,
                                      "id_driver": vehicleInfoController.userModel!.userData!.id.toString(),
                                      "id_categorie_vehicle": vehicleInfoController.selectedCategoryID.value,
                                      "car_make": vehicleInfoController.carMakeController.value.text,
                                      "milage": vehicleInfoController.millageController.value.text,
                                      "km_driven": vehicleInfoController.kmDrivenController.value.text,
                                      "zone_id": vehicleInfoController.selectedZone.join(",")
                                    };
                                    log(bodyParams1.toString());
                                    await vehicleInfoController.vehicleRegister(bodyParams1).then((value) {
                                      if (value != null) {
                                        if (value.success == "Success" || value.success == "success") {
                                          ShowToastDialog.closeLoader();
                                          ShowToastDialog.showToast("Vehicle Information save successfully");
                                        } else {
                                          ShowToastDialog.closeLoader();
                                          ShowToastDialog.showToast(value.error);
                                        }
                                      }
                                    });

                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }

  brandDialog(BuildContext context, List<BrandData>? brandList, VehicleInfoController vehicleInfoController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Brand list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                vehicleInfoController.brandController.value.text = brandList[index].name.toString();
                                vehicleInfoController.selectedBrandID.value = brandList[index].id.toString();
                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  modelDialog(BuildContext context, List<ModelData>? brandList, VehicleInfoController vehicleInfoController) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Model list'),
            content: SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: brandList!.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: brandList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: InkWell(
                              onTap: () {
                                vehicleInfoController.modelController.value.text = brandList[index].name.toString();
                                vehicleInfoController.selectedModelID.value = brandList[index].id.toString();

                                Get.back();
                              },
                              child: Text(brandList[index].name.toString())),
                        );
                      },
                    ),
            ),
          );
        });
  }

  zoneDialog(BuildContext context, VehicleInfoController vehicleInfoController) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: ConstantColors.primary),
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        if (vehicleInfoController.selectedZone.isEmpty) {
          ShowToastDialog.showToast("Please select zone");
        } else {
          String nameValue = "";
          for (var element in vehicleInfoController.selectedZone) {
            nameValue = "$nameValue${nameValue.isEmpty ? "" : ","} ${vehicleInfoController.zoneList.where((p0) => p0.id == element).first.name}";
          }
          vehicleInfoController.zoneNameController.value.text = nameValue;
          Get.back();
        }
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Zone list'),
            content: SizedBox(
              width: Responsive.width(90, context), // Change as per your requirement
              child: vehicleInfoController.zoneList.isEmpty
                  ? Container()
                  : Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: vehicleInfoController.zoneList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(
                            () => CheckboxListTile(
                              value: vehicleInfoController.selectedZone.contains(vehicleInfoController.zoneList[index].id),
                              onChanged: (value) {
                                if (vehicleInfoController.selectedZone.contains(vehicleInfoController.zoneList[index].id)) {
                                  vehicleInfoController.selectedZone.remove(vehicleInfoController.zoneList[index].id); // unselect
                                } else {
                                  vehicleInfoController.selectedZone.add(vehicleInfoController.zoneList[index].id); // select
                                }
                              },
                              title: Text(vehicleInfoController.zoneList[index].name.toString()),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }
}
