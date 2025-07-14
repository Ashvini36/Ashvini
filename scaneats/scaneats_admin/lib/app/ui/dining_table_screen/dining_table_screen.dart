import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/dining_table_controller.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/pickup_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../model/dining_table_model.dart';

class DiningTableScreen extends StatelessWidget {
  const DiningTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: DiningTableController(),
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
                    TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium)
                  ])
                ]),
                spaceH(height: 20),
                ContainerCustom(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (!Responsive.isMobile(context))
                          Expanded(
                              child: TextCustom(title: '${controller.title.value} (${controller.offerList.length})', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                        Constant.selectedRole.permission!.firstWhere((element) => element.title == "Dining Tables").isUpdate == false
                            ? const SizedBox()
                            : Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    if (!Responsive.isMobile(context)) spaceW(),
                                    spaceW(),
                                    RoundedButtonFill(
                                        isRight: true,
                                        icon: SvgPicture.asset(
                                          'assets/icons/plus.svg',
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.cover,
                                          color: AppThemeData.pickledBluewood50,
                                        ),
                                        width: 160,
                                        radius: 6,
                                        height: 40,
                                        fontSizes: 14,
                                        title: "Add ${controller.title.value}",
                                        color: AppThemeData.crusta500,
                                        textColor: AppThemeData.pickledBluewood50,
                                        onPress: () {
                                          if (int.parse(Constant.restaurantModel.subscription!.noOfTablePerBranch.toString()) > controller.offerList.length) {
                                            controller.reset();
                                            showGlobalDrawer(
                                                duration: const Duration(milliseconds: 400),
                                                barrierDismissible: true,
                                                context: context,
                                                builder: horizontalDrawerBuilder(),
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
                    spaceH(),
                    controller.offerList.isEmpty || controller.isGetItemLoading.value
                        ? Constant.loaderWithNoFound(context, isLoading: controller.isGetItemLoading.value, isNotFound: controller.offerList.isEmpty)
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              child: DataTable(
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
                                        width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.14 : MediaQuery.of(context).size.width * 0.18,
                                        child: const TextCustom(title: 'Name'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.14,
                                        child: const TextCustom(title: 'Size'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.12,
                                        child: const TextCustom(title: 'Status'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12,
                                        child: const TextCustom(title: 'QR Download'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: SizedBox(
                                        width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.16,
                                        child: const TextCustom(title: 'Actions'),
                                      ),
                                    )
                                  ],
                                  rows: controller.offerList
                                      .map((e) => DataRow(cells: [
                                            DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? '')),
                                            DataCell(TextCustom(fontFamily: AppThemeData.medium, title: e.size ?? '')),
                                            DataCell(
                                              e.isActive == true
                                                  ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                                  : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                            ),
                                            DataCell(SizedBox(
                                              height: 30,
                                              width: 82,
                                              child: InkWell(
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctxt) => QRPdfDialog(
                                                            diningTableModel: e,
                                                          ));
                                                  // controller.downLoadPdf(diningTableModel: e);
                                                },
                                                child: ContainerCustom(
                                                  color: AppThemeData.crusta500,
                                                  radius: 30,
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                  child: const TextCustom(title: 'Download', color: AppThemeData.white),
                                                ),
                                              ),
                                            )),
                                            DataCell(Row(children: [
                                              Constant.selectedRole.permission!.firstWhere((element) => element.title == "Dining Tables").isUpdate == false
                                                  ? const SizedBox()
                                                  : IconButton(
                                                      onPressed: () {
                                                        controller.setEditValue(e);
                                                        showGlobalDrawer(
                                                            duration: const Duration(milliseconds: 200),
                                                            barrierDismissible: true,
                                                            context: context,
                                                            builder: horizontalDrawerBuilder(
                                                              itemId: e.id.toString(),
                                                              isEdit: true,
                                                            ),
                                                            direction: AxisDirection.right);
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                      ),
                                                    ),
                                              spaceW(),
                                              IconButton(
                                                onPressed: () {
                                                  controller.setEditValue(e);
                                                  showGlobalDrawer(
                                                      duration: const Duration(milliseconds: 200),
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: horizontalDrawerBuilder(itemId: e.id.toString(), isReadOnly: true),
                                                      direction: AxisDirection.right);
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              spaceW(),
                                              Constant.selectedRole.permission!.firstWhere((element) => element.title == "Dining Tables").isDelete == false
                                                  ? const SizedBox()
                                                  : IconButton(
                                                      onPressed: () {
                                                        if (Constant.isDemo()) {
                                                          ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                        } else {
                                                          controller.deleteByItemAttributeId(e);
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
                  ]),
                )
              ],
            ));
      },
    );
  }
}

// ignore: must_be_immutable
class QRPdfDialog extends StatefulWidget {
  DiningTableModel diningTableModel;

  QRPdfDialog({super.key, required this.diningTableModel});

  @override
  State<QRPdfDialog> createState() => _QRPdfDialogState();
}

class _QRPdfDialogState extends State<QRPdfDialog> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DiningTableController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'QR Template', fontSize: 18),
            content: SizedBox(
              width: Responsive.width(28, context),
              height: Responsive.height(54, context),
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
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.pageController.value.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.decelerate,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: AppThemeData.crusta500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: const Icon(Icons.navigate_before, color: AppThemeData.white, size: 20),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: PageView.builder(
                            itemCount: controller.qrList.length,
                            controller: controller.pageController.value,
                            onPageChanged: (value) {
                              controller.selectedIndex.value = value;
                            },
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return FutureBuilder(
                                future: itemIndex == 0
                                    ? controller.image1(diningTableModel: widget.diningTableModel)
                                    : itemIndex == 1
                                        ? controller.image2(diningTableModel: widget.diningTableModel)
                                        : itemIndex == 2
                                            ? controller.image3(diningTableModel: widget.diningTableModel)
                                            : controller.image4(diningTableModel: widget.diningTableModel),
                                builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Constant.loader(context);
                                    default:
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SfPdfViewer.memory(
                                            snapshot.data!,
                                          ),
                                        );
                                      }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.pageController.value.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.decelerate,
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: AppThemeData.crusta500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: const Icon(Icons.navigate_next, color: AppThemeData.white, size: 20),
                          ),
                        )
                      ],
                    ),
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
              RoundedButtonFill(
                  width: 120,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Download",
                  icon: const Icon(Icons.download_rounded, color: AppThemeData.white, size: 20),
                  color: AppThemeData.crusta500,
                  textColor: AppThemeData.white,
                  isRight: false,
                  onPress: () async {
                    ShowToastDialog.showLoader("Please wait");
                    Uint8List? pdfInBytes;
                    if (controller.selectedIndex.value == 0) {
                      pdfInBytes = await controller.image1(diningTableModel: widget.diningTableModel);
                    } else if (controller.selectedIndex.value == 1) {
                      pdfInBytes = await controller.image2(diningTableModel: widget.diningTableModel);
                    } else if (controller.selectedIndex.value == 2) {
                      pdfInBytes = await controller.image3(diningTableModel: widget.diningTableModel);
                    } else if (controller.selectedIndex.value == 3) {
                      pdfInBytes = await controller.image4(diningTableModel: widget.diningTableModel);
                    }
                    await FileSaver.instance.saveFile(
                      name: "${widget.diningTableModel.name}",
                      ext: 'pdf',
                      mimeType: MimeType.pdf,
                      bytes: pdfInBytes,
                      dioClient: Dio(),
                      transformDioResponse: (response) {
                        return response.data;
                      },
                    );
                    ShowToastDialog.closeLoader();
                  }),
            ],
          );
        });
  }
}

WidgetBuilder horizontalDrawerBuilder({String? itemId, bool isEdit = false, bool isReadOnly = false}) {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DiningTableController>(
        init: DiningTableController(),
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
                          TextCustom(title: controller.title.value, fontSize: 20),
                          spaceH(height: 20),
                          SizedBox(height: 2, child: ContainerCustom(color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100)),
                          spaceH(height: 30),
                          Row(
                            children: [
                              isReadOnly
                                  ? SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: PrettyQrView.data(
                                        data: Constant.qrCodeLink(branchId: controller.selectBranch.value.id.toString(), tableId: controller.tableId.value),
                                        decoration: PrettyQrDecoration(
                                          shape: PrettyQrSmoothSymbol(color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              spaceW(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextCustom(
                                    title: 'Logo',
                                    fontSize: 12,
                                  ),
                                  spaceH(height: 20),
                                  InkWell(
                                      onTap: () {
                                        showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                          if (value != null) {
                                            XFile stringFile = value;
                                            controller.imageAvtar.value = stringFile.path;
                                            controller.imageAvtarUin8List.value = await stringFile.readAsBytes();
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        height: 90,
                                        width: 90,
                                        child: DottedBorder(
                                          radius: const Radius.circular(12),
                                          strokeWidth: 2,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                                          padding: const EdgeInsets.all(6),
                                          child: controller.imageAvtar.isEmpty
                                              ? const Center(child: Icon(Icons.add))
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Constant().hasValidUrl(controller.imageAvtar.value) == false
                                                      ? kIsWeb
                                                          ? controller.imageAvtarUin8List.value.isEmpty
                                                              ? Constant.loader(context)
                                                              : Image.memory(
                                                                  controller.imageAvtarUin8List.value,
                                                                  height: 90,
                                                                  width: 90,
                                                                  fit: BoxFit.cover,
                                                                )
                                                          : Image.file(
                                                              File(controller.imageAvtar.value),
                                                              height: 90,
                                                              width: 90,
                                                              fit: BoxFit.cover,
                                                            )
                                                      : NetworkImageWidget(
                                                          imageUrl: controller.imageAvtar.value.toString(),
                                                          placeHolderUrl: Constant.placeholderURL,
                                                          fit: BoxFit.cover,
                                                          height: 90,
                                                          width: 90,
                                                        ),
                                                ),
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                          spaceH(height: 20),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.nameTextFiledController.value,
                                  title: 'Name',
                                  isReadOnly: isReadOnly,
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.sizeTextFiledController.value,
                                  title: 'Size',
                                  isReadOnly: isReadOnly,
                                )),
                          ]),
                          spaceH(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextCustom(
                                      title: 'Select Branch',
                                      fontSize: 12,
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<BranchModel>(
                                      isExpanded: true,
                                      value: controller.selectBranch.value.id == null ? null : controller.selectBranch.value,
                                      hint: const TextCustom(title: 'Select Branch'),
                                      onChanged: (BranchModel? newValue) {
                                        controller.selectBranch.value = newValue!;
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
                                          hintText: "Select Branch".tr,
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppThemeData.medium)),
                                      items: Constant.allBranch.map<DropdownMenuItem<BranchModel>>((BranchModel value) {
                                        return DropdownMenuItem<BranchModel>(
                                          value: value,
                                          child: TextCustom(title: value.name ?? ''),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              spaceW(width: 15),
                              Expanded(
                                flex: 1,
                                child: customRadioButton(context,
                                    parameter: controller.status.value,
                                    title: 'Status',
                                    radioOne: "Active",
                                    onChangeOne: () {
                                      if (!isReadOnly) {
                                        controller.status.value = "Active";
                                        controller.update();
                                      }
                                    },
                                    radioTwo: "Inactive",
                                    onChangeTwo: () {
                                      if (!isReadOnly) {
                                        controller.status.value = "Inactive";
                                        controller.update();
                                      }
                                    }),
                              ),
                            ],
                          ),
                          spaceH(),
                          spaceH(),
                          Row(
                            children: [
                              Visibility(
                                visible: !isReadOnly,
                                child: RoundedButtonFill(
                                    width: 120,
                                    radius: 8,
                                    height: 45,
                                    icon: controller.isAddItemLoading.value == true
                                        ? Constant.loader(context, color: AppThemeData.white)
                                        : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                                    title: "Save",
                                    color: AppThemeData.crusta500,
                                    fontSizes: 14,
                                    textColor: AppThemeData.white,
                                    isRight: false,
                                    onPress: () {
                                      if (Constant.isDemo()) {
                                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                      } else {
                                        if (controller.nameTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please Enter name");
                                        } else if (controller.sizeTextFiledController.value.text.isEmpty) {
                                          ShowToastDialog.showToast("Please Enter size");
                                        } else if (controller.imageAvtar.value.isEmpty) {
                                          ShowToastDialog.showToast("Please select image");
                                        } else if (controller.selectBranch.value.id == null) {
                                          ShowToastDialog.showToast("Please select branch");
                                        } else {
                                          controller.addOfferData(itemCategoryId: itemId ?? '', isEdit: isEdit);
                                        }
                                      }
                                    }),
                              ),
                              spaceW(width: 15),
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
                                    controller.reset();
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
