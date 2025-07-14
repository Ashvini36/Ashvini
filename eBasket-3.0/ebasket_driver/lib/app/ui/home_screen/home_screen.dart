import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_driver/widgets/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_driver/app/controller/home_controller.dart';
import 'package:ebasket_driver/app/controller/order_details_controller.dart';
import 'package:ebasket_driver/app/model/order_model.dart';
import 'package:ebasket_driver/app/ui/notification_screen/notification_screen.dart';
import 'package:ebasket_driver/app/ui/order_screen/order_details_screen.dart';
import 'package:ebasket_driver/app/ui/profile_screen/profile_screen.dart';
import 'package:ebasket_driver/constant/collection_name.dart';
import 'package:ebasket_driver/constant/constant.dart';
import 'package:ebasket_driver/theme/app_theme_data.dart';
import 'package:ebasket_driver/theme/responsive.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppThemeData.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppThemeData.white,
                elevation: 0,
                titleSpacing: 10,
                leadingWidth: 60,
                surfaceTintColor: AppThemeData.white,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Image.asset(
                    "assets/icons/ic_logo.png",
                  ),
                ),
                title: Text(
                  "eBasket".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppThemeData.black,
                    fontSize: 20,
                    fontFamily: AppThemeData.semiBold,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(const ProfileScreen())!.then((value) {
                              controller.getData();
                            });
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: Responsive.height(5, context),
                                height: Responsive.height(5, context),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                                  border: Border.all(
                                    color: AppThemeData.groceryAppDarkBlue,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: controller.userModel.value.profilePictureURL.toString() != "null" && controller.userModel.value.profilePictureURL.toString().isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(controller.userModel.value.profilePictureURL.toString()),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(Constant.placeHolder),
                                        ),
                                ),
                              ),
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_circle.svg",
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(const NotificationScreen());
                            },
                            child: SvgPicture.asset(
                              "assets/icons/ic_notification.svg",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: DefaultTabController(
                          length: 2,
                          child: Builder(builder: (BuildContext context) {
                            final TabController tabController = DefaultTabController.of(context);
                            tabController.addListener(() {
                              if (!tabController.indexIsChanging) {
                                controller.tabIndex.value = tabController.index;
                                controller.update();
                              }
                            });
                            return Column(
                              children: [
                                TabBar(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  splashFactory: NoSplash.splashFactory,
                                  labelPadding: EdgeInsets.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  dividerColor: Colors.transparent,
                                  indicator: const BoxDecoration(color: Colors.transparent),
                                  onTap: (index) {
                                    //your currently selected index
                                    controller.tabIndex.value = index;
                                    controller.update();
                                  },
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: controller.tabIndex.value == 0 ? AppThemeData.groceryAppDarkBlue : AppThemeData.white,
                                                border: Border.all(color: AppThemeData.groceryAppDarkBlue, width: 1)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "New Order".tr,
                                                    style: const TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(right: 3),
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: controller.tabIndex.value == 0 ? AppThemeData.white : AppThemeData.black,
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                  ),
                                                  child: Center(
                                                    child: StreamBuilder<QuerySnapshot>(
                                                        stream: FirebaseFirestore.instance
                                                            .collection(CollectionName.orders)
                                                            .where("driverID", isEqualTo: controller.userModel.value.id)
                                                            .where('status', whereIn: [Constant.inProcess, Constant.inTransit])
                                                            .orderBy("createdAt", descending: true)
                                                            .snapshots(),
                                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                          return snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.data!.docs.isEmpty
                                                              ? Text(
                                                                  '00',
                                                                  style: TextStyle(
                                                                      color: controller.tabIndex.value == 0 ? AppThemeData.black : AppThemeData.white,
                                                                      fontSize: 12,
                                                                      fontFamily: AppThemeData.bold
                                                                      // fontSize: 10,
                                                                      ),
                                                                  textAlign: TextAlign.center,
                                                                )
                                                              : Text(
                                                                  snapshot.data!.docs.length.toString().length == 1
                                                                      ? "0${snapshot.data!.docs.length}"
                                                                      : snapshot.data!.docs.length.toString(),
                                                                  style: TextStyle(
                                                                      color: controller.tabIndex.value == 0 ? AppThemeData.black : AppThemeData.white,
                                                                      fontSize: 12,
                                                                      fontFamily: AppThemeData.bold
                                                                      // fontSize: 10,
                                                                      ),
                                                                  textAlign: TextAlign.center,
                                                                );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: controller.tabIndex.value == 1 ? AppThemeData.groceryAppDarkBlue : AppThemeData.white,
                                                border: Border.all(color: AppThemeData.groceryAppDarkBlue, width: 1)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                    child: Text("Previous Order".tr, style: TextStyle(color: AppThemeData.black, fontSize: 14, fontFamily: AppThemeData.regular))),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(right: 3),
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: controller.tabIndex.value == 1 ? AppThemeData.white : AppThemeData.black,
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                  ),
                                                  child: Center(
                                                    child: StreamBuilder<QuerySnapshot>(
                                                        stream: FirebaseFirestore.instance
                                                            .collection(CollectionName.orders)
                                                            .where("driverID", isEqualTo: controller.userModel.value.id.toString())
                                                            .where('status', whereIn: [Constant.orderComplete, Constant.delivered])
                                                            .orderBy("createdAt", descending: true)
                                                            .snapshots(),
                                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                          return snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.data!.docs.isEmpty
                                                              ? Text(
                                                                  '00',
                                                                  style: TextStyle(
                                                                      color: controller.tabIndex.value == 1 ? AppThemeData.black : AppThemeData.white,
                                                                      fontSize: 12,
                                                                      fontFamily: AppThemeData.bold
                                                                      // fontSize: 10,
                                                                      ),
                                                                  textAlign: TextAlign.center,
                                                                )
                                                              : Text(
                                                                  snapshot.data!.docs.length.toString().length == 1
                                                                      ? "0${snapshot.data!.docs.length}"
                                                                      : snapshot.data!.docs.length.toString(),
                                                                  style: TextStyle(
                                                                      color: controller.tabIndex.value == 1 ? AppThemeData.black : AppThemeData.white,
                                                                      fontSize: 12,
                                                                      fontFamily: AppThemeData.bold),
                                                                  textAlign: TextAlign.center,
                                                                );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                    child: TabBarView(
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(CollectionName.orders)
                                            .where("driverID", isEqualTo: controller.userModel.value.id)
                                            .where("status", whereIn: [Constant.inProcess, Constant.inTransit])
                                            .orderBy("createdAt", descending: true)
                                            .snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(child: Text('Something went wrong'.tr));
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Constant.loader();
                                          }
                                          return snapshot.data!.docs.isEmpty
                                              ? Center(
                                                  child: Constant.emptyView(
                                                      image: "assets/icons/no_record.png", text: "Empty".tr, description: "You don’t have any new orders at this time"))
                                              : ListView.builder(
                                                  itemCount: snapshot.data!.docs.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    OrderModel orders = OrderModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                                                    return orders.status.toString() == 'Delivered'
                                                        ? const SizedBox()
                                                        : InkWell(
                                                            onTap: () {
                                                              Get.to(const OrderDetailsScreen(), arguments: {"orderId": orders.id})!.then((value) {
                                                                Get.delete<OrderDetailsController>();
                                                              });
                                                            },
                                                            child: Container(
                                                                color: AppThemeData.white,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      color: AppThemeData.white,
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color: Colors.grey,
                                                                          blurRadius: 4,
                                                                          offset: Offset(0, 0),
                                                                          spreadRadius: 0,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: orders.status == 'InProcess'
                                                                                ? AppThemeData.colorLightGreen
                                                                                : AppThemeData.colorDullOrange.withOpacity(0.50),
                                                                            borderRadius: const BorderRadius.only(
                                                                              topLeft: Radius.circular(16),
                                                                              topRight: Radius.circular(16),
                                                                            ),
                                                                            border: Border(
                                                                              bottom: BorderSide(color: AppThemeData.black.withOpacity(0.20)),
                                                                            ),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  orders.createdAt.toDate().formatDate(),
                                                                                  style: const TextStyle(color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.bold),
                                                                                ),
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: orders.status == 'InProcess'
                                                                                        ? AppThemeData.groceryAppDarkBlue
                                                                                        : AppThemeData.colorDullOrange,
                                                                                    borderRadius: const BorderRadius.all(
                                                                                      Radius.circular(12),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                                                                                    child: Text(
                                                                                      orders.status.toString(),
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.white,
                                                                                          fontSize: 12,
                                                                                          fontFamily: AppThemeData.medium,
                                                                                          fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      orders.user!.fullName.toString(),
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.black, fontSize: 16, fontFamily: AppThemeData.semiBold),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      'Order ID: #${orders.id.toString()}',
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.semiBold),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      // 'Deliver To: ${orders.user!.businessAddress.toString()}',
                                                                                      'Deliver To: ${orders.address!.getFullAddress()}',
                                                                                      maxLines: 3,
                                                                                      style: TextStyle(
                                                                                          color: AppThemeData.black.withOpacity(0.50),
                                                                                          fontSize: 10,
                                                                                          fontFamily: AppThemeData.regular),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                          );
                                                  });
                                        }),
                                    StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(CollectionName.orders)
                                            .where("driverID", isEqualTo: controller.userModel.value.id)
                                            .where('status', whereIn: [Constant.orderComplete, Constant.delivered])
                                            .orderBy("createdAt", descending: true)
                                            .snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(child: Text('Something went wrong'.tr));
                                          }
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Constant.loader();
                                          }
                                          return snapshot.data!.docs.isEmpty
                                              ? Center(
                                                  child:
                                                      Constant.emptyView(image: "assets/icons/no_record.png", text: "Empty".tr, description: "You don’t have any previous orders"))
                                              : ListView.builder(
                                                  itemCount: snapshot.data!.docs.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    OrderModel orders = OrderModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);

                                                    return orders.status.toString() == 'Delivered'
                                                        ? InkWell(
                                                            onTap: () {
                                                              Get.to(const OrderDetailsScreen(), arguments: {"orderId": orders.id})!.then((value) {
                                                                Get.delete<OrderDetailsController>();
                                                              });
                                                            },
                                                            child: Container(
                                                                color: AppThemeData.white,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(16),
                                                                      color: AppThemeData.white,
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                          color: Colors.grey,
                                                                          blurRadius: 4,
                                                                          offset: Offset(0, 0),
                                                                          spreadRadius: 0,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: AppThemeData.colorLightGreen,
                                                                            borderRadius: const BorderRadius.only(
                                                                              topLeft: Radius.circular(16),
                                                                              topRight: Radius.circular(16),
                                                                            ),
                                                                            border: Border(
                                                                              bottom: BorderSide(color: AppThemeData.black.withOpacity(0.20)),
                                                                            ),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  orders.createdAt.toDate().formatDate(),
                                                                                  style: const TextStyle(color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.bold),
                                                                                ),
                                                                                Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    color: AppThemeData.groceryAppDarkBlue,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(12),
                                                                                    ),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                                                                                    child: Text(
                                                                                      orders.status.toString(),
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.white,
                                                                                          fontSize: 12,
                                                                                          fontFamily: AppThemeData.medium,
                                                                                          fontWeight: FontWeight.w500),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      orders.user!.fullName.toString(),
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.black, fontSize: 16, fontFamily: AppThemeData.semiBold),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      'Order ID: #${orders.id.toString()}',
                                                                                      style: const TextStyle(
                                                                                          color: AppThemeData.black, fontSize: 12, fontFamily: AppThemeData.semiBold),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      // 'Deliver To: ${orders.user!.businessAddress!.toString()}',
                                                                                      'Deliver To:  "${orders.address!.getFullAddress()}"',
                                                                                      maxLines: 3,
                                                                                      style: TextStyle(
                                                                                          color: AppThemeData.black.withOpacity(0.50),
                                                                                          fontSize: 10,
                                                                                          fontFamily: AppThemeData.regular),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                          )
                                                        : const SizedBox();
                                                  });
                                        }),
                                  ],
                                ))
                              ],
                            );
                          })),
                    ));
        });
  }
}
