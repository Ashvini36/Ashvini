import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/collection_name.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/constant/show_toast_dialog.dart';
import 'package:scaneats_customer/model/currencies_model.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/page/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats_customer/page/pos_screen/order_detail_screen.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  bool isScan = false;
  @override
  void initState() {
    redirect();
    super.initState();
  }

  redirect() async {
    await Preferences.clearKeyData(Preferences.orderData);
    // if(kDebugMode){
    //   Constant.tableNo = "ekdwT1rSdYQ9Ft6rxlU9";
    //   Constant.branchId = "WvZ84S25WoKbYK4yDcUh";
    //   CollectionName.restaurantId = "f75692ae-6d14-470f-9592-d88bb960afd8";
    //   await getBranchData();
    //   ShowToastDialog.closeLoader();
    //   Get.to(const NavigatePosScreen());
    // }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
        elevation: 0,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: TextCustom(title: Constant.projectName, color: AppThemeData.crusta500, fontSize: 20),
      ),
      body: MobileScanner(
        fit: BoxFit.contain,
        controller: MobileScannerController(
          returnImage: true,
        ),
        onDetect: (capture) async {
          if (!isScan) {
            isScan == true;
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
              ShowToastDialog.showLoader("Please wait");
              var uri = Uri.dataFromString(barcode.rawValue.toString());
              Map<String, String> params = uri.queryParameters;
              Constant.tableNo = params['table'].toString();
              Constant.branchId = params['branchId'].toString();
              CollectionName.restaurantId = params['restaurantId'].toString();
              await getBranchData();
              List<OrderModel>? orderList = await FireStoreUtils.getAllOrderwithTableNo(tableNo: Constant.tableNo);
              ShowToastDialog.closeLoader();
              if (orderList?.isEmpty == true) {
                Get.to(const NavigatePosScreen())?.then((v) {
                  setState(() {
                    isScan == false;
                  });
                });
              } else {
                Get.to(OrderDetailScreen(ordermodel: orderList!.first, restaurantId: CollectionName.restaurantId))?.then((v) {
                  setState(() {
                    isScan == false;
                  });
                });
              }
            }
          }
        },
      ),
    );
  }

  Future<void> getBranchData() async {
    await FireStoreUtils.getRestaurantById(restaurantId: CollectionName.restaurantId).then((value) {
      if (value != null) {
        Constant.restaurantModel = value;
      }
    });

    await FireStoreUtils.getActiveCurrencies().then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          Constant.currency = value.first;
        } else {
          Constant.currency = CurrenciesModel(id: "", isActive: true, name: "Dollar", code: "US", symbol: "\$", decimalDigits: "2", symbolAtRight: false);
        }
      }
    });

    await FireStoreUtils.getActiveTax().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });

    await FireStoreUtils.getThem().then((value) {
      if (value != null) {
        AppThemeData.crusta500 = HexColor.fromHex(value.color.toString());
        Constant.projectName = value.name.toString();
        Constant.projectLogo = value.logo.toString();
      }
    });

    await FireStoreUtils.getPaymentData().then((value) {
      if (value != null) {
        Constant.paymentModel = value;
      }
    });

    await FireStoreUtils.getServerKeyDetails().then((value) {
      if (value != null) {
        Constant.serverKey = value.serverKey.toString();
      }
    });
    setState(() {});
  }
}
