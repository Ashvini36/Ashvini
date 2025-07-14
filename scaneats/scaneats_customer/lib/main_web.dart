// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_icons/flutter_app_icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/constant/collection_name.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/controller/global_setting_controller.dart';
import 'package:scaneats_customer/model/order_model.dart';
import 'package:scaneats_customer/page/pos_screen/order_detail_screen.dart';
import 'package:scaneats_customer/page/success_page.dart';
import 'package:scaneats_customer/service/localization_service.dart';
import 'package:scaneats_customer/theme/Styles.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/utils/Preferences.dart';
import 'package:scaneats_customer/utils/fire_store_utils.dart';
import 'page/pos_screen/navigate_pos_screen.dart';

Future<void> getParams() async {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  if (kDebugMode) {
    print("======>");
    print(params);
    Constant.paymentStatus = params['payment_status'];
    Preferences.setString(Preferences.table, "OhNjINF26GqjG5YssO1q");
    Preferences.setString(Preferences.branchId, "UlZ1ZViPXZP18NFzZ1EN");
    Preferences.setString(Preferences.restaurantId, "f75692ae-6d14-470f-9592-d88bb960afd8");
    Constant.tableNo = "OhNjINF26GqjG5YssO1q";
    Constant.branchId = "UlZ1ZViPXZP18NFzZ1EN";
    CollectionName.restaurantId = "f75692ae-6d14-470f-9592-d88bb960afd8";
  } else {
    Constant.paymentStatus = params['payment_status'];
    if ((params['table'].toString().isEmpty || params['table'] == null) && params['branchId'].toString().isEmpty ||
        params['branchId'] == null && params['restaurantId'].toString().isEmpty ||
        params['restaurantId'] == null) {
      String table = Preferences.getString(Preferences.table);
      String branchId = Preferences.getString(Preferences.branchId);
      String restaurantId = Preferences.getString(Preferences.restaurantId);

      Constant.tableNo = table;
      Constant.branchId = branchId;
      CollectionName.restaurantId = restaurantId;
    } else {
      Preferences.setString(Preferences.table, params['table'].toString());
      Preferences.setString(Preferences.branchId, params['branchId'].toString());
      Preferences.setString(Preferences.restaurantId, params['restaurantId'].toString());

      Constant.tableNo = params['table'].toString();
      Constant.branchId = params['branchId'].toString();
      CollectionName.restaurantId = params['restaurantId'].toString();
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    getUrlParameter();
    getCurrentAppTheme();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  // final _flutterAppIconsPlugin = FlutterAppIcons();
  bool isLoading = true;
  List<OrderModel>? orderList = <OrderModel>[].obs;

  getUrlParameter() async {
    await getParams();
    if (CollectionName.restaurantId.isNotEmpty) {
      await FireStoreUtils.getThem().then((value) {
        if (value != null) {
          if (value.color != null && value.color!.isNotEmpty) {
            AppThemeData.crusta500 = HexColor.fromHex(value.color.toString());
          }
          Constant.projectName = value.name.toString();
          Constant.projectLogo = value.logo.toString();
          // _flutterAppIconsPlugin.setIcon(icon: value.favIcon ?? Constant.projectLogo);
        }
      });

      await FireStoreUtils.getRestaurantById(restaurantId: CollectionName.restaurantId).then((value) {
        if (value != null) {
          Constant.restaurantModel = value;
        }
      });
    }

    orderList = await FireStoreUtils.getAllOrderwithTableNo(tableNo: Constant.tableNo);
    if (Constant.paymentStatus == '') {
      await Preferences.clearKeyData(Preferences.orderData);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return GetMaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            title: Constant.projectName,
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(
                themeChangeProvider.darkTheme == 0
                    ? true
                    : themeChangeProvider.darkTheme == 1
                        ? false
                        : themeChangeProvider.getSystemThem(),
                context),
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.locale,
            translations: LocalizationService(),
            builder: EasyLoading.init(),
            home: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GetX<GlobalSettingController>(
                    init: GlobalSettingController(),
                    builder: (controller) {
                      return controller.isLoading.value
                          ? Constant.loader(context)
                          : Constant.paymentStatus != null && Constant.paymentStatus!.isNotEmpty
                              ? Constant.paymentStatus == "success"
                                  ? const SuccessPage(isSuccess: true)
                                  : const SuccessPage(isSuccess: false)
                              : orderList?.isEmpty == true
                                  ? const NavigatePosScreen()
                                  : OrderDetailScreen(ordermodel: orderList!.first, restaurantId: CollectionName.restaurantId);
                    },
                  ),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
