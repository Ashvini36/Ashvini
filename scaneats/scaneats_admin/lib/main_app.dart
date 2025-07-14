// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/model/language_model.dart';
import 'package:scaneats/app/ui/dashboard_screen.dart';
import 'package:scaneats/app/ui/login_screen/login_screen.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/service/localization_service.dart';
import 'package:scaneats/theme/Styles.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/Preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
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
          home: Preferences.getString(Preferences.user).isEmpty ? const LoginScreen() : const DashBoardScreen());
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
