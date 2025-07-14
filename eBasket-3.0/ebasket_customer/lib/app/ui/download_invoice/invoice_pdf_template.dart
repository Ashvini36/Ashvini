import 'dart:io';
import 'dart:math';

import 'package:ebasket_customer/widgets/number_to_character_converter/number_to_character.dart';
import 'package:flutter/services.dart';
import 'package:ebasket_customer/app/model/order_model.dart';
import 'package:ebasket_customer/app/model/tax_model.dart';
import 'package:ebasket_customer/app/ui/download_invoice/file_handle_api.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class CreateInvoicePdf {
  static Future<File> generate(OrderModel orderModel, String? state) async {
    final pdf = Document();

    var converter = NumberToCharacterConverter('en');

    final iconImage = (await rootBundle.load('assets/icons/ic_ebasket_logo.png')).buffer.asUint8List();

    getDiscount(product) {
      RxDouble discount = 0.0.obs;

      discount.value = (((double.parse(product.price!) * double.parse(product.quantity!.toString())) * double.parse(product.discount.toString())) / 100);

      return discount.value;
    }

    double getTaxableValue(product) {
      RxDouble taxableValue = 0.0.obs;
      RxDouble discount = 0.0.obs;
      discount.value = getDiscount(product);

      taxableValue.value = ((double.parse(product.price.toString())) * (double.parse(product.quantity.toString()))) - discount.value;

      return taxableValue.value;
    }

    getCoupon(orderModel) {
      RxDouble coupon = 0.0.obs;
      RxDouble subTotal = 0.0.obs;
      if (orderModel.coupon!.id != null) {
        if (orderModel.coupon!.discountType == "Fix Price") {
          coupon.value = double.parse(orderModel.coupon!.discount.toString());
        } else {
          for (var element in orderModel.products) {
            //subTotal.value += getTaxableValue(element);
            if (element.discountPrice != '0') {
              subTotal.value +=  ((double.parse(element.discountPrice.toString())) * (double.parse(element.quantity.toString())));

            } else {
              subTotal.value += ((double.parse(element.price.toString())) * (double.parse(element.quantity.toString())));
            }
          }
          coupon.value = double.parse(subTotal.value.toString()) * double.parse(orderModel.coupon!.discount.toString()) / 100;
        }
      }

      return coupon.value;
    }

    double getGSTAmount(orderModel) {
      RxDouble taxAmount = 0.0.obs;
      RxDouble amount = 0.0.obs;
      for (var element in orderModel.products) {
        if (element.discountPrice != '0') {
          amount.value += double.parse(element.discountPrice!);
        } else {
          amount.value += double.parse(element.price);
        }
      }
      if (orderModel.taxModel != null) {
        for (var element in orderModel.taxModel!) {
          taxAmount.value = (double.parse(taxAmount.value.toString()) + Constant.calculateTax(amount: (amount.value).toString(), taxModel: element));
        }
      }

      return taxAmount.value;
    }

    double getAllTaxableValue(orderModel) {
      RxDouble taxableValue = 0.0.obs;
      RxDouble coupon = 0.0.obs;
      coupon.value = getCoupon(orderModel);
      for (var element in orderModel.products) {
        taxableValue.value += getTaxableValue(element);
      }

      return (taxableValue.value - coupon.value);
    }

    getAllDiscount(orderModel) {
      RxDouble discount = 0.0.obs;
      RxDouble coupon = 0.0.obs;
      coupon.value = getCoupon(orderModel);
      for (var element in orderModel.products) {
        discount.value += getDiscount(element);
      }
      return (discount.value + coupon.value);
    }

    /*  double getTotalGSTAmount(orderModel) {
      RxDouble taxAmount = 0.0.obs;
      RxDouble amount = 0.0.obs;

      for (var element in orderModel.products) {
        if (element.discountPrice != '0') {
          amount.value += double.parse(element.discountPrice!);
        } else {
          amount.value += double.parse(element.price);
        }
        if (element.tax != null && element.tax.enable == true) {
          if (element.tax.type == "fix") {
            taxAmount.value += double.parse(element.tax.tax.toString());
          } else {
            taxAmount.value += (double.parse(amount.toString()) * double.parse(element.tax.tax!.toString())) / 100;
          }
        }
      }
      return taxAmount.value;
    }*/

    // double getGSTAmount(product) {
    //   RxDouble taxAmount = 0.0.obs;
    //   RxDouble amount = 0.0.obs;
    //
    //   if (product.discountPrice != '0') {
    //     amount.value += double.parse(product.discountPrice!);
    //   } else {
    //     amount.value += double.parse(product.price);
    //   }
    //   taxAmount.value = Constant.calculateTax(amount: (amount.value).toString(), taxModel: product.tax);
    //
    //   return taxAmount.value;
    // }

    double getTotalValue(product, orderModel) {
      RxDouble taxAmount = 0.0.obs;
      RxDouble total = 0.0.obs;
      RxDouble taxableValue = 0.0.obs;
      // taxAmount.value = getGSTAmount(product);
      //  taxAmount.value = getGSTAmount(orderModel);
      taxableValue.value = getTaxableValue(product);

      total.value = taxableValue.value + taxAmount.value;
      return total.value;
    }

    double getAllTotalValue(orderModel) {
      RxDouble total = 0.0.obs;
      RxDouble coupon = 0.0.obs;
      coupon.value = getCoupon(orderModel);
      for (var element in orderModel.products) {
        total.value += getTotalValue(element, orderModel);
      }
      return (total.value - coupon.value);
    }

    getQuantity(orderModel) {
      RxDouble quantity = 0.0.obs;
      for (var element in orderModel.products) {
        quantity.value = quantity.value + double.parse(element.quantity.toString());
      }
      return quantity.value;
    }

    double getAmount(product) {
      RxDouble amount = 0.0.obs;

      amount.value += (double.parse(product.price!) * double.parse(product.quantity!.toString()));

      return amount.value;
    }

    getTotalAmount(orderModel) {
      RxDouble totalAmount = 0.0.obs;

      for (var element in orderModel.products) {
        totalAmount.value += getAmount(element);
      }
      return totalAmount.value;
    }

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(marginLeft: 10, marginRight: 10, marginBottom: 1.5),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Center(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text('Trimaran Agro Foods International Pvt Ltd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
                Text('Original', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ]));
        },
        build: (Context context) => <Widget>[
          Header(
            level: 0,
            child: Container(
              // decoration: const BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       width: 2,
              //       color: PdfColors.black,
              //     ),
              //   ),
              // ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Image(
                  MemoryImage(iconImage),
                  height: 80,
                  width: 80,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pune.PIN: 411008', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 20),
                    Text('GSTIN: ABCD123456SDS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Duplicate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Triplicate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Extra OC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ), // Need this to be

                // PdfLogo()
              ]),
            ),
          ),
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const EdgeInsets.all(
                3.0 * PdfPageFormat.mm,
              ),
              decoration: BoxDecoration(
                color: PdfColors.green300,
                border: Border.all(
                  width: 1,
                  color: PdfColors.black,
                ),
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Tax Invoice ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  children: <TextSpan>[
                    orderModel.coupon!.id != null
                        ? TextSpan(text: '(Scenario 2-Coupon Code applied on Total Value)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: PdfColors.red))
                        : TextSpan(text: '(Scenario 1 above 30 KG no GST)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: PdfColors.red)),
                  ],
                ),
              )),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text('Invoice No: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            Constant.getOtpCode(),
                          ),
                        ]),
                        Row(children: [
                          Text('Invoice date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            orderModel.createdAt.toDate().formatDate(),
                          ),
                        ]),
                        Text('Reverse Charge (Y/N):',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Row(children: [
                          Expanded(
                              child: Text('State:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ))),
                          Expanded(
                              child: Text('Code:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )))
                        ]),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text('Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text('Place:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                padding: const EdgeInsets.all(
                  3.0 * PdfPageFormat.mm,
                ),
                decoration: BoxDecoration(
                  color: PdfColors.green300,
                  border: Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Details of Receiver(Billed to)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Details of Consignee(Billed to)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ])),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(orderModel.user!.fullName.toString()),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('Address: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(width: 200, child: Text(
                          //orderModel.user!.businessAddress.toString(),
                        orderModel.address!.getFullAddress(),
                          maxLines: 3)),
                    ]),
                    Row(children: [
                      Expanded(
                        child: Row(children: [
                          Text('State: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          Text(state.toString()),
                        ]),
                      ),
                      Expanded(
                          child: Row(children: [
                        Text('Code: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(orderModel.address!.pinCode.toString()),
                      ])),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Address:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('GSTIN:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Row(children: [
                      Expanded(
                          child: Text('State:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))),
                      Expanded(
                          child: Text('Code:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )))
                    ]),
                  ],
                ),
              ),
            ])
          ]),
          SizedBox(height: 30),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                width: 0.4,
                color: PdfColors.grey,
              ),
              columnWidths: {
                0: const FixedColumnWidth(20),
                1: const FixedColumnWidth(70),
                2: const FixedColumnWidth(20), //add
                3: const FixedColumnWidth(25),
                4: const FixedColumnWidth(25),
                5: const FixedColumnWidth(30),
                6: const FixedColumnWidth(30),
                7: const FixedColumnWidth(32),
                // 8: const FixedColumnWidth(20),
                // 9: const FixedColumnWidth(25),
                8: const FixedColumnWidth(26),
              },
              children: [
                TableRow(
                    decoration: const BoxDecoration(
                      color: PdfColors.green300,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Sr No.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Product \nDescription',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'UOM',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Rate',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Amount',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          'Discount',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Taxable \nValue',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(4),
                      //   child: Text(
                      //     'GST+cess \nRate',
                      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(3),
                      //   child: Text(
                      //     'GST+cess \nAmount',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          'Total',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ]),
              ]),
          ListView.builder(
              itemCount: orderModel.products.length,
              itemBuilder: (context, index) {
                CartProduct product = orderModel.products[index];
                return Table(
                    columnWidths: {
                      0: const FixedColumnWidth(20),
                      1: const FixedColumnWidth(70),
                      2: const FixedColumnWidth(20),
                      3: const FixedColumnWidth(25),
                      4: const FixedColumnWidth(25),
                      5: const FixedColumnWidth(30),
                      6: const FixedColumnWidth(30),
                      7: const FixedColumnWidth(32),
                      // 8: const FixedColumnWidth(20),
                      // 9: const FixedColumnWidth(25),
                      8: const FixedColumnWidth(26),
                    },
                    border: TableBorder.all(
                      width: 0.4,
                      color: PdfColors.grey,
                    ),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(product.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(product.unit,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(product.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 8,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(product.price.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(double.parse(getAmount(product).toString()).round().toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(double.parse(getDiscount(product).toString()).round().toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(double.parse(getTaxableValue(product).toString()).round().toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(3),
                        //   child: Text((Constant.calculateTax(amount: product.discountPrice.toString(), taxModel: product.tax)).toString(),
                        //       textAlign: TextAlign.center,
                        //       style: const TextStyle(
                        //         fontSize: 10,
                        //       )),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(3),
                        //   child: Text(double.parse(getGSTAmount(product).toString()).round().toString(),
                        //       textAlign: TextAlign.center,
                        //       style: const TextStyle(
                        //         fontSize: 10,
                        //       )),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(double.parse(getTotalValue(product, orderModel).toString()).round().toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              )),
                        ),
                      ]),
                    ]);
              }),
          orderModel.coupon!.id != null
              ? Table(
                  columnWidths: {
                    0: const FixedColumnWidth(20),
                    1: const FixedColumnWidth(70),
                    2: const FixedColumnWidth(20),
                    3: const FixedColumnWidth(25),
                    4: const FixedColumnWidth(25),
                    5: const FixedColumnWidth(30),
                    6: const FixedColumnWidth(30),
                    7: const FixedColumnWidth(32),
                    // 8: const FixedColumnWidth(20),
                    // 9: const FixedColumnWidth(25),
                    8: const FixedColumnWidth(26),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('Coupon Applied',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('-',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 8,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(getCoupon(orderModel).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('-${getCoupon(orderModel).toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(3),
                      //   child: Text('',
                      //       textAlign: TextAlign.center,
                      //       style: const TextStyle(
                      //         fontSize: 10,
                      //       )),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(3),
                      //   child: Text('',
                      //       textAlign: TextAlign.center,
                      //       style: const TextStyle(
                      //         fontSize: 10,
                      //       )),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('-${getCoupon(orderModel).toString()}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                            )),
                      ),
                    ]),
                  ])
              : SizedBox(),
          Table(
            columnWidths: {
              0: const FixedColumnWidth(110),
              1: const FixedColumnWidth(27),
              2: const FixedColumnWidth(24),
              3: const FixedColumnWidth(30),
              4: const FixedColumnWidth(30),
              5: const FixedColumnWidth(32),
              // 6: const FixedColumnWidth(20),
              // 7: const FixedColumnWidth(25),
              6: const FixedColumnWidth(26),
            },
            border: TableBorder.all(
              width: 0.4,
              color: PdfColors.grey,
            ),
            children: [
              TableRow(children: [
                Container(
                    decoration: BoxDecoration(
                      color: PdfColors.green300,
                      border: Border.all(
                        width: 1,
                        color: PdfColors.black,
                      ),
                    ),
                    child: Text('Total',
                        style: TextStyle(
                          fontSize: 18,
                          color: PdfColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)),
                Text(double.parse(getQuantity(orderModel).toString()).round().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
                Text('', textAlign: TextAlign.center),
                Text(double.parse(getTotalAmount(orderModel).toString()).round().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
                Text(double.parse(getAllDiscount(orderModel).toString()).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
                Text(double.parse(getAllTaxableValue(orderModel).toString()).round().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
                // Text('',
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //       fontSize: 10,
                //     )),
                // Text(double.parse(getTotalGSTAmount(orderModel).toString()).round().toString(),
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //       fontSize: 10,
                //     )),
                Text(double.parse(getAllTotalValue(orderModel).toString()).round().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
              ])
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0 * PdfPageFormat.mm,
                    ),
                    decoration: BoxDecoration(
                      color: PdfColors.green300,
                      border: Border.all(
                        width: 1,
                        color: PdfColors.black,
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text('Total Invoice amount in Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ])),
                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2.0 * PdfPageFormat.mm,
                  ),
                  child: Text(
                      '${converter.convertDouble(double.parse((double.parse(getAllTaxableValue(orderModel).toString()) + double.parse(getGSTAmount(orderModel).toString()) + double.parse(orderModel.deliveryCharge.toString())).toStringAsFixed(2)))} Only',
                      maxLines: 3,
                      textAlign: TextAlign.start),
                )
              ]),
            ),
            Container(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 8.0 * PdfPageFormat.mm,
              // ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                Table(
                  columnWidths: {
                    0: const FixedColumnWidth(155),
                    1: const FixedColumnWidth(45),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text('Total Amount before Tax:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                      Text(double.parse(getAllTaxableValue(orderModel).toString()).toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center),
                    ])
                  ],
                ),
                /*   Table(
                  columnWidths: {
                    0: const FixedColumnWidth(155),
                    1: const FixedColumnWidth(45),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text('Add GST+cess:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                            //   double.parse(getTotalGSTAmount(orderModel).toString()).round().toString(),
                            double.parse(getGSTAmount(orderModel).toString()).toString(),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ])
                  ],
                ),*/
                ListView.builder(
                  itemCount: orderModel.taxModel!.length,
                  itemBuilder: (context, index) {
                    TaxModel taxModel = orderModel.taxModel![index];
                    return Table(
                      columnWidths: {
                        0: const FixedColumnWidth(155),
                        1: const FixedColumnWidth(45),
                      },
                      border: TableBorder.all(
                        width: 0.4,
                        color: PdfColors.grey,
                      ),
                      children: [
                        TableRow(children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Text('Add ${taxModel.title}:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(double.parse(getGSTAmount(orderModel).toString()).toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ])
                      ],
                    );
                  },
                ),
                Table(
                  columnWidths: {
                    0: const FixedColumnWidth(155),
                    1: const FixedColumnWidth(45),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text('Delivery Charges:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(orderModel.deliveryCharge.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ])
                  ],
                ),
                orderModel.coupon!.id == null
                    ? Table(
                        columnWidths: {
                          0: const FixedColumnWidth(160),
                          1: const FixedColumnWidth(40),
                        },
                        border: TableBorder.all(
                          width: 0.4,
                          color: PdfColors.grey,
                        ),
                        children: [
                          TableRow(children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Text('Sales Return:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Text('0',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ])
                        ],
                      )
                    : SizedBox(),
                Table(
                  columnWidths: {
                    0: const FixedColumnWidth(155),
                    1: const FixedColumnWidth(45),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                            (double.parse(getAllTaxableValue(orderModel).toString()) +
                                    double.parse(getGSTAmount(orderModel).toString()) +
                                    double.parse(orderModel.deliveryCharge.toString()))
                                .toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ])
                  ],
                ),
              ]),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.35 * PdfPageFormat.cm, vertical: 1 * PdfPageFormat.mm),
                  decoration: BoxDecoration(
                    color: PdfColors.green300,
                    border: Border.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                  ),
                  child: Text('Bank Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Bank Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Bank A/C:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Bank IFSC:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Terms and Conditions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ]),
            ),
            Container(
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 8.0 * PdfPageFormat.mm,
              // ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                Table(
                  columnWidths: {
                    0: const FixedColumnWidth(160),
                    1: const FixedColumnWidth(40),
                  },
                  border: TableBorder.all(
                    width: 0.4,
                    color: PdfColors.grey,
                  ),
                  children: [
                    TableRow(children: [
                      Container(
                          decoration: BoxDecoration(
                            color: PdfColors.green300,
                            border: Border.all(
                              width: 1,
                              color: PdfColors.black,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 1 * PdfPageFormat.mm, vertical: 1 * PdfPageFormat.mm),
                          child: Text('GST On Reverse Charge:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.start)),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 1 * PdfPageFormat.mm, vertical: 1 * PdfPageFormat.mm),
                          decoration: BoxDecoration(
                            color: PdfColors.green300,
                            border: Border.all(
                              width: 2,
                              color: PdfColors.black,
                            ),
                          ),
                          child: Text('0',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center)),
                    ])
                  ],
                ),
                Container(
                    width: 200, child: Text('Certified that the particulars given above are true and correct:', style: const TextStyle(fontSize: 10), textAlign: TextAlign.center)),
                SizedBox(height: 5),
                Text('For XYZ & Co',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 25),
                Text('Authorised Signatory',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ]),
            ),
          ]),
        ],
      ),
    );
    // return FileHandleApi.saveDocument(name: 'invoice_${orderModel.id.toString()}.pdf', pdf: pdf);
    return FileHandleApi.saveDocument(name: '${Random().nextInt(100000)}.pdf', pdf: pdf);
  }
}
