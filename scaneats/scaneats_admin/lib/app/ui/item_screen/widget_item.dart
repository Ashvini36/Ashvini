import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/employees_controller.dart';
import 'package:scaneats/app/controller/item_controller.dart';
import 'package:scaneats/app/model/item_attributes.dart';
import 'package:scaneats/app/model/item_attributes_model.dart';
import 'package:scaneats/app/model/item_category_model.dart';
import 'package:scaneats/app/model/item_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/pagination.dart';
import 'package:scaneats/widgets/pickup_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

class AllItemWidget extends StatelessWidget {
  const AllItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: ItemController(),
      builder: (controller) {
        return Padding(
          padding: paddingEdgeInsets(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceH(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                Row(children: [
                  const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                  const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                  InkWell(onTap: () => controller.navigateScreen(0), child: TextCustom(title: ' ${controller.titleItem.value} ', fontSize: 14, fontFamily: AppThemeData.medium)),
                  Visibility(
                      visible: controller.selectedScreenIndex.value == 1,
                      child: const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600)),
                  Visibility(visible: controller.selectedScreenIndex.value == 1, child: const TextCustom(title: ' View ', fontSize: 14, fontFamily: AppThemeData.medium)),
                ])
              ]),
              spaceH(height: 20),
              SizedBox(
                  width: Responsive.isDesktop(context) ? Responsive.width(85, context) : Responsive.width(100, context),
                  height: Responsive.height(90, context),
                  child: PageView(controller: controller.pageController.value, physics: const NeverScrollableScrollPhysics(), scrollDirection: Axis.horizontal, children: [
                    SingleChildScrollView(
                      child: ContainerCustom(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                    child: TextCustom(
                                        title: '${controller.titleItem.value} (${controller.itemList.length})', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    // if (!Responsive.isMobile(context)) spaceW(),
                                    // const FilterPopUp(),
                                    // spaceW(),
                                    // const ExportPopUp(),
                                    // spaceW(),
                                    SizedBox(
                                      width: 100,
                                      height: 40,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                        ),
                                        value: controller.totalItemPerPage.value,
                                        hint: const TextCustom(title: 'Select'),
                                        onChanged: (String? newValue) {
                                          controller.setPagition(newValue!);
                                        },
                                        decoration: InputDecoration(
                                            iconColor: AppThemeData.crusta500,
                                            isDense: true,
                                            filled: true,
                                            fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                            ),
                                            hintText: "Select",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood950,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppThemeData.medium)),
                                        items: Constant.numofpageitemList.map<DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: TextCustom(
                                              title: value,
                                              fontFamily: AppThemeData.medium,
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    spaceW(),
                                    Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                        ? const SizedBox()
                                        : RoundedButtonFill(
                                            isRight: true,
                                            icon: SvgPicture.asset(
                                              'assets/icons/plus.svg',
                                              height: 20,
                                              width: 20,
                                              fit: BoxFit.cover,
                                              color: AppThemeData.pickledBluewood50,
                                            ),
                                            width: 110,
                                            radius: 6,
                                            height: 40,
                                            fontSizes: 14,
                                            title: "Add ${controller.titleItem.value}",
                                            color: AppThemeData.crusta500,
                                            textColor: AppThemeData.pickledBluewood50,
                                            onPress: () {
                                              if (int.parse(Constant.restaurantModel.subscription!.noOfItem.toString()) > controller.itemList.length) {
                                                controller.setDefaultData();
                                                showGlobalDrawer(
                                                    duration: const Duration(milliseconds: 400),
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: horizontalProductDrawerBuilder(),
                                                    direction: AxisDirection.right);
                                              } else {
                                                ShowToastDialog.showToast(
                                                    "Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                                              }
                                            }),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          spaceH(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              child: controller.itemList.isEmpty
                                  ? Constant.loaderWithNoFound(context, isLoading: controller.isItemLoading.value, isNotFound: controller.itemList.isEmpty)
                                  : DataTable(
                                      horizontalMargin: 20,
                                      columnSpacing: 30,
                                      dataRowMaxHeight: 70,
                                      border: TableBorder.all(
                                        color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      headingRowColor:
                                          MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.18 : MediaQuery.of(context).size.width * 0.2,
                                            child: const TextCustom(title: 'Name'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12,
                                            child: const TextCustom(title: 'Category'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Responsive.isMobile(context) ? 160 : MediaQuery.of(context).size.width * 0.12,
                                            child: const TextCustom(title: 'Price'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Responsive.isMobile(context) ? 160 : MediaQuery.of(context).size.width * 0.12,
                                            child: const TextCustom(title: 'Status'),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.16,
                                            child: const TextCustom(title: 'Action'),
                                          ),
                                        ),
                                      ],
                                      rows: controller.currentPageItems
                                          .map((e) => DataRow(cells: [
                                                DataCell(GestureDetector(
                                                  onTap: () {
                                                    controller.selectedAttributesList.clear();
                                                    controller.itemAttributes.value = ItemAttributes(attributes: [], variants: []);

                                                    controller.selectImage.value = e.image ?? '';
                                                    if (e.itemAttributes != null) {
                                                      for (var element in e.itemAttributes!.attributes!) {
                                                        ItemAttributeModel attributesModel = controller.attributesList.firstWhere((product) => product.id == element.attributesId);
                                                        controller.selectedAttributesList.add(attributesModel);
                                                      }
                                                      controller.itemAttributes.value = e.itemAttributes!;
                                                    }

                                                    controller.navigateScreen(1, model: e);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius: BorderRadius.circular(30),
                                                          child: NetworkImageWidget(imageUrl: e.image ?? '', placeHolderUrl: Constant.userPlaceholderURL, height: 30, width: 30)),
                                                      spaceW(),
                                                      TextCustom(
                                                        fontFamily: AppThemeData.medium,
                                                        title: e.name ?? '',
                                                        color: AppThemeData.crusta500,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                                DataCell(Theme(
                                                  data: ThemeData(
                                                      textTheme: TextTheme(
                                                          displaySmall: TextStyle(
                                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                                              fontFamily: AppThemeData.medium,
                                                              fontSize: 14))),
                                                  child: FutureBuilder<ItemCategoryModel?>(
                                                    future: FireStoreUtils.getCategoryById(categoryId: e.categoryId.toString()), // async work
                                                    builder: (BuildContext context, AsyncSnapshot<ItemCategoryModel?> snapshot) {
                                                      switch (snapshot.connectionState) {
                                                        case ConnectionState.waiting:
                                                          return Text('Loading...', style: Theme.of(context).textTheme.displaySmall);
                                                        default:
                                                          if (snapshot.hasError) {
                                                            return Text('Error: ${snapshot.error}');
                                                          } else {
                                                            return Text(snapshot.data?.name ?? '', style: Theme.of(context).textTheme.displaySmall);
                                                          }
                                                      }
                                                    },
                                                  ),
                                                )),
                                                DataCell(TextCustom(title: Constant.amountShow(amount: '${e.price ?? 0}'))),
                                                DataCell(
                                                  e.isActive == true
                                                      ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                                      : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                                ),
                                                DataCell(Row(children: [
                                                  Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                                      ? const SizedBox()
                                                      : IconButton(
                                                          onPressed: () {
                                                            controller.setModelData(e);
                                                            showGlobalDrawer(
                                                                duration: const Duration(milliseconds: 200),
                                                                barrierDismissible: true,
                                                                context: context,
                                                                builder: horizontalProductDrawerBuilder(isEdit: true),
                                                                direction: AxisDirection.right);
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 20,
                                                          )),
                                                  spaceW(),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller.selectedAttributesList.clear();
                                                      controller.itemAttributes.value = ItemAttributes(attributes: [], variants: []);

                                                      controller.selectImage.value = e.image ?? '';
                                                      if (e.itemAttributes != null) {
                                                        for (var element in e.itemAttributes!.attributes!) {
                                                          ItemAttributeModel attributesModel =
                                                              controller.attributesList.firstWhere((product) => product.id == element.attributesId);
                                                          controller.selectedAttributesList.add(attributesModel);
                                                        }
                                                        controller.itemAttributes.value = e.itemAttributes!;
                                                      }

                                                      controller.navigateScreen(1, model: e);
                                                    },
                                                    icon: const Icon(
                                                      Icons.visibility_outlined,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  spaceW(),
                                                  Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isDelete == false
                                                      ? const SizedBox()
                                                      : IconButton(
                                                          onPressed: () {
                                                            if (Constant.isDemo()) {
                                                              ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                            } else {
                                                              controller.deleteItemById(e.id!);
                                                            }
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete_outline_outlined,
                                                            size: 20,
                                                          )),
                                                ])),
                                              ]))
                                          .toList()),
                            ),
                          ),
                          spaceH(),
                          Visibility(
                            visible: controller.totalPage.value > 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: WebPagination(
                                      isDark: themeChange.getThem(),
                                      currentPage: controller.currentPage.value,
                                      totalPage: controller.totalPage.value,
                                      displayItemCount: controller.pageValue(controller.totalItemPerPage.value),
                                      onPageChanged: (page) {
                                        controller.currentPage.value = page;
                                        controller.setPagition(controller.totalItemPerPage.value);
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                    ContainerCustom(
                      child: DefaultTabController(
                        initialIndex: 0,
                        length: 3,
                        child: Builder(// Add this
                            builder: (context) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                tabAlignment: Responsive.isMobile(context) ? TabAlignment.start : null,
                                onTap: (v) => controller.tabViewChange(v),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerHeight: 0,
                                isScrollable: Responsive.isMobile(context),
                                unselectedLabelColor: (themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood600),
                                labelStyle: TextStyle(fontFamily: AppThemeData.regular, letterSpacing: 0.8, color: AppThemeData.crusta500, fontSize: 15),
                                controller: DefaultTabController.of(context),
                                indicatorColor: AppThemeData.crusta500,
                                tabs: [
                                  Tab(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.info, size: 15), spaceW(width: 6), const Text('Information')])),
                                  Tab(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [const Icon(Icons.backup_table_rounded, size: 15), spaceW(width: 6), const Text('Variation')])),
                                  Tab(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [const Icon(Icons.add_circle_outline, size: 15), spaceW(width: 6), const Text('Addons')])),
                                ],
                              ),
                              spaceH(height: 20),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Responsive.isMobile(context)
                                        ? SingleChildScrollView(
                                            child: Column(children: [
                                              GetBuilder(
                                                  init: ItemController(),
                                                  builder: (controllers) {
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        controllers.selectImage.value == ''
                                                            ? ClipRRect(
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: NetworkImageWidget(
                                                                  imageUrl: Constant.userPlaceholderURL,
                                                                  placeHolderUrl: Constant.userPlaceholderURL,
                                                                  fit: BoxFit.fill,
                                                                  height: Responsive.width(20, context),
                                                                  width: Responsive.width(20, context),
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: Constant().hasValidUrl(controllers.selectItem.value.image!) == false
                                                                    ? kIsWeb
                                                                        ? controllers.profileImageUin8List.value.isEmpty
                                                                            ? Constant.loader(
                                                                                context,
                                                                              )
                                                                            : Image.memory(
                                                                                controllers.profileImageUin8List.value,
                                                                                height: Responsive.width(20, context),
                                                                                width: Responsive.width(20, context),
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                        : Image.file(
                                                                            File(controllers.selectItem.value.image!),
                                                                            height: Responsive.width(20, context),
                                                                            width: Responsive.width(20, context),
                                                                            fit: BoxFit.fill,
                                                                          )
                                                                    : NetworkImageWidget(
                                                                        imageUrl: controllers.selectImage.value.toString(),
                                                                        placeHolderUrl: Constant.userPlaceholderURL,
                                                                        fit: BoxFit.fill,
                                                                        height: Responsive.width(20, context),
                                                                        width: Responsive.width(20, context),
                                                                      ),
                                                              ),
                                                        spaceW(),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const TextCustom(title: 'Size : (262px , 182px)'),
                                                            spaceH(height: 20),
                                                            Row(
                                                              children: [
                                                                Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                                                    ? const SizedBox()
                                                                    : RoundedButtonFill(
                                                                        color: AppThemeData.crusta500,
                                                                        width: 160,
                                                                        radius: 6,
                                                                        height: 40,
                                                                        fontSizes: 14,
                                                                        title: "Upload New Image",
                                                                        icon: Icon(Icons.image,
                                                                            size: 20,
                                                                            color: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                                                        textColor: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                                                        isRight: false,
                                                                        onPress: () {
                                                                          showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                                                            if (value != null) {
                                                                              XFile stringFile = value;
                                                                              controllers.selectImage.value = stringFile.path;
                                                                              controllers.profileImageUin8List.value = await stringFile.readAsBytes();
                                                                              controllers.update();
                                                                            }
                                                                          });
                                                                        }),
                                                                spaceW(),
                                                                Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                                                    ? const SizedBox()
                                                                    : RoundedButtonFill(
                                                                        color: Colors.green,
                                                                        width: 100,
                                                                        radius: 8,
                                                                        height: 40,
                                                                        fontSizes: 14,
                                                                        title: "Save",
                                                                        icon: controller.isUpdateLoading.value == true
                                                                            ? Constant.loader(context,
                                                                                color: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)
                                                                            : const SizedBox(),
                                                                        textColor: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                                                        isRight: false,
                                                                        onPress: () async {
                                                                          if (Constant.isDemo()) {
                                                                            ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                                          } else {
                                                                            controller.uploadItemImage();
                                                                          }
                                                                        }),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              spaceH(height: 40),
                                              labelData(isEnd: false, label: 'Name', value: controller.selectItem.value.name ?? ''),
                                              spaceH(height: 20),
                                              labelData(
                                                  isEnd: false,
                                                  label: 'Category',
                                                  widget: FutureBuilder<ItemCategoryModel?>(
                                                    future: FireStoreUtils.getCategoryById(categoryId: controller.selectItem.value.categoryId ?? ''), // async work
                                                    builder: (BuildContext context, AsyncSnapshot<ItemCategoryModel?> snapshot) {
                                                      switch (snapshot.connectionState) {
                                                        case ConnectionState.waiting:
                                                          return const TextCustom(
                                                            title: 'Loading...',
                                                            color: AppThemeData.pickledBluewood500,
                                                            fontFamily: AppThemeData.regular,
                                                            textAlign: TextAlign.start,
                                                          );
                                                        default:
                                                          if (snapshot.hasError) {
                                                            return Text('Error: ${snapshot.error}');
                                                          } else {
                                                            return TextCustom(
                                                              title: snapshot.data!.name ?? '',
                                                              color: AppThemeData.pickledBluewood500,
                                                              fontFamily: AppThemeData.regular,
                                                              textAlign: TextAlign.start,
                                                            );
                                                          }
                                                      }
                                                    },
                                                  )),
                                              spaceH(height: 20),
                                              labelData(isEnd: false, label: 'Status', value: controller.selectItem.value.isActive == true ? 'Active' : 'Inactive'),
                                              spaceH(height: 20),
                                              labelData(isEnd: false, label: 'Caution', value: controller.selectItem.value.caution ?? ''),
                                              spaceH(height: 20),
                                              labelData(isEnd: false, label: 'Description', value: controller.selectItem.value.description ?? ''),
                                              spaceH(height: 20),
                                              labelData(isEnd: false, label: 'Price', value: Constant.amountShow(amount: controller.selectItem.value.price ?? '')),
                                              spaceH(height: 20),
                                              spaceH(height: 20),
                                              labelData(isEnd: false, label: 'Featured', value: controller.selectItem.value.isFeature.toString())
                                            ]),
                                          )
                                        : Row(
                                            children: [
                                              GetBuilder(
                                                  init: ItemController(),
                                                  builder: (controllers) {
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        controllers.selectImage.value == ''
                                                            ? ClipRRect(
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: NetworkImageWidget(
                                                                  imageUrl: Constant.userPlaceholderURL,
                                                                  placeHolderUrl: Constant.userPlaceholderURL,
                                                                  fit: BoxFit.fill,
                                                                  height: Responsive.width(20, context),
                                                                  width: Responsive.width(20, context),
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: Constant().hasValidUrl(controllers.selectItem.value.image!) == false
                                                                    ? kIsWeb
                                                                        ? controllers.profileImageUin8List.value.isEmpty
                                                                            ? Constant.loader(
                                                                                context,
                                                                              )
                                                                            : Image.memory(
                                                                                controllers.profileImageUin8List.value,
                                                                                height: Responsive.width(20, context),
                                                                                width: Responsive.width(20, context),
                                                                                fit: BoxFit.fill,
                                                                              )
                                                                        : Image.file(
                                                                            File(controllers.selectItem.value.image!),
                                                                            height: Responsive.width(20, context),
                                                                            width: Responsive.width(20, context),
                                                                            fit: BoxFit.fill,
                                                                          )
                                                                    : NetworkImageWidget(
                                                                        imageUrl: controllers.selectImage.value.toString(),
                                                                        placeHolderUrl: Constant.userPlaceholderURL,
                                                                        fit: BoxFit.fill,
                                                                        height: Responsive.width(20, context),
                                                                        width: Responsive.width(20, context),
                                                                      ),
                                                              ),
                                                        spaceW(),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const TextCustom(title: 'Size : (262px , 182px)'),
                                                            spaceH(height: 20),
                                                            Row(
                                                              children: [
                                                                Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                                                    ? const SizedBox()
                                                                    : RoundedButtonFill(
                                                                        color: AppThemeData.crusta500,
                                                                        width: 160,
                                                                        radius: 6,
                                                                        height: 40,
                                                                        fontSizes: 14,
                                                                        title: "Upload New Image",
                                                                        icon: Icon(Icons.image,
                                                                            size: 20,
                                                                            color: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                                                        textColor: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                                                        isRight: false,
                                                                        onPress: () {
                                                                          showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                                                            if (value != null) {
                                                                              XFile stringFile = value;
                                                                              controllers.selectImage.value = stringFile.path;
                                                                              controllers.profileImageUin8List.value = await stringFile.readAsBytes();
                                                                              controllers.update();
                                                                            }
                                                                          });
                                                                        }),
                                                                spaceW(),
                                                                if (Constant().hasValidUrl(controllers.selectImage.value) == false)
                                                                  Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                                                                      ? const SizedBox()
                                                                      : RoundedButtonFill(
                                                                          color: Colors.green,
                                                                          width: 100,
                                                                          radius: 8,
                                                                          height: 40,
                                                                          fontSizes: 14,
                                                                          title: "Save",
                                                                          icon: controller.isUpdateLoading.value == true
                                                                              ? Constant.loader(context,
                                                                                  color: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950)
                                                                              : const SizedBox(),
                                                                          textColor: !themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                                                          isRight: false,
                                                                          onPress: () async {
                                                                            if (Constant.isDemo()) {
                                                                              ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                                            } else {
                                                                              controller.uploadItemImage();
                                                                            }
                                                                          }),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                              spaceW(width: Responsive.width(15, context)),
                                              Expanded(
                                                child: Column(children: [
                                                  spaceH(height: 30),
                                                  labelData(isEnd: false, label: 'Name', value: controller.selectItem.value.name ?? ''),
                                                  spaceH(height: 20),
                                                  labelData(
                                                      isEnd: false,
                                                      label: 'Category',
                                                      widget: FutureBuilder<ItemCategoryModel?>(
                                                        future: FireStoreUtils.getCategoryById(categoryId: controller.selectItem.value.categoryId ?? ''), // async work
                                                        builder: (BuildContext context, AsyncSnapshot<ItemCategoryModel?> snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              return const TextCustom(
                                                                title: 'Loading...',
                                                                color: AppThemeData.pickledBluewood500,
                                                                fontFamily: AppThemeData.regular,
                                                                textAlign: TextAlign.start,
                                                              );
                                                            default:
                                                              if (snapshot.hasError) {
                                                                return Text('Error: ${snapshot.error}');
                                                              } else {
                                                                return TextCustom(
                                                                  title: snapshot.data!.name ?? '',
                                                                  color: AppThemeData.pickledBluewood500,
                                                                  fontFamily: AppThemeData.regular,
                                                                  textAlign: TextAlign.start,
                                                                );
                                                              }
                                                          }
                                                        },
                                                      )),
                                                  spaceH(height: 20),
                                                  labelData(isEnd: false, label: 'Status', value: controller.selectItem.value.isActive == true ? 'Active' : 'Inactive'),
                                                  spaceH(height: 20),
                                                  labelData(isEnd: false, label: 'Caution', value: controller.selectItem.value.caution ?? ''),
                                                  spaceH(height: 20),
                                                  labelData(isEnd: false, label: 'Description', value: controller.selectItem.value.description ?? ''),
                                                ]),
                                              ),
                                            ],
                                          ),
                                    const AttributeView(),
                                    const AddonView()
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                  ]))
            ],
          ),
        );
      },
    );
  }
}

class AttributeView extends StatefulWidget {
  const AttributeView({super.key});

  @override
  State<AttributeView> createState() => _AttributeViewState();
}

class _AttributeViewState extends State<AttributeView> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ItemController(),
        builder: (controllers) {
          return SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              spaceH(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextCustom(title: 'Select Attributes'),
              ),
              spaceH(),
              Theme(
                data: ThemeData(),
                child: DropdownSearch<ItemAttributeModel>.multiSelection(
                  popupProps: PopupPropsMultiSelection.menu(
                    showSelectedItems: true,
                    fit: FlexFit.loose,
                    listViewProps: const ListViewProps(physics: BouncingScrollPhysics(), padding: EdgeInsets.only(left: 8)),
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        selectedColor: AppThemeData.crusta500,
                        selected: isSelected,
                        title: Text(
                          item.name.toString(),
                          style: TextStyle(fontSize: 14, color: isSelected ? AppThemeData.crusta500 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
                        ),
                      );
                    },
                  ),
                  items: controllers.attributesList,
                  dropdownButtonProps: DropdownButtonProps(
                    focusColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                      dropdownSearchDecoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 8, right: 8),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, width: 2.0)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          focusColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                          hintStyle: TextStyle(
                              fontSize: 14, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontFamily: AppThemeData.medium),
                          iconColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                          hintText: 'Select Attributes')),
                  compareFn: (i1, i2) => i1.name == i2.name,
                  itemAsString: (u) => u.name.toString(),
                  selectedItems: controllers.selectedAttributesList,
                  onSaved: (data) {},
                  onChanged: (data) {
                    controllers.selectedAttributesList.clear();
                    controllers.itemAttributes.value = ItemAttributes(attributes: [], variants: []);

                    controllers.selectedAttributesList.addAll(data);
                    for (var element in controllers.selectedAttributesList) {
                      controllers.itemAttributes.value.attributes!.add(Attributes(attributesId: element.id, attributeOptions: []));
                    }
                  },
                ),
              ),
              controllers.itemAttributes.value.attributes == null || controllers.itemAttributes.value.attributes!.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Attribute value",
                          style:
                              TextStyle(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        spaceH(height: 40),
                        ListView.builder(
                          itemCount: controllers.itemAttributes.value.attributes!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String title = "";
                            for (var element in controllers.attributesList) {
                              if (controllers.itemAttributes.value.attributes![index].attributesId == element.id) {
                                title = element.name.toString();
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          displayTextInputDialog(context, index, controllers.itemAttributes.value.attributes![index].attributesId.toString(), controllers);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        ),
                                      )
                                    ],
                                  ),
                                  spaceH(),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 6.0,
                                    children: List.generate(
                                      controllers.itemAttributes.value.attributes![index].attributeOptions!.length,
                                      (i) {
                                        return InkWell(
                                            onTap: () {
                                              controllers.itemAttributes.value.attributes![index].attributeOptions!.removeAt(i);
                                              List<List<dynamic>> listArary = [];
                                              for (int i = 0; i < controllers.itemAttributes.value.attributes!.length; i++) {
                                                if (controllers.itemAttributes.value.attributes![i].attributeOptions!.isNotEmpty) {
                                                  listArary.add(controllers.itemAttributes.value.attributes![i].attributeOptions!);
                                                }
                                              }

                                              if (listArary.isNotEmpty) {
                                                List<Variants>? variantsTemp = [];
                                                List<dynamic> list = getCombination(listArary);
                                                for (var element in list) {
                                                  bool productIsInList = controllers.itemAttributes.value.variants!.any((product) => product.variantSku == element);
                                                  if (productIsInList) {
                                                    Variants variant = controllers.itemAttributes.value.variants!.firstWhere((product) => product.variantSku == element);
                                                    Variants variantsModel = Variants(
                                                        variantSku: variant.variantSku,
                                                        variantId: variant.variantId,
                                                        variantImage: variant.variantImage,
                                                        variantPrice: variant.variantPrice,
                                                        variantQuantity: variant.variantQuantity);
                                                    variantsTemp.add(variantsModel);
                                                  }
                                                }
                                                controllers.itemAttributes.value.variants!.clear();
                                                controllers.itemAttributes.value.variants!.addAll(variantsTemp);
                                              }
                                              setState(() {});
                                            },
                                            child: _buildChip(controllers.itemAttributes.value.attributes![index].attributeOptions![i], themeChange.getThem()));
                                      },
                                    ).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              controllers.itemAttributes.value.variants == null || controllers.itemAttributes.value.variants!.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        spaceH(height: 40),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Variant",
                                style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Variant Price",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Variant Quantity" " ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: controllers.itemAttributes.value.variants!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controllers.itemAttributes.value.variants![index].variantSku.toString(),
                                        style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        maxLength: 5,
                                        textInputAction: TextInputAction.done,
                                        initialValue: controllers.itemAttributes.value.variants![index].variantPrice.toString(),
                                        onChanged: (val) {
                                          controllers.itemAttributes.value.variants![index].variantPrice = val;
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        style: TextStyle(fontSize: 18.0, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                        cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        decoration: InputDecoration(
                                          hintText: "Price",
                                          contentPadding: const EdgeInsets.only(left: 8, right: 8),
                                          counterText: '',
                                          errorStyle: const TextStyle(),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, width: 2.0)),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        maxLength: 5,
                                        textInputAction: TextInputAction.done,
                                        initialValue: controllers.itemAttributes.value.variants![index].variantQuantity,
                                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                        onChanged: (val) {
                                          controllers.itemAttributes.value.variants![index].variantQuantity = val;
                                        },
                                        style: TextStyle(fontSize: 18.0, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                        cursorColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                        decoration: InputDecoration(
                                          hintText: "Quantity",
                                          contentPadding: const EdgeInsets.only(left: 8, right: 8),
                                          counterText: '',
                                          errorStyle: const TextStyle(),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7.0),
                                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950, width: 2.0)),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(7.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                  ? const SizedBox()
                  : RoundedButtonFill(
                      width: 110,
                      radius: 8,
                      height: 45,
                      title: "Save",
                      color: AppThemeData.crusta500,
                      fontSizes: 14,
                      textColor: AppThemeData.white,
                      isRight: false,
                      onPress: () {
                        if (Constant.isDemo()) {
                          ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                        } else {
                          controllers.selectItem.value.itemAttributes = controllers.itemAttributes.value;
                          controllers.saveItemData();
                          controllers.navigateScreen(0);
                        }
                      }),
            ]),
          );
        });
  }

  Future<void> displayTextInputDialog(BuildContext context, int index, String attributeId, ItemController controller) async {
    for (var element in controller.attributesList) {
      if (controller.itemAttributes.value.attributes![index].attributesId == element.id) {
        controller.title.value = element.name.toString();
      }
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextCustom(title: '${controller.title.value} Attributes value'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidget(
                  onChanged: (value) {},
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z a]")),
                  ],
                  maxLine: 1,
                  controller: controller.attributesValueController.value,
                  hintText: 'Add Attributes',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          if (controller.attributesValueController.value.text.isEmpty) {
                            showAlertDialog(context, 'Error', "Please enter attribute value", true);
                          } else {
                            Navigator.pop(context);

                            controller.itemAttributes.value.attributes![index].attributeOptions!.add(controller.attributesValueController.value.text);

                            List<List<dynamic>> listArary = [];
                            for (int i = 0; i < controller.itemAttributes.value.attributes!.length; i++) {
                              // main Attribute loop
                              if (controller.itemAttributes.value.attributes![i].attributeOptions!.isNotEmpty) {
                                listArary.add(controller.itemAttributes.value.attributes![i].attributeOptions!);
                              }
                            }

                            List<dynamic> list = getCombination(listArary);

                            for (var element in list) {
                              bool productIsInList = controller.itemAttributes.value.variants!.any((product) => product.variantSku == element);
                              if (productIsInList) {
                              } else {
                                if (controller.itemAttributes.value.attributes![index].attributeOptions!.length == 1) {
                                  controller.itemAttributes.value.variants!.clear();
                                  Variants variantsModel = Variants(variantSku: element, variantId: const Uuid().v1(), variantImage: "", variantPrice: '0', variantQuantity: "-1");
                                  controller.itemAttributes.value.variants!.add(variantsModel);
                                } else {
                                  Variants variantsModel = Variants(variantSku: element, variantId: const Uuid().v1(), variantImage: "", variantPrice: '0', variantQuantity: "-1");
                                  controller.itemAttributes.value.variants!.add(variantsModel);
                                }
                              }
                            }
                            print(controller.itemAttributes.value.variants!.map((e) => e.toJson()).toList());
                            controller.attributesValueController.value.clear();
                          }
                          setState(() {});
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class AddonView extends StatefulWidget {
  const AddonView({super.key});

  @override
  State<AddonView> createState() => _AddonViewState();
}

class _AddonViewState extends State<AddonView> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ItemController(),
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: RoundedButtonFill(
                            isRight: true,
                            icon: SvgPicture.asset(
                              'assets/icons/plus.svg',
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                              color: AppThemeData.pickledBluewood50,
                            ),
                            width: 130,
                            radius: 6,
                            height: 40,
                            fontSizes: 14,
                            title: "Add ${controller.addonsTitle.value}",
                            color: AppThemeData.crusta500,
                            textColor: AppThemeData.pickledBluewood50,
                            onPress: () {
                              controller.addonsimage.value = '';
                              controller.addOnsimageUin8List.value = Uint8List(100);
                              controller.itemNameController.value.text = '';
                              controller.itempriceController.value.text = '';
                              showDialog(context: context, builder: (ctxt) => const AddAddonsDialog()).then((value) {
                                controller.getAllItem();
                                controller.update();
                                setState(() {});
                              });
                            }),
                      ),
                spaceH(),
                controller.selectItem.value.addons == null
                    ? const SizedBox()
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        child: DataTable(
                            horizontalMargin: 20,
                            columnSpacing: 30,
                            dataRowMaxHeight: 70,
                            border: TableBorder.all(
                              color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                            columns: [
                              DataColumn(
                                  label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: const TextCustom(title: 'Name'),
                              )),
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  child: const TextCustom(title: 'Price'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  child: const TextCustom(title: 'Status'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.185,
                                  child: const TextCustom(title: 'Action'),
                                ),
                              ),
                            ],
                            rows: controller.selectItem.value.addons!
                                .map((e) => DataRow(cells: [
                                      DataCell(TextCustom(title: e.name ?? '')),
                                      DataCell(TextCustom(title: Constant.amountShow(amount: e.price ?? ''))),
                                      DataCell(
                                        e.isActive == true
                                            ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                            : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                      ),
                                      DataCell(Row(children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.itemNameController.value.text = e.name ?? '';
                                              controller.itempriceController.value.text = e.price ?? '';
                                              controller.addonstatus.value = e.isActive == true ? 'Active' : 'Inactive';
                                              controller.addonsimage.value = e.image ?? '';
                                              showDialog(context: context, builder: (ctxt) => AddAddonsDialog(id: e.id.toString())).then((value) {
                                                // if (value != null) {
                                                controller.getAllItem();
                                                controller.update();
                                                setState(() {});
                                                // }
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            )),
                                        spaceW(),
                                        IconButton(
                                            onPressed: () {
                                              if (Constant.isDemo()) {
                                                ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                              } else {
                                                for (int i = 0; i < controller.selectItem.value.addons!.length; i++) {
                                                  if (controller.selectItem.value.addons?[i].id == e.id) {
                                                    printLog("DELETE :: ${controller.selectItem.value.addons![i].name}");
                                                    controller.selectItem.value.addons?.removeAt(i);
                                                    controller.update();
                                                    setState(() {});
                                                  }
                                                }
                                                controller.saveItemData(isDelete: true);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline_outlined,
                                              size: 20,
                                            )),
                                      ])),
                                    ]))
                                .toList()),
                      ),
              ],
            ),
          );
        });
  }
}

class FilterPopUp extends StatelessWidget {
  const FilterPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          return ContainerBorderCustom(
            radius: 6,
            fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
            color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
            child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                child: SizedBox(
                  width: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(title: controller.selectedfilter.value == '' ? 'Filters' : controller.selectedfilter.value, fontSize: 15, fontFamily: AppThemeData.medium),
                      SvgPicture.asset(
                        'assets/icons/filter.svg',
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                      ),
                    ],
                  ),
                ),
                onSelected: (value) {
                  controller.selectedfilter.value = value;
                },
                itemBuilder: (BuildContext bc) {
                  return controller.filterList
                      .map((e) => PopupMenuItem(
                            height: 30,
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black, fontFamily: AppThemeData.medium)),
                              ],
                            ),
                          ))
                      .toList();
                }),
          );
        });
  }
}

class ExportPopUp extends StatelessWidget {
  const ExportPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          return ContainerBorderCustom(
            radius: 6,
            fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
            color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
            child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                child: SizedBox(
                  width: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(title: controller.selectedExport.value == '' ? 'Export as' : controller.selectedExport.value, fontSize: 15, fontFamily: AppThemeData.medium),
                      SvgPicture.asset('assets/icons/down.svg',
                          height: 25, width: 25, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                    ],
                  ),
                ),
                onSelected: (value) {
                  controller.selectedExport.value = value;
                },
                itemBuilder: (BuildContext bc) {
                  return controller.exportAsList
                      .map((e) => PopupMenuItem(
                            height: 30,
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black, fontFamily: AppThemeData.medium)),
                              ],
                            ),
                          ))
                      .toList();
                }),
          );
        });
  }
}

WidgetBuilder horizontalProductDrawerBuilder({bool isEdit = false, bool isSave = true}) {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ItemController>(
        init: ItemController(),
        builder: (controller) {
          return Drawer(
            width: 500,
            child: Container(
              width: Responsive.width(100, context),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.white, fontFamily: AppThemeData.medium),
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
                          TextCustom(title: controller.title.value, fontSize: 20),
                          spaceH(height: 20),
                          SizedBox(height: 2, child: ContainerCustom(color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100)),
                          spaceH(height: 30),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.nameController.value,
                                  title: 'Name',
                                  isReadOnly: !isSave,
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.priceController.value,
                                  title: 'PRICE',
                                  textInputType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  isReadOnly: (isSave && isEdit),
                                )),
                          ]),
                          spaceH(),
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextCustom(
                                    title: 'CATEGORY',
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField<ItemCategoryModel>(
                                    isExpanded: true,
                                    value: controller.selectItemCategory.value.id == null ? null : controller.selectItemCategory.value,
                                    hint: const TextCustom(title: 'Select Category'),
                                    onChanged: (ItemCategoryModel? newValue) {
                                      controller.selectItemCategory.value = newValue!;
                                      controller.update();
                                    },
                                    decoration: InputDecoration(
                                        errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                        isDense: true,
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                          ),
                                        ),
                                        hintText: "Select Category".tr,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                    items: controller.itemCategoryList.map<DropdownMenuItem<ItemCategoryModel>>((ItemCategoryModel value) {
                                      return DropdownMenuItem<ItemCategoryModel>(
                                        value: value,
                                        child: TextCustom(title: value.name ?? ''),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          spaceH(height: 20),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                      if (value != null) {
                                        XFile stringFile = value;
                                        controller.selectImage.value = stringFile.path;
                                        controller.profileImageUin8List.value = await stringFile.readAsBytes();
                                      }
                                    });
                                  },
                                  child: controller.selectImage.isEmpty
                                      ? SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: DottedBorder(
                                            radius: const Radius.circular(12),
                                            strokeWidth: 2,
                                            padding: const EdgeInsets.all(6),
                                            child: const Center(child: Icon(Icons.add)),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(2),
                                          child: Constant().hasValidUrl(controller.selectImage.value) == false
                                              ? kIsWeb
                                                  ? controller.profileImageUin8List.value.isEmpty
                                                      ? Constant.loader(
                                                          context,
                                                        )
                                                      : Image.memory(
                                                          controller.profileImageUin8List.value,
                                                          height: 90,
                                                          width: 90,
                                                          fit: BoxFit.cover,
                                                        )
                                                  : Image.file(
                                                      File(controller.selectImage.value),
                                                      height: 90,
                                                      width: 90,
                                                      fit: BoxFit.cover,
                                                    )
                                              : NetworkImageWidget(
                                                  imageUrl: controller.selectImage.value.toString(),
                                                  placeHolderUrl: Constant.userPlaceholderURL,
                                                  fit: BoxFit.cover,
                                                  height: 90,
                                                  width: 90,
                                                ),
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: customRadioButton(context,
                                    parameter: controller.selectItemType.value,
                                    title: 'ITEM TYPE',
                                    radioOne: controller.itemType[0],
                                    onChangeOne: () {
                                      controller.selectItemType.value = controller.itemType[0];
                                      controller.update();
                                    },
                                    radioTwo: controller.itemType[1],
                                    onChangeTwo: () {
                                      controller.selectItemType.value = controller.itemType[1];
                                      controller.update();
                                    })),
                          ]),
                          spaceH(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: customRadioButton(context,
                                      parameter: controller.selectFeature.value,
                                      title: 'IS FEATURED',
                                      radioOne: controller.featureList[0],
                                      onChangeOne: () {
                                        controller.selectFeature.value = controller.featureList[0];
                                        controller.update();
                                      },
                                      radioTwo: controller.featureList[1],
                                      onChangeTwo: () {
                                        controller.selectFeature.value = controller.featureList[1];
                                        controller.update();
                                      })),
                              spaceW(width: 15),
                              Expanded(
                                  flex: 1,
                                  child: customRadioButton(context,
                                      parameter: controller.selectStatus.value,
                                      title: 'STATUS',
                                      radioOne: controller.statusList[0],
                                      onChangeOne: () {
                                        controller.selectStatus.value = controller.statusList[0];
                                        controller.update();
                                      },
                                      radioTwo: controller.statusList[1],
                                      onChangeTwo: () {
                                        controller.selectStatus.value = controller.statusList[1];
                                        controller.update();
                                      })),
                            ],
                          ),
                          spaceH(),
                          // TextFieldWidget(
                          //   hintText: '',
                          //   maxLine: 3,
                          //   controller: controller.cautionController.value,
                          //   title: 'CAUTION',
                          //   isReadOnly: !isSave,
                          // ),
                          // spaceH(),
                          TextFieldWidget(
                            maxLine: 3,
                            hintText: '',
                            controller: controller.descController.value,
                            title: 'DESCRIPTION',
                            isReadOnly: !isSave,
                          ),
                          spaceH(height: 30),
                          Row(
                            children: [
                              Visibility(
                                visible: isSave,
                                child: RoundedButtonFill(
                                    width: 120,
                                    radius: 8,
                                    height: 45,
                                    icon: !controller.isAddLoading.value ? const SizedBox() : Constant.loader(context, color: AppThemeData.pickledBluewood50),
                                    title: "Save",
                                    color: AppThemeData.crusta500,
                                    fontSizes: 14,
                                    textColor: AppThemeData.white,
                                    isRight: false,
                                    onPress: () {
                                      if (Constant.isDemo()) {
                                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                      } else {
                                        if (controller.nameController.value.text != '' &&
                                            controller.priceController.value.text != '' &&
                                            controller.selectItemCategory.value.id != null) {
                                          controller.addItemData(isEdit: isEdit);
                                        } else {
                                          ShowToastDialog.showToast("Please Fill Required Fields...");
                                        }
                                      }
                                    }),
                              ),
                              Visibility(visible: isSave, child: spaceW(width: 15)),
                              RoundedButtonFill(
                                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  width: 120,
                                  radius: 8,
                                  height: 45,
                                  fontSizes: 14,
                                  title: "Close",
                                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  isRight: false,
                                  onPress: () {
                                    controller.setDefaultData();
                                    Get.back();
                                  }),
                            ],
                          )
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

// ignore: dead_code
Widget _buildChip(String label, theme) {
  return Chip(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
          ),
        ),
        const SizedBox(width: 10),
        Icon(Icons.remove_circle, color: theme ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
      ],
    ),
    backgroundColor: theme ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}

List<dynamic> getCombination(List<List<dynamic>> listArray) {
  if (listArray.length == 1) {
    return listArray[0];
  } else {
    List<dynamic> result = [];
    var allCasesOfRest = getCombination(listArray.sublist(1));
    for (var i = 0; i < allCasesOfRest.length; i++) {
      for (var j = 0; j < listArray[0].length; j++) {
        result.add(listArray[0][j] + '-' + allCasesOfRest[i]);
      }
    }
    return result;
  }
}

Widget labelData({required String label, String? value, Widget? widget, Color? textColor, bool isEnd = true}) {
  return Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: TextCustom(title: label, color: textColor)),
    Visibility(
        visible: value != null,
        child: Expanded(
            child: TextCustom(
          title: value ?? '',
          textAlign: isEnd ? TextAlign.end : TextAlign.start,
          maxLine: 4,
          color: textColor ?? AppThemeData.pickledBluewood500,
          fontFamily: AppThemeData.regular,
        ))),
    Visibility(visible: widget != null, child: Expanded(child: widget ?? const Text('')))
  ]);
}

class AddAddonsDialog extends StatelessWidget {
  final String id;

  const AddAddonsDialog({super.key, this.id = ''});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ItemController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Addons', fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TextFieldWidget(hintText: '', controller: controller.itemNameController.value, title: 'Item Name')),
                      spaceW(width: 10),
                      Expanded(
                        child: TextFieldWidget(
                            hintText: '',
                            controller: controller.itempriceController.value,
                            textInputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            title: 'Price'),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                if (value != null) {
                                  XFile stringFile = value;
                                  controller.addonsimage.value = stringFile.path;
                                  controller.addOnsimageUin8List.value = await stringFile.readAsBytes();
                                }
                              });
                            },
                            child: controller.addonsimage.isEmpty
                                ? SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: DottedBorder(
                                      radius: const Radius.circular(12),
                                      strokeWidth: 2,
                                      padding: const EdgeInsets.all(6),
                                      child: const Center(child: Icon(Icons.add)),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Constant().hasValidUrl(controller.addonsimage.value) == false
                                        ? kIsWeb
                                            ? controller.addOnsimageUin8List.value.isEmpty
                                                ? Constant.loader(
                                                    context,
                                                  )
                                                : Image.memory(
                                                    controller.addOnsimageUin8List.value,
                                                    height: 90,
                                                    width: 90,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.file(
                                                File(controller.addonsimage.value),
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.cover,
                                              )
                                        : NetworkImageWidget(
                                            imageUrl: controller.addonsimage.value.toString(),
                                            placeHolderUrl: Constant.userPlaceholderURL,
                                            fit: BoxFit.cover,
                                            height: 90,
                                            width: 90,
                                          ),
                                  ),
                          ),
                        ),
                      ),
                      spaceW(width: 10),
                      Expanded(
                        flex: 1,
                        child: customRadioButton(context,
                            parameter: controller.addonstatus.value,
                            title: 'STATUS',
                            radioOne: "Active",
                            onChangeOne: () {
                              controller.addonstatus.value = "Active";
                              controller.update();
                            },
                            radioTwo: "Inactive",
                            onChangeTwo: () {
                              controller.addonstatus.value = "Inactive";
                              controller.update();
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RoundedButtonFill(
                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Close",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    Get.back();
                  }),
              Constant.selectedRole.permission!.firstWhere((element) => element.title == "Items").isUpdate == false
                  ? const SizedBox()
                  : RoundedButtonFill(
                      width: 80,
                      radius: 8,
                      height: 40,
                      fontSizes: 14,
                      title: "Save",
                      icon: controller.isUpdateLoading.value == true
                          ? Constant.loader(context, color: AppThemeData.white)
                          : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                      color: AppThemeData.crusta500,
                      textColor: AppThemeData.white,
                      isRight: false,
                      onPress: () {
                        if (Constant.isDemo()) {
                          ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                        } else {
                          if (controller.itemNameController.value.text != '' && controller.itempriceController.value.text != '' && controller.addonsimage.value != '') {
                            controller.isUpdateLoading.value = true;
                            Addons model = Addons(
                                id: id,
                                isActive: controller.addonstatus.value == "Active" ? true : false,
                                name: controller.itemNameController.value.text.trim(),
                                price: controller.itempriceController.value.text.trim(),
                                image: controller.addonsimage.value);
                            controller.saveAddonData(model).then((value) {
                              controller.isUpdateLoading.value = false;
                              controller.update();
                              Get.back();
                            });
                          } else {
                            ShowToastDialog.showToast("It is necessary to fill out every field in its entirety without exception..");
                            Get.back();
                          }
                        }
                      }),
            ],
          );
        });
  }
}
