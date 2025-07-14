import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:get/get.dart';

class TermsAndCondition extends StatelessWidget {
  final String? type;

  const TermsAndCondition({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUI.customAppBar(context,
          title: Text(
              type == "privacy"
                  ? "Privacy Policy".tr
                  : type == "refund"
                      ? "Refund Policy".tr
                      : type == "support"
                          ? "Help".tr
                          : type == "aboutUs"
                              ? "About Us".tr
                              : "Terms & Conditions".tr,
              style: const TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)),
          isBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            //   vertical: 4,
          ),
          child: Html(
            shrinkWrap: true,
            style: {
              "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
              "p": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
            },
            data: type == "privacy"
                ? Constant.privacyPolicy
                : type == "refund"
                    ? Constant.refundPolicy
                    : type == "support"
                        ? Constant.help
                        : type == "aboutUs"
                            ? Constant.aboutUs
                            : Constant.termsAndConditions,
          ),
        ),
      ),
    );
  }
}
