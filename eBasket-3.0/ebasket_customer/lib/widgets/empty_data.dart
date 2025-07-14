import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/empty.gif",
          height: Responsive.height(30, context),
          width: Responsive.width(80, context),
        ),
        Center(
          child: Text(
            "The service is not available in your area.",
            style: TextStyle(fontFamily: AppThemeData.medium),
          ),
        ),
      ],
    );
  }
}