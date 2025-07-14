

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:scaneats/app/model/order_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

class OrderDetailsController extends GetxController {
  Rx<OrderModel> selectedOrder = OrderModel().obs;

  RxList<String> paymentStatus = ['Paid', 'Unpaid'].obs;
  RxString selectedPaymentStatus = ''.obs;

  RxList<String> orderType =
      [Constant.statusOrderPlaced, Constant.statusAccept, Constant.statusPending, Constant.statusDelivered, Constant.statusTakeaway, Constant.statusRejected].obs;
  RxString selectedOrderStatus = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit=
    super.onInit();
  }

  setOrderModel(OrderModel orderModel) async {
    selectedOrder.value = orderModel;
    selectedOrderStatus.value = selectedOrder.value.status ?? Constant.statusDelivered;
    selectedPaymentStatus.value = selectedOrder.value.paymentStatus == true ? 'Paid' : 'Unpaid';
  }

  Future updateOrderData() async {
    selectedOrder.value.updatedAt = Timestamp.now();
    selectedOrder.value.paymentStatus = selectedPaymentStatus.value == 'Paid' ? true : false;
    selectedOrder.value.status = selectedOrderStatus.value;

    await FireStoreUtils.updateOrderById(model: selectedOrder.value).then((value) {
      Get.back();
      ShowToastDialog.showToast("Table Order has been updated.");
    });
  }

  printInvoice() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              child: pw.Column(
                children: [
                  pw.Text(Constant.projectName,
                      textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 24, color: const PdfColor.fromInt(0xff1D2834), fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text(Constant.selectedBranch.address.toString(), textAlign: pw.TextAlign.center, style: const pw.TextStyle(color: PdfColor.fromInt(0xffA6BFD3))),
                  pw.SizedBox(height: 10),
                  pw.Text("Tel: ${Constant.selectedBranch.phoneNumber.toString()}", textAlign: pw.TextAlign.center, style: const pw.TextStyle(color: PdfColor.fromInt(0xffA6BFD3))),
                  pw.SizedBox(height: 20),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.LayoutBuilder(
                        builder: (context, constraints) {
                          final boxWidth = constraints!.constrainWidth();
                          const dashWidth = 5.0;
                          const dashHeight = 1.0;
                          final dashCount = (boxWidth / (2 * dashWidth)).floor();
                          return pw.Flex(
                            children: List.generate(dashCount, (_) {
                              return pw.SizedBox(
                                width: dashWidth,
                                height: dashHeight,
                                child: pw.DecoratedBox(
                                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                                ),
                              );
                            }),
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            direction: pw.Axis.horizontal,
                          );
                        },
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text("OrderId: ${Constant.orderId(orderId: selectedOrder.value.id.toString())}",
                          textAlign: pw.TextAlign.start, style: const pw.TextStyle(color: PdfColor.fromInt(0xffA6BFD3))),
                      pw.SizedBox(height: 5),
                      pw.Text("Date: ${Constant.timestampToDateAndTime(selectedOrder.value.createdAt!)}",
                          textAlign: pw.TextAlign.start, style: const pw.TextStyle(color: PdfColor.fromInt(0xffA6BFD3))),
                      pw.SizedBox(height: 10),
                      pw.LayoutBuilder(
                        builder: (context, constraints) {
                          final boxWidth = constraints!.constrainWidth();
                          const dashWidth = 5.0;
                          const dashHeight = 1.0;
                          final dashCount = (boxWidth / (2 * dashWidth)).floor();
                          return pw.Flex(
                            children: List.generate(dashCount, (_) {
                              return pw.SizedBox(
                                width: dashWidth,
                                height: dashHeight,
                                child: pw.DecoratedBox(
                                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                                ),
                              );
                            }),
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            direction: pw.Axis.horizontal,
                          );
                        },
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints!.constrainWidth();
                      const dashWidth = 5.0;
                      const dashHeight = 1.0;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return pw.Flex(
                        children: List.generate(dashCount, (_) {
                          return pw.SizedBox(
                            width: dashWidth,
                            height: dashHeight,
                            child: pw.DecoratedBox(
                              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                            ),
                          );
                        }),
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        direction: pw.Axis.horizontal,
                      );
                    },
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    children: [
                      pw.TableRow(children: [
                        pw.Container(
                          height: 30,
                          child: pw.Text('Qty'),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Container(
                            height: 30,
                            child: pw.Text('Item Description'),
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Container(
                          height: 30,
                          child: pw.Text('Price'),
                        ),
                      ]),
                      for (var i = 0; i < selectedOrder.value.product!.length; i++)
                        pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Text('${selectedOrder.value.product![i].qty}'),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: pw.Container(
                              child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                                pw.Text('${selectedOrder.value.product![i].name}'),
                                selectedOrder.value.product![i].variantId != null
                                    ? pw.Text(
                                        '(${selectedOrder.value.product![i].itemAttributes!.variants!.firstWhere((element) => element.variantId == selectedOrder.value.product![i].variantId).variantSku.toString()})')
                                    : pw.SizedBox(),
                                pw.SizedBox(height: 5),
                                selectedOrder.value.product![i].addons!.isNotEmpty
                                    ? pw.SizedBox(
                                        height: 30,
                                        child: pw.Column(
                                            children: selectedOrder.value.product![i].addons!.map((e) {
                                          return pw.Row(children: [
                                            pw.Text('${e.name} * ${e.qty}'),
                                            pw.SizedBox(width: 10),
                                            pw.Text('='),
                                            pw.SizedBox(width: 10),
                                            pw.Text(Constant.amountShow(amount: (double.parse(e.price.toString()) * double.parse(e.qty.toString())).toString()))
                                          ]);
                                        }).toList()),
                                      )
                                    : pw.SizedBox(),
                              ]),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Container(
                            height: 20,
                            child: pw.Text(
                              Constant.amountShow(
                                amount: (double.parse(selectedOrder.value.product![i].price.toString()) * double.parse(selectedOrder.value.product![i].qty.toString())).toString(),
                              ),
                            ),
                          ),
                        ])
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints!.constrainWidth();
                      const dashWidth = 5.0;
                      const dashHeight = 1.0;
                      final dashCount = (boxWidth / (2 * dashWidth)).floor();
                      return pw.Flex(
                        children: List.generate(dashCount, (_) {
                          return pw.SizedBox(
                            width: dashWidth,
                            height: dashHeight,
                            child: pw.DecoratedBox(
                              decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                            ),
                          );
                        }),
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        direction: pw.Axis.horizontal,
                      );
                    },
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table(
                    children: [
                      pw.TableRow(children: [
                        pw.Container(
                          height: 20,
                          width: 20,
                          child: pw.Text(''),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 20,
                            child: pw.Text('SubTotal'),
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Container(
                          height: 20,
                          child: pw.Text(Constant.amountShow(amount: selectedOrder.value.subtotal.toString())),
                        ),
                      ]),
                      pw.TableRow(children: [
                        pw.Container(
                          height: 20,
                          width: 20,
                          child: pw.Text(''),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 20,
                            child: pw.Text('Discount'),
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Container(
                          height: 20,
                          child: pw.Text(" - ${Constant.amountShow(amount: selectedOrder.value.discount.toString())}"),
                        ),
                      ]),
                    ],
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 10),
                    child: pw.LayoutBuilder(
                      builder: (context, constraints) {
                        final boxWidth = constraints!.constrainWidth();
                        const dashWidth = 5.0;
                        const dashHeight = 1.0;
                        final dashCount = (boxWidth / (2 * dashWidth)).floor();
                        return pw.Flex(
                          children: List.generate(dashCount, (_) {
                            return pw.SizedBox(
                              width: dashWidth,
                              height: dashHeight,
                              child: pw.DecoratedBox(
                                decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                              ),
                            );
                          }),
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          direction: pw.Axis.horizontal,
                        );
                      },
                    ),
                  ),
                  pw.Table(
                    children: [
                      if (selectedOrder.value.taxList != null)
                        for (int j = 0; j < selectedOrder.value.taxList!.length; j++)
                          pw.TableRow(children: [
                            pw.Container(
                              height: 20,
                              width: 20,
                              child: pw.Text(''),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                height: 20,
                                child: pw.Text(
                                    '${selectedOrder.value.taxList![j].name.toString()} (${selectedOrder.value.taxList![j].isFix == true ? Constant.amountShow(amount: selectedOrder.value.taxList![j].rate.toString()) : "${selectedOrder.value.taxList![j].rate}%"})'),
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Container(
                              height: 20,
                              child: pw.Text(
                                Constant.amountShow(
                                  amount: Constant()
                                      .calculateTax(
                                          taxModel: selectedOrder.value.taxList![j],
                                          amount: (double.parse(selectedOrder.value.subtotal.toString()) - double.parse(selectedOrder.value.discount.toString())).toString())
                                      .toString(),
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 10),
                    child: pw.LayoutBuilder(
                      builder: (context, constraints) {
                        final boxWidth = constraints!.constrainWidth();
                        const dashWidth = 5.0;
                        const dashHeight = 1.0;
                        final dashCount = (boxWidth / (2 * dashWidth)).floor();
                        return pw.Flex(
                          children: List.generate(dashCount, (_) {
                            return pw.SizedBox(
                              width: dashWidth,
                              height: dashHeight,
                              child: pw.DecoratedBox(
                                decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xffA6BFD3)),
                              ),
                            );
                          }),
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          direction: pw.Axis.horizontal,
                        );
                      },
                    ),
                  ),
                  pw.Table(
                    children: [
                      pw.TableRow(children: [
                        pw.Container(
                          height: 20,
                          width: 20,
                          child: pw.Text(''),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            height: 20,
                            child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Container(
                          height: 20,
                          child: pw.Text(
                            Constant.amountShow(amount: (double.parse(selectedOrder.value.total.toString())).toString()),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    "Thank You",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xffA6BFD3), fontSize: 30),
                  )
                ],
              ),
            )
          ]; // Center
        },
      ),
    );
    // Uint8List pdfInBytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
