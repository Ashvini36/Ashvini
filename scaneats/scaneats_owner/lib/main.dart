import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_icons/flutter_app_icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/global_setting_controller.dart';
import 'package:scaneats_owner/app/ui/dashboard_screen.dart';
import 'package:scaneats_owner/app/model/language_model.dart';
import 'package:scaneats_owner/app/ui/login_screen/login_screen.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/firebase_options.dart';
import 'package:scaneats_owner/service/localization_service.dart';
import 'package:scaneats_owner/theme/Styles.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/Preferences.dart';
import 'package:scaneats_owner/utils/fire_store_utils.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FireStoreUtils.getNotificationData();
  await Preferences.initPref();
  setPathUrlStrategy();
  runApp(const MyApp());
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

  final _flutterAppIconsPlugin = FlutterAppIcons();
  bool isLoading = true;

  getUrlParameter() async {
    await FireStoreUtils.getThem().then((value) {
      if (value != null) {
        AppThemeData.crusta500 = HexColor.fromHex(value.color.toString());
        Constant.projectName = value.name.toString();
        Constant.projectLogo = value.logo.toString();
        _flutterAppIconsPlugin.setIcon(icon: value.favIcon ?? Constant.projectLogo);
      }
    });
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
          home: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GetX<GlobalSettingController>(
                  init: GlobalSettingController(),
                  builder: (controller) {
                    return controller.isLoading.value
                        ? Constant.loader(context)
                        : Preferences.getBoolean(Preferences.isLogin) == false
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
