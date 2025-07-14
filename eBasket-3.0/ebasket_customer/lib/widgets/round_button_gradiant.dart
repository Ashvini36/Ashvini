import 'package:flutter/material.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';

class RoundedButtonGradiant extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Function() onPress;
  final bool? icon;

  const RoundedButtonGradiant({super.key, required this.title, this.height, required this.onPress, this.width, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPress();
      },
      child: Container(
        width: Responsive.width(width ?? 100, context),
        height: Responsive.height(height ?? 6, context),
        decoration: ShapeDecoration(
        color: AppThemeData.groceryAppDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppThemeData.semiBold,
                    color: AppThemeData.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            icon == true
                ? const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppThemeData.white,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
