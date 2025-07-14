import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/dining_table_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class DiningTableController extends GetxController {
  RxString title = 'Dining Tables'.obs;

  RxString selectedType = "Fix".obs;

  Rx<TextEditingController> nameTextFiledController = TextEditingController().obs;
  Rx<TextEditingController> sizeTextFiledController = TextEditingController().obs;

  RxString status = "Active".obs;
  RxString tableId = "".obs;
  RxBool isGetItemLoading = false.obs;
  RxList<DiningTableModel> offerList = <DiningTableModel>[].obs;
  RxList<String> qrList = ["assets/images/qr_1.jpg", "assets/images/qr_2.png", "assets/images/qr_3.png", "assets/images/qr_4.png"].obs;

  Rx<BranchModel> selectBranch = BranchModel().obs;

  RxString imageAvtar = "".obs;
  Rx<Uint8List> imageAvtarUin8List = Uint8List(100).obs;

  Future<void> getDiningTableData({String name = ''}) async {
    isGetItemLoading.value = true;
    offerList.clear();
    await FireStoreUtils.getDiningTable(name).then((value) {
      if (value!.isNotEmpty) {
        offerList.value = value;
        isGetItemLoading.value = false;
      } else {
        isGetItemLoading.value = false;
      }
    });
  }

  setEditValue(DiningTableModel currenciesModel) {
    nameTextFiledController.value.text = currenciesModel.name.toString();
    tableId.value = currenciesModel.id.toString();
    sizeTextFiledController.value.text = currenciesModel.size.toString();
    imageAvtar.value = currenciesModel.tableAvtarImage.toString();

    for (var element in Constant.allBranch) {
      if (element.id == currenciesModel.branchId) {
        selectBranch.value = element;
      }
    }
    status.value = currenciesModel.isActive == true ? "Active" : "Inactive";
  }

  RxBool isAddItemLoading = false.obs;

  Future<void> addOfferData({String itemCategoryId = '', bool isEdit = false}) async {
    isAddItemLoading.value = true;
    print(imageAvtar.value);
    if (!imageAvtar.value.contains("firebasestorage.googleapis.com")) {
      print("=======>");
      imageAvtar.value = await FireStoreUtils.uploadUserImageToFireStorage(imageAvtarUin8List.value, "logo/", File(imageAvtar.value).path.split('/').last);
    }
    print(imageAvtar.value);

    DiningTableModel model = DiningTableModel(
      id: itemCategoryId,
      isActive: status.value == "Active" ? true : false,
      name: nameTextFiledController.value.text.trim(),
      size: sizeTextFiledController.value.text.trim(),
      branchId: selectBranch.value.id.toString(),
      tableAvtarImage: imageAvtar.value,
    );

    await FireStoreUtils.setDiningTable(model).then((value) {
      if (value.id != null) {
        if (isEdit == false) {
          offerList.add(model);
          isAddItemLoading.value = false;
        } else {
          for (int i = 0; i < offerList.length; i++) {
            if (offerList[i].id == itemCategoryId) {
              offerList.removeAt(i);
              offerList.insert(i, value);
            }
          }
          isAddItemLoading.value = false;
        }
        update();
        Get.back();
        ShowToastDialog.showToast("Table successfully Added!!");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  Future<void> deleteByItemAttributeId(DiningTableModel languageModel) async {
    await FireStoreUtils.deleteDiningTable(languageModel.id.toString()).then((value) {
      if (value == true) {
        for (int i = 0; i < offerList.length; i++) {
          if (offerList[i].id == languageModel.id) {
            offerList.removeAt(i);
          }
        }
        ShowToastDialog.showToast("Table has been Removed");
      } else {
        ShowToastDialog.showToast("Something Went to wrong");
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    getDiningTableData();
  }

  reset() {
    nameTextFiledController.value.clear();
    sizeTextFiledController.value.clear();
    status.value = "Active";
    imageAvtar.value = "";
    imageAvtarUin8List.value = Uint8List.fromList([]);
    selectBranch.value = BranchModel();
  }

  Rx<PageController> pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: 0.70).obs;

  RxInt selectedIndex = 0.obs;

  Future<Uint8List> image1({required DiningTableModel diningTableModel}) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/qr_1.jpg');
    final imageBytes = img.buffer.asUint8List();
    final netImage = await networkImage(diningTableModel.tableAvtarImage.toString());

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: MediaQuery.of(Get.context!).size.width * 100,
            height: MediaQuery.of(Get.context!).size.height * 100,
            decoration: pw.BoxDecoration(image: pw.DecorationImage(image: pw.MemoryImage(imageBytes))),
            child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.ClipOval(
                    child: pw.Image(netImage, fit: pw.BoxFit.fitHeight, height: 80, width: 80),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Paragraph(text: diningTableModel.name.toString(), style: const pw.TextStyle(fontSize: 20, color: PdfColor.fromInt(0xffFFFFFF))),
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.BarcodeWidget(
                    color: PdfColor.fromHex("#FFFFFF"),
                    barcode: pw.Barcode.qrCode(),
                    height: 200,
                    width: 200,
                    data: Constant.qrCodeLink(branchId: diningTableModel.branchId.toString(), tableId: diningTableModel.id.toString()),
                  ),
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.Paragraph(text: "Scan QR Code to", style: const pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xff6a6d71))),
                  pw.Paragraph(text: "View Our Menu", style: const pw.TextStyle(fontSize: 30, color: PdfColor.fromInt(0xffFFFFFF))),
                ])),
          ); // Center
        }));

    return await pdf.save();
  }

  Future<Uint8List> image2({required DiningTableModel diningTableModel}) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/qr_2.jpg');
    final imageBytes = img.buffer.asUint8List();
    final netImage = await networkImage(diningTableModel.tableAvtarImage.toString());

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: MediaQuery.of(Get.context!).size.width * 100,
            height: MediaQuery.of(Get.context!).size.height * 100,
            decoration: pw.BoxDecoration(image: pw.DecorationImage(image: pw.MemoryImage(imageBytes))),
            child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.ClipOval(
                    child: pw.Image(netImage, fit: pw.BoxFit.fitHeight, height: 100, width: 100),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Paragraph(text: diningTableModel.name.toString(), style: const pw.TextStyle(fontSize: 24, color: PdfColor.fromInt(0xffFFFFFF))),
                  pw.SizedBox(
                    height: 80,
                  ),
                  pw.BarcodeWidget(
                    color: PdfColor.fromHex("#000000"),
                    barcode: pw.Barcode.qrCode(),
                    height: 120,
                    width: 120,
                    data: Constant.qrCodeLink(branchId: diningTableModel.branchId.toString(), tableId: diningTableModel.id.toString()),
                  ),
                  pw.SizedBox(
                    height: 80,
                  ),
                  pw.Paragraph(text: "Scan QR Code to", style: const pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xff6a6d71))),
                  pw.Paragraph(text: "View Our Menu", style: const pw.TextStyle(fontSize: 30, color: PdfColor.fromInt(0xffFFFFFF))),
                ])),
          ); // Center
        }));
    return await pdf.save();
  }

  Future<Uint8List> image3({required DiningTableModel diningTableModel}) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/qr_3.jpg');
    final imageBytes = img.buffer.asUint8List();
    final netImage = await networkImage(diningTableModel.tableAvtarImage.toString());

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: MediaQuery.of(Get.context!).size.width * 100,
            height: MediaQuery.of(Get.context!).size.height * 100,
            decoration: pw.BoxDecoration(image: pw.DecorationImage(image: pw.MemoryImage(imageBytes))),
            child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.ClipOval(
                    child: pw.Image(netImage, fit: pw.BoxFit.fitHeight, height: 120, width: 120),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Paragraph(text: diningTableModel.name.toString(), style: const pw.TextStyle(fontSize: 22, color: PdfColor.fromInt(0xffFFFFFF))),
                  pw.SizedBox(
                    height: 30,
                  ),
                  pw.BarcodeWidget(
                    color: PdfColor.fromHex("#FFFFFF"),
                    barcode: pw.Barcode.qrCode(),
                    height: 120,
                    width: 120,
                    data: Constant.qrCodeLink(branchId: diningTableModel.branchId.toString(), tableId: diningTableModel.id.toString()),
                  ),
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.Paragraph(text: "Scan QR Code to", style: const pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xffFFFFFF))),
                  pw.Paragraph(text: "View Our Menu", style: const pw.TextStyle(fontSize: 30, color: PdfColor.fromInt(0xffFFFFFF))),
                ])),
          ); // Center
        }));
    return await pdf.save();
  }

  Future<Uint8List> image4({required DiningTableModel diningTableModel}) async {
    final pdf = pw.Document();
    final img = await rootBundle.load('assets/images/qr_4.jpg');
    final imageBytes = img.buffer.asUint8List();
    final netImage = await networkImage(diningTableModel.tableAvtarImage.toString());

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            width: MediaQuery.of(Get.context!).size.width * 100,
            height: MediaQuery.of(Get.context!).size.height * 100,
            decoration: pw.BoxDecoration(image: pw.DecorationImage(image: pw.MemoryImage(imageBytes))),
            child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.ClipOval(
                    child: pw.Image(netImage, fit: pw.BoxFit.fitHeight, height: 120, width: 120),
                  ),
                  pw.Paragraph(text: diningTableModel.name.toString(), style: const pw.TextStyle(fontSize: 20, color: PdfColor.fromInt(0xffEF6320))),
                  pw.SizedBox(
                    height: 60,
                  ),
                  pw.BarcodeWidget(
                    color: PdfColor.fromHex("#FFFFFF"),
                    barcode: pw.Barcode.qrCode(),
                    height: 160,
                    width: 160,
                    data: Constant.qrCodeLink(branchId: diningTableModel.branchId.toString(), tableId: diningTableModel.id.toString()),
                  ),
                  pw.SizedBox(
                    height: 40,
                  ),
                  pw.Paragraph(text: "Scan QR Code to", style: const pw.TextStyle(fontSize: 16, color: PdfColor.fromInt(0xffFFFFFF))),
                  pw.Paragraph(text: "View Our Menu", style: const pw.TextStyle(fontSize: 30, color: PdfColor.fromInt(0xffFFFFFF))),
                ])),
          ); // Center
        }));
    return await pdf.save();
  }
}
