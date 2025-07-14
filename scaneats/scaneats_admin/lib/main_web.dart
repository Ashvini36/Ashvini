// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_icons/flutter_app_icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/global_setting_controller.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/app/ui/error_page.dart';
import 'package:scaneats/app/ui/login_screen/login_screen.dart';
import 'package:scaneats/app/ui/success_page.dart';
import 'package:scaneats/constant/collection_name.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/service/localization_service.dart';
import 'package:scaneats/theme/Styles.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/Preferences.dart';
import 'package:scaneats/utils/fire_store_utils.dart';

import 'app/model/language_model.dart';

Future<void> getParams() async {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  if (kDebugMode) {
    print("======>");
    print(params);
    Constant.paymentStatus = params['payment_status'];
    if (params['restaurant'].toString().isEmpty || params['restaurant'] == null) {
      String slug = Preferences.getString(Preferences.restaurantSlug);
      if (slug.isEmpty) {
        await getRestaurantId("dominos");
      } else {
        await getRestaurantId(slug);
      }
    } else {
      await getRestaurantId("dominos");
    }
  } else {
    Constant.paymentStatus = params['payment_status'];
    if (params['restaurant'].toString().isEmpty || params['restaurant'] == null) {
      String slug = Preferences.getString(Preferences.restaurantSlug);
      await getRestaurantId(slug);
    } else {
      await getRestaurantId(params['restaurant'].toString());
    }
  }
}

getRestaurantId(String restaurantSlug) async {
  Preferences.setString(Preferences.restaurantSlug, restaurantSlug);
  await FireStoreUtils.getRestaurantBySlug(restaurantSlug).then((value) {
    if (value != null) {
      if (value.isNotEmpty) {
        CollectionName.restaurantId = value.first.id.toString();
      }
    }
  });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
        LanguageModel languageModel = Constant.getLanguage();
        LocalizationService().changeLocale(languageModel.code.toString());
      } else {
        LanguageModel languageModel = LanguageModel(id: "cdc", code: "en", name: "English");
        Preferences.setString(Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
      }
    });
    super.initState();
  }

  // final _flutterAppIconsPlugin = FlutterAppIcons();
  bool isLoading = true;

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
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
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
          supportedLocales: const [
            Locale('en'),
          ],
          localizationsDelegates: const [
            CountryLocalizations.delegate,
          ],
          // home: const DashBoardScreen());
          home: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CollectionName.restaurantId.isEmpty
                  ? const ErrorPage()
                  : GetBuilder<GlobalSettingController>(
                      init: GlobalSettingController(),
                      builder: (controller) {
                        return Constant.paymentStatus != null && Constant.paymentStatus!.isNotEmpty
                            ? Constant.paymentStatus == "success"
                                ? const SuccessPage(isSuccess: true)
                                : const SuccessPage(isSuccess: false)
                            : Preferences.getString(Preferences.user).isEmpty
                                ? const LoginScreen()
                                : const DashBoardScreen();
                      }));
    }));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
