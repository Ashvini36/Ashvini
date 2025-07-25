import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MercadoPagoScreen extends StatefulWidget {
  final String initialURl;

  const MercadoPagoScreen({
    super.key,
    required this.initialURl,
  });

  @override
  State<MercadoPagoScreen> createState() => _MercadoPagoScreenState();
}

class _MercadoPagoScreenState extends State<MercadoPagoScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            debugPrint("--->2 ${navigation.url}");
            if (navigation.url.contains("${Constant.globalUrl}payment/success")) {
              Get.back(result: true);
            }
            if (navigation.url.contains("${Constant.globalUrl}payment/failure") || navigation.url.contains("${Constant.globalUrl}payment/pending")) {
              Get.back(result: false);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialURl));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text("Payment".tr),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _showMyDialog();
              },
              child: const Icon(
                Icons.arrow_back,
              ),
            )),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Payment'.tr),
          content: SingleChildScrollView(
            child: Text("Are you sure want to cancel payment?".tr),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.back(result: false);
              },
            ),
            TextButton(
              child: Text(
                'Continue'.tr,
                style: const TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
