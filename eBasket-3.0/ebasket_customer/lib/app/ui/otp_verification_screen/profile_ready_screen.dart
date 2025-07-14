import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileReadySuccessfullyScreen extends StatelessWidget {
  const ProfileReadySuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: AppThemeData.white,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
              future: Future.delayed(
                const Duration(seconds: 2),
                () async {
                  Get.offAll(const DashBoardScreen());
                },
              ),
              builder: (context, snapshot) {
                return (snapshot.connectionState != ConnectionState.done)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/icons/ic_success.svg"),
                          const SizedBox(
                            height: 36,
                          ),
                          Text(
                            "Congratulations!".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppThemeData.black,
                                fontSize: 36,
                                fontFamily: AppThemeData.semiBold,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Text(
                              "Your profile is ready to use".tr,
                              style: const TextStyle(
                                  color: AppThemeData.black,
                                  fontSize: 16,
                                  fontFamily: AppThemeData.medium,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    : Container();
              })),
    );
  }
}
