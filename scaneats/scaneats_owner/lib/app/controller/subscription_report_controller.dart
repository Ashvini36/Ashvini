import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scaneats_owner/app/model/restaurant_model.dart';
import 'package:scaneats_owner/app/model/subscription_transaction.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class SubscriptionReportController extends GetxController {
  RxString title = "Subscription Report".obs;

  final Rx<TextEditingController> searchEditingController = TextEditingController().obs;
  Rx<TextEditingController> dateFiledController = TextEditingController().obs;

  RxBool isOrderLoading = true.obs;
  RxList<SubscriptionTransaction> tempList = <SubscriptionTransaction>[].obs;
  RxList<SubscriptionTransaction> posOrderList = <SubscriptionTransaction>[].obs;

  Rx<DateTimeRange> selectedDate = DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0),
          end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0))
      .obs;

  @override
  void onInit() {
    // TODO: implement onInit
    totalItemPerPage.value = Constant.numofpageitemList.first;
    getPosOrderData();
    dateFiledController.value.text = "${DateFormat('yyyy-MM-dd').format(selectedDate.value.start)} to ${DateFormat('yyyy-MM-dd').format(selectedDate.value.end)}";
    super.onInit();
  }

  RxList<RestaurantModel> restaurantList = <RestaurantModel>[].obs;

  Future<void> getPosOrderData() async {
    isOrderLoading.value = true;

    await FireStoreUtils.getAllRestaurant().then((value) async {
      restaurantList.addAll(value!);
    });

    await FireStoreUtils.getAllSubscriptionTransaction().then((value) {
      if (value != null) {
        tempList.value = value;
        posOrderList.value = value;
      }
      setPagition(totalItemPerPage.value);
      isOrderLoading.value = false;
    });
  }

  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<SubscriptionTransaction> currentPageOrder = <SubscriptionTransaction>[].obs;
  Rx<RestaurantModel> selectedRestaurant = RestaurantModel().obs;

  setPagition(String page) {
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (posOrderList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > posOrderList.length ? posOrderList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagition(page);
      update();
    } else {
      currentPageOrder.value = posOrderList.sublist(startIndex.value, endIndex.value);
    }
    isOrderLoading.value = false;
    update();
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return posOrderList.length;
    } else {
      return int.parse(data);
    }
  }

  filter() {
    isOrderLoading.value = true;

    posOrderList.value = tempList.where(
      (e) {
        print("====>");
        print(selectedDate.value.start);
        print(selectedDate.value.end);
        print("=====>");
        return dateFiledController.value.text.isEmpty
            ? true
            : e.restaurantId == selectedRestaurant.value.id ||
                e.startDate!.toDate().isAfter(selectedDate.value.start) &&
                e.startDate!.toDate().isBefore(
                      DateTime(selectedDate.value.end.year, selectedDate.value.end.month, selectedDate.value.end.day, 23, 59, 0),
                    );
      },
    ).toList();

    setPagition(totalItemPerPage.value);
    isOrderLoading.value = false;
  }

  downLoadPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Table(border: pw.TableBorder.all(), children: [
              pw.TableRow(
                children: [
                  pw.Expanded(child: pw.Text("Subscription Plan")),
                  pw.Expanded(child: pw.Text("Plan Duration")),
                  pw.Expanded(child: pw.Text("Payment Type")),
                  pw.Expanded(child: pw.Text("Purchase date")),
                  pw.Expanded(child: pw.Text("Renew Date")),
                ],
              )
            ]),
            pw.Divider(),
            pw.Table(border: pw.TableBorder.all(), children: [
              for (var i = 0; i < posOrderList.length; i++)
                pw.TableRow(children: [
                  pw.Expanded(child: pw.Text(posOrderList[i].subscription!.planName.toString())),
                  pw.Expanded(child: pw.Text(Constant.durationName(posOrderList[i].durations!))),
                  pw.Expanded(child: pw.Text(posOrderList[i].paymentType.toString())),
                  pw.Expanded(child: pw.Text(Constant.timestampToDateAndTime(posOrderList[i].startDate!))),
                  pw.Expanded(child: pw.Text(Constant.timestampToDateAndTime(posOrderList[i].endDate!))),
                ]),
            ])
          ]; // Center
        }));
    Uint8List pdfInBytes = await pdf.save();

    await FileSaver.instance.saveFile(
      name: "sales_report",
      ext: 'pdf',
      mimeType: MimeType.pdf,
      bytes: pdfInBytes,
      dioClient: Dio(),
      transformDioResponse: (response) {
        return response.data;
      },
    );
  }

  createExcel(String type) async {
    //Create a new Excel Document.
    final Workbook workbook = Workbook();

//Access the sheets via index.
    final Worksheet worksheet = workbook.worksheets[0];

//Rename the worksheet.
    worksheet.name = 'Sales Report';

    worksheet.showGridlines = true;
    worksheet.enableSheetCalculations();
    //Defining a global style with properties.
    final Style globalStyle = workbook.styles.add('globalStyle');
    globalStyle.backColor = '#EF6320';
    globalStyle.fontSize = 12;
    globalStyle.fontColor = '#000000';
    globalStyle.bold = true;
    globalStyle.wrapText = true;
    globalStyle.hAlign = HAlignType.center;
    globalStyle.vAlign = VAlignType.center;
    worksheet.getRangeByName('A1:H1').cellStyle = globalStyle;
    worksheet.getRangeByName('A1:H1').autoFit();
    worksheet.getRangeByName('A1:H1').autoFitRows();
    worksheet.getRangeByName('A1:H1').autoFitColumns();
    worksheet.getRangeByName('A1:H1').columnWidth = 30.0;
    worksheet.getRangeByName('A1:H1').rowHeight = 20.0;

    final Style globalStyle1 = workbook.styles.add('globalStyle1');
    globalStyle1.fontSize = 12;
    globalStyle1.fontColor = '#000000';
    globalStyle1.hAlign = HAlignType.center;
    globalStyle1.vAlign = VAlignType.center;

    worksheet.getRangeByName('A1').setText('Subscription Plan');
    worksheet.getRangeByName('B1').setText('Plan Duration');
    worksheet.getRangeByName('C1').setText('Payment Type');
    worksheet.getRangeByName('D1').setText('Purchase date');
    worksheet.getRangeByName('E1').setText('Renew Date');

    for (int i = 0; i < posOrderList.length; i++) {
      worksheet.getRangeByName('A${i + 2}:H${i + 2}').cellStyle = globalStyle1;

      worksheet.getRangeByName('A${i + 2}').setText(posOrderList[i].subscription!.planName.toString());
      worksheet.getRangeByName('B${i + 2}').setText(Constant.durationName(posOrderList[i].durations!));
      worksheet.getRangeByName('C${i + 2}').setText(posOrderList[i].paymentType.toString());
      worksheet.getRangeByName('D${i + 2}').setText(Constant.timestampToDateAndTime(posOrderList[i].startDate!));
      worksheet.getRangeByName('E${i + 2}').setText(Constant.timestampToDateAndTime(posOrderList[i].endDate!));
    }

    //Save workbook as CSV
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    if (type == "CSV") {
      await FileSaver.instance.saveFile(
        name: "sales_report",
        ext: 'csv',
        mimeType: MimeType.csv,
        bytes: Uint8List.fromList(bytes),
        dioClient: Dio(),
        transformDioResponse: (response) {
          return response.data;
        },
      );
    } else {
      await FileSaver.instance.saveFile(
        name: "sales_report",
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
        bytes: Uint8List.fromList(bytes),
        dioClient: Dio(),
        transformDioResponse: (response) {
          return response.data;
        },
      );
    }
  }

//   Future<void> createExcel() async {
// //Create an Excel document.
//
//     //Creating a workbook.
//     final Workbook workbook = Workbook();
//     //Accessing via index
//     final Worksheet sheet = workbook.worksheets[0];
//     sheet.showGridlines = false;
//
//     // Enable calculation for worksheet.
//     sheet.enableSheetCalculations();
//
//     //Set data in the worksheet.
//     sheet.getRangeByName('A1').columnWidth = 4.82;
//     sheet.getRangeByName('B1:C1').columnWidth = 13.82;
//     sheet.getRangeByName('D1').columnWidth = 13.20;
//     sheet.getRangeByName('E1').columnWidth = 7.50;
//     sheet.getRangeByName('F1').columnWidth = 9.73;
//     sheet.getRangeByName('G1').columnWidth = 8.82;
//     sheet.getRangeByName('H1').columnWidth = 4.46;
//
//     sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
//     sheet.getRangeByName('A1:H1').merge();
//     sheet.getRangeByName('B4:D6').merge();
//
//     sheet.getRangeByName('B4').setText('Invoice');
//     sheet.getRangeByName('B4').cellStyle.fontSize = 32;
//
//     sheet.getRangeByName('B8').setText('BILL TO:');
//     sheet.getRangeByName('B8').cellStyle.fontSize = 9;
//     sheet.getRangeByName('B8').cellStyle.bold = true;
//
//     sheet.getRangeByName('B9').setText('Abraham Swearegin');
//     sheet.getRangeByName('B9').cellStyle.fontSize = 12;
//
//     sheet
//         .getRangeByName('B10')
//         .setText('United States, California, San Mateo,');
//     sheet.getRangeByName('B10').cellStyle.fontSize = 9;
//
//     sheet.getRangeByName('B11').setText('9920 BridgePointe Parkway,');
//     sheet.getRangeByName('B11').cellStyle.fontSize = 9;
//
//     sheet.getRangeByName('B12').setNumber(9365550136);
//     sheet.getRangeByName('B12').cellStyle.fontSize = 9;
//     sheet.getRangeByName('B12').cellStyle.hAlign = HAlignType.left;
//
//     final Range range1 = sheet.getRangeByName('F8:G8');
//     final Range range2 = sheet.getRangeByName('F9:G9');
//     final Range range3 = sheet.getRangeByName('F10:G10');
//     final Range range4 = sheet.getRangeByName('F11:G11');
//     final Range range5 = sheet.getRangeByName('F12:G12');
//
//     range1.merge();
//     range2.merge();
//     range3.merge();
//     range4.merge();
//     range5.merge();
//
//     sheet.getRangeByName('F8').setText('INVOICE#');
//     range1.cellStyle.fontSize = 8;
//     range1.cellStyle.bold = true;
//     range1.cellStyle.hAlign = HAlignType.right;
//
//     sheet.getRangeByName('F9').setNumber(2058557939);
//     range2.cellStyle.fontSize = 9;
//     range2.cellStyle.hAlign = HAlignType.right;
//
//     sheet.getRangeByName('F10').setText('DATE');
//     range3.cellStyle.fontSize = 8;
//     range3.cellStyle.bold = true;
//     range3.cellStyle.hAlign = HAlignType.right;
//
//     sheet.getRangeByName('F11').dateTime = DateTime(2020, 08, 31);
//     sheet.getRangeByName('F11').numberFormat =
//     '[\$-x-sysdate]dddd, mmmm dd, yyyy';
//     range4.cellStyle.fontSize = 9;
//     range4.cellStyle.hAlign = HAlignType.right;
//
//     range5.cellStyle.fontSize = 8;
//     range5.cellStyle.bold = true;
//     range5.cellStyle.hAlign = HAlignType.right;
//
//     final Range range6 = sheet.getRangeByName('B15:G15');
//     range6.cellStyle.fontSize = 10;
//     range6.cellStyle.bold = true;
//
//     sheet.getRangeByIndex(15, 2).setText('Code');
//     sheet.getRangeByIndex(16, 2).setText('CA-1098');
//     sheet.getRangeByIndex(17, 2).setText('LJ-0192');
//     sheet.getRangeByIndex(18, 2).setText('So-B909-M');
//     sheet.getRangeByIndex(19, 2).setText('FK-5136');
//     sheet.getRangeByIndex(20, 2).setText('HL-U509');
//
//     sheet.getRangeByIndex(15, 3).setText('Description');
//     sheet.getRangeByIndex(16, 3).setText('AWC Logo Cap');
//     sheet.getRangeByIndex(17, 3).setText('Long-Sleeve Logo Jersey, M');
//     sheet.getRangeByIndex(18, 3).setText('Mountain Bike Socks, M');
//     sheet.getRangeByIndex(19, 3).setText('ML Fork');
//     sheet.getRangeByIndex(20, 3).setText('Sports-100 Helmet, Black');
//
//     sheet.getRangeByIndex(15, 3, 15, 4).merge();
//     sheet.getRangeByIndex(16, 3, 16, 4).merge();
//     sheet.getRangeByIndex(17, 3, 17, 4).merge();
//     sheet.getRangeByIndex(18, 3, 18, 4).merge();
//     sheet.getRangeByIndex(19, 3, 19, 4).merge();
//     sheet.getRangeByIndex(20, 3, 20, 4).merge();
//
//     sheet.getRangeByIndex(15, 5).setText('Quantity');
//     sheet.getRangeByIndex(16, 5).setNumber(2);
//     sheet.getRangeByIndex(17, 5).setNumber(3);
//     sheet.getRangeByIndex(18, 5).setNumber(2);
//     sheet.getRangeByIndex(19, 5).setNumber(6);
//     sheet.getRangeByIndex(20, 5).setNumber(1);
//
//     sheet.getRangeByIndex(15, 6).setText('Price');
//     sheet.getRangeByIndex(16, 6).setNumber(8.99);
//     sheet.getRangeByIndex(17, 6).setNumber(49.99);
//     sheet.getRangeByIndex(18, 6).setNumber(9.50);
//     sheet.getRangeByIndex(19, 6).setNumber(175.49);
//     sheet.getRangeByIndex(20, 6).setNumber(34.99);
//
//     sheet.getRangeByIndex(15, 7).setText('Total');
//     sheet.getRangeByIndex(16, 7).setFormula('=E16*F16+(E16*F16)');
//     sheet.getRangeByIndex(17, 7).setFormula('=E17*F17+(E17*F17)');
//     sheet.getRangeByIndex(18, 7).setFormula('=E18*F18+(E18*F18)');
//     sheet.getRangeByIndex(19, 7).setFormula('=E19*F19+(E19*F19)');
//     sheet.getRangeByIndex(20, 7).setFormula('=E20*F20+(E20*F20)');
//     sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = '\$#,##0.00';
//
//     sheet.getRangeByName('E15:G15').cellStyle.hAlign = HAlignType.right;
//     sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
//     sheet.getRangeByName('B15:G15').cellStyle.bold = true;
//     sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;
//
//     sheet.getRangeByName('E22:G22').merge();
//     sheet.getRangeByName('E22:G22').cellStyle.hAlign = HAlignType.right;
//     sheet.getRangeByName('E23:G24').merge();
//
//     final Range range7 = sheet.getRangeByName('E22');
//     final Range range8 = sheet.getRangeByName('E23');
//     range7.setText('TOTAL');
//     range7.cellStyle.fontSize = 8;
//     range8.setFormula('=SUM(G16:G20)');
//     range8.numberFormat = '\$#,##0.00';
//     range8.cellStyle.fontSize = 24;
//     range8.cellStyle.hAlign = HAlignType.right;
//     range8.cellStyle.bold = true;
//
//     sheet.getRangeByIndex(26, 1).text =
//     '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
//     sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;
//
//     final Range range9 = sheet.getRangeByName('A26:H27');
//     range9.cellStyle.backColor = '#ACB9CA';
//     range9.merge();
//     range9.cellStyle.hAlign = HAlignType.center;
//     range9.cellStyle.vAlign = VAlignType.center;
//
//
//     //Save and launch the excel.
//     final List<int> bytes = await workbook.save();
//     //Dispose the document.
//     workbook.dispose();
//     //Save and launch file.
//     // SaveFilehelper.saveAndOpenFile(bytes);
//
//     await FileSaver.instance.saveFile(
//       name: "sales_report",
//       ext: 'csv',
//       mimeType: MimeType.csv,
//       bytes: Uint8List.fromList(bytes),
//       dioClient: Dio(),
//       transformDioResponse: (response) {
//         return response.data;
//       },
//     );
//   }
}
