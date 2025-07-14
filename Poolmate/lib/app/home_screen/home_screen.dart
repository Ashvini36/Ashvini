import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poolmate/app/add_your_ride/add_your_ride_screen.dart';
import 'package:poolmate/app/home_screen/view_all_search_screen.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/constant/show_toast_dialog.dart';
import 'package:poolmate/controller/home_controller.dart';
import 'package:poolmate/model/map/place_picker_model.dart';
import 'package:poolmate/model/recent_search_model.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/themes/responsive.dart';
import 'package:poolmate/themes/round_button_fill.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:poolmate/widgets/google_map_search_place.dart';
import 'package:provider/provider.dart';

import '../../utils/network_image_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
         backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
          body: controller.isLoading.value
              ? Constant.loader()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          NetworkImageWidget(
                            imageUrl: Constant.appBannerImage,
                            fit: BoxFit.cover,
                            width: Responsive.width(100, context),
                            height: Responsive.height(50, context),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .32,
                              left: 16,
                              right: 16,
                            ),
                            child: Container(
                              width: Responsive.width(100, context),
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Get.to(const GoogleMapSearchPlacesApi())!.then((value) {
                                            if (value != null) {
                                              PlaceDetailsModel placeDetailsModel = value;
                                              controller.pickUpLocationController.value.text = placeDetailsModel.result!.formattedAddress.toString();
                                              controller.pickUpLocation.value = placeDetailsModel.result!.geometry!.location!;
                                            }
                                          });
                                        },
                                        child: TextFormField(
                                          controller: controller.pickUpLocationController.value,
                                          style:
                                              TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter pickup location'.tr,
                                            enabled: false,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset("assets/icons/ic_source.svg"),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(const GoogleMapSearchPlacesApi())!.then((value) {
                                            if (value != null) {
                                              PlaceDetailsModel placeDetailsModel = value;
                                              controller.dropLocationController.value.text = placeDetailsModel.result!.formattedAddress.toString();
                                              controller.dropLocation.value = placeDetailsModel.result!.geometry!.location!;
                                            }
                                          });
                                        },
                                        child: TextFormField(
                                          controller: controller.dropLocationController.value,
                                          style:
                                              TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter drop-off location'.tr,
                                            enabled: false,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset("assets/icons/ic_destination.svg"),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          buildBottomSheet(context);
                                        },
                                        child: TextFormField(
                                          controller: controller.personController.value,
                                          style:
                                              TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Person'.tr,
                                            enabled: false,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset("assets/icons/ic_user_icon.svg"),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () async {
                                          await Constant.selectFeatureDate(context, controller.selectedDate.value).then((value) {
                                            if (value != null) {
                                              controller.selectedDate.value = value;
                                              if (Constant.dateCustomizationShow(controller.selectedDate.value).toString().isNotEmpty) {
                                                controller.dateController.value.text = Constant.dateCustomizationShow(controller.selectedDate.value).toString();
                                              } else {
                                                controller.dateController.value.text = DateFormat('MMMM dd,yyyy').format(value);
                                              }
                                            }
                                          });
                                        },
                                        child: TextFormField(
                                          controller: controller.dateController.value,
                                          style:
                                              TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabled: false,
                                            hintText: 'Select date'.tr,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset("assets/icons/ic_calender.svg"),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (controller.pickUpLocationController.value.text.isEmpty) {
                                            ShowToastDialog.showToast("Please select pickup location".tr);
                                          } else if (controller.dropLocationController.value.text.isEmpty) {
                                            ShowToastDialog.showToast("Please select pickup location".tr);
                                          } else {
                                            controller.searchRide();
                                          }
                                        },
                                        child: Container(
                                          width: Responsive.width(100, context),
                                          decoration: BoxDecoration(
                                            color: AppThemeData.primary300,
                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                            border: Border.all(
                                              color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Search Cab".tr,
                                                  style: TextStyle(
                                                      fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50, fontFamily: AppThemeData.medium),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  Icons.arrow_right_alt_sharp,
                                                  color: AppThemeData.grey50,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      controller.recentSearch.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    thickness: 5,
                                    color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Recent Searches".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                            fontSize: 18,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(const ViewAllSearchScreen());
                                        },
                                        child: Text(
                                          "View all".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.recentSearch.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    RecentSearchModel recentSearchModel = controller.recentSearch[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${recentSearchModel.pickUpAddress}',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontFamily: AppThemeData.medium,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: SvgPicture.asset("assets/icons/ic_right_arrow.svg"),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${recentSearchModel.dropAddress}',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontFamily: AppThemeData.medium,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              Constant.timestampToDateTime(recentSearchModel.createdAt!),
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: AppThemeData.regular,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: AppThemeData.primary300,
            onPressed: () async {
              Get.to(const AddYourRideScreen(), transition: Transition.downToUp);
            },
            child: const Icon(
              Icons.add,
              color: AppThemeData.grey50,
            ),
          ),
        );
      },
    );
  }

  buildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: HomeController(),
              builder: (controller) {
                return SizedBox(
                  height: Responsive.height(34, context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  "Select Seats".tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.close))
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    controller.numberOfSheet.value -= 1;
                                  },
                                  child: Icon(Icons.remove, color: AppThemeData.primary300)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "0${controller.numberOfSheet.value}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  fontSize: 62,
                                  fontFamily: AppThemeData.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (controller.numberOfSheet.value < 8) {
                                    controller.numberOfSheet.value += 1;
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: AppThemeData.primary300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RoundedButtonFill(
                          title: "Confirm Seat".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            controller.personController.value.text = controller.numberOfSheet.value.toString();
                            Get.back();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
