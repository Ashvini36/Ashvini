import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/coupon_controller.dart';
import 'package:ebasket_customer/app/model/coupon_model.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: CouponController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(context,
                  title: Text("Coupons".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            controller: controller.couponCodeTextFieldController.value,
                            hintText: "Enter Coupon Code".tr,
                            enable: true,
                            onChanged: (value) {
                              controller.getFilterData(value.toString());
                              return null;
                            },
                          ),
                        ),
                      /*  Padding(
                          padding: const EdgeInsets.only(bottom: 16.0, left: 10),
                          child: InkWell(
                            onTap: () async {
                              ShowToastDialog.showLoader("Please wait".tr);
                              controller.getFilterData(controller.couponCodeTextFieldController.value.text);

                              /*if (controller.couponCodeTextFieldController.value.text.isNotEmpty) {
                                ShowToastDialog.showLoader("Please wait".tr);
                                await FireStoreUtils.fireStore
                                    .collection(CollectionName.coupons)
                                    .where('code', isEqualTo: controller.couponCodeTextFieldController.value.text)
                                    .where('isEnabled', isEqualTo: true)
                                    .where('expiresAt', isGreaterThanOrEqualTo: Timestamp.now())
                                    .get()
                                    .then((value) {
                                  ShowToastDialog.closeLoader();
                                  if (value.docs.isNotEmpty) {
                                    controller.selectedCouponModel.value = CouponModel.fromJson(value.docs.first.data());

                                    ShowToastDialog.showToast("Coupon Applied".tr);

                                    Get.back(result: controller.selectedCouponModel.value);
                                  } else {
                                    ShowToastDialog.showToast("Coupon code is Invalid".tr);
                                  }
                                }).catchError((error) {
                                  log(error.toString());
                                });
                              } else {
                                ShowToastDialog.showToast("Please Enter coupon code".tr);
                              }*/
                            },
                            child: Container(
                              width: Responsive.width(20, context),
                              height: Responsive.height(5, context),
                              decoration: ShapeDecoration(
                                color: AppThemeData.groceryAppDarkBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Apply'.tr,
                                    style: TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.white, fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )*/
                      ],
                    ),
                    Expanded(
                      child: controller.couponModel.isEmpty
                          ? Constant.emptyView(image: "assets/icons/no_data.png", text: "No Data Found".tr)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.couponModel.length,
                              itemBuilder: (context, index) {
                                CouponModel couponModel = controller.couponModel[index];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: AppThemeData.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppThemeData.black.withOpacity(0.25),
                                              blurRadius: 4,
                                              offset: const Offset(0, 0),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              Text(
                                                couponModel.discountType == "Fix Price"
                                                    ? "${Constant.amountShow(amount: couponModel.discount.toString())} OFF"
                                                    : "${couponModel.discount.toString()}% OFF",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: AppThemeData.semiBold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                couponModel.description.toString(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: AppThemeData.black.withOpacity(0.50),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: AppThemeData.regular,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Divider(
                                                  color: AppThemeData.black.withOpacity(0.20),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  /*DottedBorder(
                                                    borderType: BorderType.RRect,
                                                    radius: const Radius.circular(12),
                                                    dashPattern: const [2, 2],
                                                    color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                                    child: Container(
                                                      width: Responsive.width(24, context),
                                                      height: Responsive.height(5, context),
                                                      decoration: BoxDecoration(
                                                        color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child: Center(
                                                          child: Center(
                                                        child: Text(
                                                          couponModel.code.toString(),
                                                          style: const TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.medium),
                                                        ),
                                                      )),
                                                    ),
                                                  ),*/
                                                  Container(
                                                    width: Responsive.width(24, context),
                                                    height: Responsive.height(5, context),
                                                    decoration: BoxDecoration(
                                                      color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: DottedBorder(
                                                      borderType: BorderType.RRect,
                                                      radius: const Radius.circular(12),
                                                      dashPattern: const [2, 2],
                                                      color: AppThemeData.groceryAppDarkBlue,
                                                      child: Center(
                                                          child: Center(
                                                        child: Text(
                                                          couponModel.code.toString(),
                                                          style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.medium),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      controller.selectedCouponModel.value = couponModel;

                                                      ShowToastDialog.showToast("Coupon Applied".tr);

                                                      Future.delayed(const Duration(seconds: 2), () {
                                                        Get.back(result: controller.selectedCouponModel.value);
                                                      });
                                                    },
                                                    child: Container(
                                                      width: Responsive.width(20, context),
                                                      height: Responsive.height(5, context),
                                                      decoration: ShapeDecoration(
                                                        color: AppThemeData.groceryAppDarkBlue,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                          child: Text(
                                                            'Apply'.tr,
                                                            style: TextStyle(fontFamily: AppThemeData.medium, color: AppThemeData.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]))));
                              }),
                    ),
                  ],
                ),
              ));
        });
  }
}
