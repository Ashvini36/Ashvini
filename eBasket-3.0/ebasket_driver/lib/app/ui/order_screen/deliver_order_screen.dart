import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/controller/order_details_controller.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/model/product_model.dart';
import 'package:ebasket_driver/app/model/tax_model.dart';
import 'package:ebasket_driver/app/ui/otp_verification_screen/otp_verification_screen.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:ebasket_driver/widgets/network_image_widget.dart';
import 'package:ebasket_driver/widgets/round_button_fill.dart';
import 'package:get/get.dart';

class DeliverOrderDetailsScreen extends StatelessWidget {
  const DeliverOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: OrderDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.white,
          appBar: CommonUI.customAppBar(
            context,
            title: Text('Deliver Order'.tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
            isBack: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade100, width: 1),
                        color: AppThemeData.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: #${controller.orderModel.value.id.toString()}',
                              style: const TextStyle(color: AppThemeData.black, fontSize: 20, fontFamily: AppThemeData.semiBold),
                            ),
                            const SizedBox(height: 10),
                            Text(controller.orderModel.value.user!.fullName.toString(),
                                style: const TextStyle(color: AppThemeData.black, fontSize: 16, fontFamily: AppThemeData.medium)),
                            const SizedBox(height: 5),
                            Text(
                                // controller.orderModel.value.user!.businessAddress.toString(),
                                controller.orderModel.value.address!.getFullAddress().toString(),
                                style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Items'.tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 18)),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.orderModel.value.products.length,
                    itemBuilder: (context, index) {
                      ProductModel productList = controller.orderModel.value.products[index];
                      return ProductItemWidget(
                        productList: productList,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade100, width: 1),
                        color: AppThemeData.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Obx(() => Checkbox(
                                    value: controller.confirmOrder.value,
                                    onChanged: (value) {
                                      controller.confirmOrder.value = value!;
                                    },
                                    activeColor: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                    checkColor: AppThemeData.groceryAppDarkBlue,
                                  )),
                            ),
                            // const SizedBox(width: 10),
                            Text('Given ${controller.orderModel.value.products.length} items to Customer',
                                style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Item Total".tr,
                          style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                        ),
                        Text(
                          Constant.amountShow(amount: controller.subTotal.value.toString()),
                          style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Discount".tr,
                            style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                          ),
                          Text(
                            Constant.amountShow(amount: controller.discount.value.toString()),
                            style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: controller.orderModel.value.taxModel!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      TaxModel taxModel = controller.orderModel.value.taxModel![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                taxModel.title.toString(),
                                style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                              ),
                            ),
                            Obx(
                              () => Text(
                                Constant.amountShow(
                                    amount: Constant.calculateTax(
                                            amount: (double.parse(controller.subTotal.value.toString()) - double.parse(controller.discount.value.toString())).toString(),
                                            taxModel: taxModel)
                                        .toString()),
                                style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Charges".tr,
                          style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                        ),
                        Text(
                          controller.orderModel.value.deliveryCharge != '0' ? Constant.amountShow(amount: controller.orderModel.value.deliveryCharge.toString()) : "FREE",
                          style: const TextStyle(fontSize: 14, color: AppThemeData.groceryAppDarkBlue, fontWeight: FontWeight.w600, fontFamily: AppThemeData.extraBold),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppThemeData.black.withOpacity(0.50),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Billing Amount'.tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 16)),
                        Text(Constant.amountShow(amount: controller.totalAmount.value.toString()),
                            style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 16)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Mode'.tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 16)),
                        Text(" (${controller.orderModel.value.paymentMethod})", style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: RoundedButtonFill(
              title: "Delivered".tr,
              color: AppThemeData.groceryAppDarkBlue,
              textColor: AppThemeData.white,
              fontFamily: AppThemeData.bold,
              onPress: () {
                if (controller.confirmOrder.value) {
                  paymentReceivedBottomSheet(context, controller.selectPaymentRadioListTile.value, controller, controller.orderModel.value);
                } else {
                  ShowToastDialog.showToast("Please select your ${controller.orderModel.value.products.length} given items to customer!");
                }
              },
            ),
          ),
        );
      },
    );
  }

  paymentReceivedBottomSheet(BuildContext context, selectPaymentRadioListTile, OrderDetailsController controller, OrderModel orderModel) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: Get.height * 0.35,
          decoration: const BoxDecoration(
            color: AppThemeData.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    'Payment Received'.tr,
                    style: const TextStyle(fontFamily: AppThemeData.semiBold, fontSize: 24, color: AppThemeData.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Have you successfully received your".tr,
                      maxLines: 2, style: const TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                ),
                Center(
                  child: Text(
                      //  selectPaymentRadioListTile == 'Online' ? "payment in online?".tr :
                      selectPaymentRadioListTile == 'Cash On Delivery' ? "payment in cash?" : "payment in online?".tr,
                      // : "payment in cheque?",
                      maxLines: 2,
                      style: const TextStyle(color: AppThemeData.black, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: AppThemeData.medium)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppThemeData.white,
                            padding: const EdgeInsets.all(8),
                            side: const BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 2),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'No'.tr,
                              style: const TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            backgroundColor: AppThemeData.groceryAppDarkBlue,
                            padding: const EdgeInsets.all(8),
                            side: const BorderSide(color: AppThemeData.groceryAppDarkBlue, width: 0.4),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Get.back();

                            await controller.updateOrder();
                            await Get.to(const OTPVerificationScreen(), arguments: {"orderId": orderModel.id});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'Yes'.tr,
                              style: const TextStyle(color: AppThemeData.white, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductModel productList;

  const ProductItemWidget({super.key, required this.productList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            color: AppThemeData.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppThemeData.black, width: 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NetworkImageWidget(
                      height: Responsive.height(5, context),
                      width: Responsive.width(10, context),
                      imageUrl: productList.photo.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList.name.toString(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: AppThemeData.black, fontSize: 12, overflow: TextOverflow.ellipsis, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  productList.discountPrice != null && productList.discountPrice != "0"
                                      ? Constant.amountShow(amount: (productList.quantity! * double.parse(productList.discountPrice!)).toString())
                                      : Constant.amountShow(amount: (productList.quantity! * double.parse(productList.price!)).toString()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                                ),
                              ),
                              productList.variantInfo == null || productList.variantInfo!.variantOptions!.isEmpty
                                  ? Container()
                                  : Wrap(
                                      spacing: 6.0,
                                      runSpacing: 6.0,
                                      children: List.generate(
                                        productList.variantInfo!.variantOptions!.length,
                                        (i) {
                                          return Text(
                                            "${productList.variantInfo!.variantOptions!.keys.elementAt(i)} : ${productList.variantInfo!.variantOptions![productList.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular),
                                          );
                                        },
                                      ).toList(),
                                    ),
                            ],
                          ),
                        ),
                        Text(
                          "${productList.quantity} qty",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: AppThemeData.semiBold, color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
