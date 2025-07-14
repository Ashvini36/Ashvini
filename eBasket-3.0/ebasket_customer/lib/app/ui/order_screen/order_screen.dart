import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/order_controller.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/order_details_screen/order_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';

class MyOrderListScreen extends StatelessWidget {
  const MyOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppThemeData.white,
        appBar:
        CommonUI.customAppBar(context, title: Text("My Orders".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
        body: GetX<OrderController>(
            init: OrderController(),
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SizedBox(
                  height: Responsive.height(90, context),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                controller.selectOrderStatusRadioListTile.value = 'All';
                                controller.update();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'All',
                                    activeColor: AppThemeData.groceryAppDarkBlue,
                                    groupValue: controller.selectOrderStatusRadioListTile.value,
                                    onChanged: (value) {
                                      controller.selectOrderStatusRadioListTile.value = value!;
                                      // controller.getFilterData('');
                                      controller.update();
                                    },
                                  ),
                                  Text(
                                    'All'.tr,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.selectOrderStatusRadioListTile.value = 'InProcess';
                                controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                controller.update();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'InProcess',
                                    activeColor: AppThemeData.groceryAppDarkBlue,
                                    groupValue: controller.selectOrderStatusRadioListTile.value,
                                    onChanged: (value) {
                                      controller.selectOrderStatusRadioListTile.value = value!;
                                      controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                      controller.update();
                                    },
                                  ),
                                  Text(
                                    'InProcess'.tr,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.selectOrderStatusRadioListTile.value = 'InTransit';
                                controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                controller.update();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'InTransit',
                                    activeColor: AppThemeData.groceryAppDarkBlue,
                                    groupValue: controller.selectOrderStatusRadioListTile.value,
                                    onChanged: (value) {
                                      controller.selectOrderStatusRadioListTile.value = value!;
                                      controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                      controller.update();
                                    },
                                  ),
                                  Text(
                                    'InTransit'.tr,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.selectOrderStatusRadioListTile.value = 'Delivered';
                                controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                controller.update();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'Delivered',
                                    activeColor: AppThemeData.groceryAppDarkBlue,
                                    groupValue: controller.selectOrderStatusRadioListTile.value,
                                    onChanged: (value) {
                                      controller.selectOrderStatusRadioListTile.value = value!;
                                      controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                      controller.update();
                                    },
                                  ),
                                  Text(
                                    'Delivered'.tr,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(CollectionName.orders)
                                .where("userID", isEqualTo: FireStoreUtils.getCurrentUid())
                                .orderBy("createdAt", descending: true)
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text('Something went wrong'.tr));
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Constant.loader();
                              }
                              List<QueryDocumentSnapshot> list = snapshot.data!.docs;
                              if (snapshot.data!.docs.isNotEmpty) {
                                controller.orderDataList.clear();
                                controller.allOrderDataList.clear();
                                for (var i = 0; i < list.length; i++) {
                                  dynamic data = snapshot.data!.docs[i].data() as Map<String, dynamic>;
                                  controller.allOrderDataList.add(OrderModel.fromJson(data));
                                }
                                if (controller.selectOrderStatusRadioListTile.value.isNotEmpty) {
                                  controller.getFilterData(controller.selectOrderStatusRadioListTile.value);
                                }
                              }

                              return controller.orderDataList.isEmpty
                                  ? Center(
                                child: Text("No orders found".tr),
                              )
                                  : ListView.builder(
                                itemCount: controller.orderDataList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  OrderModel orderList = controller.orderDataList[index];
                                  RxDouble total = 0.0.obs;
                                  RxDouble items = 0.0.obs;

                                  return InkWell(
                                    onTap: () {
                                      Get.to(const OrderDetailsScreen(), arguments: {
                                        "orderId": orderList.id,
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
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
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: Responsive.width(22, context),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Opacity(
                                                            opacity: 0.50,
                                                            child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              padding: const EdgeInsets.all(20),
                                                              decoration: ShapeDecoration(
                                                                color: Colors.white,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                shadows: const [
                                                                  BoxShadow(
                                                                    color: Color(0x3F000000),
                                                                    blurRadius: 4,
                                                                    offset: Offset(0, 0),
                                                                    spreadRadius: 0,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 10,
                                                            child: Container(
                                                              width: 70,
                                                              height: 70,
                                                              padding: const EdgeInsets.all(20),
                                                              decoration: ShapeDecoration(
                                                                color: Colors.white,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                                                                shadows: const [
                                                                  BoxShadow(
                                                                    color: Color(0x3F000000),
                                                                    blurRadius: 4,
                                                                    offset: Offset(0, 0),
                                                                    spreadRadius: 0,
                                                                  )
                                                                ],
                                                              ),
                                                              child: NetworkImageWidget(
                                                                height: Responsive.height(6, context),
                                                                width: Responsive.width(13, context),
                                                                imageUrl:
                                                                (orderList.products.first.photo.isNotEmpty) ? orderList.products.first.photo : Constant.placeholderImage,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            /*  Stack(
                                                                    children: [
                                                                      Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color: (orderList.status == Constant.inProcess || orderList.status == Constant.delivered)
                                                                                ? AppThemeData.groceryAppDarkBlue
                                                                                : orderList.status == Constant.orderCanceled
                                                                                    ? AppThemeData.colorRed
                                                                                    : orderList.status == Constant.orderComplete
                                                                                        ? AppThemeData.colorBlue
                                                                                        : AppThemeData.colorDullOrange,
                                                                            borderRadius: const BorderRadius.all(
                                                                              Radius.circular(12),
                                                                            ),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                                                                            child: Text(
                                                                              orderList.status == Constant.inProcess
                                                                                  ? Constant.inProcess
                                                                                  : orderList.status == Constant.orderCanceled
                                                                                      ? Constant.orderCanceled
                                                                                      : orderList.status == Constant.orderComplete
                                                                                          ? Constant.orderComplete
                                                                                          : orderList.status == Constant.inTransit
                                                                                              ? Constant.inTransit
                                                                                              : Constant.delivered,
                                                                              style: const TextStyle(
                                                                                  color: AppThemeData.white,
                                                                                  fontSize: 12,
                                                                                  fontFamily: AppThemeData.medium,
                                                                                  fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 20),
                                                                        child: SizedBox(
                                                                          width: Responsive.width(30, context),
                                                                          child: Text(
                                                                            '#${orderList.id.toString()}',
                                                                            textAlign: TextAlign.start,
                                                                            maxLines: 1,
                                                                            style: const TextStyle(
                                                                                color: AppThemeData.black,
                                                                                fontSize: 14,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                fontFamily: AppThemeData.semiBold,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),*/
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: (orderList.status == Constant.inProcess || orderList.status == Constant.delivered)
                                                                      ? AppThemeData.groceryAppDarkBlue
                                                                      : AppThemeData.colorDullOrange,
                                                                  borderRadius: const BorderRadius.all(
                                                                    Radius.circular(12),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                                                                  child: Text(
                                                                    orderList.status == Constant.inProcess
                                                                        ? Constant.inProcess
                                                                        : orderList.status == Constant.inTransit
                                                                        ? Constant.inTransit
                                                                        : Constant.delivered,
                                                                    style: const TextStyle(
                                                                        color: AppThemeData.white,
                                                                        fontSize: 12,
                                                                        fontFamily: AppThemeData.medium,
                                                                        fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Responsive.width(30, context),
                                                              child: Text(
                                                                '#${orderList.id.toString()}',
                                                                textAlign: TextAlign.start,
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                    color: AppThemeData.black,
                                                                    fontSize: 14,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    fontFamily: AppThemeData.semiBold,
                                                                    fontWeight: FontWeight.w600),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Responsive.width(35, context),
                                                              child: Text(
                                                                orderList.address!.getFullAddress().toString(),
                                                                textAlign: TextAlign.center,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    color: AppThemeData.black.withOpacity(0.50),
                                                                    fontSize: 12,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    fontFamily: AppThemeData.regular,
                                                                    fontWeight: FontWeight.w400),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: SizedBox(
                                                                    width: Responsive.width(20, context),
                                                                    height: Responsive.height(2, context),
                                                                    child: ListView.builder(
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        itemCount: orderList.products.length,
                                                                        shrinkWrap: true,
                                                                        itemBuilder: (context, index) {
                                                                          items.value += double.parse(orderList.products[index].quantity.toString());
                                                                          return Obx(
                                                                                () =>
                                                                                SizedBox(
                                                                                  width: Responsive.width(30, context),
                                                                                  height: Responsive.height(10, context),
                                                                                  child: Text(
                                                                                    '${items.value.round().toString()} items',
                                                                                    textAlign: TextAlign.start,
                                                                                    style: TextStyle(
                                                                                        color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible: orderList.status == Constant.inProcess || orderList.status == Constant.inTransit,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "OTP".tr,
                                                                        style: const TextStyle(
                                                                            color: AppThemeData.black,
                                                                            //  fontSize: 12,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Text(
                                                                        " : ${orderList.otp}",
                                                                        style: TextStyle(
                                                                            color: AppThemeData.black.withOpacity(0.50),
                                                                            fontSize: 12,
                                                                            fontFamily: AppThemeData.regular,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Divider(
                                                  color: AppThemeData.black.withOpacity(0.40),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      orderList.createdAt.toDate().formatDate(),
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                          color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.bold, fontWeight: FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      width: Responsive.width(20, context),
                                                      height: Responsive.height(2, context),
                                                      child: ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: orderList.products.length,
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index1) {
                                                            if (orderList.products[index1].discountPrice != '0') {
                                                              total.value += double.parse(orderList.products[index1].discountPrice!) * orderList.products[index1].quantity;
                                                            } else {
                                                              total.value += double.parse(orderList.products[index1].price) * orderList.products[index1].quantity;
                                                            }
                                                            return Obx(
                                                                  () =>
                                                                  SizedBox(
                                                                    height: Responsive.height(3.7, context),
                                                                    child: Text(
                                                                      Constant.amountShow(amount: total.value.toString()),
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                          color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.bold, fontWeight: FontWeight.w700),
                                                                    ),
                                                                  ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
