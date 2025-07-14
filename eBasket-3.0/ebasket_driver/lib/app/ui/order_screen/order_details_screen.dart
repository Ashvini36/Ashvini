import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_driver/app/model/notification_payload_model.dart';
import 'package:ebasket_driver/app/model/user_model.dart';
import 'package:ebasket_driver/constant/send_notification.dart';
import 'package:ebasket_driver/services/firebase_helper.dart';
import 'package:ebasket_driver/services/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_driver/app/controller/order_details_controller.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/model/product_model.dart';
import 'package:ebasket_driver/app/model/tax_model.dart';
import 'package:ebasket_driver/app/ui/order_screen/reach_drop_location_screen.dart';
import 'package:ebasket_driver/constant/collection_name.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:ebasket_driver/widgets/common_ui.dart';
import 'package:ebasket_driver/widgets/network_image_widget.dart';
import 'package:ebasket_driver/widgets/round_button_fill.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: OrderDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppThemeData.white,
          appBar: CommonUI.customAppBar(
            context,
            title: Text("Order Details".tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
            isBack: true,
            actions: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection(CollectionName.orders).doc(controller.orderId.toString()).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'.tr));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Constant.loader();
                    }

                    OrderModel orderModel = OrderModel.fromJson(snapshot.data!.data()!);
                    return orderModel.status.toString() == Constant.inProcess || orderModel.status.toString() == Constant.inTransit
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(const ReachDropLocationScreen(), arguments: {'orderId': orderModel.id});
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_track.svg",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  })
            ],
          ),
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection(CollectionName.orders).doc(controller.orderId.toString()).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'.tr));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Constant.loader();
                }

                OrderModel orderModel = OrderModel.fromJson(snapshot.data!.data()!);
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(orderModel.vendor!.authorName.toString(),
                                      style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.medium, fontSize: 16))),
                              Center(
                                  child: Text(orderModel.vendor!.location.toString(),
                                      style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.regular, fontSize: 14))),
                            ],
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: Responsive.width(10.5, context),
                                        height: Responsive.height(5, context),
                                        placeholder: (context, url) => Image.network(
                                              Constant.placeHolder,
                                              fit: BoxFit.fill,
                                            ),
                                        errorWidget: (_, s, image) => Image.network(
                                              Constant.placeHolder,
                                              fit: BoxFit.fill,
                                            ),
                                        imageUrl: orderModel.user!.image! ?? '')),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(orderModel.user!.fullName.toString(), style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.bold, fontSize: 14)),
                                        Text('Order ID: #${orderModel.id.toString()}',
                                            style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.regular, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (orderModel.status == Constant.inTransit)
                                  InkWell(
                                    onTap: () {
                                      Constant.makePhoneCall(orderModel.user!.countryCode! + orderModel.user!.phoneNumber.toString());
                                    },
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: AppThemeData.groceryAppDarkBlue.withOpacity(0.20),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_calling.svg",
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
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
                          itemCount: orderModel.products.length,
                          itemBuilder: (context, index) {
                            ProductModel productList = orderModel.products[index];

                            return ProductItemWidget(
                              productList: productList,
                            );
                          }),
                      buildTotalRow(orderModel, controller, context),
                    ],
                  ),
                ));
              }),
          bottomNavigationBar: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(CollectionName.orders).doc(controller.orderId.toString()).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Constant.loader();
              }

              OrderModel orderModel = OrderModel.fromJson(snapshot.data!.data()!);
              return orderModel.status == Constant.inProcess
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: RoundedButtonFill(
                        title: "Picked Order".tr,
                        color: AppThemeData.groceryAppDarkBlue,
                        textColor: AppThemeData.white,
                        fontFamily: AppThemeData.bold,
                        onPress: () async {
                          ShowToastDialog.showLoader("Please wait".tr);
                          UserModel? userData = await FireStoreUtils.getUser(controller.orderModel.value.userID);
                          NotificationPayload notificationPayload = NotificationPayload(
                              id: Constant.getUuid(),
                              userId: userData!.id.toString(),
                              title: "Order Pickup",
                              body: "Order Pickup Successfully.",
                              createdAt: Timestamp.now(),
                              role: Constant.USER_ROLE_CUSTOMER,
                              notificationType: "orderPickUp",
                              orderId: controller.orderId.value);

                          Map<String, dynamic> playLoad = <String, dynamic>{
                            "type": "orderPickUp",
                          };

                          await SendNotification.sendOneNotification(
                              token: userData.fcmToken.toString(), title: "Order Pickup", body: "Order Pickup Successfully.", payload: playLoad);
                          await FireStoreUtils.setNotification(notificationPayload);

                          await controller.updateOrder();
                          await Get.to(const ReachDropLocationScreen(), arguments: {
                            "orderId": controller.orderId.value,
                          });
                          ShowToastDialog.closeLoader();
                        },
                      ),
                    )
                  : const Offstage();
            },
          ),
        );
      },
    );
  }

  Widget buildTotalRow(OrderModel orderModel, OrderDetailsController controller, BuildContext context) {
    controller.calculation(orderModel);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item Total".tr,
                style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
              ),
              Text(
                Constant.amountShow(amount: controller.subTotal.value.toString()),
                style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
              ),
            ],
          ),
        ),
        Padding(
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
        ListView.builder(
          itemCount: orderModel.taxModel!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TaxModel taxModel = orderModel.taxModel![index];
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
                  Text(
                    Constant.amountShow(
                        amount: Constant.calculateTax(
                                amount: (double.parse(controller.subTotal.value.toString()) - double.parse(controller.discount.value.toString())).toString(), taxModel: taxModel)
                            .toString()),
                    style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
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
                orderModel.deliveryCharge != '0' ? Constant.amountShow(amount: orderModel.deliveryCharge.toString()) : "FREE",
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
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment Mode'.tr, style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 16)),
                orderModel.paymentMethod.toString() == "Cash On Delivery"
                    ? Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppThemeData.white, border: Border.all(color: AppThemeData.groceryAppDarkBlue, width: 1)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Cash On Delivery".tr, style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontFamily: AppThemeData.bold, fontSize: 12)),
                        ))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(orderModel.paymentMethod.toString(), style: const TextStyle(color: AppThemeData.groceryAppDarkBlue, fontFamily: AppThemeData.bold, fontSize: 12)),
                      ),
              ],
            )),
      ],
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
