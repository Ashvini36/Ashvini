import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poolmate/constant/constant.dart';
import 'package:poolmate/controller/add_your_ride_controller.dart';
import 'package:poolmate/model/map/geometry.dart';
import 'package:poolmate/model/stop_over_model.dart';
import 'package:poolmate/themes/app_them_data.dart';
import 'package:poolmate/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class StepSixStopOverPriceScreen extends StatelessWidget {
  const StepSixStopOverPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddYourRideController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                    child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Edit price per seat".tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.stopOverList.length,
                      itemBuilder: (context, index) {
                        StopOverModel legs = controller.stopOverList[index];
                        return Row(
                          children: [
                            Expanded(
                              child: Timeline.tileBuilder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                theme: TimelineThemeData(
                                  nodePosition: 0,
                                ),
                                builder: TimelineTileBuilder.connected(
                                  contentsAlign: ContentsAlign.basic,
                                  indicatorBuilder: (context, index) {
                                    return Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFFF5F7F8),
                                        shape: OvalBorder(),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0xFFC1CED6),
                                            blurRadius: 0,
                                            offset: Offset(0, 0),
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  contentsBuilder: (context, index) {
                                    return index == 0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            child: Constant.getCityName(themeChange, Location(lat: legs.startLocation!.lat!, lng: legs.startLocation!.lng!)),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            child: Constant.getCityName(themeChange, Location(lat: legs.endLocation!.lat!, lng: legs.endLocation!.lng!)),
                                          );
                                  },
                                  connectorBuilder: (context, index, connectorType) {
                                    return const DashedLineConnector(
                                      color: AppThemeData.grey300,
                                      gap: 2,
                                    );
                                  },
                                  itemCount: 2,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${Constant.distanceCalculate(legs.distance!.value.toString())} ${Constant.distanceType} ".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (double.parse(legs.price.toString()) >= Constant.getMinusPercentageAmount(legs.recommendedPrice.toString())) {
                                          controller.changeStopOverPrice(index, false);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                                        child:  Icon(Icons.remove, color: AppThemeData.primary300),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      Constant.amountShow(amount: legs.price),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        fontFamily: AppThemeData.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (double.parse(legs.price.toString()) <= Constant.getPlusPercentageAmount(legs.recommendedPrice.toString())) {
                                          controller.changeStopOverPrice(index, true);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                                        child:  Icon(
                                          Icons.add,
                                          color: AppThemeData.primary300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
