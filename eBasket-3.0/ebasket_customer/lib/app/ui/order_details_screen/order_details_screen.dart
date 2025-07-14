import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/app/ui/download_invoice/file_handle_api.dart';
import 'package:ebasket_customer/app/ui/download_invoice/invoice_pdf_template.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/order_details_controller.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: OrderDetailsController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: CommonUI.customAppBar(context,
                  title: Text("Bill Details".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
              body: StreamBuilder(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Order Date".tr,
                                                style: TextStyle(
                                                    fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  orderModel.createdAt.toDate().formatDate(),
                                                  style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Order #".tr,
                                                style: TextStyle(
                                                    fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: SizedBox(
                                                  width: Responsive.width(30, context),
                                                  child: Text(
                                                    orderModel.id.toString(),
                                                    maxLines: 1,
                                                    style:
                                                        const TextStyle(fontSize: 12, color: AppThemeData.black, overflow: TextOverflow.ellipsis, fontFamily: AppThemeData.regular),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Order Total".tr,
                                                style: TextStyle(
                                                    fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Obx(
                                                  () => Text(
                                                    Constant.amountShow(amount: controller.totalAmount.value.toString()),
                                                    style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: AppThemeData.black.withOpacity(0.40),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                      child: InkWell(
                                        onTap: () async {
                                          RxString? state = ''.obs;
                                          await placemarkFromCoordinates(orderModel.address!.location!.latitude, orderModel.address!.location!.longitude)
                                              .then((valuePlaceMaker) async {
                                            List<Placemark> placeMarks =
                                                await placemarkFromCoordinates(orderModel.address!.location!.latitude, orderModel.address!.location!.longitude);
                                            state.value = placeMarks.first.administrativeArea.toString();
                                          });
                                          final pdf = await CreateInvoicePdf.generate(orderModel, state.value);

                                          FileHandleApi.openFile(pdf);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Download Invoice".tr,
                                              style: TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_right_rounded,
                                              color: Colors.black,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Shipment Details".tr,
                                style: TextStyle(fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderModel.status,
                                          style:
                                              TextStyle(fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            orderModel.estimatedTimeToPrepare.toString(),
                                            style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            Constant.dateFormatTimestamp(controller.orderModel.value.createdAt),
                                            style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Visibility(
                                            visible: orderModel.status == Constant.inProcess || orderModel.status == Constant.inTransit,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "OTP".tr,
                                                  style: TextStyle(
                                                      fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                                ),
                                                Text(
                                                  " : ${orderModel.otp}",
                                                  style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Order Summary".tr,
                                style: TextStyle(fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.medium),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: orderModel.products.length,
                                    itemBuilder: (context, index) {
                                      CartProduct productList = orderModel.products[index];
                                      // controller.quantity.value = productList.quantity;
                                      return ProductItemWidget(
                                        productList: productList,
                                      );
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            buildTotalRow(orderModel.products, orderModel, controller, context),
                            if (orderModel.driver != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.0),
                                    child: Text(
                                      "Driver Details".tr,
                                      style: TextStyle(fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          if (orderModel.driver!.profilePictureURL!.isNotEmpty)
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(80),
                                                child: Image.network(
                                                  width: 50,
                                                  height: 50,
                                                  orderModel.driver!.profilePictureURL.toString(),
                                                  fit: BoxFit.cover,
                                                )),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    orderModel.driver!.name.toString(),
                                                    style: TextStyle(
                                                        fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(
                                                      orderModel.driver!.email.toString(),
                                                      style:
                                                          const TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              String url = 'tel:${orderModel.driver!.countryCode.toString() + orderModel.driver!.phoneNumber.toString()}';
                                              launchUrl(Uri.parse(url.toString()));
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(20)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.phone, color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Store Details".tr,
                                style: TextStyle(fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Store Address: ',
                                            style: TextStyle(fontSize: 12, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                          ),
                                          Expanded(
                                            child: Text(
                                              orderModel.vendor!.location.toString(),
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 12, color: AppThemeData.black.withOpacity(0.50), fontWeight: FontWeight.w600, fontFamily: AppThemeData.semiBold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        String url = 'tel:${orderModel.vendor!.phonenumber}';
                                        launchUrl(Uri.parse(url.toString()));
                                      },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        decoration: BoxDecoration(color: AppThemeData.groceryAppDarkBlue, borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.phone, color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Payment Information".tr,
                                style: TextStyle(fontSize: 16, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
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
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Methods".tr,
                                      style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.semiBold),
                                    ),
                                    Text(
                                      orderModel.paymentMethod == 'Cash On Delivery' ? 'Cash On Delivery'.tr : orderModel.paymentMethod.toString(),
                                      style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                      child: Divider(
                                        color: AppThemeData.black.withOpacity(0.50),
                                      ),
                                    ),
                                    Text(
                                      "Billing Address".tr,
                                      style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.semiBold),
                                    ),
                                    Text(
                                      //  orderModel.user!.businessAddress.toString(),
                                      orderModel.address!.getFullAddress().toString(),
                                      style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                      child: Divider(
                                        color: AppThemeData.black.withOpacity(0.50),
                                      ),
                                    ),
                                    Text(
                                      "Shipping Address".tr,
                                      style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.semiBold),
                                    ),
                                    Text(
                                      orderModel.user!.fullName.toString(),
                                      style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                    ),
                                    Text(
                                      orderModel.address!.getFullAddress().toString(),
                                      //  orderModel.user!.businessAddress.toString(),
                                      style: const TextStyle(fontSize: 12, color: AppThemeData.black, fontFamily: AppThemeData.regular),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  }));
        });
  }

  Widget buildTotalRow(List<CartProduct> data, OrderModel orderModel, OrderDetailsController controller, BuildContext context) {
    controller.subTotal.value = 0.00;
    controller.totalAmount.value = 0.0;
    controller.quantity.value = 0;
    for (int a = 0; a < data.length; a++) {
      CartProduct e = data[a];
      controller.quantity.value += e.quantity;
      if (e.discountPrice != '0') {
        controller.subTotal.value += double.parse(e.discountPrice!) * e.quantity;
      } else {
        controller.subTotal.value += double.parse(e.price) * e.quantity;
      }
    }
    discountCalculation(controller, orderModel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_clock.svg",
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery in  ${orderModel.estimatedTimeToPrepare}',
                              style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w700, fontFamily: AppThemeData.bold),
                            ),
                            Text(
                              "Shipment of ${controller.quantity.value} items",
                              style: const TextStyle(fontSize: 10, color: AppThemeData.black, fontWeight: FontWeight.w400, fontFamily: AppThemeData.regular),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
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
                        style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                      ),
                      Text(
                        orderModel.deliveryCharge != '0' ? Constant.amountShow(amount: orderModel.deliveryCharge.toString()) : "FREE",
                        style: TextStyle(fontSize: 14, color: AppThemeData.groceryAppDarkBlue, fontWeight: FontWeight.w600, fontFamily: AppThemeData.extraBold),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppThemeData.black.withOpacity(0.50),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total".tr,
                        style: TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w500, fontFamily: AppThemeData.semiBold),
                      ),
                      Obx(
                        () => Text(
                          Constant.amountShow(amount: controller.totalAmount.value.toString()),
                          style: const TextStyle(fontSize: 14, color: AppThemeData.black, fontWeight: FontWeight.w600, fontFamily: AppThemeData.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  discountCalculation(OrderDetailsController controller, OrderModel orderModel) {
    controller.totalAmount.value = 0.0;

    if (orderModel.coupon!.id != null) {
      if (orderModel.coupon!.discountType == "Fix Price") {
        controller.discount.value = double.parse(orderModel.coupon!.discount.toString());
      } else {
        controller.discount.value = double.parse(controller.subTotal.value.toString()) * double.parse(orderModel.coupon!.discount.toString()) / 100;
      }
    }
    controller.totalAmount.value = controller.subTotal.value + double.parse(orderModel.deliveryCharge.toString());

    controller.totalAmount.value = controller.totalAmount.value - controller.discount.value;

    String taxAmount = " 0.0";
    if (orderModel.taxModel != null) {
      for (var element in orderModel.taxModel!) {
        taxAmount = (double.parse(taxAmount) + Constant.calculateTax(amount: (controller.subTotal.value - controller.discount.value).toString(), taxModel: element)).toString();
      }
    }
    controller.totalAmount.value += double.parse(taxAmount);
  }
}

class ProductItemWidget extends StatelessWidget {
  final CartProduct productList;

  const ProductItemWidget({super.key, required this.productList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productList.name.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(color: AppThemeData.black, fontSize: 12, overflow: TextOverflow.ellipsis, fontFamily: AppThemeData.regular, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          productList.discountPrice != '0'
                              ? Constant.amountShow(amount: (productList.quantity * double.parse(productList.discountPrice.toString())).toString())
                              : Constant.amountShow(amount: (productList.quantity * double.parse(productList.price)).toString()),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.semiBold, fontWeight: FontWeight.w600),
                        ),
                        productList.variant_info == null || productList.variant_info.variantOptions!.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children: List.generate(
                                    productList.variant_info.variantOptions!.length,
                                    (i) {
                                      return Text(
                                        "${productList.variant_info.variantOptions!.keys.elementAt(i)} : ${productList.variant_info.variantOptions![productList.variant_info.variantOptions!.keys.elementAt(i)]}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "${productList.quantity.toString()} Quantity",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(color: AppThemeData.groceryAppDarkBlue, fontSize: 12, fontFamily: AppThemeData.bold, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
