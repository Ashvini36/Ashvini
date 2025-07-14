import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/order_details_controller.dart';
import 'package:scaneats/app/controller/pos_table_controller.dart';
import 'package:scaneats/app/model/dining_table_model.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/app/model/tax_model.dart';
import 'package:scaneats/app/ui/item_screen/widget_item.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class PosTableListView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const PosTableListView({super.key, this.crossAxisCount = 10, this.childAspectRatio = 1});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PosTableController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: TextCustom(title: 'All Tables (${controller.diningTableList.length})', maxLine: 1, fontSize: 16, fontFamily: AppThemeData.semiBold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: Responsive.height(Responsive.isMobile(context) ? 85 : 85, context),
                  child: controller.diningTableList.isEmpty || controller.isTableLoading.value
                      ? SizedBox(
                          width: Responsive.width(100, context),
                          height: Responsive.height(90, context),
                          child: Constant.loaderWithNoFound(context, isLoading: controller.isTableLoading.value, isNotFound: controller.diningTableList.isEmpty))
                      : GridView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: controller.diningTableList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 150, childAspectRatio: childAspectRatio, crossAxisCount: crossAxisCount),
                          itemBuilder: (context, index) {
                            DiningTableModel model = controller.diningTableList[index];
                            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                future: FireStoreUtils.fireStore
                                    .collection(CollectionName.restaurants)
                                    .doc(CollectionName.restaurantId)
                                    .collection(CollectionName.order)
                                    .where("branchId", isEqualTo: Constant.selectedBranch.id.toString())
                                    .where("tableId", isEqualTo: model.id)
                                    .where('status', isNotEqualTo: Constant.statusRejected)
                                    .where("paymentStatus", isEqualTo: false)
                                    .orderBy('createdAt', descending: false)
                                    .get(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return SizedBox(); //height: 80, child: Center(child: Constant.loader(context))
                                    default:
                                      if ((snapshot.data?.docs.isEmpty == true || snapshot.hasError)) {
                                        return InkWell(
                                          onTap: () async {
                                            controller.selectTableId.value = model.id ?? '';
                                            controller.getOrderByTable(tableid: controller.selectTableId.value);
                                            showGlobalDrawer(
                                                duration: const Duration(milliseconds: 200),
                                                barrierDismissible: true,
                                                context: context,
                                                builder: productListDrawerBuilder(),
                                                direction: AxisDirection.right);
                                          },
                                          child: ContainerCustom(
                                              color: (themeChange.getThem() ? AppThemeData.black : AppThemeData.white),
                                              radius: 10,
                                              padding: const EdgeInsets.all(0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextCustom(
                                                    title: model.name ?? '',
                                                    fontSize: 18,
                                                  ),
                                                ],
                                              )),
                                        );
                                      }
                                      OrderModel orderModel = OrderModel.fromJson(snapshot.data!.docs.first.data());
                                      return orderModel.id != null
                                          ? InkWell(
                                              onTap: () async {
                                                controller.selectTableId.value = model.id ?? '';
                                                controller.getOrderByTable(tableid: controller.selectTableId.value);
                                                showGlobalDrawer(
                                                    duration: const Duration(milliseconds: 200),
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: productListDrawerBuilder(),
                                                    direction: AxisDirection.right);
                                              },
                                              child: ContainerCustom(
                                                color: (themeChange.getThem() ? AppThemeData.black : AppThemeData.white),
                                                radius: 10,
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Center(
                                                        child: TextCustom(
                                                          title: model.name ?? '',
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());
                                                        orderDetailsController.setOrderModel(orderModel);
                                                        showGlobalDrawer(
                                                            duration: const Duration(milliseconds: 200),
                                                            barrierDismissible: true,
                                                            context: context,
                                                            builder: orderDetailsDrawerBuilder(),
                                                            direction: AxisDirection.right);
                                                      },
                                                      child: ContainerCustom(
                                                        padding: EdgeInsets.all(0),
                                                        radius: 10,
                                                        color: AppThemeData.crusta500.withAlpha(75),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 5),
                                                            if (orderModel.createdAt != null)
                                                              TextCustom(
                                                                title: Constant.getCurrentTimeString(date: orderModel.createdAt!.toDate()),
                                                                fontSize: 13,
                                                                fontFamily: AppThemeData.medium,
                                                              ),
                                                            SizedBox(height: 5),
                                                            TextCustom(
                                                              title: Constant.amountShow(amount: orderModel.total ?? '0'),
                                                              fontSize: 13,
                                                              fontFamily: AppThemeData.medium,
                                                            ),
                                                            SizedBox(height: 5),
                                                            Icon(
                                                              Icons.visibility_outlined,
                                                              color: AppThemeData.crusta500,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                  }
                                });
                          },
                        ),
                ),
              ],
            ),
          );
        });
  }
}

WidgetBuilder productListDrawerBuilder() {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PosTableController>(
        init: PosTableController(),
        initState: (state) => state.controller!.searchController.value.text = '',
        builder: (controller) {
          return Drawer(
            width: 500,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
                child: IntrinsicWidth(
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          spaceH(),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                              )),
                          spaceH(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                                height: 55,
                                child: TextFieldWidget(
                                  fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                  borderColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                  bottom: 0,
                                  top: 0,
                                  hintText: 'Search product here...',
                                  controller: controller.searchController.value,
                                  onChanged: (String v) {
                                    if (v.isEmpty) {
                                      controller.getAllItem(name: v.toString());
                                    }
                                  },
                                  onSubmitted: (value) {
                                    controller.getAllItem(name: value.toString());
                                  },
                                  suffix: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                    child: SizedBox(
                                      width: 80,
                                      child: InkWell(
                                        onTap: () {
                                          controller.getAllItem(name: controller.searchController.value.text.trim());
                                        },
                                        child: ContainerCustom(
                                          color: AppThemeData.crusta500,
                                          radius: 30,
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          child: const TextCustom(title: 'Search', color: AppThemeData.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  prefix: IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset('assets/icons/search.svg',
                                          fit: BoxFit.contain, color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood950)),
                                )),
                          ),
                          spaceH(),
                          FutureBuilder<DiningTableModel?>(
                            future: FireStoreUtils.getDiningTableById(tableId: controller.selectTableId.value.toString()), // async work
                            builder: (BuildContext context, AsyncSnapshot<DiningTableModel?> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const TextCustom(title: 'Table Name : Loading...');
                                default:
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return TextCustom(title: "Table Name : ${snapshot.data?.name ?? ''}");
                                  }
                              }
                            },
                          ),
                          spaceH(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 36,
                              child: ListView.separated(
                                  separatorBuilder: (BuildContext context, int index) {
                                    return spaceW();
                                  },
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.itemCategoryList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    ItemCategoryModel model = controller.itemCategoryList[index];

                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedCategory.value = model;
                                        controller.getAllItem();
                                        controller.update();
                                      },
                                      child: Chip(
                                          backgroundColor: model.id == controller.selectedCategory.value.id
                                              ? AppThemeData.crusta500
                                              : themeChange.getThem()
                                                  ? AppThemeData.black
                                                  : AppThemeData.white,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: model.id == controller.selectedCategory.value.id
                                                      ? AppThemeData.crusta500
                                                      : themeChange.getThem()
                                                          ? AppThemeData.pickledBluewood900
                                                          : AppThemeData.pickledBluewood100),
                                              borderRadius: BorderRadius.circular(8)),
                                          avatar: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: NetworkImageWidget(
                                                imageUrl: model.image ?? '',
                                                placeHolderUrl: Constant.placeholderURL,
                                              )),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          label: TextCustom(
                                              title: model.name ?? '',
                                              fontFamily: AppThemeData.regular,
                                              color: model.id == controller.selectedCategory.value.id
                                                  ? AppThemeData.white
                                                  : themeChange.getThem()
                                                      ? AppThemeData.pickledBluewood400
                                                      : AppThemeData.pickledBluewood600)),
                                    );
                                  }),
                            ),
                          ),
                          spaceH(height: 10),
                          SizedBox(
                            height: Responsive.height(80, context),
                            child: controller.itemList.isEmpty || controller.isItemLoading.value
                                ? SizedBox(
                                    width: Responsive.width(100, context),
                                    height: Responsive.height(90, context),
                                    child: Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.itemList.isEmpty))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: controller.itemList.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 250, childAspectRatio: 1.5, crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      ItemModel model = controller.itemList[index];
                                      return InkWell(
                                        onTap: () async {
                                          await controller.productDetailInit(model);
                                          productDetailsDialog(context, isDarkTheme: themeChange.getThem());
                                        },
                                        child: ContainerCustom(
                                            radius: 10,
                                            padding: const EdgeInsets.all(0),
                                            child: Column(children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                  child: NetworkImageWidget(
                                                    imageUrl: model.image ?? '',
                                                    placeHolderUrl: Constant.placeholderURL,
                                                    fit: BoxFit.fill,
                                                    placeHolderFit: BoxFit.contain,
                                                    width: Responsive.width(100, context),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: paddingEdgeInsets(vertical: 8),
                                                child: Row(children: [
                                                  Expanded(
                                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    TextCustom(title: model.name ?? ''),
                                                    spaceH(height: 4),
                                                    TextCustom(title: Constant.amountShow(amount: model.price ?? '0')),
                                                    if (Responsive.isMobile(context))
                                                      Chip(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                          backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                          avatar: Icon(
                                                            Icons.add,
                                                            color: AppThemeData.crusta500,
                                                          ),
                                                          label: TextCustom(title: 'Add', color: AppThemeData.crusta500))
                                                  ])),
                                                  if (!Responsive.isMobile(context))
                                                    Chip(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                        backgroundColor: themeChange.getThem() ? AppThemeData.crusta950 : AppThemeData.crusta50,
                                                        avatar: Icon(
                                                          Icons.add,
                                                          color: AppThemeData.crusta500,
                                                        ),
                                                        label: TextCustom(title: 'Add', color: AppThemeData.crusta500))
                                                ]),
                                              ),
                                            ])),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  };
}

productDetailsDialog(
  BuildContext context, {
  required bool isDarkTheme,
}) {
  Dialog alert = Dialog(
    shadowColor: isDarkTheme ? AppThemeData.white : AppThemeData.black,
    backgroundColor: isDarkTheme ? AppThemeData.black : AppThemeData.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: GetBuilder(
        init: PosTableController(),
        builder: (controller) {
          return SizedBox(
            width: Responsive.width(
                Responsive.isMobile(context)
                    ? 90
                    : Responsive.isDesktop(context)
                        ? 40
                        : 60,
                context),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                decoration: BoxDecoration(
                  color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: NetworkImageWidget(
                              imageUrl: controller.productDetails.value.image ?? '',
                              placeHolderUrl: Constant.placeholderURL,
                              height: 100,
                              width: 100,
                            )),
                        spaceW(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(title: controller.productDetails.value.name ?? '', fontSize: 18),
                              if (controller.productDetails.value.description != null)
                                Wrap(
                                  children: [
                                    Text(controller.productDetails.value.description ?? '',
                                        maxLines: controller.isReadMore.value ? 10 : 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: AppThemeData.regular, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 14)),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        child: Text(
                                          controller.isReadMore.value ? "Read less" : "Read more",
                                          style: const TextStyle(color: AppThemeData.crusta400, fontFamily: AppThemeData.regular, fontSize: 12),
                                        ),
                                        onTap: () {
                                          controller.isReadMore.value = !controller.isReadMore.value;
                                          controller.update();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              GetBuilder(
                                  init: PosTableController(),
                                  builder: (controller) {
                                    return TextCustom(title: Constant.amountShow(amount: controller.productDetails.value.price ?? '0'), fontSize: 16);
                                  }),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close, size: 18, color: isDarkTheme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950))
                  ]),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: CustomPaint(
                  painter: DashedLinePainter(),
                ),
              ),
              spaceH(height: 20),
              Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextCustom(title: 'Quantity'),
                    spaceH(),
                    GetBuilder(
                        init: PosTableController(),
                        builder: (controller) {
                          return controller.productDetails.value.qty == 0
                              ? InkWell(
                                  onTap: () {
                                    controller.productDetails.value.qty ??= 0;
                                    controller.productDetails.value.qty = controller.productDetails.value.qty! + 1;
                                    controller.update();

                                    // controller.calculateAddToCart();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                    decoration: BoxDecoration(color: AppThemeData.crusta500, borderRadius: BorderRadius.circular(20)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                                      child: TextCustom(
                                        title: '+ Add',
                                        color: AppThemeData.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200, borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.productDetails.value.qty ??= 0;
                                          if (controller.productDetails.value.qty != 0) {
                                            controller.productDetails.value.qty = controller.productDetails.value.qty! - 1;
                                            controller.update();
                                          }
                                        },
                                        child: TextCustom(
                                          title: '-',
                                          color: AppThemeData.crusta500,
                                          fontSize: 20,
                                        ),
                                      ),
                                      spaceW(),
                                      TextCustom(title: '${controller.productDetails.value.qty ?? 0}'),
                                      spaceW(),
                                      InkWell(
                                        onTap: () {
                                          controller.productDetails.value.qty ??= 0;
                                          controller.productDetails.value.qty = controller.productDetails.value.qty! + 1;
                                          controller.update();
                                        },
                                        child: TextCustom(
                                          title: '+',
                                          color: AppThemeData.crusta500,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ));
                        }),
                    controller.productDetails.value.itemAttributes == null
                        ? Container()
                        : controller.productDetails.value.itemAttributes!.attributes!.isEmpty
                            ? Container()
                            : GetBuilder(
                                init: PosTableController(),
                                builder: (controller) {
                                  return ListView.builder(
                                    itemCount: controller.productDetails.value.itemAttributes!.attributes?.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String title = "";
                                      for (var element in controller.itemAttributeList) {
                                        if (controller.productDetails.value.itemAttributes!.attributes![index].attributesId == element.id) {
                                          title = element.name.toString();
                                        }
                                      }
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          spaceH(height: 15),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                            child: TextCustom(title: title),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                            child: Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: List.generate(
                                                controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions!.length,
                                                (i) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        if (controller.selectedIndexVariants.where((element) => element.contains('$index _')).isEmpty) {
                                                          controller.selectedVariants
                                                              .insert(index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                          controller.selectedIndexVariants
                                                              .add('$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
                                                          controller.selectedIndexArray.add('${index}_$i');
                                                        } else {
                                                          controller.selectedIndexArray.remove(
                                                              '${index}_${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions?.indexOf(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first.replaceAll('$index _', ''))}');
                                                          controller.selectedVariants.removeAt(index);
                                                          controller.selectedIndexVariants
                                                              .remove(controller.selectedIndexVariants.where((element) => element.contains('$index _')).first);
                                                          controller.selectedVariants
                                                              .insert(index, controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString());
                                                          controller.selectedIndexVariants
                                                              .add('$index _${controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString()}');
                                                          controller.selectedIndexArray.add('${index}_$i');
                                                        }

                                                        if (controller.productDetails.value.itemAttributes!.variants!
                                                            .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                            .isNotEmpty) {
                                                          controller.productDetails.value.price = controller.productDetails.value.itemAttributes!.variants!
                                                                  .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                                  .first
                                                                  .variantPrice ??
                                                              '0';
                                                          controller.productDetails.value.variantId = controller.productDetails.value.itemAttributes!.variants!
                                                                  .where((element) => element.variantSku == controller.selectedVariants.join('-'))
                                                                  .first
                                                                  .variantId ??
                                                              '';
                                                          controller.productDetails.value.disPrice = '0';
                                                        }

                                                        // controller.calculateAddToCart();
                                                        controller.update();
                                                      },
                                                      child: buildChip(
                                                          label: controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString(),
                                                          isSelected: controller.selectedVariants
                                                                  .contains(controller.productDetails.value.itemAttributes!.attributes![index].attributeOptions![i].toString())
                                                              ? true
                                                              : false,
                                                          isDarkMode: isDarkTheme));
                                                },
                                              ).toList(),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }),
                    Visibility(
                      // ignore: unnecessary_null_comparison
                      visible: controller.productDetails.value != null,
                      // ignore: prefer_is_empty
                      child: controller.productDetails.value.addons?.length == 0
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceH(height: 20),
                                const TextCustom(title: 'Addons'),
                                spaceH(),
                                SizedBox(
                                  height: 80,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.productDetails.value.addons?.length ?? 0,
                                      separatorBuilder: (context, index) {
                                        return spaceW();
                                      },
                                      itemBuilder: (BuildContext context, int i) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                                              borderRadius: BorderRadius.circular(10)),
                                          height: 80,
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                                child: NetworkImageWidget(
                                                  imageUrl: controller.productDetails.value.addons![i].image ?? '',
                                                  placeHolderUrl: Constant.placeholderURL,
                                                  height: 80,
                                                  width: 100,
                                                ),
                                              ),
                                              spaceW(),
                                              SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    spaceH(height: 5),
                                                    Row(
                                                      children: [
                                                        TextCustom(title: controller.productDetails.value.addons![i].name ?? '', fontFamily: AppThemeData.regular),
                                                        spaceW(),
                                                        TextCustom(title: Constant.amountShow(amount: controller.productDetails.value.addons![i].price ?? '0')),
                                                      ],
                                                    ),
                                                    spaceH(),
                                                    GetBuilder(
                                                        init: PosTableController(),
                                                        builder: (controller) {
                                                          return controller.productDetails.value.addons![i].qty == 0
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    if (controller.productDetails.value.addons![i].qty == null) {
                                                                      controller.productDetails.value.addons![i].qty = 0;
                                                                    }
                                                                    controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! + 1;
                                                                    controller.update();
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                                                    decoration: BoxDecoration(color: AppThemeData.crusta500, borderRadius: BorderRadius.circular(20)),
                                                                    child: const Padding(
                                                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                                                                      child: TextCustom(
                                                                        title: '+ Add',
                                                                        color: AppThemeData.white,
                                                                        fontSize: 16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                                                                  decoration: BoxDecoration(
                                                                      color: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                                                      borderRadius: BorderRadius.circular(20)),
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (controller.productDetails.value.addons![i].qty == null) {
                                                                            controller.productDetails.value.addons![i].qty = 0;
                                                                          }
                                                                          if (controller.productDetails.value.addons![i].qty != 0) {
                                                                            controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! - 1;
                                                                          }
                                                                          controller.update();
                                                                        },
                                                                        child: TextCustom(
                                                                          title: '-',
                                                                          color: AppThemeData.crusta500,
                                                                          fontSize: 20,
                                                                        ),
                                                                      ),
                                                                      spaceW(),
                                                                      TextCustom(title: '${controller.productDetails.value.addons![i].qty ?? 0}'),
                                                                      spaceW(),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          if (controller.productDetails.value.addons![i].qty == null) {
                                                                            controller.productDetails.value.addons![i].qty = 0;
                                                                          }
                                                                          controller.productDetails.value.addons![i].qty = controller.productDetails.value.addons![i].qty! + 1;
                                                                          controller.update();
                                                                        },
                                                                        child: TextCustom(
                                                                          title: '+',
                                                                          color: AppThemeData.crusta500,
                                                                          fontSize: 20,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ));
                                                        }),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                    ),
                    spaceH(height: 20),
                    const TextCustom(title: 'Special Instructions'),
                    spaceH(),
                    TextFieldWidget(
                      hintText: 'Instructions',
                      fillColor: isDarkTheme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                      controller: controller.specialInstruController.value,
                    ),
                    spaceH(height: 10),
                    if (!Responsive.isMobile(context))
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (controller.productDetails.value.qty != 0) {
                                  controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                  if (controller.addToCart.value.product == null) {
                                    controller.addToCart.value =
                                        OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
                                  }
                                  if (controller.addToCart.value.product!
                                      .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                      .isNotEmpty) {
                                    print("same");
                                    controller.addToCart.value
                                            .product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                        ItemModel.fromJson(controller.productDetails.value.toJson());
                                  } else {
                                    print("Not same");
                                    controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                  }
                                  controller.calculateAddToCart();
                                  await controller.orderPlace();
                                  Get.back();
                                } else {
                                  ShowToastDialog.showToast("Please Select At least One Qty.");
                                }
                              },
                              child: GetBuilder(
                                  init: PosTableController(),
                                  builder: (controller) {
                                    return SizedBox(
                                      height: 48,
                                      child: ContainerCustom(
                                        color: AppThemeData.crusta500,
                                        child: Row(
                                          children: [
                                            const Expanded(child: Center(child: TextCustom(title: 'Settle & Save', color: AppThemeData.white, fontSize: 15))),
                                            spaceW(width: 5),
                                            const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 20),
                                            spaceW(width: 5),
                                            TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontFamily: AppThemeData.medium),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    if (Responsive.isMobile(context))
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (controller.productDetails.value.qty != 0) {
                                controller.productDetails.value.specialInstructions = controller.specialInstruController.value.text.trim();
                                if (controller.addToCart.value.product == null) {
                                  controller.addToCart.value = OrderModel(product: [], customer: controller.selectedCustomer.value, tokenNo: controller.tokenController.value.text);
                                }
                                if (controller.addToCart.value.product!
                                    .where((element) => element.id == controller.productDetails.value.id && element.variantId == controller.productDetails.value.variantId)
                                    .isNotEmpty) {
                                  print("same");
                                  controller
                                          .addToCart.value.product![controller.addToCart.value.product!.indexWhere((element) => element.id == controller.productDetails.value.id)] =
                                      ItemModel.fromJson(controller.productDetails.value.toJson());
                                } else {
                                  print("Not same");
                                  controller.addToCart.value.product?.add(ItemModel.fromJson(controller.productDetails.value.toJson()));
                                }
                                controller.calculateAddToCart();
                                await controller.orderPlace();
                                Get.back();
                              } else {
                                ShowToastDialog.showToast("Please Select At least One Qty.");
                              }
                            },
                            child: GetBuilder(
                                init: PosTableController(),
                                builder: (controller) {
                                  return SizedBox(
                                    height: 48,
                                    child: ContainerCustom(
                                      color: AppThemeData.crusta500,
                                      child: Row(
                                        children: [
                                          const Expanded(child: TextCustom(title: 'Settle & Save', color: AppThemeData.white, fontSize: 15)),
                                          spaceW(width: 5),
                                          const Icon(Icons.shopping_bag_outlined, color: AppThemeData.white, size: 20),
                                          spaceW(width: 5),
                                          TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontFamily: AppThemeData.medium),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    spaceH(height: 20)
                  ],
                ),
              ),
            ]),
          );
        }),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

WidgetBuilder orderDetailsDrawerBuilder() {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OrderDetailsController>(
        init: OrderDetailsController(),
        builder: (controller) {
          return Drawer(
            width: 500,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
                child: IntrinsicWidth(
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          spaceH(),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back, size: 25, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)),
                          spaceH(),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TextCustom(
                              title: 'Order Id: ',
                              fontSize: 20,
                              letterSpacing: 1.2,
                              fontFamily: AppThemeData.bold,
                              color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                            ),
                            TextCustom(
                                title: controller.selectedOrder.value.id == '' ? '' : Constant.orderId(orderId: controller.selectedOrder.value.id.toString()),
                                fontSize: 20,
                                fontFamily: AppThemeData.bold,
                                letterSpacing: 1.2,
                                color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                          ]),
                          spaceH(height: 15),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, size: 15, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600),
                              spaceW(),
                              TextCustom(
                                  title: controller.selectedOrder.value.createdAt == null ? '' : Constant.timestampToDateAndTime(controller.selectedOrder.value.createdAt!),
                                  letterSpacing: 0.4,
                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                  fontFamily: AppThemeData.medium)
                            ],
                          ),
                          if (controller.selectedOrder.value.paymentStatus == true) spaceH(),
                          if (controller.selectedOrder.value.paymentStatus == true)
                            Row(children: [
                              TextCustom(
                                  title: 'Payment Type :',
                                  letterSpacing: 0.4,
                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                  fontFamily: AppThemeData.medium),
                              spaceW(),
                              TextCustom(title: controller.selectedOrder.value.paymentMethod ?? '', letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                            ]),
                          spaceH(),
                          Row(children: [
                            TextCustom(
                                title: 'Order Type :',
                                letterSpacing: 0.4,
                                color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                fontFamily: AppThemeData.medium),
                            spaceW(),
                            TextCustom(
                                title: controller.selectedOrder.value.type == null ? '' : controller.selectedOrder.value.type!.toUpperCase(),
                                fontFamily: AppThemeData.medium,
                                letterSpacing: 0.4)
                          ]),
                          if (controller.selectedOrder.value.status == Constant.statusDelivered) spaceH(),
                          if (controller.selectedOrder.value.status == Constant.statusDelivered)
                            Row(children: [
                              TextCustom(
                                  title: 'Delivery Time :',
                                  letterSpacing: 0.4,
                                  color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                  fontFamily: AppThemeData.medium),
                              spaceW(),
                              TextCustom(
                                  title: controller.selectedOrder.value.updatedAt == null ? '' : Constant.timestampToDateAndTime(controller.selectedOrder.value.updatedAt!),
                                  fontFamily: AppThemeData.medium,
                                  letterSpacing: 0.4)
                            ]),
                          spaceH(),
                          controller.selectedOrder.value.tableId == null || controller.selectedOrder.value.tableId!.isEmpty
                              ? const SizedBox()
                              : FutureBuilder<DiningTableModel?>(
                                  future: FireStoreUtils.getDiningTableById(tableId: controller.selectedOrder.value.tableId.toString()),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Constant.loader(context);
                                      default:
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          return Row(children: [
                                            TextCustom(
                                                title: 'Table Name :',
                                                letterSpacing: 0.4,
                                                color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                                                fontFamily: AppThemeData.medium),
                                            spaceW(),
                                            TextCustom(title: "${snapshot.data!.name}", letterSpacing: 0.4, fontFamily: AppThemeData.medium)
                                          ]);
                                        }
                                    }
                                  },
                                ),
                          spaceH(),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: controller.selectedPaymentStatus.value,
                                    hint: const TextCustom(title: 'Select'),
                                    onChanged: (String? newValue) async {
                                      controller.selectedPaymentStatus.value = newValue!;
                                      if (newValue == 'Paid') {
                                        controller.selectedOrderStatus.value = Constant.statusDelivered;
                                      }
                                      controller.update();
                                      await controller.updateOrderData();
                                      final PosTableController posTableController = Get.find<PosTableController>();
                                      await posTableController.getDiningTableData();
                                    },
                                    decoration: InputDecoration(
                                        iconColor: AppThemeData.crusta500,
                                        isDense: true,
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        hintText: "Select",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                    items: controller.paymentStatus.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: TextCustom(title: value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              spaceW(),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: controller.selectedOrderStatus.value,
                                    hint: const TextCustom(title: 'Select'),
                                    onChanged: (String? newValue) async {
                                      controller.selectedOrderStatus.value = newValue!;
                                      if (newValue == Constant.statusDelivered) {
                                        controller.selectedPaymentStatus.value = "Paid";
                                      }
                                      controller.update();
                                      controller.updateOrderData();
                                      if (newValue == Constant.statusDelivered || newValue == Constant.statusRejected) {
                                        final PosTableController posTableController = Get.find<PosTableController>();
                                        await posTableController.getDiningTableData();
                                      }
                                    },
                                    decoration: InputDecoration(
                                        iconColor: AppThemeData.crusta500,
                                        isDense: true,
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: AppThemeData.crusta500,
                                          ),
                                        ),
                                        hintText: "Select",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                    items: controller.orderType.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: TextCustom(title: value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          spaceH(),
                          RoundedButtonFill(
                              radius: 6,
                              width: 150,
                              height: 40,
                              icon: const Icon(Icons.print, size: 20, color: AppThemeData.white),
                              title: "Print Invoice",
                              color: AppThemeData.crusta500,
                              fontSizes: 14,
                              textColor: AppThemeData.white,
                              isRight: false,
                              onPress: () async {
                                controller.printInvoice();
                              }),
                          spaceH(height: 15),
                          orderDetailWidget(context: context, ordermodel: controller.selectedOrder.value),
                          spaceH(),
                          auditDeliveryDetailWidget(context: context, orderModel: controller.selectedOrder.value),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  };
}

Widget orderDetailWidget({required BuildContext context, required OrderModel ordermodel}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return GetBuilder(
      init: PosTableController(),
      builder: (controller) {
        return ContainerCustom(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(title: 'Order Details', fontSize: Responsive.isMobile(context) ? 16 : 18),
              spaceH(),
              devider(context),
              spaceH(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: ordermodel.product?.isEmpty == true
                      ? Constant.loaderWithNoFound(context, isLoading: false, isNotFound: ordermodel.product?.isEmpty == true)
                      : DataTable(
                          horizontalMargin: 20,
                          columnSpacing: 30,
                          dataRowMaxHeight: 70,
                          border: TableBorder.all(
                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                          columns: const [
                            DataColumn(
                              label: SizedBox(
                                width: 220,
                                child: Center(child: TextCustom(title: 'Item')),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 85,
                                child: Center(child: TextCustom(title: 'Price')),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 85,
                                child: Center(child: TextCustom(title: 'Qty')),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 85,
                                child: Center(child: TextCustom(title: 'Extras')),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 85,
                                child: Center(child: TextCustom(title: 'Total')),
                              ),
                            ),
                          ],
                          rows: ordermodel.product!.map(
                            (e) {
                              var productAmount = double.parse(e.price!) * e.qty!;
                              var addonAmount = e.addons!.isNotEmpty ? e.addons!.fold(0.0, (sum, item) => sum + item.qty!.toDouble() * double.parse(item.price!)) : 0.0;
                              String totalCost = (productAmount + addonAmount).toString();
                              return DataRow(
                                cells: [
                                  DataCell(Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: NetworkImageWidget(imageUrl: e.image ?? '', placeHolderUrl: Constant.userPlaceholderURL, height: 30, width: 30)),
                                      spaceW(),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? ''),
                                                spaceW(),
                                                if (e.variantId != null)
                                                  TextCustom(
                                                    title: '(${e.itemAttributes?.variants?.firstWhere((element) => element.variantId == e.variantId).variantSku.toString()})',
                                                    fontSize: 14,
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            if (e.addons!.isNotEmpty)
                                              Column(
                                                  children: e.addons!
                                                      .map((e) => e.qty == 0
                                                          ? const SizedBox()
                                                          : Padding(
                                                              padding: const EdgeInsets.only(bottom: 4),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "${e.name ?? ''} (${Constant.amountShow(amount: e.price.toString())})",
                                                                    fontSize: 10,
                                                                  ),
                                                                  spaceW(),
                                                                  TextCustom(
                                                                    title: "x ${e.qty ?? ''}",
                                                                    fontSize: 10,
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                      .toList())
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                  DataCell(Center(child: TextCustom(title: Constant.amountShow(amount: e.price.toString()), color: AppThemeData.forestGreen))),
                                  DataCell(Center(child: TextCustom(title: 'x ${e.qty.toString()}'))),
                                  DataCell(
                                    Center(
                                      child: e.addons!.isEmpty
                                          ? TextCustom(
                                              title: Constant.amountShow(amount: "0"),
                                              color: AppThemeData.forestGreen,
                                            )
                                          : TextCustom(
                                              title: Constant.amountShow(amount: addonAmount.toString()),
                                              color: AppThemeData.forestGreen,
                                            ),
                                    ),
                                  ),
                                  DataCell(Center(
                                      child: TextCustom(
                                    title: Constant.amountShow(amount: totalCost),
                                    color: AppThemeData.forestGreen,
                                  ))),
                                ],
                              );
                            },
                          ).toList()),
                ),
              ),
              if (ordermodel.paymentStatus == false && ordermodel.type == Constant.orderTypeCustomer) spaceH(),
              if (ordermodel.paymentStatus == false && ordermodel.type == Constant.orderTypeCustomer)
                InkWell(
                  onTap: () async {
                    controller.selectTableId.value = ordermodel.tableId ?? '';
                    controller.getOrderByTable(tableid: controller.selectTableId.value);
                    Get.back();
                    showGlobalDrawer(
                        duration: const Duration(milliseconds: 200),
                        barrierDismissible: true,
                        context: context,
                        builder: productListDrawerBuilder(),
                        direction: AxisDirection.right);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(color: AppThemeData.crusta500, borderRadius: BorderRadius.circular(6)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                      child: TextCustom(
                        title: '+ Add Product',
                        color: AppThemeData.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      });
}

Widget auditDeliveryDetailWidget({required BuildContext context, OrderModel? orderModel}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Column(
    children: [
      ContainerCustom(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.all(12),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                spaceH(),
                labelData(
                    label: 'Sub Total',
                    textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                    value: Constant.amountShow(amount: '${orderModel?.subtotal ?? 0}')),
                spaceH(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Divider(
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                  ),
                ),
                labelData(
                    label: 'Discount',
                    textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                    value: "-${Constant.amountShow(amount: orderModel?.discount ?? '')}"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Divider(
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood300 : AppThemeData.pickledBluewood300,
                  ),
                ),
                ListView.builder(
                    itemCount: orderModel!.taxList!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      TaxModel taxModel = orderModel.taxList![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: labelData(
                            label: '${taxModel.name.toString()} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.rate.toString()) : "${taxModel.rate}%"})',
                            textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                            value: Constant.amountShow(
                                amount: Constant()
                                    .calculateTax(
                                        taxModel: taxModel, amount: (double.parse(orderModel.subtotal.toString()) - double.parse(orderModel.discount.toString())).toString())
                                    .toString())),
                      );
                    }),
              ])),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                  color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
                  border: Border.all(color: themeChange.getThem() == true ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
              child: labelData(
                label: 'Total',
                textColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                value: Constant.amountShow(amount: orderModel.total ?? ''),
              )),
        ]),
      ),
      spaceH(height: 15),
      orderModel.customer?.id != null
          ? ContainerCustom(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextCustom(title: 'Customer Information', fontSize: Responsive.isMobile(context) ? 16 : 18),
                spaceH(height: 5),
                devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                spaceH(height: 5),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: NetworkImageWidget(
                              imageUrl: orderModel.customer?.profileImage ?? '',
                              placeHolderUrl: Constant.userPlaceholderURL,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          spaceW(width: 15),
                          TextCustom(title: capitalize(orderModel.customer?.name ?? ''))
                        ],
                      ),
                      spaceH(height: 15),
                      devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                      spaceH(height: 15),
                      Row(
                        children: [
                          Icon(Icons.email, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600, size: 18),
                          spaceW(),
                          TextCustom(
                            title: orderModel.customer?.email ?? '',
                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                            fontFamily: AppThemeData.regular,
                          )
                        ],
                      ),
                      spaceH(height: 15),
                      Row(
                        children: [
                          Icon(Icons.phone, color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600, size: 18),
                          spaceW(),
                          TextCustom(
                            title: orderModel.customer?.mobileNo ?? '',
                            color: themeChange.getThem() ? AppThemeData.white : AppThemeData.pickledBluewood600,
                            fontFamily: AppThemeData.regular,
                          )
                        ],
                      ),
                      spaceH(height: 15),
                      devider(context, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                    ]),
                  ),
                ])
              ]),
            )
          : const SizedBox(),
    ],
  );
}
